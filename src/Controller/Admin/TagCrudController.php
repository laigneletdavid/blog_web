<?php

namespace App\Controller\Admin;

use App\Entity\Tag;
use App\Service\SeoAnalyzer;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class TagCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;
    use Trait\SeoScoreTrait;
    use Trait\SlugFieldHelperTrait;

    public function __construct(
        private readonly SeoAnalyzer $seoAnalyzer,
    ) {
    }

    private function getSeoAnalyzer(): SeoAnalyzer
    {
        return $this->seoAnalyzer;
    }

    public static function getEntityFqcn(): string
    {
        return Tag::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Tag')
            ->setEntityLabelInPlural('Tags')
            ->setDefaultSort(['name' => 'ASC']);
    }

    public function configureFields(string $pageName): iterable
    {
        yield IdField::new('id')->hideOnForm();
        yield $this->seoScoreField();
        yield TextField::new('name', 'Nom');
        yield $this->slugField('name', null, false);

        yield AssociationField::new('tagGroup', 'Famille')
            ->setHelp('Optionnel. Regroupe le tag dans une famille (ex: Villes, Métiers) pour générer des filtres front dédiés. Sans famille, le tag reste "général" — comportement compatible avec l\'usage blog actuel.')
            ->setRequired(false);

        yield AssociationField::new('article', 'Articles')
            ->setHelp('Articles associés à ce tag')
            ->hideOnIndex();

        // --- Panel SEO ---
        yield FormField::addPanel('SEO')
            ->setIcon('fa fa-search')
            ->collapsible()
            ->renderCollapsed();

        yield TextField::new('seoTitle', 'Titre SEO')
            ->setHelp('Apparait dans l\'onglet du navigateur et comme titre dans Google. Max 70 caracteres. Laissez vide = nom du tag.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Meta description')
            ->setHelp('Texte affiche sous le titre dans les resultats Google. Max 160 caracteres.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]])
            ->hideOnIndex();

        yield TextField::new('seoKeywords', 'Mots-cles')
            ->setHelp('Mots-cles du tag, separes par des virgules.')
            ->hideOnIndex();

        yield BooleanField::new('noIndex', 'Masquer des moteurs')
            ->setHelp('Active par defaut pour les tags. Desactivez pour indexer un tag strategique dont vous avez rempli le titre SEO et la meta description.')
            ->hideOnIndex();

        yield TextField::new('canonicalUrl', 'URL canonique')
            ->setHelp('A remplir uniquement si ce contenu existe aussi sur un autre site. Laissez vide sinon.')
            ->hideOnIndex();
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Tags',
            'sections' => [
                [
                    'title' => 'Classification',
                    'content' => '<p>Les tags permettent une classification fine par mots-cles. Ils sont partages entre les <strong>articles</strong>, l\'<strong>annuaire</strong>, les <strong>produits</strong> et le <strong>portfolio</strong>.</p>
                    <p>Chaque tag genere sa propre page (<code>/tag/{slug}</code>) listant tous les contenus associes, toutes sources confondues.</p>',
                ],
                [
                    'title' => 'Familles de tags',
                    'content' => '<p>Vous pouvez regrouper les tags par <strong>famille</strong> (Villes, Métiers, Marques...) pour générer automatiquement des filtres front dédiés.</p>
                    <p>Le rattachement à une famille reste <strong>optionnel</strong> : un tag sans famille fonctionne comme avant.</p>
                    <p>Pour gérer les familles, allez dans <em>Classification > Familles de tags</em>.</p>',
                ],
            ],
            'tips' => [
                'Pour des filtres front dédiés (ex: filtrer l\'annuaire par ville), créez d\'abord une Famille puis rattachez vos tags.',
                'Un même tag peut servir à plusieurs modules (ex: tag "Paris" sur des articles ET sur des fiches d\'annuaire).',
                'Les tags non utilisés restent visibles dans l\'admin mais n\'apparaissent pas sur le front tant qu\'aucun contenu ne les emploie.',
                '<strong>SEO</strong> : les tags sont masqués des moteurs de recherche par défaut (noIndex). Pour promouvoir un tag stratégique (ex: une ville, un métier), décochez « Masquer des moteurs » dans le panel SEO.',
            ],
        ];
    }
}
