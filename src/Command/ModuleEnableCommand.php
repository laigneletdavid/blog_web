<?php

namespace App\Command;

use App\Enum\ModuleEnum;
use App\Enum\SystemPageEnum;
use App\Service\LegalPageContentService;
use App\Service\MenuSyncService;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:module:enable',
    description: 'Enable a module and create associated legal pages and menu items',
)]
class ModuleEnableCommand extends Command
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly EntityManagerInterface $em,
        private readonly LegalPageContentService $legalPageService,
        private readonly MenuSyncService $menuSyncService,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this->addArgument('module', InputArgument::REQUIRED, 'Module name (' . implode(', ', array_column(ModuleEnum::cases(), 'value')) . ')');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $moduleName = $input->getArgument('module');

        $module = ModuleEnum::tryFrom($moduleName);
        if ($module === null) {
            $io->error("Unknown module \"$moduleName\". Available: " . implode(', ', array_column(ModuleEnum::cases(), 'value')));
            return Command::FAILURE;
        }

        $site = $this->siteContext->getCurrentSite();
        if ($site === null) {
            $io->error('No site found. Run app:init-site first.');
            return Command::FAILURE;
        }

        // Add module if not already enabled
        $modules = $site->getEnabledModules();
        if (in_array($module->value, $modules, true)) {
            $io->warning("Module \"{$module->label()}\" is already enabled.");
        } else {
            $modules[] = $module->value;
            $site->setEnabledModules($modules);
            $io->text("Module \"{$module->label()}\" enabled.");
        }

        // Create legal pages for this module
        $pagesCreated = 0;
        foreach (SystemPageEnum::forModule($module) as $pageType) {
            $page = $this->legalPageService->createIfNotExists($pageType);
            $io->text("  + Page: {$page->getTitle()}");
            $pagesCreated++;
        }

        $this->em->flush();

        // Sync menus (shows items for newly enabled module)
        $stats = $this->menuSyncService->syncAllZones($site);

        $io->success(sprintf(
            'Module "%s" enabled. %d page(s) created, %d menu item(s) updated.',
            $module->label(),
            $pagesCreated,
            $stats['created'] + $stats['updated']
        ));

        return Command::SUCCESS;
    }
}
