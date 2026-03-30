<?php

namespace App\Controller\Admin;

use App\Entity\Media;
use App\Entity\Product;
use App\Entity\ProductImage;
use App\Enum\AvailabilityEnum;
use App\Service\MediaProcessorService;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\CollectionField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\MoneyField;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Filter\BooleanFilter;
use EasyCorp\Bundle\EasyAdminBundle\Filter\ChoiceFilter;
use EasyCorp\Bundle\EasyAdminBundle\Filter\EntityFilter;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class ProductCrudController extends AbstractCrudController
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly MediaProcessorService $mediaProcessor,
    ) {
    }

    public static function getEntityFqcn(): string
    {
        return Product::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Produits / Prestations')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouveau produit')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier le produit')
            ->setDefaultSort(['position' => 'ASC'])
            ->setSearchFields(['title', 'shortDescription', 'slug'])
            ->showEntityActionsInlined();
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->add(Crud::PAGE_INDEX, Action::DETAIL)
            ->reorder(Crud::PAGE_INDEX, [Action::DETAIL, Action::EDIT, Action::DELETE]);
    }

    public function configureFilters(Filters $filters): Filters
    {
        return $filters
            ->add(EntityFilter::new('category', 'Categorie'))
            ->add(ChoiceFilter::new('availability', 'Disponibilite')
                ->setChoices(AvailabilityEnum::choices()))
            ->add(BooleanFilter::new('isActive', 'Actif'))
            ->add(BooleanFilter::new('isFeatured', 'Mis en avant'));
    }

    public function configureFields(string $pageName): iterable
    {
        $site = $this->siteContext->getCurrentSite();
        $isHT = $site?->isCatalogDisplayHT() ?? false;
        $priceLabel = $isHT ? 'Prix HT' : 'Prix TTC';

        // ============================================================
        // PANEL : Contenu
        // ============================================================
        yield FormField::addPanel('Contenu')
            ->setIcon('fa fa-pen')
            ->collapsible();

        yield TextField::new('title', 'Titre')
            ->setHelp('Nom du produit ou de la prestation.')
            ->setColumns(8);

        yield AssociationField::new('category', 'Categorie')
            ->setHelp('Classez votre produit dans une categorie du catalogue.')
            ->setColumns(4);

        yield TextareaField::new('shortDescription', 'Description courte')
            ->setHelp('Resume affiche dans les cartes du catalogue. 2-3 phrases max.')
            ->setFormTypeOptions(['attr' => ['rows' => 3]])
            ->hideOnIndex();

        yield TextareaField::new('blocksJson', 'Description detaillee')
            ->setFormTypeOptions([
                'attr' => [
                    'data-tiptap-editor' => '',
                    'style' => 'display: none',
                ],
            ])
            ->setColumns('col-12')
            ->setHelp('Description longue avec mise en forme, images, videos, encarts. Tapez <strong>/</strong> pour inserer rapidement un bloc.')
            ->hideOnIndex();

        yield AssociationField::new('image', 'Image principale')
            ->setHelp('Image affichee en premier dans la fiche produit et sur les cartes du catalogue.')
            ->hideOnIndex();

        // ============================================================
        // PANEL : Galerie
        // ============================================================
        yield FormField::addPanel('Galerie photos')
            ->setIcon('fa fa-images')
            ->collapsible()
            ->renderCollapsed()
            ->setHelp('Ajoutez des images supplementaires pour la galerie du produit.');

        yield CollectionField::new('galleryImages', 'Images')
            ->useEntryCrudForm(ProductImageCrudController::class)
            ->setHelp('Cliquez sur "Ajouter" pour ajouter des images. Reordonnez-les avec le champ "Ordre".')
            ->allowAdd()
            ->allowDelete()
            ->hideOnIndex();

        // ============================================================
        // PANEL : Tarifs
        // ============================================================
        yield FormField::addPanel('Tarifs')
            ->setIcon('fa fa-euro-sign')
            ->collapsible();

        yield NumberField::new('priceHT', 'Prix HT (€)')
            ->setHelp('Prix hors taxe. Laissez vide pour les prestations "sur devis".')
            ->setNumDecimals(2)
            ->setColumns(4);

        yield NumberField::new('oldPriceHT', 'Ancien prix HT (€)')
            ->setHelp('Si rempli, le prix actuel apparait en promotion avec l\'ancien prix barre.')
            ->setNumDecimals(2)
            ->setColumns(4)
            ->hideOnIndex();

        yield ChoiceField::new('vatRate', 'Taux TVA')
            ->setChoices([
                '20 % (standard)' => '20.00',
                '10 % (restauration, travaux)' => '10.00',
                '5.5 % (alimentation, livres)' => '5.50',
                '2.1 % (presse, medicaments)' => '2.10',
                '0 % (exonere)' => '0.00',
            ])
            ->setHelp('Taux de TVA applicable a ce produit.')
            ->setColumns(4)
            ->hideOnIndex();

        yield ChoiceField::new('availability', 'Disponibilite')
            ->setChoices([
                'Disponible' => AvailabilityEnum::AVAILABLE,
                'Indisponible' => AvailabilityEnum::UNAVAILABLE,
                'Sur devis' => AvailabilityEnum::ON_REQUEST,
            ])
            ->formatValue(fn ($value) => $value instanceof AvailabilityEnum ? $value->label() : ($value ?? ''))
            ->setHelp('Disponible = achat possible. Indisponible = grise. Sur devis = bouton "Nous contacter".');

        // Affichage du prix TTC en index (lecture seule)
        if ($pageName === Crud::PAGE_INDEX || $pageName === Crud::PAGE_DETAIL) {
            yield NumberField::new('priceTTC', 'Prix TTC')
                ->setNumDecimals(2)
                ->formatValue(fn ($value) => $value !== null ? number_format((float) $value, 2, ',', ' ') . ' €' : 'Sur devis');
        }

        // ============================================================
        // PANEL : Variantes
        // ============================================================
        yield FormField::addPanel('Variantes')
            ->setIcon('fa fa-layer-group')
            ->collapsible()
            ->renderCollapsed()
            ->setHelp('Optionnel. Ajoutez des variantes si votre produit a des options de taille, duree, formule...');

        yield CollectionField::new('variants', 'Variantes')
            ->useEntryCrudForm(ProductVariantCrudController::class)
            ->setHelp('Chaque variante peut avoir son propre prix. Si le prix est vide, le prix du produit s\'applique.')
            ->allowAdd()
            ->allowDelete()
            ->hideOnIndex();

        // ============================================================
        // PANEL : Reservation externe
        // ============================================================
        yield FormField::addPanel('Reservation / Rendez-vous')
            ->setIcon('fa fa-calendar-check')
            ->collapsible()
            ->renderCollapsed()
            ->setHelp('Lien vers un service de reservation externe (Calendly, Cal.com, Google Agenda...).');

        yield TextField::new('bookingUrl', 'URL de reservation')
            ->setHelp('Lien complet vers votre page de reservation (ex: https://calendly.com/monprofil).')
            ->hideOnIndex();

        yield TextField::new('bookingLabel', 'Texte du bouton')
            ->setHelp('Personnalisez le bouton : "Reserver", "Voir les disponibilites", "Prendre RDV"... Par defaut : "Reserver".')
            ->setFormTypeOptions(['attr' => ['placeholder' => 'Reserver']])
            ->hideOnIndex();

        // ============================================================
        // PANEL : Classification
        // ============================================================
        yield FormField::addPanel('Classification')
            ->setIcon('fa fa-tags')
            ->collapsible()
            ->renderCollapsed();

        yield AssociationField::new('tags', 'Tags')
            ->setHelp('Tags partages avec les articles du blog. Utile pour le referencement croise.')
            ->hideOnIndex();

        yield AssociationField::new('relatedProducts', 'Produits associes')
            ->setHelp('Produits complementaires affiches en bas de fiche ("Vous aimerez aussi"). Si vide, les produits de la meme categorie sont suggeres automatiquement.')
            ->hideOnIndex();

        // ============================================================
        // PANEL : SEO
        // ============================================================
        yield FormField::addPanel('SEO')
            ->setIcon('fa fa-search')
            ->collapsible()
            ->renderCollapsed();

        yield TextField::new('seoTitle', 'Titre SEO')
            ->setHelp('Apparait dans Google et l\'onglet navigateur. Max 70 caracteres. Si vide = titre du produit.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Meta description')
            ->setHelp('Resume affiche sous le titre dans Google. Max 160 caracteres.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]])
            ->hideOnIndex();

        yield TextField::new('seoKeywords', 'Mots-cles')
            ->setHelp('Separes par des virgules.')
            ->hideOnIndex();

        yield BooleanField::new('noIndex', 'Masquer des moteurs')
            ->setHelp('Empeche Google d\'indexer ce produit.')
            ->hideOnIndex();

        yield TextField::new('canonicalUrl', 'URL canonique')
            ->setHelp('Si ce produit existe sur un autre site.')
            ->hideOnIndex();

        // ============================================================
        // PANEL : Parametres
        // ============================================================
        yield FormField::addPanel('Parametres')
            ->setIcon('fa fa-cog')
            ->collapsible()
            ->renderCollapsed();

        yield SlugField::new('slug')
            ->setTargetFieldName('title')
            ->setHelp('Genere automatiquement depuis le titre')
            ->hideOnIndex();

        yield BooleanField::new('isActive', 'Actif')
            ->setHelp('Desactivez pour masquer du catalogue sans supprimer.');

        yield BooleanField::new('isFeatured', 'Mis en avant')
            ->setHelp('Affiche en priorite sur la page d\'accueil et en haut du catalogue.');

        yield NumberField::new('position', 'Ordre')
            ->setHelp('Tri par ordre croissant (0 = en premier).')
            ->hideOnIndex();
    }

    public function persistEntity(EntityManagerInterface $entityManager, $entityInstance): void
    {
        $this->processGalleryUploads($entityInstance, $entityManager);
        parent::persistEntity($entityManager, $entityInstance);
    }

    public function updateEntity(EntityManagerInterface $entityManager, $entityInstance): void
    {
        $this->processGalleryUploads($entityInstance, $entityManager);
        parent::updateEntity($entityManager, $entityInstance);
    }

    /**
     * Pour chaque ProductImage avec un fichier uploadé directement (uploadFile),
     * déplacer le fichier, créer automatiquement un Media et le lier.
     */
    private function processGalleryUploads(Product $product, EntityManagerInterface $em): void
    {
        $uploadDir = $this->getParameter('kernel.project_dir') . '/public/documents/medias';

        foreach ($product->getGalleryImages() as $galleryImage) {
            /** @var ProductImage $galleryImage */
            $uploadFile = $galleryImage->getUploadFile();

            if ($uploadFile !== null) {
                // Générer un nom unique pour le fichier
                $originalName = pathinfo($uploadFile->getClientOriginalName(), PATHINFO_FILENAME);
                $extension = $uploadFile->guessExtension() ?? $uploadFile->getClientOriginalExtension();
                $fileName = $originalName . '-' . uniqid() . '.' . $extension;

                // Déplacer le fichier uploadé vers le dossier medias
                $uploadFile->move($uploadDir, $fileName);

                // Créer un Media depuis le fichier uploadé
                $media = new Media();
                $media->setName($originalName);
                $media->setFileName($fileName);

                $em->persist($media);

                // Générer le WebP + variantes responsives
                $webpFileName = $this->mediaProcessor->process($media);
                if ($webpFileName) {
                    $media->setWebpFileName($webpFileName);
                }

                // Lier le media à l'image galerie
                $galleryImage->setMedia($media);
                $galleryImage->setUploadFile(null);
            }
        }

        // Auto-affecter l'image principale si aucune n'est définie
        if (!$product->getImage()) {
            $firstGallery = $product->getGalleryImages()->first();
            if ($firstGallery && $firstGallery->getMedia()) {
                $product->setImage($firstGallery->getMedia());
            }
        }
    }
}
