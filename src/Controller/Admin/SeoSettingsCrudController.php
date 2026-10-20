<?php

namespace App\Controller\Admin;

use App\Entity\Site;
use App\Enum\SeoReachEnum;
use App\Service\SeoIntentChecker;
use App\Service\SiteContext;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\KeyValueStore;
use EasyCorp\Bundle\EasyAdminBundle\Context\AdminContext;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\Security\Http\Attribute\IsGranted;

/**
 * Zone Referencement : ce que l'admin veut obtenir de Google (activite, cible,
 * portee, priorites), plus les reglages SEO globaux du site.
 * Edition seule sur Site, comme ThemeSettingsCrudController et ModulesCrudController.
 */
#[IsGranted('ROLE_ADMIN')]
class SeoSettingsCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly SeoIntentChecker $intentChecker,
    ) {
    }

    public static function getEntityFqcn(): string
    {
        return Site::class;
    }

    /**
     * Bilan en haut de page : la fiche confrontee au contenu publie.
     * Appele par AdminHelpTrait::configureResponseParameters(), affiche par le layout admin.
     */
    protected function addSeoReportToResponse(KeyValueStore $responseParameters): KeyValueStore
    {
        $site = $responseParameters->get('entity')?->getInstance();

        if ($site instanceof Site) {
            $responseParameters->set('seo_report', $this->intentChecker->check($site));
            $responseParameters->set('seo_report_title', 'Bilan de votre référencement');
        }

        return $responseParameters;
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->disable(Action::NEW, Action::DELETE, Action::BATCH_DELETE, Action::INDEX);
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Référencement')
            ->setEntityLabelInPlural('Référencement')
            ->setPageTitle(Crud::PAGE_EDIT, 'Référencement');
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Votre activite ---
        yield FormField::addPanel('Votre activité')
            ->setIcon('fa fa-briefcase')
            ->setHelp('Décrivez votre activité avec vos mots, comme à un client. Ces réponses servent à vérifier que vos pages parlent bien de ce que vous voulez mettre en avant.');

        yield TextareaField::new('seoActivity', 'Que proposez-vous ?')
            ->setFormTypeOptions(['attr' => [
                'rows' => 3,
                'placeholder' => 'Ex : Aménagement de jardins, élagage et entretien d\'espaces verts',
            ]]);

        yield TextField::new('seoAudience', 'À qui vous adressez-vous ?')
            ->setFormTypeOptions(['attr' => [
                'maxlength' => 255,
                'placeholder' => 'Ex : Particuliers et syndics de copropriété',
            ]]);

        yield TextareaField::new('seoStrengths', 'Ce qui vous distingue')
            ->setFormTypeOptions(['attr' => [
                'rows' => 3,
                'placeholder' => 'Ex : 20 ans d\'expérience, devis gratuit sous 48 h, certifié Qualipaysage',
            ]]);

        // --- Ou voulez-vous etre trouve ---
        yield FormField::addPanel('Où voulez-vous être trouvé ?')
            ->setIcon('fa fa-location-dot');

        yield ChoiceField::new('seoReach', 'Portée')
            ->setChoices(SeoReachEnum::choices())
            ->renderExpanded()
            ->setRequired(false)
            ->setFormTypeOptions(['placeholder' => 'Pas encore décidé'])
            ->setHelp('Jusqu\'où voulez-vous attirer des clients ?');

        yield TextareaField::new('seoAreas', 'Villes ou zone visées')
            ->setHelp('Une ville ou une zone par ligne. Utile surtout en local et en régional.')
            ->setFormTypeOptions(['attr' => [
                'rows' => 3,
                'placeholder' => "Pau\nLescar\nBillère",
            ]]);

        yield TextareaField::new('seoPriorities', 'Ce que vous voulez mettre en avant')
            ->setHelp('Vos services ou produits les plus importants, par ordre de priorité. Un par ligne.')
            ->setFormTypeOptions(['attr' => [
                'rows' => 3,
                'placeholder' => "Élagage\nCréation de jardins",
            ]]);

        yield TextareaField::new('seoCustomerWords', 'Les mots que tapent vos clients (facultatif)')
            ->setHelp('Ce que vos clients écrivent dans Google pour vous trouver, selon vous. Un par ligne.')
            ->setFormTypeOptions(['attr' => [
                'rows' => 3,
                'placeholder' => "élagueur pau\npaysagiste près de chez moi",
            ]]);

        // --- Fiche Google (deplacee depuis Identite du site) ---
        yield FormField::addPanel('Fiche entreprise Google')
            ->setIcon('fa fa-store')
            ->setHelp('Ces informations sont transmises à Google pour décrire votre entreprise dans ses résultats.');

        yield ChoiceField::new('businessType', 'Type d\'activité')
            ->setChoices([
                'Organisation (défaut)' => 'Organization',
                'Commerce / Magasin' => 'Store',
                'Restaurant' => 'Restaurant',
                'Service professionnel' => 'ProfessionalService',
                'Agence' => 'LocalBusiness',
                'Santé / Médical' => 'MedicalBusiness',
                'Hébergement' => 'LodgingBusiness',
                'Sport / Loisirs' => 'SportsActivityLocation',
            ])
            ->setHelp('La catégorie qui vous ressemble le plus. « Organisation » si aucune ne correspond.')
            ->renderExpanded(false);

        yield ChoiceField::new('priceRange', 'Gamme de prix')
            ->setChoices([
                'Non renseigné' => null,
                '€ — Économique' => '€',
                '€€ — Moyen' => '€€',
                '€€€ — Haut de gamme' => '€€€',
                '€€€€ — Luxe' => '€€€€',
            ])
            ->setHelp('Laissez « Non renseigné » si ce n\'est pas pertinent pour votre activité.')
            ->renderExpanded(false);

        yield TextareaField::new('openingHours', 'Horaires d\'ouverture')
            ->setHelp('Un horaire par ligne, format : <code>Lu-Ve 09:00-18:00</code> ou <code>Sa 10:00-16:00</code>. Laissez vide si non applicable.')
            ->setFormTypeOptions(['attr' => ['rows' => 4, 'placeholder' => "Lu-Ve 09:00-18:00\nSa 10:00-16:00"]]);

        // --- Reglages par defaut et outils (deplaces depuis Identite du site) ---
        yield FormField::addPanel('Réglages par défaut et outils Google')
            ->setIcon('fa fa-sliders')
            ->collapsible();

        yield TextField::new('defaultSeoTitle', 'Titre affiché dans Google par défaut')
            ->setHelp('Utilisé quand une page n\'a pas son propre titre SEO. 70 caractères maximum.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]]);

        yield TextareaField::new('defaultSeoDescription', 'Description affichée dans Google par défaut')
            ->setHelp('Le petit texte sous le titre dans Google, quand une page n\'a pas le sien. 160 caractères maximum.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]]);

        yield AssociationField::new('ogImage', 'Image de partage')
            ->setHelp('Image affichée quand on partage votre site sur Facebook, LinkedIn ou WhatsApp. Format conseillé : 1200 x 630 px.');

        // Avec le module marketing, les statistiques integrees couvrent deja le suivi des visites
        $analyticsHelp = $this->siteContext->hasModule('marketing')
            ? 'Facultatif : les statistiques intégrées au site mesurent déjà vos visites. Format : G-XXXXXXXXXX.'
            : 'Permet de suivre les visites du site dans Google Analytics. Format : G-XXXXXXXXXX.';

        yield TextField::new('googleAnalyticsId', 'Google Analytics')
            ->setHelp($analyticsHelp);

        yield TextField::new('googleSearchConsole', 'Code de vérification Search Console')
            ->setHelp('Prouve à Google que le site vous appartient. À copier depuis Google Search Console, méthode « Balise HTML ».');
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

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Référencement',
            'sections' => [
                [
                    'title' => 'À quoi sert cette page',
                    'content' => '<p>Ici, vous dites ce que vous attendez de Google : ce que vous proposez, à qui, et où vous voulez être trouvé.</p>
                    <p>Ces réponses ne s\'affichent pas sur le site. Elles servent de repère pour vérifier que vos pages parlent bien de vos priorités.</p>',
                ],
                [
                    'title' => 'Le bilan en haut de page',
                    'content' => '<p>Le bilan compare votre fiche à ce que le site publie : villes citées dans les titres, une page par priorité, mots de vos clients présents dans les textes.</p>
                    <p>Les points en orange sont des pistes d\'amélioration, pas des erreurs. Le bilan se met à jour à chaque enregistrement.</p>',
                ],
                [
                    'title' => 'Fiche entreprise Google',
                    'content' => '<p>Le type d\'activité, la gamme de prix et les horaires sont transmis à Google sous une forme qu\'il comprend (schema.org). Ils l\'aident à présenter votre entreprise dans ses résultats.</p>',
                ],
                [
                    'title' => 'Réglages par défaut',
                    'content' => '<p>Le titre, la description et l\'image de partage par défaut servent quand une page n\'a pas les siens.</p>
                    <p>Si l\'image de partage est vide, le site utilise l\'image d\'accueil, puis le logo.</p>',
                ],
            ],
            'tips' => [
                'Inutile d\'être expert : répondez simplement, avec les mots de vos clients.',
                'En local, citez les villes où vous intervenez vraiment.',
            ],
        ];
    }
}
