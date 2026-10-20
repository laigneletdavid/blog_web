<?php

namespace App\Controller\Admin;

use App\Entity\Page;
use App\Enum\VisibilityEnum;
use App\Repository\PageViewRepository;
use App\Service\SeoAnalyzer;
use App\Service\SiteContext;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Context\AdminContext;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_AUTHOR')]
class PageCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;
    use Trait\SeoScoreTrait;
    use Trait\SlugFieldHelperTrait;

    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly PageViewRepository $pageViewRepository,
        private readonly SeoAnalyzer $seoAnalyzer,
        private readonly \App\Service\AdminModeService $adminMode,
    ) {
    }

    private function getSeoAnalyzer(): SeoAnalyzer
    {
        return $this->seoAnalyzer;
    }

    public static function getEntityFqcn(): string
    {
        return Page::class;
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Pages',
            'sections' => [
                [
                    'title' => 'Pages systeme vs personnalisees',
                    'content' => '<p>Les <strong>pages systeme</strong> (mentions legales, politique de confidentialite) ne peuvent pas etre supprimees, mais leur contenu est modifiable.</p>
                    <p>Vous pouvez creer autant de <strong>pages personnalisees</strong> que necessaire (A propos, Nos services, etc.).</p>',
                ],
                [
                    'title' => 'Mise en page',
                    'content' => '<ul>
                        <li><strong>Par defaut</strong> — Contenu avec sidebar droite (widgets, categories, archives)</li>
                        <li><strong>Pleine largeur</strong> — Contenu sur toute la largeur, ideal pour les presentations</li>
                        <li><strong>Sidebar gauche</strong> — Widgets a gauche, contenu a droite</li>
                    </ul>',
                ],
                [
                    'title' => 'L\'editeur',
                    'content' => '<p>Meme editeur visuel que pour les articles : texte riche, titres, listes, images, videos YouTube, encarts, colonnes et tableaux.</p>
                    <p>Vous pouvez aussi inserer des <strong>documents telechargeables</strong> (PDF, DOCX, XLSX, ZIP...) via le bouton <em>Document</em> de la barre d\'outils ou la commande <code>/document</code>. Ils s\'affichent en carte cliquable avec icone, nom et taille &mdash; pratique pour les plaquettes, tarifs, CGV ou formulaires a telecharger.</p>
                    <p>Votre brouillon est sauvegarde automatiquement.</p>',
                ],
            ],
            'tips' => [
                'N\'oubliez pas d\'ajouter vos nouvelles pages dans la navigation (Reglages > Navigation).',
                'Les pages systeme sont essentielles pour la conformite RGPD. Mettez-les a jour regulierement.',
                'Pour les pages "Tarifs" ou "Documents legaux", inserez vos PDF directement dans le contenu via le bouton Document de l\'editeur.',
            ],
        ];
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Pages')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle page')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la page')
            ->setDefaultSort(['createdAt' => 'DESC']);
    }

    public function createIndexQueryBuilder(
        $searchDto,
        $entityDto,
        $fields,
        $filters,
    ): \Doctrine\ORM\QueryBuilder {
        $qb = parent::createIndexQueryBuilder($searchDto, $entityDto, $fields, $filters);
        $qb->andWhere('entity.template != :landing')
            ->setParameter('landing', 'landing');

        return $qb;
    }

    public function configureActions(Actions $actions): Actions
    {
        $viewOnSite = Action::new('viewOnSite', 'Voir sur le site', 'fa fa-external-link-alt')
            ->linkToUrl(fn (Page $page) => $this->generateUrl('app_page_show', ['slug' => $page->getSlug()]))
            ->setHtmlAttributes(['target' => '_blank'])
            ->displayIf(fn (Page $page) => $page->isPublished());

        return $actions
            ->add(Crud::PAGE_INDEX, $viewOnSite)
            ->add(Crud::PAGE_EDIT, $viewOnSite)
            ->update(Crud::PAGE_INDEX, Action::DELETE, function (Action $action) {
                return $action->displayIf(fn (Page $page) => !$page->isSystem());
            })
            ->update(Crud::PAGE_DETAIL, Action::DELETE, function (Action $action) {
                return $action->displayIf(fn (Page $page) => !$page->isSystem());
            });
    }

    /**
     * Formulaire en deux colonnes : ecrire a gauche, publier a droite.
     * Mise en page, adresse et reglages SEO techniques ne sortent qu'en mode expert.
     */
    public function configureFields(string $pageName): iterable
    {
        $expert = $this->adminMode->isExpert();

        yield $this->seoScoreField();

        // ===== Colonne principale : le contenu =====
        yield FormField::addColumn('col-lg-8');

        yield TextField::new('title', 'Titre');

        yield TextareaField::new('blocksJson', 'Contenu')
            ->setFormTypeOptions([
                'attr' => [
                    'data-tiptap-editor' => '',
                    'style' => 'display: none',
                ],
            ])
            ->setColumns('col-12')
            ->setHelp('Tapez <strong>/</strong> pour insérer rapidement un bloc : image, vidéo, encart, colonnes, document.')
            ->hideOnIndex();

        // Apercu Google : le JS admin-simple affiche le rendu au-dessus de ces deux champs
        yield FormField::addFieldset('Dans Google')
            ->setHelp('Laissez vide pour reprendre le titre de la page.');

        yield TextField::new('seoTitle', 'Titre dans Google')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Description dans Google')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 2]])
            ->hideOnIndex();

        // ===== Colonne laterale =====
        yield FormField::addColumn('col-lg-4');

        yield FormField::addFieldset('Publication')->setIcon('fa fa-paper-plane');

        yield BooleanField::new('published', 'En ligne')
            ->setHelp('Décoché : brouillon, visible de vous seul.');

        yield FormField::addFieldset('Image')->setIcon('fa fa-image');

        yield AssociationField::new('featuredMedia', 'Image')
            ->setHelp('Son texte alternatif se règle dans Médias.');

        if ($expert) {
            yield FormField::addFieldset('Options avancées')
                ->setIcon('fa fa-sliders-h')
                ->setCssClass('bw-fieldset-expert');

            yield ChoiceField::new('template', 'Mise en page')
                ->setChoices([
                    'Par défaut (colonne à droite)' => 'default',
                    'Pleine largeur' => 'full-width',
                    'Colonne à gauche' => 'sidebar-left',
                ])
                ->renderExpanded(false)
                ->hideOnIndex();

            if ($this->siteContext->hasModule('private_pages')) {
                yield ChoiceField::new('visibility', 'Visible par')
                    ->setChoices(VisibilityEnum::choices())
                    ->renderExpanded(false);
            }

            yield $this->slugField('title');

            yield TextField::new('seoKeywords', 'Mots-clés')
                ->setHelp('Ignorés par Google, utiles seulement à certains outils.')
                ->hideOnIndex();

            yield BooleanField::new('noIndex', 'Masquer des moteurs de recherche')
                ->hideOnIndex();

            yield TextField::new('canonicalUrl', 'Adresse canonique')
                ->setHelp('Seulement si ce texte existe aussi sur un autre site.')
                ->hideOnIndex();

            yield BooleanField::new('isSystem', 'Page système')
                ->renderAsSwitch(false)
                ->setFormTypeOption('disabled', true)
                ->hideOnIndex();
        }

        // Colonnes de la liste uniquement
        $pvRepo = $this->pageViewRepository;
        yield IntegerField::new('viewCount', 'Vues')
            ->hideOnForm()
            ->formatValue(function ($value, Page $entity) use ($pvRepo) {
                return $pvRepo->countViewsByUrl('/' . $entity->getSlug());
            });

        yield DateTimeField::new('createdAt', 'Créée le')
            ->hideOnForm();

        yield DateTimeField::new('updatedAt', 'Modifiée le')
            ->hideOnForm();
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
