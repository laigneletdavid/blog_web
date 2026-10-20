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
            ->setHelp('Une plage par ligne, jours en abréviations anglaises (Mo, Tu, We, Th, Fr, Sa, Su) : <code>Mo-Fr 09:00-18:00</code> ou <code>Sa 10:00-16:00</code>. C\'est le format que Google comprend. Laissez vide si non applicable.')
            ->setFormTypeOptions(['attr' => ['rows' => 4, 'placeholder' => "Mo-Fr 09:00-18:00\nSa 10:00-16:00"]]);

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
        // Avec le module marketing, les statistiques integrees couvrent deja le suivi des visites
        $analytics = $this->siteContext->hasModule('marketing')
            ? '<p><strong>Google Analytics</strong> est facultatif : les statistiques intégrées au site mesurent déjà vos visites.</p>'
            : '<p><strong>Google Analytics</strong> suit les visites de votre site. Collez l\'identifiant qui commence par <code>G-</code>.</p>';

        return [
            'title' => 'Aide — Référencement',
            'sections' => [
                [
                    'title' => 'À quoi sert cette page',
                    'content' => '<p>Ici, vous dites ce que vous attendez de Google : ce que vous proposez, à qui, et où vous voulez être trouvé.</p>
                    <p>Ces réponses ne s\'affichent pas sur le site. Elles servent de repère au bilan, en haut de la page, pour vérifier que vos pages parlent bien de vos priorités.</p>',
                ],
                [
                    'title' => 'Remplir la fiche',
                    'content' => '<ul>
                        <li><strong>Villes visées</strong>, <strong>priorités</strong> et <strong>mots de vos clients</strong> : <strong>une ligne</strong> par ville, par priorité ou par expression.</li>
                        <li><strong>Portée locale ou régionale</strong> : le bilan vérifie en plus votre adresse, vos horaires, vos villes et votre type d\'activité, et la liste de vos villes est transmise à Google comme zone desservie.</li>
                        <li><strong>Portée nationale</strong> : Google est informé que vous servez toute la France, sans contrôle de villes.</li>
                    </ul>',
                ],
                [
                    'title' => 'Comment le bilan compare',
                    'content' => '<p>Le bilan cherche <strong>tous les mots importants</strong> d\'une ligne dans un même texte, dans n\'importe quel ordre. Il ignore les accents, les majuscules et les petits mots (« de », « à », « pour », « près de chez moi »...).</p>
                    <ul>
                        <li><strong>Villes</strong> : cherchées dans les titres et descriptions (accueil, pages, services, articles), là où Google les lit en premier.</li>
                        <li><strong>Priorités</strong> : cherchées dans le titre des pages et des services. Un article ne compte pas : une priorité mérite sa propre page.</li>
                        <li><strong>Mots de vos clients</strong> : cherchés partout, textes compris.</li>
                    </ul>
                    <p>Les points en orange sont des pistes, pas des erreurs. Le bilan se met à jour à chaque enregistrement.</p>',
                ],
                [
                    'title' => 'Que faire pour chaque point orange',
                    'content' => '<ul>
                        <li><strong>Votre fiche</strong> — Remplissez ce que vous proposez et la portée : les autres contrôles en dépendent.</li>
                        <li><strong>Coordonnées</strong> — Complétez l\'adresse et la ville dans <em>Réglages &rarr; Identité du site</em>, et les horaires plus bas sur cette page.</li>
                        <li><strong>Villes visées</strong> — Ajoutez la ville au <em>Titre dans Google</em> ou à la <em>Description dans Google</em> de la page qui la concerne.</li>
                        <li><strong>Type d\'activité Google</strong> — Choisissez plus précis qu\'« Organisation » dans la fiche entreprise, plus bas.</li>
                        <li><strong>Vos priorités</strong> — Créez une page ou un service portant ce sujet dans son titre, ou renommez une page existante.</li>
                        <li><strong>Mots de vos clients</strong> — Employez ces mots dans vos textes, tels que vos clients les tapent.</li>
                    </ul>',
                ],
                [
                    'title' => 'Fiche entreprise Google',
                    'content' => '<p>Le type d\'activité, la gamme de prix et les horaires sont transmis à Google sous une forme qu\'il comprend (données structurées). Ils l\'aident à présenter votre entreprise dans ses résultats.</p>
                    <p>Les horaires s\'écrivent une plage par ligne, avec les jours en abréviations anglaises (Mo, Tu, We, Th, Fr, Sa, Su) : <code>Mo-Fr 09:00-18:00</code>, <code>Sa 10:00-16:00</code>. Google ignore les autres formats, comme « Lu-Ve ».</p>',
                ],
                [
                    'title' => 'Réglages par défaut',
                    'content' => '<p>Le titre, la description et l\'image de partage par défaut servent quand une page n\'a pas les siens.</p>
                    <p>Si l\'image de partage est vide, le site utilise l\'image d\'accueil, puis le logo. Format conseillé : 1200 x 630 px.</p>',
                ],
                [
                    'title' => 'Outils Google',
                    'content' => '<p><strong>Search Console</strong> vous montre sur quelles recherches votre site apparaît, et à quelle position. Pour le relier : dans Search Console, ajoutez votre site, choisissez la méthode <em>Balise HTML</em>, puis copiez ici le code entre les guillemets de <code>content="..."</code>.</p>'
                        . $analytics,
                ],
            ],
            'tips' => [
                'Inutile d\'être expert : répondez simplement, avec les mots de vos clients.',
                'En local, citez les villes où vous intervenez vraiment, pas toutes celles du département.',
                'Une priorité, une page : c\'est le moyen le plus sûr d\'être associé à un sujet par Google.',
                'Écrivez les mots de vos clients comme ils les tapent dans Google, par exemple « notaire saint-martory ».',
                'Déclarez le site dans Search Console dès sa mise en ligne et soumettez-y le plan du site (/sitemap.xml) : Google ne garde que 16 mois d\'historique et ne commence à compter qu\'à partir de ce moment.',
            ],
        ];
    }
}
