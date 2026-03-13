<?php

namespace App\Controller\Admin;

use App\Entity\Menu;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class MenuCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Menu::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Navigation')
            ->setPageTitle(Crud::PAGE_NEW, 'Ajouter un lien de menu')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier un lien de menu')
            ->setDefaultSort(['menu_order' => 'ASC']);
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name', 'Titre de la navigation');

        yield NumberField::new('menu_order', 'Ordre')
            ->setHelp('Plus le nombre est petit, plus le lien apparaît en premier');

        yield ChoiceField::new('target', 'Type de lien')
            ->setChoices([
                'Article' => 'article',
                'Page' => 'page',
                'Catégorie' => 'categorie',
                'URL personnalisée' => 'url',
            ])
            ->renderExpanded(false)
            ->setHelp('Sélectionnez le type de contenu vers lequel ce lien pointe');

        yield TextField::new('url', 'URL')
            ->setHelp('URL personnalisée (ex: /article/ pour le blog, ou https://example.com)')
            ->hideOnIndex();

        yield AssociationField::new('article', 'Article')
            ->setHelp('Sélectionnez l\'article (si type = Article)')
            ->hideOnIndex();

        yield AssociationField::new('page', 'Page')
            ->setHelp('Sélectionnez la page (si type = Page)')
            ->hideOnIndex();

        yield AssociationField::new('categorie', 'Catégorie')
            ->setHelp('Sélectionnez la catégorie (si type = Catégorie)')
            ->hideOnIndex();

        yield BooleanField::new('is_visible', 'Visible');

        yield AssociationField::new('parent', 'Élément parent')
            ->setHelp('Laisser vide pour un élément racine')
            ->hideOnIndex();
    }
}
