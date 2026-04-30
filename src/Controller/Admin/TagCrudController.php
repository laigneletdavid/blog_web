<?php

namespace App\Controller\Admin;

use App\Entity\Tag;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class TagCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;
    use Trait\SlugFieldHelperTrait;

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
        yield TextField::new('name', 'Nom');
        yield $this->slugField('name', null, false);

        yield AssociationField::new('tagGroup', 'Famille')
            ->setHelp('Optionnel. Regroupe le tag dans une famille (ex: Villes, Métiers) pour générer des filtres front dédiés. Sans famille, le tag reste "général" — comportement compatible avec l\'usage blog actuel.')
            ->setRequired(false);

        yield AssociationField::new('article', 'Articles')
            ->setHelp('Articles associés à ce tag')
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
            ],
        ];
    }
}
