<?php

namespace App\Controller\Admin;

use App\Entity\DirectoryEntry;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ImageField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Filter\BooleanFilter;
use EasyCorp\Bundle\EasyAdminBundle\Filter\EntityFilter;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class DirectoryEntryCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public static function getEntityFqcn(): string
    {
        return DirectoryEntry::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Annuaire')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle fiche')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la fiche')
            ->setDefaultSort(['lastName' => 'ASC']);
    }

    public function configureFilters(Filters $filters): Filters
    {
        return $filters
            ->add(EntityFilter::new('category'))
            ->add(BooleanFilter::new('isActive'))
            ->add(BooleanFilter::new('isFeatured'));
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Identite ---
        yield FormField::addPanel('Identite')
            ->setIcon('fa fa-user')
            ->collapsible();

        yield TextField::new('firstName', 'Prenom');

        yield TextField::new('lastName', 'Nom');

        $photoField = ImageField::new('photo', 'Photo')
            ->setBasePath('documents/medias/')
            ->setUploadDir('public/documents/medias/')
            ->setUploadedFileNamePattern('[slug]-[uuid].[extension]')
            ->setHelp('Photo ou logo. Format carre recommande, JPG ou PNG.')
            ->hideOnIndex();

        if (Crud::PAGE_EDIT === $pageName) {
            $photoField->setRequired(false);
        }

        yield $photoField;

        yield TextField::new('jobTitle', 'Poste / Metier');

        yield TextField::new('company', 'Entreprise')
            ->hideOnIndex();

        yield TextareaField::new('bio', 'Biographie')
            ->setFormTypeOptions(['attr' => ['rows' => 4]])
            ->hideOnIndex();

        // --- Panel Coordonnees ---
        yield FormField::addPanel('Coordonnees')
            ->setIcon('fa fa-address-card')
            ->collapsible();

        yield TextField::new('email', 'Email')
            ->hideOnIndex();

        yield TextField::new('phone', 'Telephone')
            ->hideOnIndex();

        yield TextField::new('city', 'Ville');

        // --- Panel Reseaux ---
        yield FormField::addPanel('Reseaux sociaux')
            ->setIcon('fa fa-globe')
            ->collapsible()
            ->renderCollapsed();

        yield TextField::new('website', 'Site web')
            ->setHelp('URL complete (https://...)')
            ->hideOnIndex();

        yield TextField::new('linkedin', 'LinkedIn')
            ->setHelp('URL du profil LinkedIn')
            ->hideOnIndex();

        yield TextField::new('facebook', 'Facebook')
            ->setHelp('URL de la page Facebook')
            ->hideOnIndex();

        yield TextField::new('instagram', 'Instagram')
            ->setHelp('URL du profil Instagram')
            ->hideOnIndex();

        // --- Panel Referencement ---
        yield FormField::addPanel('Referencement')
            ->setIcon('fa fa-search')
            ->collapsible()
            ->renderCollapsed();

        yield TextField::new('seoTitle', 'Titre SEO')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Meta description')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]])
            ->hideOnIndex();

        yield TextField::new('seoKeywords', 'Mots-cles')
            ->hideOnIndex();

        yield BooleanField::new('noIndex', 'Ne pas indexer')
            ->hideOnIndex();

        yield TextField::new('canonicalUrl', 'URL canonique')
            ->hideOnIndex();

        // --- Panel Parametres ---
        yield FormField::addPanel('Parametres')
            ->setIcon('fa fa-cog')
            ->collapsible();

        yield SlugField::new('slug')
            ->setTargetFieldName('company')
            ->hideOnIndex();

        yield AssociationField::new('category', 'Categorie')
            ->setRequired(false);

        yield AssociationField::new('user', 'Membre lie')
            ->setHelp('Optionnel. Si lie a un compte utilisateur, le membre peut editer sa fiche depuis /annuaire/ma-fiche.')
            ->setRequired(false)
            ->hideOnIndex();

        yield BooleanField::new('isActive', 'Active');

        yield BooleanField::new('isFeatured', 'Mis en avant');
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Annuaire',
            'sections' => [
                [
                    'title' => 'Fiches professionnels',
                    'content' => '<p>Creez des fiches pour chaque professionnel de l\'annuaire :</p>
                    <ul>
                        <li><strong>Photo</strong> — format carre recommande (sera affiche en rond)</li>
                        <li><strong>Reseaux sociaux</strong> — les liens s\'affichent sous forme d\'icones sur la fiche</li>
                        <li><strong>Membre lie</strong> — si un compte utilisateur est lie, le membre peut editer sa propre fiche</li>
                    </ul>',
                ],
                [
                    'title' => 'Categories',
                    'content' => '<p>Les categories servent de filtres sur la page annuaire. Creez des categories par metier ou specialite pour faciliter la recherche.</p>',
                ],
            ],
            'tips' => [
                'Les fiches "mises en avant" peuvent etre affichees sur la page d\'accueil.',
                'Un membre lie a un compte peut modifier sa fiche via /annuaire/ma-fiche.',
                'Les visiteurs peuvent filtrer par categorie et rechercher par nom, entreprise ou ville.',
            ],
        ];
    }
}
