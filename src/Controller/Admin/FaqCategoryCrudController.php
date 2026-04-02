<?php

namespace App\Controller\Admin;

use App\Entity\FaqCategory;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class FaqCategoryCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public static function getEntityFqcn(): string
    {
        return FaqCategory::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Catégories FAQ')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle catégorie')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la catégorie')
            ->setDefaultSort(['position' => 'ASC']);
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name', 'Nom')
            ->setHelp('Nom de la catégorie affiché comme titre de section sur la page FAQ (ex : « Livraison », « Paiement »).');

        yield SlugField::new('slug')
            ->setTargetFieldName('name')
            ->setHelp('Généré automatiquement depuis le nom.')
            ->hideOnIndex();

        yield IntegerField::new('position', 'Ordre')
            ->setHelp('Les catégories sont triées par ordre croissant (0 = en premier).');

        yield BooleanField::new('isActive', 'Activée')
            ->setHelp('Désactivez pour masquer cette catégorie et toutes ses questions.');
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Categories FAQ',
            'sections' => [
                [
                    'title' => 'Organisation',
                    'content' => '<p>Les categories regroupent les questions par theme sur la page FAQ. Chaque categorie s\'affiche comme un bloc titre suivi de ses questions en accordeon.</p>',
                ],
            ],
            'tips' => [
                'Desactivez une categorie pour masquer toutes ses questions d\'un coup.',
            ],
        ];
    }
}
