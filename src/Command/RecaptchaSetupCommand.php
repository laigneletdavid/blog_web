<?php

namespace App\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:recaptcha:setup',
    description: 'Configure reCAPTCHA v3 keys in .env.local',
)]
class RecaptchaSetupCommand extends Command
{
    public function __construct(
        private readonly string $projectDir,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            ->addOption('site-key', null, InputOption::VALUE_REQUIRED, 'reCAPTCHA v3 site key')
            ->addOption('secret-key', null, InputOption::VALUE_REQUIRED, 'reCAPTCHA v3 secret key')
            ->setHelp(<<<'HELP'
                Configures Google reCAPTCHA v3 for the contact form.

                1. Go to https://www.google.com/recaptcha/admin
                2. Create a new site with reCAPTCHA v3
                3. Add your domain(s)
                4. Copy the site key and secret key
                5. Run this command

                  <info>php bin/console app:recaptcha:setup</info>
                  <info>php bin/console app:recaptcha:setup --site-key=6Le... --secret-key=6Le...</info>
                HELP
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $io->title('Configuration reCAPTCHA v3');

        $envLocalPath = $this->projectDir . '/.env.local';

        if (!file_exists($envLocalPath)) {
            $io->error('.env.local not found. Run "cp .env.local.example .env.local" first.');
            return Command::FAILURE;
        }

        $io->text([
            'reCAPTCHA v3 protege votre formulaire de contact contre les bots.',
            'Creez vos cles sur : <info>https://www.google.com/recaptcha/admin</info>',
            'Type : reCAPTCHA v3 | Domaine : votre-domaine.fr (+ localhost pour le dev)',
            '',
        ]);

        $siteKey = $input->getOption('site-key') ?? $io->ask('Cle du site (site key)');
        if (!$siteKey) {
            $io->error('La cle du site est requise.');
            return Command::FAILURE;
        }

        $secretKey = $input->getOption('secret-key') ?? $io->ask('Cle secrete (secret key)');
        if (!$secretKey) {
            $io->error('La cle secrete est requise.');
            return Command::FAILURE;
        }

        // Read current .env.local
        $content = file_get_contents($envLocalPath);

        // Remove existing RECAPTCHA lines if present
        $content = preg_replace('/^RECAPTCHA_SITE_KEY=.*$/m', '', $content);
        $content = preg_replace('/^RECAPTCHA_SECRET_KEY=.*$/m', '', $content);
        $content = preg_replace('/^# reCAPTCHA.*$/m', '', $content);
        $content = preg_replace('/\n{3,}/', "\n\n", $content);

        // Append new config
        $content = rtrim($content) . "\n\n# reCAPTCHA v3\nRECAPTCHA_SITE_KEY={$siteKey}\nRECAPTCHA_SECRET_KEY={$secretKey}\n";

        file_put_contents($envLocalPath, $content);

        $io->success('reCAPTCHA configure dans .env.local');
        $io->table(
            ['Parametre', 'Valeur'],
            [
                ['Site key', substr($siteKey, 0, 10) . '...'],
                ['Secret key', substr($secretKey, 0, 10) . '...'],
            ],
        );

        $io->text('Videz le cache pour appliquer : <info>php bin/console cache:clear</info>');

        return Command::SUCCESS;
    }
}
