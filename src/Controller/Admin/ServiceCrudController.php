<?php

namespace App\Controller\Admin;

use App\Entity\Service;
use App\Field\IconPickerField;
use App\Service\SeoAnalyzer;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_AUTHOR')]
class ServiceCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;
    use Trait\SeoScoreTrait;
    use Trait\SlugFieldHelperTrait;

    public function __construct(
        private readonly SeoAnalyzer $seoAnalyzer,
        private readonly \App\Service\AdminModeService $adminMode,
    ) {
    }

    private function getSeoAnalyzer(): SeoAnalyzer
    {
        return $this->seoAnalyzer;
    }

    public static function getEntityFqcn(): string
    {
        return Service::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Services')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouveau service')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier le service')
            ->setDefaultSort(['position' => 'ASC']);
    }

    /**
     * Formulaire en deux colonnes : decrire a gauche, publier et ranger a droite.
     * Adresse, lien externe et reglages SEO techniques ne sortent qu'en mode expert.
     */
    public function configureFields(string $pageName): iterable
    {
        $expert = $this->adminMode->isExpert();

        yield $this->seoScoreField();

        // ===== Colonne principale : le contenu =====
        yield FormField::addColumn('col-lg-8');

        yield TextField::new('title', 'Titre');

        yield TextareaField::new('shortDescription', 'Description courte')
            ->setHelp('Affichée dans la liste des services, sur l\'accueil.')
            ->setFormTypeOptions(['attr' => ['rows' => 3]])
            ->hideOnIndex();

        yield TextareaField::new('blocksJson', 'Page détaillée')
            ->setFormTypeOptions(['attr' => ['data-tiptap-editor' => '', 'style' => 'display: none']])
            ->setColumns('col-12')
            ->setHelp('Facultatif : si vide, le service n\'a pas de page à lui. Tapez <strong>/</strong> pour insérer un bloc.')
            ->hideOnIndex();

        // Apercu Google : le JS admin-simple affiche le rendu au-dessus de ces deux champs
        yield FormField::addFieldset('Dans Google')
            ->setHelp('Laissez vide pour reprendre le titre et la description courte.');

        yield TextField::new('seoTitle', 'Titre dans Google')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Description dans Google')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 2]])
            ->hideOnIndex();

        // ===== Colonne laterale =====
        yield FormField::addColumn('col-lg-4');

        yield FormField::addFieldset('Publication')->setIcon('fa fa-paper-plane');

        yield BooleanField::new('isActive', 'En ligne');

        yield IntegerField::new('position', 'Ordre d\'affichage')
            ->setHelp('0 = en premier.');

        yield FormField::addFieldset('Visuel')->setIcon('fa fa-image');

        yield AssociationField::new('image', 'Image')
            ->setHelp('Son texte alternatif se règle dans Médias.')
            ->hideOnIndex();

        yield IconPickerField::new('icon', 'Icône')
            ->hideOnIndex();

        yield FormField::addFieldset('Rangement')->setIcon('fa fa-sitemap');

        // Rattachement facultatif : laisse vide, le service reste au premier
        // niveau. C'est le cas de figure ordinaire, une offre a plat.
        yield AssociationField::new('parent', 'Rattacher à un service')
            ->setHelp('Laissez vide pour un service principal.')
            ->setFormTypeOption('choice_label', 'title')
            ->setFormTypeOption('required', false)
            ->autocomplete()
            ->hideOnIndex();

        yield AssociationField::new('linkedPage', 'Page liée')
            ->setHelp('Ouvre cette page au clic, à la place de la page détaillée.')
            ->hideOnIndex();

        if ($expert) {
            yield FormField::addFieldset('Options avancées')
                ->setIcon('fa fa-sliders-h')
                ->setCssClass('bw-fieldset-expert');

            yield $this->slugField('title');

            yield TextField::new('link', 'Lien externe')
                ->setHelp('Utilisé seulement sans page liée ni page détaillée.')
                ->hideOnIndex();

            yield TextField::new('seoKeywords', 'Mots-clés')
                ->setHelp('Ignorés par Google, utiles seulement à certains outils.')
                ->hideOnIndex();

            yield BooleanField::new('noIndex', 'Masquer des moteurs de recherche')
                ->hideOnIndex();

            yield TextField::new('canonicalUrl', 'Adresse canonique')
                ->setHelp('Seulement si ce texte existe aussi sur un autre site.')
                ->hideOnIndex();
        }
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Services',
            'sections' => [
                [
                    'title' => 'Fiches de services',
                    'content' => '<p>Présentez vos prestations en grille sur la page d\'accueil.</p>
                    <ul>
                        <li><strong>Description courte</strong> — affichée dans la liste des services</li>
                        <li><strong>Page détaillée</strong> — facultative : si elle est vide, le service n\'a pas de page à lui</li>
                        <li><strong>Icône</strong> et <strong>image</strong> — à choisir dans leurs sélecteurs</li>
                        <li><strong>Rattacher à un service</strong> — fait de ce service une prestation d\'un autre</li>
                    </ul>',
                ],
                [
                    'title' => 'Au clic sur le service',
                    'content' => '<p>Le visiteur est envoyé, dans cet ordre de priorité, vers la <em>Page liée</em>, puis le lien externe (mode expert), puis la page détaillée si elle est remplie.</p>',
                ],
            ],
            'tips' => [
                'Chaque service avec une page détaillée a sa propre adresse : remplissez son bloc Dans Google (titre de 30 à 60 caractères, description de 120 à 160).',
                'Citez la ville ou la zone où vous intervenez dans le titre dans Google : le bilan de la page Référencement le vérifie.',
            ],
        ];
    }
}
