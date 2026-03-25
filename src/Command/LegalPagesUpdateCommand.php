<?php

namespace App\Command;

use App\Enum\SystemPageEnum;
use App\Repository\PageRepository;
use App\Service\LegalPageContentService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:legal-pages:update',
    description: 'Update existing legal pages with latest default content template',
)]
class LegalPagesUpdateCommand extends Command
{
    public function __construct(
        private readonly PageRepository $pageRepository,
        private readonly LegalPageContentService $legalPageService,
        private readonly EntityManagerInterface $em,
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $updated = 0;
        foreach (SystemPageEnum::cases() as $type) {
            $page = $this->pageRepository->findSystemPage($type->value);
            if ($page !== null) {
                $page->setContent($this->legalPageService->getDefaultContent($type));
                $page->setUpdatedAt(new \DateTime());
                $page->setNoIndex(true);
                $io->text("Updated: {$page->getTitle()}");
                $updated++;
            } else {
                $page = $this->legalPageService->createIfNotExists($type);
                $io->text("Created: {$page->getTitle()}");
                $updated++;
            }
        }

        $this->em->flush();

        $io->success("$updated legal page(s) updated.");

        return Command::SUCCESS;
    }
}
