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
            'title' => 'Aide — Identité du site',
            'sections' => [
                [
                    'title' => 'Identite',
                    'content' => '<p>Les informations de base de votre site :</p>
                    <ul>
                        <li><strong>Nom du site</strong> — Affiche dans le header, le footer et les onglets du navigateur</li>
                        <li><strong>Phrase d\'accroche</strong> — Texte de presentation visible sur la page d\'accueil</li>
                        <li><strong>Logo</strong> — Affiche dans le header. Le <em>Logo fond sombre</em> est utilise dans le footer</li>
                        <li><strong>Coordonnees</strong> — Email, telephone, adresse. Utilises dans le footer et le schema.org</li>
                    </ul>',
                ],
                [
                    'title' => 'Reseaux sociaux',
                    'content' => '<p>Vos liens vers les reseaux sociaux. Ils sont affiches dans le footer et transmis a Google via le champ <code>sameAs</code> du schema.org, ce qui renforce votre presence en ligne.</p>',
                ],
                [
                    'title' => 'Referencement',
                    'content' => '<p>La fiche entreprise Google, le titre et la description par defaut, l\'image de partage, Google Analytics et Search Console se règlent dans l\'entrée <em>Référencement</em> du menu.</p>',
                ],
            ],
            'tips' => [
                'Commencez par remplir le nom, la description et l\'email de contact.',
                'Le logo est affiche en petit dans le header. Privilegiez un format horizontal ou carre, en PNG transparent.',
                'Remplir les reseaux sociaux ameliore votre visibilite dans les resultats Google.',
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
        $crud->setPageTitle(Crud::PAGE_EDIT, 'Identité du site');

        return $crud;
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Identité ---
        yield FormField::addPanel('Identité')
            ->setIcon('fa fa-building')
            ->collapsible()
            ->renderCollapsed();

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

        // Fiche entreprise Google, SEO par defaut et outils Google : voir SeoSettingsCrudController

        // --- Panel Reseaux sociaux ---
        yield FormField::addPanel('Reseaux sociaux')
            ->setIcon('fa fa-share-alt')
            ->collapsible()
            ->renderCollapsed();

        yield TextField::new('facebookUrl', 'Facebook')
            ->setHelp('URL complete de votre page Facebook')
            ->hideOnIndex();

        yield TextField::new('instagramUrl', 'Instagram')
            ->setHelp('URL complete de votre profil Instagram')
            ->hideOnIndex();

        yield TextField::new('linkedinUrl', 'LinkedIn')
            ->setHelp('URL complete de votre page LinkedIn')
            ->hideOnIndex();

        yield TextField::new('twitterHandle', 'Twitter / X')
            ->setHelp('Votre identifiant Twitter sans le @, ex: monentreprise')
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
