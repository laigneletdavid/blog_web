<?php

namespace App\Command;

use App\Repository\DirectoryCategoryRepository;
use App\Repository\FaqRepository;
use App\Repository\PortfolioCategoryRepository;
use App\Repository\ServiceRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:icons:migrate-format',
    description: 'Migre les valeurs du champ icon des entites depuis Font Awesome / bootstrap-icons CSS vers le nom court bootstrap-icons (ex: "fas fa-search" -> "search").',
)]
class IconsMigrateFormatCommand extends Command
{
    /**
     * Mapping Font Awesome -> nom Bootstrap Icons (sans prefixe).
     * Etend ce tableau pour supporter d'autres icones FA si besoin.
     */
    private const FA_TO_BI = [
        'fa-search' => 'search',
        'fa-magnifying-glass' => 'search',
        'fa-edit' => 'pencil',
        'fa-pencil' => 'pencil',
        'fa-pen' => 'pencil',
        'fa-pen-to-square' => 'pencil-square',
        'fa-lock' => 'lock',
        'fa-unlock' => 'unlock',
        'fa-bolt' => 'lightning-charge',
        'fa-envelope' => 'envelope',
        'fa-phone' => 'telephone',
        'fa-globe' => 'globe',
        'fa-user' => 'person',
        'fa-users' => 'person-circle',
        'fa-trash' => 'trash',
        'fa-trash-alt' => 'trash',
        'fa-cog' => 'gear',
        'fa-gear' => 'gear',
        'fa-eye' => 'eye',
        'fa-image' => 'image',
        'fa-images' => 'image',
        'fa-folder' => 'folder2',
        'fa-tag' => 'tag',
        'fa-tags' => 'tag',
        'fa-clock' => 'clock',
        'fa-calendar' => 'calendar3',
        'fa-link' => 'link-45deg',
        'fa-shopping-cart' => 'cart',
        'fa-cart-shopping' => 'cart',
        'fa-shopping-bag' => 'bag',
        'fa-credit-card' => 'credit-card',
        'fa-truck' => 'truck',
        'fa-info-circle' => 'info-circle',
        'fa-circle-info' => 'info-circle',
        'fa-exclamation-triangle' => 'exclamation-triangle',
        'fa-triangle-exclamation' => 'exclamation-triangle',
        'fa-check-circle' => 'check-circle-fill',
        'fa-circle-check' => 'check-circle-fill',
        'fa-question-circle' => 'question-circle',
        'fa-circle-question' => 'question-circle',
        'fa-star' => 'star',
        'fa-heart' => 'heart',
        'fa-share' => 'share',
        'fa-facebook' => 'facebook',
        'fa-facebook-f' => 'facebook',
        'fa-instagram' => 'instagram',
        'fa-linkedin' => 'linkedin',
        'fa-linkedin-in' => 'linkedin',
        'fa-youtube' => 'youtube',
        'fa-twitter' => 'twitter-x',
        'fa-x-twitter' => 'twitter-x',
        'fa-whatsapp' => 'whatsapp',
        'fa-arrow-left' => 'arrow-left',
        'fa-arrow-right' => 'arrow-right',
        'fa-chevron-left' => 'chevron-left',
        'fa-chevron-right' => 'chevron-right',
        'fa-chevron-up' => 'chevron-up',
        'fa-chevron-down' => 'chevron-down',
        'fa-bars' => 'list',
        'fa-times' => 'x-lg',
        'fa-xmark' => 'x-lg',
        'fa-check' => 'check',
        'fa-plus' => 'plus',
        'fa-download' => 'download',
        'fa-ellipsis-h' => 'three-dots',
        'fa-ellipsis-v' => 'three-dots',
        'fa-map-marker-alt' => 'geo-alt-fill',
        'fa-location-dot' => 'geo-alt-fill',
        'fa-briefcase' => 'briefcase',
        'fa-laptop' => 'laptop',
        'fa-rocket' => 'rocket',
    ];

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly ServiceRepository $serviceRepository,
        private readonly FaqRepository $faqRepository,
        private readonly DirectoryCategoryRepository $directoryCategoryRepository,
        private readonly PortfolioCategoryRepository $portfolioCategoryRepository,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this->addOption('dry-run', null, InputOption::VALUE_NONE, 'Simulation : affiche les conversions sans toucher la BDD');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $dryRun = (bool) $input->getOption('dry-run');

        if ($dryRun) {
            $io->note('Mode dry-run : aucune modification ne sera ecrite en BDD.');
        }

        $entitiesByLabel = [
            'Service' => $this->serviceRepository->findAll(),
            'Faq' => $this->faqRepository->findAll(),
            'DirectoryCategory' => $this->directoryCategoryRepository->findAll(),
            'PortfolioCategory' => $this->portfolioCategoryRepository->findAll(),
        ];

        $totalConverted = 0;
        $totalUnknown = 0;

        foreach ($entitiesByLabel as $label => $entities) {
            $io->section($label);
            foreach ($entities as $entity) {
                $original = $entity->getIcon();
                if ($original === null || $original === '') {
                    continue;
                }

                $converted = $this->convert($original);

                if ($converted === $original) {
                    $io->writeln(sprintf('  <fg=gray>#%d : "%s" (deja au bon format)</>', $entity->getId(), $original));
                    continue;
                }

                if ($converted === null) {
                    $io->writeln(sprintf('  <fg=yellow>#%d : "%s" (mapping inconnu, a traiter manuellement)</>', $entity->getId(), $original));
                    $totalUnknown++;
                    continue;
                }

                $io->writeln(sprintf('  <fg=green>#%d : "%s" -> "%s"</>', $entity->getId(), $original, $converted));
                $totalConverted++;

                if (!$dryRun) {
                    $entity->setIcon($converted);
                }
            }
        }

        if (!$dryRun && $totalConverted > 0) {
            $this->em->flush();
        }

        $io->newLine();
        $io->success(sprintf('%d conversion(s) effectuee(s), %d valeur(s) inconnue(s).', $totalConverted, $totalUnknown));

        if ($totalUnknown > 0) {
            $io->note('Pour les valeurs inconnues : completer le mapping FA_TO_BI dans la commande, ou les editer manuellement via l\'admin.');
        }

        return Command::SUCCESS;
    }

    /**
     * Convertit une valeur d'icone vers le nom court bootstrap-icons.
     * - "fas fa-search" / "fa fa-search" / "fa-search" -> "search"
     * - "bi bi-search" / "bi-search" -> "search"
     * - "search" -> "search" (deja correct)
     * - Format inconnu -> null
     */
    private function convert(string $value): ?string
    {
        $value = trim($value);

        // Deja au format court (pas d'espace, pas de prefixe) ?
        if (preg_match('/^[a-z0-9-]+$/i', $value)) {
            return $value;
        }

        // Format bootstrap-icons : "bi bi-xxx" ou "bi-xxx"
        if (preg_match('/(?:^|\s)bi-([a-z0-9-]+)/i', $value, $m)) {
            return strtolower($m[1]);
        }

        // Format Font Awesome : "fas fa-xxx", "far fa-xxx", "fa fa-xxx", "fa-xxx"
        if (preg_match('/(?:^|\s)(fa-[a-z0-9-]+)/i', $value, $m)) {
            $faKey = strtolower($m[1]);
            return self::FA_TO_BI[$faKey] ?? null;
        }

        return null;
    }
}
