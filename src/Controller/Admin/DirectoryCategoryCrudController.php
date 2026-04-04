<?php

namespace App\Controller\Admin;

use App\Entity\DirectoryCategory;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class DirectoryCategoryCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public static function getEntityFqcn(): string
    {
        return DirectoryCategory::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Categories Annuaire')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle categorie')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la categorie')
            ->setDefaultSort(['position' => 'ASC']);
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name', 'Nom')
            ->setHelp('Nom de la categorie affiche dans les filtres sur la page annuaire (ex : Artisan, Consultant, Commercant).');

        yield SlugField::new('slug')
            ->setTargetFieldName('name')
            ->setHelp('Genere automatiquement depuis le nom. Utilise dans l\'URL de filtre (/annuaire?categorie=slug).')
            ->hideOnIndex();

        yield TextField::new('icon', 'Icone')
            ->setHelp('Optionnel. Classe Bootstrap Icons (ex : bi-briefcase). Voir <a href="https://icons.getbootstrap.com/" target="_blank">icons.getbootstrap.com</a>')
            ->hideOnIndex();

        yield IntegerField::new('position', 'Ordre')
            ->setHelp('Les categories sont triees par ordre croissant (0 = en premier).');

        yield BooleanField::new('isActive', 'Activee')
            ->setHelp('Desactivez pour masquer cette categorie des filtres.');
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Categories annuaire',
            'sections' => [
                [
                    'title' => 'Filtres par metier',
                    'content' => '<p>Les categories servent de filtres sur la page annuaire. Les visiteurs cliquent sur une categorie pour afficher les professionnels correspondants.</p>
                    <p>Exemples : Artisan, Consultant, Commercant, Prestataire de services...</p>',
                ],
            ],
            'tips' => [
                'Creez au moins 2 categories pour que les filtres s\'affichent sur la page annuaire.',
                'L\'icone Bootstrap Icons (optionnelle) s\'affiche dans le bouton filtre.',
            ],
        ];
    }
}
