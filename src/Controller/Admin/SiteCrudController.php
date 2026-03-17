<?php

namespace App\Controller\Admin;

use App\Entity\Site;
use App\Enum\ModuleEnum;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use EasyCorp\Bundle\EasyAdminBundle\Context\AdminContext;
use Symfony\Component\HttpFoundation\RedirectResponse;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
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

        return $crud;
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Identite ---
        yield FormField::addPanel('Identite')
            ->setIcon('fa fa-building')
            ->collapsible();

        yield TextField::new('name')
            ->setLabel('Nom du site');

        yield TextField::new('title')
            ->setLabel('Phrase d\'accroche');

        yield AssociationField::new('logo', 'Logo')
            ->hideOnIndex();

        yield TextField::new('email')
            ->setLabel('E-mail de contact');

        yield TextField::new('phone')
            ->setLabel('Telephone de contact');

        yield TextField::new('address_1')
            ->setLabel('Adresse - ligne 1');

        yield TextField::new('address_2')
            ->setLabel('Adresse - ligne 2');

        yield TextField::new('post_code')
            ->setLabel('Code Postal');

        yield TextField::new('town')
            ->setLabel('Ville');

        yield TextField::new('google_maps')
            ->setLabel('Lien Google Maps');

        // --- Panel SEO ---
        yield FormField::addPanel('SEO')
            ->setIcon('fa fa-search')
            ->collapsible();

        yield TextField::new('defaultSeoTitle', 'Titre SEO par defaut')
            ->setHelp('Utilise quand un article ou une page n\'a pas de titre SEO propre. Apparait dans Google et l\'onglet navigateur. Max 70 caracteres.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('defaultSeoDescription', 'Meta description par defaut')
            ->setHelp('Description globale du site, affichee dans Google quand une page n\'a pas sa propre description. Max 160 caracteres.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]])
            ->hideOnIndex();

        yield TextField::new('googleAnalyticsId', 'Google Analytics ID')
            ->setHelp('Permet de suivre le trafic du site. Format : G-XXXXXXXXXX. Disponible dans votre compte Google Analytics.')
            ->hideOnIndex();

        yield TextField::new('googleSearchConsole', 'Google Search Console')
            ->setHelp('Code de verification pour prouver a Google que vous etes proprietaire du site. Disponible dans Google Search Console > Parametres.')
            ->hideOnIndex();

        yield AssociationField::new('favicon', 'Favicon')
            ->setHelp('Petite icone affichee dans l\'onglet du navigateur. Format carre recommande (32x32 ou 64x64 px).')
            ->hideOnIndex();

        // --- Panel Proprietaire (ROLE_SUPER_ADMIN) ---
        yield FormField::addPanel('Propriete')
            ->setIcon('fa fa-user-shield')
            ->collapsible()
            ->renderCollapsed()
            ->setPermission('ROLE_SUPER_ADMIN');

        yield AssociationField::new('owner', 'Proprietaire (Freelance)')
            ->setHelp('Freelance responsable de ce site')
            ->setPermission('ROLE_SUPER_ADMIN')
            ->hideOnIndex();
    }

    protected function getRedirectResponseAfterSave(AdminContext $context, string $action): RedirectResponse
    {
        $url = $this->container->get(AdminUrlGenerator::class)
            ->setController(self::class)
            ->setAction(Action::EDIT)
            ->setEntityId($context->getEntity()->getPrimaryKeyValue())
            ->generateUrl();

        return $this->redirect($url);
    }
}
