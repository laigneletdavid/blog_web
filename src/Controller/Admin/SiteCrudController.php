<?php

namespace App\Controller\Admin;

use App\Entity\Site;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class SiteCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Site::class;
    }

    public function configureActions(Actions $actions): Actions
    {
        $actions->remove(Crud::PAGE_DETAIL, Crud::PAGE_INDEX);
        $actions->disable(Action::DELETE);

        return $actions;
    }
    public function configureCrud(Crud $crud): Crud
    {
        $crud->setPageTitle(Crud::PAGE_DETAIL, 'Mon site');
       // $crud->set

        return $crud;
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name')
            ->setLabel('Nom du site');

        yield TextField::new('title')
            ->setLabel('Phrase d\'accroche');

        yield TextField::new('email')
            ->setLabel('E-mail de contact');

        yield TextField::new('phone')
            ->setLabel('Téléphone de contact');

        yield TextField::new('adress_1')
            ->setLabel('Adresse de contact - ligne 1');

        Yield TextField::new('adress_2')
            ->setLabel('Adresse de contact - ligne 2');

        Yield TextField::new('post_code')
            ->setLabel('Code Postal');

        yield TextField::new('town')
            ->setLabel('Ville');

        yield TextField::new('google_maps')
            ->setLabel('Lien Goolge map de votre adresse');
    }

}
