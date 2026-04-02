<?php

namespace App\Controller\Admin;

use App\Entity\ProductCategory;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class ProductCategoryCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public static function getEntityFqcn(): string
    {
        return ProductCategory::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Categories produits')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle categorie')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la categorie')
            ->setDefaultSort(['position' => 'ASC'])
            ->setSearchFields(['name', 'description']);
    }

    public function configureFields(string $pageName): iterable
    {
        yield FormField::addPanel('Categorie')
            ->setIcon('fa fa-folder');

        yield TextField::new('name', 'Nom')
            ->setHelp('Nom affiche dans le catalogue et les filtres.');

        yield SlugField::new('slug')
            ->setTargetFieldName('name')
            ->setHelp('Genere automatiquement depuis le nom')
            ->hideOnIndex();

        yield TextareaField::new('description', 'Description')
            ->setHelp('Courte description de la categorie, affichee en haut de la page categorie.')
            ->setFormTypeOptions(['attr' => ['rows' => 3]])
            ->hideOnIndex();

        yield AssociationField::new('image', 'Image')
            ->setHelp('Image representative de la categorie.')
            ->hideOnIndex();

        yield NumberField::new('position', 'Ordre')
            ->setHelp('Les categories sont triees par ordre croissant (0 = en premier).');

        yield BooleanField::new('isActive', 'Active');
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Categories produits',
            'sections' => [
                [
                    'title' => 'Organisation du catalogue',
                    'content' => '<p>Organisez vos produits par categorie. Chaque categorie a sa propre page avec image et description.</p>',
                ],
            ],
            'tips' => [
                'Ajoutez une image representative pour chaque categorie — elle s\'affiche dans la navigation du catalogue.',
            ],
        ];
    }
}
