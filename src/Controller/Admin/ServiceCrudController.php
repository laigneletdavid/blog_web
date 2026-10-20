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
                    'content' => '<p>Presentez vos prestations sous forme de grille sur la page d\'accueil.</p>
                    <ul>
                        <li><strong>Description courte</strong> — affichee dans la carte du service</li>
                        <li><strong>Contenu detaille</strong> — page de detail optionnelle (editeur visuel)</li>
                        <li><strong>Icone</strong> — classe Bootstrap Icons (ex: <code>bi-rocket</code>)</li>
                    </ul>',
                ],
                [
                    'title' => 'Liens',
                    'content' => '<p>Priorite des liens : page liee > lien externe > page de detail auto-generee (si contenu detaille rempli).</p>',
                ],
            ],
            'tips' => [
                'L\'icone s\'affiche dans la grille des services sur la home. Trouvez les icones sur icons.getbootstrap.com.',
                '<strong>SEO</strong> : chaque service a sa propre page. Pensez à remplir le Titre SEO (max 70 car.) et la Meta description (max 160 car.) dans le panel SEO pour un meilleur référencement.',
            ],
        ];
    }
}
