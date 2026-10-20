<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use App\Entity\User;
use Doctrine\ORM\QueryBuilder;
use App\Enum\VisibilityEnum;
use App\Repository\PageViewRepository;
use App\Service\ArticleNotificationService;
use App\Service\SeoAnalyzer;
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
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_AUTHOR')]
class ArticleCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;
    use Trait\SeoScoreTrait;
    use Trait\SlugFieldHelperTrait;

    public function __construct(
        private readonly ArticleNotificationService $notificationService,
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
        return Article::class;
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Articles',
            'sections' => [
                [
                    'title' => 'L\'editeur de contenu',
                    'content' => '<p>L\'editeur visuel vous permet de mettre en forme vos articles : <strong>gras</strong>, <em>italique</em>, titres, listes, images, videos YouTube, citations et blocs de code.</p>
                    <p>Vous pouvez aussi inserer des <strong>documents telechargeables</strong> (PDF, DOCX, XLSX, ZIP...) via le bouton <em>Document</em> de la barre d\'outils ou la commande <code>/document</code>. Ils s\'affichent en carte cliquable avec icone, nom et taille.</p>
                    <p>Votre brouillon est <strong>sauvegarde automatiquement</strong> toutes les 30 secondes dans votre navigateur.</p>',
                ],
                [
                    'title' => 'Publication',
                    'content' => '<ul>
                        <li>Par defaut, un article est en <strong>brouillon</strong> (non visible)</li>
                        <li>Cochez <em>Publie</em> pour le rendre visible immediatement</li>
                        <li>Ou definissez une <strong>date de publication programmee</strong> : l\'article sera publie automatiquement a la date et heure choisies, des qu\'un visiteur accede au site</li>
                        <li>Si une date future est definie, l\'article reste en brouillon meme si <em>Publie</em> est coche</li>
                        <li>Les abonnes sont notifies par email au moment de la publication (immediate ou programmee)</li>
                    </ul>',
                ],
                [
                    'title' => 'Article vedette',
                    'content' => '<p>Un article marque <em>vedette</em> est affiche en evidence en haut de la page Blog. Un seul article peut etre vedette a la fois.</p>',
                ],
                [
                    'title' => 'SEO',
                    'content' => '<p>Le panneau <em>SEO</em> (en bas du formulaire) vous permet de personnaliser le titre et la description qui apparaissent dans Google. Si vous les laissez vides, le titre et l\'accroche de l\'article sont utilises.</p>',
                ],
            ],
            'tips' => [
                'Ajoutez toujours une image mise en avant et un texte d\'accroche pour rendre vos articles plus attractifs.',
                'Un bon titre SEO fait entre 50 et 70 caracteres, et la meta-description entre 120 et 160.',
                'Utilisez la publication programmee pour preparer vos articles a l\'avance et maintenir un rythme regulier.',
                'Pour partager un PDF ou une plaquette, inserez-le directement depuis l\'editeur via le bouton Document : il s\'affichera en carte cliquable.',
            ],
        ];
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Articles')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvel article')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier l\'article')
            ->setDefaultSort(['createdAt' => 'DESC']);
    }

    public function configureActions(Actions $actions): Actions
    {
        $viewOnSite = Action::new('viewOnSite', 'Voir sur le site', 'fa fa-external-link-alt')
            ->linkToUrl(fn (Article $article) => $this->generateUrl('app_article_show', ['slug' => $article->getSlug()]))
            ->setHtmlAttributes(['target' => '_blank'])
            ->displayIf(fn (Article $article) => $article->isPublished());

        return $actions
            ->add(Crud::PAGE_INDEX, $viewOnSite)
            ->add(Crud::PAGE_EDIT, $viewOnSite);
    }

    /**
     * Formulaire en deux colonnes : ecrire a gauche, publier a droite.
     * Les reglages techniques (adresse, canonique, mots-cles...) ne sortent qu'en mode expert.
     */
    public function configureFields(string $pageName): iterable
    {
        $expert = $this->adminMode->isExpert();

        // Liste : score SEO, titre, categories, image, statut, vues, dates
        yield $this->seoScoreField();

        // ===== Colonne principale : le contenu =====
        yield FormField::addColumn('col-lg-8');

        yield TextField::new('title', 'Titre');

        yield TextField::new('featuredText', 'Résumé')
            ->setHelp('Une ou deux phrases, affichées dans la liste des articles.')
            ->hideOnIndex();

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
            ->setHelp('Laissez vide pour reprendre le titre et le résumé.');

        yield TextField::new('seoTitle', 'Titre dans Google')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Description dans Google')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 2]])
            ->hideOnIndex();

        // ===== Colonne laterale : publier et classer =====
        yield FormField::addColumn('col-lg-4');

        yield FormField::addFieldset('Publication')->setIcon('fa fa-paper-plane');

        yield BooleanField::new('published', 'En ligne')
            ->setHelp('Décoché : brouillon, visible de vous seul.');

        yield DateTimeField::new('scheduledAt', 'Programmer une date')
            ->setHelp('L\'article sera mis en ligne automatiquement à cette date.')
            ->hideOnIndex()
            ->setRequired(false);

        // Seuls les comptes qui ecrivent (ROLE_AUTHOR et +) sont proposes, pas les membres
        yield AssociationField::new('author', 'Auteur')
            ->setFormTypeOption('choice_label', 'displayName')
            ->setQueryBuilder(static fn (QueryBuilder $qb) => $qb
                ->andWhere(sprintf(
                    '(%1$s.roles LIKE :author OR %1$s.roles LIKE :admin OR %1$s.roles LIKE :freelance OR %1$s.roles LIKE :superAdmin)',
                    $qb->getRootAliases()[0],
                ))
                ->setParameter('author', '%ROLE_AUTHOR%')
                ->setParameter('admin', '%ROLE_ADMIN%')
                ->setParameter('freelance', '%ROLE_FREELANCE%')
                ->setParameter('superAdmin', '%ROLE_SUPER_ADMIN%'))
            ->hideOnIndex();

        yield FormField::addFieldset('Image')->setIcon('fa fa-image');

        yield AssociationField::new('featuredMedia', 'Image')
            ->setHelp('Son texte alternatif se règle dans Médias.');

        yield FormField::addFieldset('Classement')->setIcon('fa fa-tags');

        yield AssociationField::new('categories', 'Catégories');

        // Article::tags est en mappedBy (cote inverse). Sans by_reference=false,
        // Symfony Forms modifie la collection sans appeler addTag()/removeTag(),
        // donc rien n'est persiste cote owning (Tag). Ce flag force l'utilisation
        // des methodes add*/remove* qui propagent au cote proprietaire.
        yield AssociationField::new('tags', 'Étiquettes')
            ->setFormTypeOption('by_reference', false)
            ->hideOnIndex();

        yield BooleanField::new('isFeatured', 'Mettre en avant')
            ->setHelp('Affiché en tête de la page blog.')
            ->hideOnIndex();

        if ($expert) {
            yield FormField::addFieldset('Options avancées')
                ->setIcon('fa fa-sliders-h')
                ->setCssClass('bw-fieldset-expert');

            yield $this->slugField('title');

            if ($this->siteContext->hasModule('private_pages')) {
                yield ChoiceField::new('visibility', 'Visible par')
                    ->setChoices(VisibilityEnum::choices())
                    ->renderExpanded(false)
                    ->hideOnIndex();
            }

            yield TextField::new('seoKeywords', 'Mots-clés')
                ->setHelp('Ignorés par Google, utiles seulement à certains outils.')
                ->hideOnIndex();

            yield BooleanField::new('noIndex', 'Masquer des moteurs de recherche')
                ->hideOnIndex();

            yield TextField::new('canonicalUrl', 'Adresse canonique')
                ->setHelp('Seulement si ce texte existe aussi sur un autre site.')
                ->hideOnIndex();

            yield DateTimeField::new('publishedAt', 'Date de publication')
                ->setHelp('Remplie automatiquement à la première mise en ligne.')
                ->hideOnIndex();
        }

        // Colonnes de la liste uniquement
        $pvRepo = $this->pageViewRepository;
        yield IntegerField::new('viewCount', 'Vues')
            ->hideOnForm()
            ->formatValue(function ($value, Article $entity) use ($pvRepo) {
                return $pvRepo->countViewsByUrl('/article/' . $entity->getSlug());
            });

        yield DateTimeField::new('createdAt', 'Créé le')
            ->hideOnForm();

        yield DateTimeField::new('updatedAt', 'Modifié le')
            ->hideOnForm();
    }

    public function createEntity(string $entityFqcn): Article
    {
        $article = new Article();

        // L'auteur par defaut est le compte qui cree l'article (modifiable dans le formulaire)
        $user = $this->getUser();
        if ($user instanceof User) {
            $article->setAuthor($user);
        }

        return $article;
    }

    public function persistEntity(\Doctrine\ORM\EntityManagerInterface $entityManager, $entityInstance): void
    {
        /** @var Article $entityInstance */
        $entityInstance->setCreatedAt(new \DateTime());
        $entityInstance->setUpdatedAt(new \DateTime());

        // Si scheduled_at est dans le futur, forcer brouillon (le subscriber publiera)
        $this->handleScheduledPublication($entityInstance);

        $isNewlyPublished = false;
        if ($entityInstance->isPublished() && $entityInstance->getPublishedAt() === null) {
            $entityInstance->setPublishedAt(new \DateTime());
            $isNewlyPublished = true;
        }

        parent::persistEntity($entityManager, $entityInstance);

        // Notification aux abonnés si l'article est publié à la création
        if ($isNewlyPublished) {
            $this->notificationService->notifySubscribers($entityInstance);
        }
    }

    public function updateEntity(\Doctrine\ORM\EntityManagerInterface $entityManager, $entityInstance): void
    {
        /** @var Article $entityInstance */
        $entityInstance->setUpdatedAt(new \DateTime());

        // Si scheduled_at est dans le futur, forcer brouillon (le subscriber publiera)
        $this->handleScheduledPublication($entityInstance);

        $isNewlyPublished = false;
        if ($entityInstance->isPublished() && $entityInstance->getPublishedAt() === null) {
            $entityInstance->setPublishedAt(new \DateTime());
            $isNewlyPublished = true;
        }

        parent::updateEntity($entityManager, $entityInstance);

        // Notification aux abonnés si l'article vient d'être publié
        if ($isNewlyPublished) {
            $this->notificationService->notifySubscribers($entityInstance);
        }
    }

    /**
     * Gere la coherence entre scheduled_at et published :
     * - scheduled_at dans le futur → force brouillon (publication auto par le subscriber)
     * - scheduled_at dans le passe → publication immediate
     * - publication manuelle → nettoie scheduled_at
     */
    private function handleScheduledPublication(Article $entityInstance): void
    {
        $scheduledAt = $entityInstance->getScheduledAt();

        if ($scheduledAt !== null) {
            if ($scheduledAt > new \DateTime()) {
                // Date future : forcer brouillon, le subscriber publiera
                $entityInstance->setPublished(false);
                $entityInstance->setPublishedAt(null);
            } else {
                // Date passee : publier immediatement
                $entityInstance->setPublished(true);
                if ($entityInstance->getPublishedAt() === null) {
                    $entityInstance->setPublishedAt($scheduledAt);
                }
                $entityInstance->setScheduledAt(null);
            }
        } elseif ($entityInstance->isPublished()) {
            // Publication manuelle sans programmation : nettoyer scheduled_at
            $entityInstance->setScheduledAt(null);
        }
    }
}
