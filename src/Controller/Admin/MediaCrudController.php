<?php

namespace App\Controller\Admin;

use App\Entity\Media;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\ImageField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class MediaCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Media::class;
    }


    public function configureFields(string $pageName): iterable
    {
        /*$mediasDir = $this->getParameter('medias_directory');
        $uploadsDir =$this->getParameter('uploads-directory');*/

        yield TextField::new('name', 'Nom du média');

        $mediaField = ImageField::new('filename', 'Media')
            ->setBasePath('documents/medias/')
            ->setUploadDir('public/documents/medias/')
            ->setUploadedFileNamePattern('[slug]-[uuid].[extension]');

        if (Crud::PAGE_EDIT == $pageName) {
            $mediaField->setRequired(false);
        }

        yield $mediaField;
    }

}
