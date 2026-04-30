<?php

namespace App\Controller\Admin;

use App\Entity\TagGroup;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ColorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class TagGroupCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;
    use Trait\SlugFieldHelperTrait;

    public static function getEntityFqcn(): string
    {
        return TagGroup::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Famille de tags')
            ->setEntityLabelInPlural('Familles de tags')
            ->setPageTitle(Crud::PAGE_INDEX, 'Familles de tags')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle famille')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la famille')
            ->setDefaultSort(['displayOrder' => 'ASC', 'name' => 'ASC']);
    }

    public function configureFields(string $pageName): iterable
    {
        yield IdField::new('id')->hideOnForm();

        yield TextField::new('name', 'Nom')
            ->setHelp('Ex: <em>Villes</em>, <em>Métiers</em>, <em>Niveaux</em>. Sert à regrouper les tags pour générer des filtres dédiés sur l\'annuaire ou le catalogue.');

        yield $this->slugField('name', 'Identifiant URL. Généré automatiquement à partir du nom.');

        yield ColorField::new('color', 'Couleur')
            ->setHelp('Couleur des badges et pills pour cette famille (front + admin). Choisissez une couleur lisible.');

        yield IntegerField::new('displayOrder', 'Ordre')
            ->setHelp('Ordre d\'affichage des familles dans les filtres front. Plus petit = plus haut. 0 par défaut.');

        yield TextareaField::new('description', 'Description')
            ->setHelp('Optionnel. Note interne pour expliquer l\'usage de cette famille.')
            ->setFormTypeOptions(['attr' => ['rows' => 3]])
            ->hideOnIndex();

        yield AssociationField::new('tags', 'Tags rattachés')
            ->setHelp('Tags appartenant à cette famille. Gérés depuis le CRUD Tags.')
            ->onlyOnDetail();
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Familles de tags',
            'sections' => [
                [
                    'title' => 'Pourquoi des familles ?',
                    'content' => '<p>Une <strong>famille de tags</strong> regroupe des tags partageant un même thème (ex: <em>Villes</em>, <em>Métiers</em>, <em>Niveaux</em>, <em>Marques</em>).</p>
                    <p>Chaque famille génère <strong>automatiquement un filtre dédié</strong> sur les pages qui exposent les tags (annuaire, catalogue, blog).</p>
                    <p>Le rattachement d\'un tag à une famille reste <strong>optionnel</strong> : un tag sans famille reste utilisable comme avant (sujets blog).</p>',
                ],
                [
                    'title' => 'Cas d\'usage typiques',
                    'content' => '<ul>
                        <li><strong>Annuaire</strong> — familles <em>Villes</em> + <em>Métiers</em> pour permettre aux visiteurs de filtrer par localisation et compétence.</li>
                        <li><strong>Catalogue</strong> — familles <em>Marques</em>, <em>Matières</em>, <em>Saisons</em> pour des filtres produits avancés.</li>
                        <li><strong>Blog</strong> — famille <em>Niveau</em> (débutant / avancé) ou <em>Format</em> (tutoriel / actu) pour segmenter les articles.</li>
                    </ul>',
                ],
                [
                    'title' => 'Bonne pratique',
                    'content' => '<p>Créez d\'abord la famille, puis allez dans <em>Tags</em> pour rattacher les tags concernés. Les filtres front apparaissent automatiquement dès qu\'un contenu actif utilise au moins un tag de la famille.</p>',
                ],
            ],
            'tips' => [
                'Choisissez une couleur lisible : elle sert aux badges et aux pills sur le front.',
                'L\'ordre d\'affichage permet de prioriser les filtres les plus utiles (Villes avant Métiers, par exemple).',
                'Vous pouvez créer une famille même si elle n\'a pas encore de tags — vous les rattacherez plus tard.',
                'Un tag peut changer de famille à tout moment sans casser les fiches qui l\'utilisent.',
            ],
        ];
    }
}
