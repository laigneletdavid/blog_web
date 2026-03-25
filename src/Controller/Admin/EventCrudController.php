<?php

namespace App\Controller\Admin;

use App\Entity\Event;
use App\Service\EventNotificationService;
use Doctrine\ORM\EntityManagerInterface;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Filter\BooleanFilter;
use EasyCorp\Bundle\EasyAdminBundle\Filter\DateTimeFilter;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class EventCrudController extends AbstractCrudController
{
    public function __construct(
        private readonly EventNotificationService $notificationService,
    ) {
    }

    public static function getEntityFqcn(): string
    {
        return Event::class;
    }

    public function persistEntity(EntityManagerInterface $em, $entityInstance): void
    {
        parent::persistEntity($em, $entityInstance);

        if ($entityInstance instanceof Event && $entityInstance->isActive() && $entityInstance->getNotifiedAt() === null) {
            $this->notificationService->notifySubscribers($entityInstance);
            $entityInstance->setNotifiedAt(new \DateTime());
            $em->flush();
        }
    }

    public function updateEntity(EntityManagerInterface $em, $entityInstance): void
    {
        parent::updateEntity($em, $entityInstance);

        if ($entityInstance instanceof Event && $entityInstance->isActive() && $entityInstance->getNotifiedAt() === null) {
            $this->notificationService->notifySubscribers($entityInstance);
            $entityInstance->setNotifiedAt(new \DateTime());
            $em->flush();
        }
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Événements')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvel événement')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier l\'événement')
            ->setDefaultSort(['dateStart' => 'DESC']);
    }

    public function configureFilters(Filters $filters): Filters
    {
        return $filters
            ->add(DateTimeFilter::new('dateStart', 'Date de début'))
            ->add(BooleanFilter::new('isActive', 'Actif'))
            ->add(BooleanFilter::new('isFeatured', 'Mis en avant'));
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Contenu ---
        yield FormField::addPanel('Contenu')
            ->setIcon('fa fa-pen')
            ->collapsible();

        yield TextField::new('title', 'Titre');

        yield TextareaField::new('shortDescription', 'Description courte')
            ->setHelp('Résumé affiché dans les cartes et les listes.')
            ->setFormTypeOptions(['attr' => ['rows' => 3]])
            ->hideOnIndex();

        yield TextareaField::new('blocksJson', 'Contenu détaillé')
            ->setFormTypeOptions(['attr' => ['data-tiptap-editor' => '', 'style' => 'display: none']])
            ->setHelp('Description complète de l\'événement (éditeur visuel).')
            ->hideOnIndex();

        yield AssociationField::new('image', 'Image')
            ->hideOnIndex();

        // --- Panel Date & Lieu ---
        yield FormField::addPanel('Date & Lieu')
            ->setIcon('fa fa-calendar')
            ->collapsible();

        yield DateTimeField::new('dateStart', 'Date de début')
            ->setFormat('dd/MM/yyyy HH:mm');

        yield DateTimeField::new('dateEnd', 'Date de fin')
            ->setFormat('dd/MM/yyyy HH:mm')
            ->setHelp('Optionnel. Laisser vide pour un événement sans heure de fin.')
            ->setRequired(false)
            ->hideOnIndex();

        yield TextField::new('location', 'Lieu')
            ->setHelp('Adresse ou nom du lieu (ex: Salle des fêtes, 12 rue de la Paix, Paris)');

        // --- Panel SEO ---
        yield FormField::addPanel('SEO')
            ->setIcon('fa fa-search')
            ->collapsible()
            ->renderCollapsed();

        yield TextField::new('seoTitle', 'Titre SEO')
            ->setHelp('Max 70 caractères. Si vide, le titre de l\'événement est utilisé.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Meta description')
            ->setHelp('Max 160 caractères. Résumé affiché dans les résultats Google.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]])
            ->hideOnIndex();

        yield TextField::new('seoKeywords', 'Mots-clés')
            ->setHelp('Séparés par des virgules.')
            ->hideOnIndex();

        yield BooleanField::new('noIndex', 'Masquer des moteurs')
            ->setHelp('Empêche l\'indexation par Google.')
            ->hideOnIndex();

        yield TextField::new('canonicalUrl', 'URL canonique')
            ->setHelp('Si le contenu existe sur une autre URL.')
            ->hideOnIndex();

        // --- Panel Paramètres ---
        yield FormField::addPanel('Paramètres')
            ->setIcon('fa fa-cog')
            ->collapsible();

        yield SlugField::new('slug')
            ->setTargetFieldName('title')
            ->hideOnIndex();

        yield BooleanField::new('isActive', 'Actif');
        yield BooleanField::new('isFeatured', 'Mis en avant');

        yield AssociationField::new('linkedProduct', 'Produit lie')
            ->setHelp('Associer un produit du catalogue pour permettre l\'achat/inscription directe depuis l\'evenement.')
            ->setRequired(false)
            ->hideOnIndex();
    }
}
