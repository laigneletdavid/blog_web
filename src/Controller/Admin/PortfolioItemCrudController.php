<?php

namespace App\Controller\Admin;

use App\Entity\PortfolioItem;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Filter\BooleanFilter;
use EasyCorp\Bundle\EasyAdminBundle\Filter\EntityFilter;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class PortfolioItemCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return PortfolioItem::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Réalisations')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle réalisation')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la réalisation')
            ->setDefaultSort(['position' => 'ASC']);
    }

    public function configureFilters(Filters $filters): Filters
    {
        return $filters
            ->add(EntityFilter::new('category', 'Categorie'))
            ->add(BooleanFilter::new('isActive', 'Active'))
            ->add(BooleanFilter::new('isFeatured', 'Mis en avant'));
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Contenu ---
        yield FormField::addPanel('Contenu')
            ->setIcon('fa fa-pen')
            ->collapsible();

        yield TextField::new('title', 'Titre')
            ->setHelp('Nom de la réalisation, affiché en titre sur la page et dans la grille.');

        yield TextareaField::new('shortDescription', 'Description courte')
            ->setHelp('Résumé affiché dans la grille des réalisations (2-3 lignes max). Soyez accrocheur !')
            ->setFormTypeOptions(['attr' => ['rows' => 3]])
            ->hideOnIndex();

        yield TextareaField::new('blocksJson', 'Contenu détaillé')
            ->setFormTypeOptions(['attr' => ['data-tiptap-editor' => '', 'style' => 'display: none']])
            ->setColumns('col-12')
            ->setHelp('Description complete de la realisation (editeur visuel). Tapez <strong>/</strong> pour inserer un bloc (image, colonnes, encart...).')
            ->hideOnIndex();

        yield AssociationField::new('image', 'Image principale')
            ->setHelp('Image de couverture affichée dans la grille (ratio 4:3 recommandé) et en haut de la page de détail.')
            ->hideOnIndex();

        // --- Panel Projet ---
        yield FormField::addPanel('Projet')
            ->setIcon('fa fa-briefcase')
            ->collapsible();

        yield TextField::new('client', 'Client')
            ->setHelp('Nom du client ou de l\'entreprise pour qui la réalisation a été faite.');

        yield DateField::new('projectDate', 'Date de réalisation')
            ->setHelp('Date à laquelle le projet a été livré ou mis en ligne.')
            ->hideOnIndex();

        yield TextField::new('projectUrl', 'Lien du projet')
            ->setHelp('URL complète vers le projet en ligne (ex : https://www.monsite-client.fr). Un bouton « Voir le projet » sera affiché sur la page de détail.')
            ->hideOnIndex();

        yield AssociationField::new('tags', 'Tags')
            ->setHelp('Sélectionnez les technologies ou compétences utilisées. Les tags sont partagés avec le blog et le catalogue.')
            ->hideOnIndex();

        // --- Panel SEO ---
        yield FormField::addPanel('Référencement')
            ->setIcon('fa fa-search')
            ->collapsible()
            ->renderCollapsed();

        yield TextField::new('seoTitle', 'Titre SEO')
            ->setHelp('70 caractères max. Affiché dans Google. Laissez vide pour utiliser le titre de la réalisation.')
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Méta description')
            ->setHelp('160 caractères max. Texte affiché sous le titre dans les résultats Google.')
            ->setFormTypeOptions(['attr' => ['rows' => 2]])
            ->hideOnIndex();

        yield TextField::new('seoKeywords', 'Mots-clés')
            ->setHelp('Termes principaux séparés par des virgules (ex : site web, refonte, Symfony).')
            ->hideOnIndex();

        yield BooleanField::new('noIndex', 'Ne pas indexer')
            ->setHelp('Cochez pour empêcher Google d\'indexer cette réalisation (utile pour les projets confidentiels).')
            ->hideOnIndex();

        yield TextField::new('canonicalUrl', 'URL canonique')
            ->setHelp('À remplir uniquement si ce contenu existe aussi sur un autre site (ex : site du client).')
            ->hideOnIndex();

        // --- Panel Paramètres ---
        yield FormField::addPanel('Paramètres')
            ->setIcon('fa fa-cog')
            ->collapsible();

        yield SlugField::new('slug')
            ->setTargetFieldName('title')
            ->setHelp('Généré automatiquement depuis le titre.')
            ->hideOnIndex();

        yield AssociationField::new('category', 'Catégorie')
            ->setRequired(false)
            ->setHelp('Catégorie de la réalisation. Permet aux visiteurs de filtrer par type de projet.');

        yield IntegerField::new('position', 'Ordre')
            ->setHelp('Ordre d\'affichage dans la grille (0 = en premier).');

        yield BooleanField::new('isActive', 'Activée')
            ->setHelp('Désactivez pour masquer cette réalisation sans la supprimer.');

        yield BooleanField::new('isFeatured', 'Mise en avant')
            ->setHelp('Les réalisations mises en avant peuvent être affichées sur la page d\'accueil.');
    }
}
