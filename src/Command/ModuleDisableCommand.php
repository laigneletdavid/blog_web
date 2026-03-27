<?php

namespace App\Command;

use App\Enum\ModuleEnum;
use App\Enum\SystemPageEnum;
use App\Repository\PageRepository;
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
    name: 'app:module:disable',
    description: 'Disable a module and hide associated menu items',
)]
class ModuleDisableCommand extends Command
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly EntityManagerInterface $em,
        private readonly MenuSyncService $menuSyncService,
        private readonly PageRepository $pageRepository,
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
            $io->error("Unknown module \"$moduleName\".");
            return Command::FAILURE;
        }

        $site = $this->siteContext->getCurrentSite();
        if ($site === null) {
            $io->error('No site found.');
            return Command::FAILURE;
        }

        // Remove module
        $modules = $site->getEnabledModules();
        $modules = array_values(array_filter($modules, fn (string $m) => $m !== $module->value));
        $site->setEnabledModules($modules);
        $io->text("Module \"{$module->label()}\" disabled.");

        // Unpublish (don't delete) legal pages for this module
        $pagesHidden = 0;
        foreach (SystemPageEnum::forModule($module) as $pageType) {
            $page = $this->pageRepository->findSystemPage($pageType->value);
            if ($page !== null && $page->isPublished()) {
                $page->setPublished(false);
                $io->text("  - Page hidden: {$page->getTitle()}");
                $pagesHidden++;
            }
        }

        $this->em->flush();

        // Sync menus (hides items for disabled module)
        $stats = $this->menuSyncService->syncAllZones($site);

        $io->success(sprintf(
            'Module "%s" disabled. %d page(s) hidden, %d menu item(s) hidden.',
            $module->label(),
            $pagesHidden,
            $stats['hidden']
        ));

        return Command::SUCCESS;
    }
}
