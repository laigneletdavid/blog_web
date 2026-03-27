<?php

namespace App\Controller\Admin;

use App\Entity\ProductVariant;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class ProductVariantCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return ProductVariant::class;
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('label', 'Intitule')
            ->setHelp('Ex: "Demi-journee", "Taille M", "2 personnes"...')
            ->setColumns(5);

        yield NumberField::new('priceHT', 'Prix HT (€)')
            ->setHelp('Vide = prix du produit parent.')
            ->setNumDecimals(2)
            ->setColumns(3);

        yield NumberField::new('position', 'Ordre')
            ->setColumns(2);

        yield BooleanField::new('isActive', 'Active')
            ->setColumns(2);
    }
}
