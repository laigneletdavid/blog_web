<?php

namespace App\Controller\Admin;

use App\Entity\Site;
use App\Enum\ModuleEnum;
use App\Service\SiteContext;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use EasyCorp\Bundle\EasyAdminBundle\Context\AdminContext;
use Symfony\Component\HttpFoundation\RedirectResponse;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class SiteCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public function __construct(
        private readonly SiteContext $siteContext,
    ) {
    }

    public static function getEntityFqcn(): string
    {
        return Site::class;
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Identite du site',
            'sections' => [
                [
                    'title' => 'Informations essentielles',
                    'content' => '<p>Cette page contient les informations de base de votre site :</p>
                    <ul>
                        <li><strong>Nom du site</strong> — Affiche dans le header, le footer et les onglets du navigateur</li>
                        <li><strong>Description</strong> — Texte de presentation utilise par defaut pour le SEO</li>
                        <li><strong>Coordonnees</strong> — Email de contact, telephone, adresse</li>
                        <li><strong>Logo</strong> — Affiche dans le header du site</li>
                    </ul>',
                ],
                [
                    'title' => 'SEO global',
                    'content' => '<p>Les champs <em>Titre SEO par defaut</em> et <em>Description SEO par defaut</em> sont utilises comme valeurs de repli quand un article ou une page n\'a pas ses propres champs SEO remplis.</p>',
                ],
                [
                    'title' => 'Google Analytics & Search Console',
                    'content' => '<p>Collez votre <strong>ID Google Analytics</strong> (format G-XXXXXXXXXX) pour activer le suivi de visites Google.</p>
                    <p>Le champ <strong>Google Search Console</strong> sert a la verification de propriete du site.</p>',
                ],
            ],
            'tips' => [
                'Commencez par remplir le nom, la description et l\'email de contact. Ce sont les 3 champs les plus importants.',
                'Le logo est affiche en petit dans le header. Privilegiez un format horizontal ou carre, en PNG transparent.',
            ],
        ];
    }

    public function configureActions(Actions $actions): Actions
    {
        $actions->remove(Crud::PAGE_DETAIL, Crud::PAGE_INDEX);
        $actions->disable(Action::DELETE);

        return $actions;
    }

    public function configureCrud(Crud $crud): Crud
    {
        $crud->setPageTitle(Crud::PAGE_DETAIL, 'Mon site');

        return $crud;
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Identite ---
        yield FormField::addPanel('Identite')
            ->setIcon('fa fa-building')
            ->collapsible();

        // Sous-section : Nom et presentation
        yield FormField::addFieldset('Nom et presentation');

        yield TextField::new('name')
            ->setLabel('Nom du site');

        yield TextField::new('title')
            ->setLabel('Phrase d\'accroche');

        // Sous-section : Visuels
        yield FormField::addFieldset('Visuels');

        yield AssociationField::new('logo', 'Logo')
            ->setHelp('Format horizontal ou carre recommande. PNG transparent ou JPG. Affiche dans le header. Les favicons (onglet navigateur, ecran d\'accueil mobile) sont generes automatiquement.')
            ->hideOnIndex();

        yield AssociationField::new('logoDark', 'Logo fond sombre')
            ->setHelp('Pour le footer et les zones sombres. Si vide, le logo principal est utilise.')
            ->hideOnIndex();

        yield AssociationField::new('ogImage', 'Image Open Graph')
            ->setHelp('Image affichee lors du partage sur les reseaux sociaux. Format recommande : 1200x630 px.')
            ->hideOnIndex();

        // Sous-section : Coordonnees
        yield FormField::addFieldset('Coordonnees');

        yield TextField::new('email')
            ->setLabel('E-mail de contact');

        yield TextField::new('phone')
            ->setLabel('Telephone de contact');

        yield TextField::new('address_1')
            ->setLabel('Adresse - ligne 1');

        yield TextField::new('address_2')
            ->setLabel('Adresse - ligne 2');

        yield TextField::new('post_code')
            ->setLabel('Code Postal');

        yield TextField::new('town')
            ->setLabel('Ville');

        yield TextField::new('google_maps')
            ->setLabel('Lien Google Maps');

        // --- Panel SEO ---
        yield FormField::addPanel('SEO')
            ->setIcon('fa fa-search')
            ->collapsible();

        yield TextField::new('defaultSeoTitle', 'Titre SEO par defaut')
            ->setHelp('Utilise quand un article ou une page n\'a pas de titre SEO propre. Apparait dans Google et l\'onglet navigateur. Max 70 caracteres.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('defaultSeoDescription', 'Meta description par defaut')
            ->setHelp('Description globale du site, affichee dans Google quand une page n\'a pas sa propre description. Max 160 caracteres.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]])
            ->hideOnIndex();

        yield TextField::new('googleAnalyticsId', 'Google Analytics ID')
            ->setHelp('Permet de suivre le trafic du site. Format : G-XXXXXXXXXX. Disponible dans votre compte Google Analytics.')
            ->hideOnIndex();

        yield TextField::new('googleSearchConsole', 'Google Search Console')
            ->setHelp('Code de verification pour prouver a Google que vous etes proprietaire du site. Disponible dans Google Search Console > Parametres.')
            ->hideOnIndex();

        // --- Panel Catalogue (si module actif) ---
        if ($this->siteContext->hasModule('catalogue')) {
            yield FormField::addPanel('Catalogue')
                ->setIcon('fa fa-store')
                ->collapsible()
                ->renderCollapsed();

            yield ChoiceField::new('catalogPriceDisplay', 'Affichage des prix')
                ->setChoices([
                    'TTC (clients particuliers)' => 'ttc',
                    'HT (clients professionnels)' => 'ht',
                ])
                ->setHelp('Definit si les prix sont affiches TTC ou HT sur le site. Les deux valeurs restent calculees.')
                ->hideOnIndex();
        }

        // --- Panel Paiement Stripe (ROLE_FREELANCE+) ---
        if ($this->siteContext->hasModule('ecommerce')) {
            yield FormField::addPanel('Paiement Stripe')
                ->setIcon('fa fa-credit-card')
                ->collapsible()
                ->renderCollapsed()
                ->setPermission('ROLE_FREELANCE');

            yield TextField::new('stripePublicKey', 'Cle publique Stripe')
                ->setHelp('Commence par pk_test_ (test) ou pk_live_ (production). Disponible dans votre dashboard Stripe > Developers > API keys.')
                ->setPermission('ROLE_FREELANCE')
                ->hideOnIndex();

            yield TextField::new('stripeSecretKey', 'Cle secrete Stripe')
                ->setHelp('Commence par sk_test_ (test) ou sk_live_ (production). Ne la partagez jamais.')
                ->setPermission('ROLE_FREELANCE')
                ->setFormTypeOptions(['attr' => ['autocomplete' => 'off']])
                ->hideOnIndex();

            yield TextField::new('stripeWebhookSecret', 'Secret Webhook Stripe')
                ->setHelp('Commence par whsec_. Configure dans Stripe > Developers > Webhooks. URL du webhook : /webhook/stripe')
                ->setPermission('ROLE_FREELANCE')
                ->hideOnIndex();
        }

        // --- Panel Proprietaire (ROLE_SUPER_ADMIN) ---
        yield FormField::addPanel('Propriete')
            ->setIcon('fa fa-user-shield')
            ->collapsible()
            ->renderCollapsed()
            ->setPermission('ROLE_SUPER_ADMIN');

        yield AssociationField::new('owner', 'Proprietaire (Freelance)')
            ->setHelp('Freelance responsable de ce site')
            ->setPermission('ROLE_SUPER_ADMIN')
            ->hideOnIndex();
    }

    protected function getRedirectResponseAfterSave(AdminContext $context, string $action): RedirectResponse
    {
        $url = $this->container->get(AdminUrlGenerator::class)
            ->setController(self::class)
            ->setAction(Action::EDIT)
            ->setEntityId($context->getEntity()->getPrimaryKeyValue())
            ->generateUrl();

        return $this->redirect($url);
    }
}
