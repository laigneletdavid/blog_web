<?php

namespace App\Controller\Admin;

use App\Entity\Categorie;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ColorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class CategorieCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public static function getEntityFqcn(): string
    {
        return Categorie::class;
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Categories',
            'sections' => [
                [
                    'title' => 'Organiser vos contenus',
                    'content' => '<p>Les categories regroupent vos articles par thematique. Un article peut appartenir a <strong>plusieurs categories</strong>.</p>
                    <p>Les visiteurs peuvent filtrer les articles par categorie sur la page Blog.</p>',
                ],
                [
                    'title' => 'Couleur et image',
                    'content' => '<p>Chaque categorie a une <strong>couleur</strong> qui s\'affiche sous forme de badge sur les cartes articles, et une <strong>image</strong> optionnelle pour la page de la categorie.</p>',
                ],
                [
                    'title' => 'SEO des categories',
                    'content' => '<p>Chaque categorie a sa propre page avec son URL. Pensez a remplir le <em>Titre SEO</em> et la <em>Meta description</em> pour les categories les plus importantes.</p>',
                ],
            ],
            'tips' => [
                'Limitez-vous a 5-10 categories. Trop de categories diluent la navigation et le SEO.',
                'Vous pouvez ajouter une categorie dans le menu principal via Reglages > Navigation.',
            ],
        ];
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name');

        yield SlugField::new('slug')
            ->setTargetFieldName('name');

        yield ColorField::new('color');

        yield AssociationField::new('featured_media', 'Image')
            ->hideOnIndex();

        // --- Panel SEO ---
        yield FormField::addPanel('SEO')
            ->setIcon('fa fa-search')
            ->collapsible()
            ->renderCollapsed();

        yield TextField::new('seoTitle', 'Titre SEO')
            ->setHelp('Apparait dans l\'onglet du navigateur et comme titre dans Google. Max 70 caracteres. Laissez vide = nom de la categorie.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Meta description')
            ->setHelp('Texte affiche sous le titre dans les resultats Google. Decrivez le theme de cette categorie. Max 160 caracteres.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]])
            ->hideOnIndex();

        yield TextField::new('seoKeywords', 'Mots-cles')
            ->setHelp('Mots-cles de la categorie, separes par des virgules. Aide au referencement thematique.')
            ->hideOnIndex();

        yield BooleanField::new('noIndex', 'Masquer des moteurs')
            ->setHelp('Si active, Google n\'indexera pas cette categorie.')
            ->hideOnIndex();

        yield TextField::new('canonicalUrl', 'URL canonique')
            ->setHelp('A remplir uniquement si cette categorie existe aussi sur un autre site. Laissez vide sinon.')
            ->hideOnIndex();
    }
}
