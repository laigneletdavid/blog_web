<?php

namespace App\Controller\Admin;

use App\Entity\Menu;
use App\Repository\MenuRepository;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use http\Env\Request;
use phpDocumentor\Reflection\DocBlock\Tags\Property;
use Symfony\Component\HttpFoundation\RequestStack;

class MenuCrudController extends AbstractCrudController
{
    public function __construct(
        private RequestStack $requestStack

    )
    {
    }

    public static function getEntityFqcn(): string
    {
        return Menu::class;
    }
    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->remove(Crud::PAGE_INDEX, Action::NEW);
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Tous les liens du menu');
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name', 'Titre de la navigation');
        yield NumberField::new('menu_order', 'Ordre');
        yield TextField::new('target', 'Cible');
        yield BooleanField::new('is_visible', 'Visible');
        yield AssociationField::new('sub_menu', 'Sous-éléments');
    }

}
