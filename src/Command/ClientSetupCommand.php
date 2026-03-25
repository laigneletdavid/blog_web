<?php

namespace App\Command;

use App\Entity\Site;
use App\Entity\User;
use App\Enum\SystemPageEnum;
use App\Service\LegalPageContentService;
use App\Service\MenuSyncService;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

#[AsCommand(
    name: 'app:client:setup',
    description: 'Full client setup: site + super admin + legal pages + menus. Idempotent.',
)]
class ClientSetupCommand extends Command
{
    private const DEV_FILES = [
        'CLAUDE.md',
        'CLAUDE2.md',
        'CLAUDE_FULL.md',
        'PLAN.md',
        'DESIGN_THEME.md',
        'audit_cms_claude_code.md',
    ];

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly UserPasswordHasherInterface $hasher,
        private readonly SiteContext $siteContext,
        private readonly LegalPageContentService $legalPageService,
        private readonly MenuSyncService $menuSyncService,
        #[Autowire('%kernel.project_dir%')]
        private readonly string $projectDir,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            ->addOption('site-name', null, InputOption::VALUE_REQUIRED, 'Site name')
            ->addOption('site-email', null, InputOption::VALUE_REQUIRED, 'Contact email')
            ->addOption('admin-email', null, InputOption::VALUE_REQUIRED, 'Super admin email')
            ->addOption('admin-password', null, InputOption::VALUE_REQUIRED, 'Super admin password (min 12 chars)')
            ->setHelp(<<<'HELP'
                Sets up a fresh client site in one command. Can be run interactively or with options:

                  <info>php bin/console app:client:setup</info>
                  <info>php bin/console app:client:setup --site-name="Mon Site" --site-email=contact@example.com --admin-email=admin@example.com --admin-password=MyStr0ngP@ss!</info>

                Idempotent: skips steps already done (existing site, existing admin).
                HELP
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $io->title('BlogWeb — Installation client');

        // ── Step 1: Site ──
        $io->section('1/5 — Site');
        $site = $this->setupSite($io, $input);
        if (!$site) {
            return Command::FAILURE;
        }

        // ── Step 2: Super Admin ──
        $io->section('2/5 — Super admin');
        $admin = $this->setupAdmin($io, $input);
        if (!$admin) {
            return Command::FAILURE;
        }

        // ── Step 3: Legal pages ──
        $io->section('3/5 — Pages legales');
        $this->setupLegalPages($io, $site);

        // ── Step 4: Menus ──
        $io->section('4/5 — Navigation');
        $this->setupMenus($io, $site);

        // ── Step 5: Cleanup dev files ──
        $io->section('5/5 — Nettoyage');
        $this->cleanupDevFiles($io);

        // ── Summary ──
        $io->newLine();
        $io->success('Installation terminee !');

        $io->table(
            ['Element', 'Statut'],
            [
                ['Site', $site->getName()],
                ['Email contact', $site->getEmail() ?? '—'],
                ['Super admin', $admin->getEmail()],
                ['Pages legales', 'Creees'],
                ['Menus', 'Synchronises'],
            ],
        );

        $io->text([
            'Prochaines etapes :',
            '  1. Accedez a <info>http://localhost:8080/admin</info>',
            '  2. Personnalisez l\'identite du site (logo, coordonnees)',
            '  3. Activez les modules necessaires (blog, services, catalogue...)',
            '  4. Ajoutez du contenu (articles, pages)',
            '  5. Consultez le guide dans <info>Aide > Guide</info>',
        ]);

        return Command::SUCCESS;
    }

    private function setupSite(SymfonyStyle $io, InputInterface $input): ?Site
    {
        $existing = $this->siteContext->getCurrentSite();
        if ($existing) {
            $io->text("Site existant : <info>{$existing->getName()}</info> — etape ignoree.");
            return $existing;
        }

        $name = $input->getOption('site-name') ?? $io->ask('Nom du site');
        if (!$name) {
            $io->error('Le nom du site est requis.');
            return null;
        }

        $email = $input->getOption('site-email') ?? $io->ask('Email de contact');
        $phone = $io->ask('Telephone (optionnel)', '');

        $site = new Site();
        $site->setName($name);
        $site->setTitle($name);
        $site->setEmail($email);
        if ($phone) {
            $site->setPhone($phone);
        }

        $this->em->persist($site);
        $this->em->flush();

        $io->text("Site <info>$name</info> cree.");

        return $site;
    }

