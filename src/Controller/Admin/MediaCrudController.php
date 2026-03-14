<?php

namespace App\Controller\Admin;

use App\Entity\Media;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ImageField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class MediaCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Media::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Medias')
            ->setPageTitle(Crud::PAGE_NEW, 'Ajouter un media')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier le media')
            ->setDefaultSort(['id' => 'DESC']);
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Fichier ---
        yield FormField::addPanel('Fichier')
            ->setIcon('fa fa-image')
            ->collapsible();

        yield TextField::new('name', 'Nom du media')
            ->setHelp('Nom descriptif pour identifier le media (aussi utilise comme attribut alt)')
            ->setFormTypeOptions([
                'attr' => ['placeholder' => 'Ex: Photo equipe, Logo client, Banniere article...'],
            ]);

        $mediaField = ImageField::new('filename', 'Image')
            ->setBasePath('documents/medias/')
            ->setUploadDir('public/documents/medias/')
            ->setUploadedFileNamePattern('[slug]-[uuid].[extension]')
            ->setHelp('Formats acceptes : JPG, PNG, GIF, WebP. Taille max : 25 Mo.');

        if (Crud::PAGE_EDIT === $pageName) {
            $mediaField->setRequired(false);
        }

        yield $mediaField;

        yield TextField::new('webpFileName', 'WebP')
            ->hideOnForm();
    }
}
