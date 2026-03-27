<?php

namespace App\Controller\Admin;

use App\Entity\Menu;
use App\Enum\MenuLocationEnum;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Filter\ChoiceFilter;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
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
            ->setDefaultSort(['location' => 'ASC', 'menu_order' => 'ASC']);
    }

    public function configureFilters(Filters $filters): Filters
    {
        return $filters
            ->add(ChoiceFilter::new('location', 'Zone')->setChoices(MenuLocationEnum::choices()));
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->update(Crud::PAGE_INDEX, Action::DELETE, function (Action $action) {
                return $action->displayIf(fn (Menu $menu) => !$menu->isSystem());
            })
            ->update(Crud::PAGE_DETAIL, Action::DELETE, function (Action $action) {
                return $action->displayIf(fn (Menu $menu) => !$menu->isSystem());
            });
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name', 'Titre de la navigation');

        yield ChoiceField::new('location', 'Zone')
            ->setChoices(MenuLocationEnum::choices())
            ->renderExpanded(false)
            ->setHelp('Où afficher ce lien : header, footer navigation ou footer légal');

        yield NumberField::new('menu_order', 'Ordre')
            ->setHelp('Plus le nombre est petit, plus le lien apparaît en premier');

        yield ChoiceField::new('target', 'Type de lien')
            ->setChoices([
                'Route système' => 'route',
                'Article' => 'article',
                'Page' => 'page',
                'Catégorie' => 'categorie',
                'URL personnalisée' => 'url',
            ])
            ->renderExpanded(false)
            ->setHelp('Sélectionnez le type de contenu vers lequel ce lien pointe');

        yield TextField::new('url', 'URL')
            ->setHelp('URL personnalisée (ex: https://example.com)')
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

        yield BooleanField::new('is_system', 'Système')
            ->setHelp('Les éléments système ne peuvent pas être supprimés')
            ->renderAsSwitch(false)
            ->setFormTypeOption('disabled', true);

        yield AssociationField::new('parent', 'Élément parent')
            ->setHelp('Laisser vide pour un élément racine')
            ->hideOnIndex();
    }

    public function deleteEntity(\Doctrine\ORM\EntityManagerInterface $entityManager, $entityInstance): void
    {
        if ($entityInstance instanceof Menu && $entityInstance->isSystem()) {
            $this->addFlash('danger', 'Les éléments de menu système ne peuvent pas être supprimés.');
            return;
        }

        parent::deleteEntity($entityManager, $entityInstance);
    }
}
