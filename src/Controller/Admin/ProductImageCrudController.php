<?php

namespace App\Controller\Admin;

use App\Entity\ProductImage;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\Field;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Security\Http\Attribute\IsGranted;
use Symfony\Component\Validator\Constraints\File;

#[IsGranted('ROLE_ADMIN')]
class ProductImageCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return ProductImage::class;
    }

    public function configureFields(string $pageName): iterable
    {
        yield Field::new('uploadFile', 'Importer une image')
            ->setFormType(FileType::class)
            ->setFormTypeOptions([
                'required' => false,
                'constraints' => [
                    new File([
                        'maxSize' => '10M',
                        'mimeTypes' => ['image/jpeg', 'image/png', 'image/webp', 'image/gif'],
                        'mimeTypesMessage' => 'Formats acceptes : JPG, PNG, WebP, GIF.',
                    ]),
                ],
                'attr' => [
                    'accept' => 'image/*',
                ],
            ])
            ->setHelp('Uploadez une nouvelle image (JPG, PNG, WebP, GIF — max 10 Mo).');

        yield AssociationField::new('media', 'Ou choisir un media existant')
            ->setRequired(false)
            ->setHelp('Selectionnez une image deja presente dans la bibliotheque de medias.');

        yield NumberField::new('position', 'Ordre')
            ->setHelp('0 = premiere image de la galerie.');
    }
}
