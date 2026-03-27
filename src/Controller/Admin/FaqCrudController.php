<?php

namespace App\Controller\Admin;

use App\Entity\Faq;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class FaqCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Faq::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Questions fréquentes')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle question')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la question')
            ->setDefaultSort(['position' => 'ASC']);
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Contenu ---
        yield FormField::addPanel('Contenu')
            ->setIcon('fa fa-pen')
            ->collapsible();

        yield TextField::new('question', 'Question')
            ->setHelp('Formulez la question du point de vue du visiteur (ex : « Comment puis-je vous contacter ? »).');

        yield TextareaField::new('blocksJson', 'Réponse')
            ->setFormTypeOptions(['attr' => ['data-tiptap-editor' => '', 'style' => 'display: none']])
            ->setHelp('Reponse detaillee a la question (editeur visuel). Tapez <strong>/</strong> pour inserer un bloc (image, liste, encart...).')
            ->hideOnIndex();

        yield TextField::new('icon', 'Icône')
            ->setHelp('Optionnel. Icone affichee devant la question. Classe Bootstrap Icons (ex : bi-question-circle). Voir <a href="https://icons.getbootstrap.com/" target="_blank">icons.getbootstrap.com</a>')
            ->hideOnIndex();

        // --- Panel Parametres ---
        yield FormField::addPanel('Paramètres')
            ->setIcon('fa fa-cog')
            ->collapsible();

        yield SlugField::new('slug')
            ->setTargetFieldName('question')
            ->setHelp('Généré automatiquement depuis la question. Sert d\'ancre dans l\'URL (/faq#slug).')
            ->hideOnIndex();

        yield AssociationField::new('category', 'Catégorie')
            ->setRequired(false)
            ->setHelp('Optionnel. Permet de regrouper les questions par thème sur la page FAQ.');

        yield IntegerField::new('position', 'Ordre')
            ->setHelp('Ordre d\'affichage dans sa catégorie (0 = en premier).');

        yield BooleanField::new('isActive', 'Activée')
            ->setHelp('Désactivez pour masquer cette question sans la supprimer.');
    }
}
