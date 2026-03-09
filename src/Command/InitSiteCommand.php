<?php

namespace App\Command;

use App\Entity\Site;
use App\Repository\SiteRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:init-site',
    description: 'Initialize the site configuration',
)]
class InitSiteCommand extends Command
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly SiteRepository $siteRepository,
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $existing = $this->siteRepository->find(1);
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

        $io->success("Site \"$name\" created. You can now customize it in /admin.");

        return Command::SUCCESS;
    }
}
