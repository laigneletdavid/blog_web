<?php

namespace App\Controller\Admin;

use App\Entity\Page;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class PageCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Page::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Pages')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle page')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la page')
            ->setDefaultSort(['created_at' => 'DESC']);
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Contenu ---
        yield FormField::addPanel('Contenu')
            ->setIcon('fa fa-pen');

        yield TextField::new('title', 'Titre de la page');

        yield TextareaField::new('blocksJson', 'Contenu de la page')
            ->setFormTypeOptions([
                'attr' => [
                    'data-tiptap-editor' => '',
                    'style' => 'display: none',
                ],
            ])
            ->hideOnIndex();

        // --- Panel Paramètres ---
        yield FormField::addPanel('Paramètres')
            ->setIcon('fa fa-cog');

        yield AssociationField::new('featured_media', 'Image mise en avant');

        yield BooleanField::new('published', 'Publiée');

        // --- Panel Avancé (collapsed) ---
        yield FormField::addPanel('Avancé')
            ->setIcon('fa fa-sliders-h')
            ->collapsible()
            ->renderCollapsed();

        yield SlugField::new('slug')
            ->setTargetFieldName('title')
            ->setHelp('Généré automatiquement depuis le titre')
            ->hideOnIndex();

        yield DateTimeField::new('created_at', 'Créée le')
            ->hideOnForm();

        yield DateTimeField::new('updated_at', 'Modifiée le')
            ->hideOnForm();
    }

    public function persistEntity(\Doctrine\ORM\EntityManagerInterface $entityManager, $entityInstance): void
    {
        /** @var Page $entityInstance */
        $entityInstance->setCreatedAt(new \DateTime());
        $entityInstance->setUpdatedAt(new \DateTime());

        parent::persistEntity($entityManager, $entityInstance);
    }

    public function updateEntity(\Doctrine\ORM\EntityManagerInterface $entityManager, $entityInstance): void
    {
        /** @var Page $entityInstance */
        $entityInstance->setUpdatedAt(new \DateTime());

        parent::updateEntity($entityManager, $entityInstance);
    }
}
