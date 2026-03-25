<?php

namespace App\Controller\Admin;

use App\Entity\Page;
use App\Enum\VisibilityEnum;
use App\Service\SiteContext;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class PageCrudController extends AbstractCrudController
{
    public function __construct(
        private readonly SiteContext $siteContext,
    ) {
    }

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

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->update(Crud::PAGE_INDEX, Action::DELETE, function (Action $action) {
                return $action->displayIf(fn (Page $page) => !$page->isSystem());
            })
            ->update(Crud::PAGE_DETAIL, Action::DELETE, function (Action $action) {
                return $action->displayIf(fn (Page $page) => !$page->isSystem());
            });
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Contenu ---
        yield FormField::addPanel('Contenu')
            ->setIcon('fa fa-pen')
            ->collapsible();

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
            ->setIcon('fa fa-cog')
            ->collapsible();

        yield AssociationField::new('featured_media', 'Image mise en avant');

        yield BooleanField::new('published', 'Publiée');

        if ($this->siteContext->hasModule('private_pages')) {
            yield ChoiceField::new('visibility', 'Visibilite')
                ->setChoices(VisibilityEnum::choices())
                ->renderExpanded(false)
                ->setHelp('Public = visible par tous. Membres = connectes uniquement. Admin = administrateurs uniquement.');
        }

        yield ChoiceField::new('template', 'Mise en page')
            ->setChoices([
                'Par défaut (sidebar droite)' => 'default',
                'Pleine largeur' => 'full-width',
                'Sidebar gauche' => 'sidebar-left',
            ])
            ->renderExpanded(false)
            ->setHelp('Choisissez la disposition de la page');

        // --- Panel Avancé (collapsed) ---
        yield FormField::addPanel('Avancé')
            ->setIcon('fa fa-sliders-h')
            ->collapsible()
            ->renderCollapsed();

        yield SlugField::new('slug')
            ->setTargetFieldName('title')
            ->setHelp('Généré automatiquement depuis le titre')
            ->hideOnIndex();

        yield BooleanField::new('is_system', 'Page système')
            ->renderAsSwitch(false)
            ->setFormTypeOption('disabled', true)
            ->hideOnIndex();

        yield DateTimeField::new('created_at', 'Créée le')
            ->hideOnForm();

        yield DateTimeField::new('updated_at', 'Modifiée le')
            ->hideOnForm();

        // --- Panel SEO ---
        yield FormField::addPanel('SEO')
            ->setIcon('fa fa-search')
            ->collapsible()
            ->renderCollapsed();

        yield TextField::new('seoTitle', 'Titre SEO')
            ->setHelp('Apparait dans l\'onglet du navigateur et comme titre dans Google. Un bon titre attire les clics. Max 70 caracteres. Laissez vide = titre de la page.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Meta description')
            ->setHelp('Texte affiche sous le titre dans les resultats Google. Un bon resume incite au clic et ameliore le taux de visite. Max 160 caracteres.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]])
            ->hideOnIndex();

        yield TextField::new('seoKeywords', 'Mots-cles')
            ->setHelp('Mots-cles principaux de la page, separes par des virgules. Aide au referencement thematique.')
            ->hideOnIndex();

        yield BooleanField::new('noIndex', 'Masquer des moteurs')
            ->setHelp('Si active, Google n\'indexera pas cette page. Utile pour les pages privees ou en construction.')
            ->hideOnIndex();

        yield TextField::new('canonicalUrl', 'URL canonique')
            ->setHelp('A remplir uniquement si ce contenu existe aussi sur un autre site, pour eviter le contenu duplique. Laissez vide sinon.')
            ->hideOnIndex();
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

    public function deleteEntity(\Doctrine\ORM\EntityManagerInterface $entityManager, $entityInstance): void
    {
        if ($entityInstance instanceof Page && $entityInstance->isSystem()) {
            $this->addFlash('danger', 'Les pages système ne peuvent pas être supprimées.');
            return;
        }

        parent::deleteEntity($entityManager, $entityInstance);
    }
}
