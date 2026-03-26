<?php

namespace App\Controller\Admin;

use App\Entity\FaqCategory;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class FaqCategoryCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return FaqCategory::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Categories FAQ')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle categorie')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la categorie')
            ->setDefaultSort(['position' => 'ASC']);
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name', 'Nom');

        yield SlugField::new('slug')
            ->setTargetFieldName('name')
            ->hideOnIndex();

        yield IntegerField::new('position', 'Ordre')
            ->setHelp('Ordre d\'affichage (0 = premier)');

        yield BooleanField::new('isActive', 'Active');
    }
}