    private function setupAdmin(SymfonyStyle $io, InputInterface $input): ?User
    {
        $email = $input->getOption('admin-email') ?? $io->ask('Email admin');
        if (!$email) {
            $io->error('L\'email admin est requis.');
            return null;
        }

        $existing = $this->em->getRepository(User::class)->findOneBy(['email' => $email]);
        if ($existing) {
            $io->text("Admin <info>$email</info> existe deja — etape ignoree.");
            return $existing;
        }

        $password = $input->getOption('admin-password') ?? $io->askHidden('Mot de passe (min 12 caracteres)');
        if (!$password || strlen($password) < 12) {
            $io->error('Le mot de passe doit faire au moins 12 caracteres.');
            return null;
        }

        if (!$input->getOption('admin-password')) {
            $confirm = $io->askHidden('Confirmer le mot de passe');
            if ($password !== $confirm) {
                $io->error('Les mots de passe ne correspondent pas.');
                return null;
            }
        }

        $firstName = $io->ask('Prenom', '');
        $name = $io->ask('Nom', '');

        $user = new User();
        $user->setEmail($email);
        $user->setRoles(['ROLE_SUPER_ADMIN']);
        $user->setPassword($this->hasher->hashPassword($user, $password));
        $user->setFirstName($firstName);
        $user->setName($name);

        $this->em->persist($user);
        $this->em->flush();

        $io->text("Super admin <info>$email</info> cree.");

        return $user;
    }

    private function setupLegalPages(SymfonyStyle $io, Site $site): void
    {
        $count = 0;

        foreach (SystemPageEnum::alwaysRequired() as $pageType) {
            $page = $this->legalPageService->createIfNotExists($pageType);
            $io->text("  + {$page->getTitle()}");
            $count++;
        }

        foreach ($site->getEnabledModules() as $moduleName) {
            $module = \App\Enum\ModuleEnum::tryFrom($moduleName);
            if ($module === null) {
                continue;
            }
            foreach (SystemPageEnum::forModule($module) as $pageType) {
                $page = $this->legalPageService->createIfNotExists($pageType);
                $io->text("  + {$page->getTitle()}");
                $count++;
            }
        }

        $this->em->flush();
        $io->text("<info>$count</info> page(s) legale(s) prete(s).");
    }

    private function setupMenus(SymfonyStyle $io, Site $site): void
    {
        $stats = $this->menuSyncService->syncAllZones($site);
        $io->text("<info>{$stats['created']}</info> element(s) de menu cree(s).");
    }

    private function cleanupDevFiles(SymfonyStyle $io): void
    {
        $removed = 0;

        foreach (self::DEV_FILES as $file) {
            $path = $this->projectDir . '/' . $file;
            if (file_exists($path)) {
                unlink($path);
                $io->text("  - Supprime : <comment>$file</comment>");
                $removed++;
            }
        }

        // Remove .claude/docs/ directory if present
        $docsDir = $this->projectDir . '/.claude/docs';
        if (is_dir($docsDir)) {
            $files = new \RecursiveIteratorIterator(
                new \RecursiveDirectoryIterator($docsDir, \FilesystemIterator::SKIP_DOTS),
                \RecursiveIteratorIterator::CHILD_FIRST,
            );
            foreach ($files as $fileInfo) {
                $fileInfo->isDir() ? rmdir($fileInfo->getPathname()) : unlink($fileInfo->getPathname());
            }
            rmdir($docsDir);
            $io->text('  - Supprime : <comment>.claude/docs/</comment>');
            $removed++;
        }

        if ($removed === 0) {
            $io->text('Aucun fichier de developpement a supprimer.');
        } else {
            $io->text("<info>$removed</info> element(s) de developpement supprime(s).");
        }
    }
}
