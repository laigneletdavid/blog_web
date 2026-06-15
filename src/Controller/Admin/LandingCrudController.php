<?php

namespace App\Controller\Admin;

use App\Entity\Page;
use App\Repository\PageViewRepository;
use App\Service\SiteContext;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class LandingCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;
    use Trait\SlugFieldHelperTrait;

    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly PageViewRepository $pageViewRepository,
    ) {
    }

    public static function getEntityFqcn(): string
    {
        return Page::class;
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Landing pages',
            'sections' => [
                [
                    'title' => 'Qu\'est-ce qu\'une landing page ?',
                    'content' => '<p>Une <strong>landing page</strong> est une page de conversion sans menu ni navigation. Le visiteur n\'a qu\'un seul choix : cliquer sur le CTA (appel a l\'action).</p>
                    <p>Ideale pour les campagnes marketing, partenariats, offres speciales ou prospection.</p>',
                ],
                [
                    'title' => 'CTA et formulaire',
                    'content' => '<ul>
                        <li><strong>Lien RDV rempli</strong> — Le bouton CTA renvoie vers votre calendrier (Calendly, Cal.com...). Un formulaire secondaire peut etre affiche en complement.</li>
                        <li><strong>Lien RDV vide</strong> — Le CTA renvoie vers le formulaire de contact integre (nom, email, activite).</li>
                    </ul>',
                ],
                [
                    'title' => 'Suivi UTM',
                    'content' => '<p>Les parametres UTM (<code>?utm_source=linkedin&amp;utm_campaign=demo</code>) sont captures automatiquement dans le formulaire et enregistres avec le message de contact.</p>
                    <p>Si un lien RDV est configure, les UTM sont aussi passes dans l\'URL du calendrier.</p>',
                ],
            ],
            'tips' => [
                'Les landing pages sont automatiquement masquees des moteurs de recherche (noindex).',
                'Gardez un seul objectif par landing page : un CTA, pas deux.',
                'Utilisez la meta description comme sous-titre du hero.',
                'Testez vos UTM : ajoutez ?utm_source=test a l\'URL pour verifier le suivi.',
            ],
        ];
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Landing pages')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouvelle landing page')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier la landing page')
            ->setDefaultSort(['created_at' => 'DESC']);
    }

    public function createIndexQueryBuilder(
        $searchDto,
        $entityDto,
        $fields,
        $filters,
    ): \Doctrine\ORM\QueryBuilder {
        $qb = parent::createIndexQueryBuilder($searchDto, $entityDto, $fields, $filters);
        $qb->andWhere('entity.template = :tpl')
            ->setParameter('tpl', 'landing');

        return $qb;
    }

    public function configureActions(Actions $actions): Actions
    {
        $viewOnSite = Action::new('viewOnSite', 'Voir sur le site', 'fa fa-external-link-alt')
            ->linkToUrl(fn (Page $page) => $this->generateUrl('app_page_show', ['slug' => $page->getSlug()]))
            ->setHtmlAttributes(['target' => '_blank'])
            ->displayIf(fn (Page $page) => $page->isPublished());

        $copyUrl = Action::new('copyUrl', 'Copier l\'URL', 'fa fa-copy')
            ->linkToUrl(fn (Page $page) => $this->generateUrl('app_page_show', ['slug' => $page->getSlug()], UrlGeneratorInterface::ABSOLUTE_URL))
            ->setHtmlAttributes([
                'onclick' => 'event.preventDefault();navigator.clipboard.writeText(this.href).then(function(){var b=event.target.closest(\'a\');var o=b.innerHTML;b.innerHTML=\'<i class="fa fa-check"></i> Copié !\';setTimeout(function(){b.innerHTML=o},1500)})',
            ])
            ->displayIf(fn (Page $page) => $page->isPublished());

        return $actions
            ->add(Crud::PAGE_INDEX, $viewOnSite)
            ->add(Crud::PAGE_INDEX, $copyUrl)
            ->add(Crud::PAGE_EDIT, $viewOnSite)
            ->add(Crud::PAGE_EDIT, $copyUrl);
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Contenu ---
        yield FormField::addPanel('Contenu')
            ->setIcon('fa fa-pen')
            ->collapsible();

        yield TextField::new('title', 'Titre de la landing');

        yield TextareaField::new('blocksJson', 'Contenu')
            ->setFormTypeOptions([
                'attr' => [
                    'data-tiptap-editor' => '',
                    'style' => 'display: none',
                ],
            ])
            ->setColumns('col-12')
            ->setHelp('Contenu de la page : sections probleme, solution, benefices, reassurance, FAQ... Tapez <strong>/</strong> pour inserer un bloc.')
            ->hideOnIndex();

        // --- CTA & Conversion ---
        yield FormField::addPanel('CTA & Conversion')
            ->setIcon('fa fa-rocket')
            ->collapsible();

        yield TextField::new('cta_text', 'Texte du CTA')
            ->setHelp('Texte du bouton principal. Défaut : "Réserver un appel" (si lien RDV) ou "Nous contacter" (si formulaire).')
            ->setFormTypeOptions(['attr' => ['maxlength' => 100, 'placeholder' => 'Réserver un appel']])
            ->setRequired(false)
            ->hideOnIndex();

        yield TextField::new('cta_url', 'Lien de prise de RDV')
            ->setHelp('URL Calendly, Cal.com ou autre. Si vide, le CTA renvoie vers le formulaire intégré.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 500, 'placeholder' => 'https://calendly.com/...']])
            ->setRequired(false)
            ->hideOnIndex();

        yield BooleanField::new('show_form', 'Afficher le formulaire')
            ->setHelp('Formulaire de contact allégé (nom, email, activité) intégré à la landing.');

        yield TextField::new('form_title', 'Titre du formulaire')
            ->setHelp('Défaut : "Laissez vos coordonnées".')
            ->setFormTypeOptions(['attr' => ['maxlength' => 255, 'placeholder' => 'Laissez vos coordonnées']])
            ->setRequired(false)
            ->hideOnIndex();

        // --- Paramètres ---
        yield FormField::addPanel('Paramètres')
            ->setIcon('fa fa-cog')
            ->collapsible();

        yield AssociationField::new('featured_media', 'Image hero')
            ->setHelp('Image de fond du hero (section haute). Recommandé : 1920x800px minimum.');

        yield BooleanField::new('published', 'Publiée');

        // --- Avancé ---
        yield FormField::addPanel('Avancé')
            ->setIcon('fa fa-sliders-h')
            ->collapsible()
            ->renderCollapsed();

        yield $this->slugField('title');

        $pvRepo = $this->pageViewRepository;
        yield IntegerField::new('viewCount', 'Vues')
            ->hideOnForm()
            ->formatValue(function ($value, Page $entity) use ($pvRepo) {
                return $pvRepo->countViewsByUrl('/page/' . $entity->getSlug());
            });

        yield DateTimeField::new('created_at', 'Créée le')
            ->hideOnForm();

        yield DateTimeField::new('updated_at', 'Modifiée le')
            ->hideOnForm();

        // --- SEO ---
        yield FormField::addPanel('SEO')
            ->setIcon('fa fa-search')
            ->collapsible()
            ->renderCollapsed();

        yield TextField::new('seoTitle', 'Titre SEO')
            ->setHelp('Max 70 caractères. Laissez vide = titre de la landing.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Meta description / Sous-titre hero')
            ->setHelp('Utilisé comme sous-titre dans le hero ET comme description pour les partages sociaux. Max 160 caractères.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]])
            ->hideOnIndex();

        yield TextField::new('seoKeywords', 'Mots-clés')
            ->hideOnIndex();

        yield TextField::new('canonicalUrl', 'URL canonique')
            ->setRequired(false)
            ->hideOnIndex();
    }

    public function persistEntity(\Doctrine\ORM\EntityManagerInterface $entityManager, $entityInstance): void
    {
        /** @var Page $entityInstance */
        $entityInstance->setTemplate('landing');
        $entityInstance->setNoIndex(true);
        $entityInstance->setCreatedAt(new \DateTime());
        $entityInstance->setUpdatedAt(new \DateTime());

        parent::persistEntity($entityManager, $entityInstance);
    }

    public function updateEntity(\Doctrine\ORM\EntityManagerInterface $entityManager, $entityInstance): void
    {
        /** @var Page $entityInstance */
        $entityInstance->setTemplate('landing');
        $entityInstance->setUpdatedAt(new \DateTime());

        parent::updateEntity($entityManager, $entityInstance);
    }
}
