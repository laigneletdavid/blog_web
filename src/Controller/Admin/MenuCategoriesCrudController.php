<?php

namespace App\Controller\Admin;

use App\Entity\Menu;
use Doctrine\ORM\QueryBuilder;
use EasyCorp\Bundle\EasyAdminBundle\Collection\FieldCollection;
use EasyCorp\Bundle\EasyAdminBundle\Collection\FilterCollection;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Dto\EntityDto;
use EasyCorp\Bundle\EasyAdminBundle\Dto\SearchDto;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class MenuCategoriesCrudController extends MenuCrudController
{

    public function configureCrud(Crud $crud): Crud
    {
        return parent::configureCrud($crud)
            ->setPageTitle(Crud::PAGE_INDEX, 'Lien de menu vers une catégorie')
            ->setPageTitle(Crud::PAGE_NEW, 'Créez un lien de menu vers une catégorie');
    }
    public function configureActions(Actions $actions): Actions
    {
        return parent::configureActions($actions)
            ->add(Crud::PAGE_INDEX, Action::NEW);
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name', 'Titre de la navigation');
        yield NumberField::new('menu_order', 'Ordre');
        yield AssociationField::new('categorie');
        yield TextField::new('target', 'Cible')
            ->setValue('categorie');
        yield BooleanField::new('is_visible', 'Visible');
        yield AssociationField::new('sub_menu', 'Sous-éléments');
    }

    public function createEntity(string $entityFqcn)
    {
        $entity = new $entityFqcn;
        $entity->setTarget('Catégorie');
        return $entity;
    }

    public function createIndexQueryBuilder(SearchDto $searchDto, EntityDto $entityDto, FieldCollection $fields, FilterCollection $filters): QueryBuilder
    {
        $qb = parent::createIndexQueryBuilder($searchDto, $entityDto, $fields, $filters);

        $qb->andWhere($qb->expr()->eq('entity.target', $qb->expr()->literal('categorie')));

        return $qb;
    }
}