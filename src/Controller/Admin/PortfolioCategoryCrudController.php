<?php

namespace App\Controller\Admin;

use App\Entity\PortfolioCategory;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class PortfolioCategoryCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return PortfolioCategory::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Catégories Portfolio')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle catégorie')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la catégorie')
            ->setDefaultSort(['position' => 'ASC']);
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name', 'Nom')
            ->setHelp('Nom de la catégorie affiché dans les filtres sur la page réalisations (ex : « Sites web », « Applications »).');

        yield SlugField::new('slug')
            ->setTargetFieldName('name')
            ->setHelp('Généré automatiquement depuis le nom. Utilisé dans l\'URL de filtre (/realisations?categorie=slug).')
            ->hideOnIndex();

        yield TextField::new('icon', 'Icône')
            ->setHelp('Optionnel. Icône affichée dans le bouton filtre. Classe Bootstrap Icons (ex : bi-brush). Voir <a href="https://icons.getbootstrap.com/" target="_blank">icons.getbootstrap.com</a>')
            ->hideOnIndex();

        yield IntegerField::new('position', 'Ordre')
            ->setHelp('Les catégories sont triées par ordre croissant (0 = en premier).');

        yield BooleanField::new('isActive', 'Activée')
            ->setHelp('Désactivez pour masquer cette catégorie des filtres.');
    }
}
