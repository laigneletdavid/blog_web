<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class ArticleCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Article::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Articles')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvel article')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier l\'article')
            ->setDefaultSort(['created_at' => 'DESC']);
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Contenu ---
        yield FormField::addPanel('Contenu')
            ->setIcon('fa fa-pen');

        yield TextField::new('title', 'Titre de l\'article');

        yield TextEditorField::new('content', 'Contenu de l\'article')
            ->hideOnIndex();

        // --- Panel Paramètres ---
        yield FormField::addPanel('Paramètres')
            ->setIcon('fa fa-cog');

        yield AssociationField::new('categories', 'Catégories');

        yield AssociationField::new('featured_media', 'Image mise en avant');

        yield TextField::new('featured_text', 'Texte mis en avant')
            ->setHelp('Court résumé affiché dans les listes d\'articles')
            ->hideOnIndex();

        yield BooleanField::new('published', 'Publié');

        // --- Panel Avancé (collapsed) ---
        yield FormField::addPanel('Avancé')
            ->setIcon('fa fa-sliders-h')
            ->collapsible()
            ->renderCollapsed();

        yield SlugField::new('slug')
            ->setTargetFieldName('title')
            ->setHelp('Généré automatiquement depuis le titre')
            ->hideOnIndex();

        yield DateTimeField::new('created_at', 'Créé le')
            ->hideOnForm();

        yield DateTimeField::new('updated_at', 'Modifié le')
            ->hideOnForm();

        yield DateTimeField::new('published_at', 'Date de publication')
            ->setHelp('Rempli automatiquement à la première publication')
            ->hideOnIndex();
    }

    public function persistEntity(\Doctrine\ORM\EntityManagerInterface $entityManager, $entityInstance): void
    {
        /** @var Article $entityInstance */
        $entityInstance->setCreatedAt(new \DateTime());
        $entityInstance->setUpdatedAt(new \DateTime());

        if ($entityInstance->isPublished() && $entityInstance->getPublishedAt() === null) {
            $entityInstance->setPublishedAt(new \DateTime());
        }

        parent::persistEntity($entityManager, $entityInstance);
    }

    public function updateEntity(\Doctrine\ORM\EntityManagerInterface $entityManager, $entityInstance): void
    {
        /** @var Article $entityInstance */
        $entityInstance->setUpdatedAt(new \DateTime());

        if ($entityInstance->isPublished() && $entityInstance->getPublishedAt() === null) {
            $entityInstance->setPublishedAt(new \DateTime());
        }

        parent::updateEntity($entityManager, $entityInstance);
    }
}
