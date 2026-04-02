<?php

namespace App\Controller\Admin;

use App\Entity\Site;
use App\Service\FontService;
use App\Service\ThemeService;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ColorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use EasyCorp\Bundle\EasyAdminBundle\Context\AdminContext;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_FREELANCE')]
class ThemeSettingsCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public function __construct(
        private readonly ThemeService $themeService,
        private readonly SiteContext $siteContext,
        private readonly FontService $fontService,
    ) {
    }

    public static function getEntityFqcn(): string
    {
        return Site::class;
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->disable(Action::NEW, Action::DELETE, Action::BATCH_DELETE, Action::INDEX);
    }

    public function configureCrud(Crud $crud): Crud
    {
        $site = $this->siteContext->getCurrentSite();
        $themeSlug = $site?->getTemplate() ?? 'default';
        $theme = $this->themeService->getTheme($themeSlug);
        $themeName = $theme['name'] ?? ucfirst($themeSlug);

        return $crud
            ->setEntityLabelInSingular('Reglages du theme')
            ->setEntityLabelInPlural('Reglages du theme')
            ->setPageTitle(Crud::PAGE_EDIT, 'Personnaliser le theme « ' . $themeName . ' »')
            ->setPageTitle(Crud::PAGE_DETAIL, 'Personnaliser le theme « ' . $themeName . ' »');
    }

    /**
     * Pre-fill null color/font fields with theme defaults so the color picker
     * shows the effective color.
     */
    public function edit(\EasyCorp\Bundle\EasyAdminBundle\Context\AdminContext $context)
    {
        /** @var Site|null $site */
        $site = $context->getEntity()->getInstance();

        if ($site instanceof Site) {
            $defaults = $this->getThemeDefaults($site);

            $fields = [
                'primaryColor' => 'getPrimaryColor',
                'secondaryColor' => 'getSecondaryColor',
                'accentColor' => 'getAccentColor',
                'fontFamily' => 'getFontFamily',
                'fontFamilySecondary' => 'getFontFamilySecondary',
            ];

            foreach ($fields as $field => $getter) {
                if ($site->$getter() === null && isset($defaults[$field]) && $defaults[$field] !== null) {
                    $setter = 'set' . ucfirst($field);
                    $site->$setter($defaults[$field]);
                }
            }
        }

        return parent::edit($context);
    }

    /**
     * On save: if a value equals the theme default, restore null (= overlay inactive).
     */
    public function updateEntity(EntityManagerInterface $em, $entityInstance): void
    {
        if ($entityInstance instanceof Site) {
            $defaults = $this->getThemeDefaults($entityInstance);

            $fields = [
                'primaryColor' => ['get' => 'getPrimaryColor', 'set' => 'setPrimaryColor'],
                'secondaryColor' => ['get' => 'getSecondaryColor', 'set' => 'setSecondaryColor'],
                'accentColor' => ['get' => 'getAccentColor', 'set' => 'setAccentColor'],
                'fontFamily' => ['get' => 'getFontFamily', 'set' => 'setFontFamily'],
                'fontFamilySecondary' => ['get' => 'getFontFamilySecondary', 'set' => 'setFontFamilySecondary'],
            ];

            foreach ($fields as $field => $methods) {
                $currentValue = $entityInstance->{$methods['get']}();
                $defaultValue = $defaults[$field] ?? null;

                // Value matches theme default → null (use theme)
                if ($currentValue !== null && $defaultValue !== null
                    && strtolower(trim($currentValue)) === strtolower(trim($defaultValue))
                ) {
                    $entityInstance->{$methods['set']}(null);
                }

                // Empty string → null
                if ($currentValue === '') {
                    $entityInstance->{$methods['set']}(null);
                }
            }
        }

        parent::updateEntity($em, $entityInstance);
        $this->themeService->clearCache();
    }

    public function configureFields(string $pageName): iterable
    {
        $site = $this->siteContext->getCurrentSite();
        $themeSlug = $site?->getTemplate() ?? 'default';
        $defaults = $this->themeService->getDefaults($themeSlug);

        $defaultPrimary = $defaults['primaryColor'] ?? '#2563EB';
        $defaultSecondary = $defaults['secondaryColor'] ?? '#F59E0B';
        $defaultAccent = $defaults['accentColor'] ?? '#8B5CF6';
        $defaultFont = $defaults['fontFamily'] ?? "'Inter', sans-serif";
        $defaultFontLabel = $this->fontService->getLabel($defaultFont);

        $isCustom = fn (?string $value): string => $value !== null
            ? ' ✎ personnalise'
            : '';

        // --- Panel Couleurs ---
        yield FormField::addPanel('Couleurs')
            ->setIcon('fa fa-palette')
            ->setHelp('Les couleurs pre-remplies sont celles du theme actif. Modifiez pour personnaliser.')
            ->collapsible();

        yield ColorField::new('primaryColor', 'Couleur principale')
            ->setHelp('Defaut du theme : ' . $defaultPrimary . $isCustom($site?->getPrimaryColor()));

        yield ColorField::new('secondaryColor', 'Couleur secondaire')
            ->setHelp('Defaut du theme : ' . $defaultSecondary . $isCustom($site?->getSecondaryColor()));

        yield ColorField::new('accentColor', 'Couleur d\'accent')
            ->setHelp('Defaut du theme : ' . $defaultAccent . $isCustom($site?->getAccentColor()));

        // --- Panel Typographie ---
        yield FormField::addPanel('Typographie')
            ->setIcon('fa fa-font')
            ->setHelp('20 polices Google Fonts disponibles. Defaut du theme : ' . $defaultFontLabel . '.')
            ->collapsible();

        yield ChoiceField::new('fontFamily', 'Police principale')
            ->setChoices($this->fontService->getChoices())
            ->setHelp('Defaut du theme : ' . $defaultFontLabel . $isCustom($site?->getFontFamily()));

        yield ChoiceField::new('fontFamilySecondary', 'Police des titres')
            ->setChoices($this->fontService->getSecondaryChoices())
            ->setHelp('Optionnel. Police reservee aux titres. Laissez "Identique" pour utiliser la police principale.');

        // --- Panel Images ---
        yield FormField::addPanel('Images du theme')
            ->setIcon('fa fa-image')
            ->setHelp('Images principales du theme. Pour les galeries, logos et temoignages, utilisez le menu "Images du theme".')
            ->collapsible();

        yield AssociationField::new('heroImage', 'Image hero (fond)')
            ->setHelp('Image de fond du hero en page d\'accueil. Format paysage recommande (1920x800 min).');

        yield AssociationField::new('aboutImage', 'Image a propos')
            ->setHelp('Photo ou illustration pour la section "A propos". Format portrait ou carre recommande.');
    }

    /**
     * @return array<string, string|null>
     */
    protected function getRedirectResponseAfterSave(AdminContext $context, string $action): RedirectResponse
    {
        $url = $this->container->get(AdminUrlGenerator::class)
            ->setController(self::class)
            ->setAction(Action::EDIT)
            ->setEntityId($context->getEntity()->getPrimaryKeyValue())
            ->generateUrl();

        return $this->redirect($url);
    }

    private function getThemeDefaults(Site $site): array
    {
        $slug = $site->getTemplate();
        $defaults = $this->themeService->getDefaults($slug);

        return [
            'primaryColor' => $defaults['primaryColor'] ?? '#2563EB',
            'secondaryColor' => $defaults['secondaryColor'] ?? '#F59E0B',
            'accentColor' => $defaults['accentColor'] ?? '#8B5CF6',
            'fontFamily' => $defaults['fontFamily'] ?? "'Inter', sans-serif",
            'fontFamilySecondary' => $defaults['fontFamilySecondary'] ?? null,
        ];
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Apparence',
            'sections' => [
                [
                    'title' => 'Couleurs et polices',
                    'content' => '<p>Personnalisez l\'apparence sans toucher au code :</p>
                    <ul>
                        <li><strong>Couleur primaire</strong> — boutons, liens, elements d\'accentuation</li>
                        <li><strong>Couleur secondaire</strong> — fonds, bordures, elements complementaires</li>
                        <li><strong>Couleur d\'accent</strong> — details, survols, call-to-action</li>
                        <li><strong>Polices</strong> — 20 Google Fonts disponibles</li>
                    </ul>
                    <p>Laissez un champ vide pour utiliser la valeur par defaut du theme.</p>',
                ],
                [
                    'title' => 'Images du theme',
                    'content' => '<p>Les images principales du site :</p>
                    <ul>
                        <li><strong>Image hero</strong> — grande image d\'accueil (format paysage, 1920x800 min)</li>
                        <li><strong>Image a propos</strong> — section "A propos" (portrait ou carre)</li>
                    </ul>
                    <p>Pour les galeries, logos et temoignages, utilisez le menu <strong>Images du theme</strong>.</p>',
                ],
            ],
            'tips' => [
                'Les 6 themes disponibles : Default, Corporate, Artisan, Vitrine, Starter, Moderne.',
                'Changez de theme sans perdre vos couleurs personnalisees — elles sont conservees.',
            ],
        ];
    }
}
