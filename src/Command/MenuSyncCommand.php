<?php

namespace App\Command;

use App\Service\MenuSyncService;
use App\Service\SiteContext;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:menu:sync',
    description: 'Sync system menu items from theme.yaml (useful after theme change)',
)]
class MenuSyncCommand extends Command
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly MenuSyncService $menuSyncService,
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $site = $this->siteContext->getCurrentSite();
        if ($site === null) {
            $io->error('No site found. Run app:init-site first.');
            return Command::FAILURE;
        }

        $stats = $this->menuSyncService->syncAllZones($site);

        $io->success(sprintf(
            'Menu sync complete: %d created, %d updated, %d hidden.',
            $stats['created'],
            $stats['updated'],
            $stats['hidden']
        ));

        return Command::SUCCESS;
    }
}
