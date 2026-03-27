<?php

namespace App\Command;

use App\Entity\Site;
use App\Enum\SystemPageEnum;
use App\Service\LegalPageContentService;
use App\Service\MenuSyncService;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:init-site',
    description: 'Initialize the site configuration, legal pages and navigation menus',
)]
class InitSiteCommand extends Command
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly SiteContext $siteContext,
        private readonly LegalPageContentService $legalPageService,
        private readonly MenuSyncService $menuSyncService,
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $existing = $this->siteContext->getCurrentSite();
        if ($existing) {
            $io->warning('A site already exists. Use /admin to edit it.');
            return Command::SUCCESS;
        }

        $name = $io->ask('Site name (e.g. "Mon Blog")');
        if (!$name) {
            $io->error('Site name is required.');
            return Command::FAILURE;
        }

        $title = $io->ask('Site title (displayed in browser tab)', $name);
        $email = $io->ask('Contact email');

        $site = new Site();
        $site->setName($name);
        $site->setTitle($title);
        $site->setEmail($email);

        $this->em->persist($site);
        $this->em->flush();

        $io->success("Site \"$name\" created.");

        // Create mandatory legal pages
        $io->section('Legal pages');
        $pagesCreated = 0;
        foreach (SystemPageEnum::alwaysRequired() as $pageType) {
            $page = $this->legalPageService->createIfNotExists($pageType);
            $io->text("  + {$page->getTitle()}");
            $pagesCreated++;
        }

        // Also create pages for default modules
        foreach ($site->getEnabledModules() as $moduleName) {
            $module = \App\Enum\ModuleEnum::tryFrom($moduleName);
            if ($module === null) {
                continue;
            }
            foreach (SystemPageEnum::forModule($module) as $pageType) {
                $page = $this->legalPageService->createIfNotExists($pageType);
                $io->text("  + {$page->getTitle()}");
                $pagesCreated++;
            }
        }
        $this->em->flush();
        $io->text("$pagesCreated legal page(s) created.");

        // Sync system menus from theme.yaml
        $io->section('Navigation menus');
        $stats = $this->menuSyncService->syncAllZones($site);
        $io->text("{$stats['created']} menu item(s) created.");

        $io->success('Site initialized. Customize it in /admin.');

        return Command::SUCCESS;
    }
}
