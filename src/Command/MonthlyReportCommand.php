<?php

namespace App\Command;

use App\Service\MonthlyReportBuilder;
use App\Service\SystemMailerService;
use Doctrine\DBAL\Connection;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Twig\Environment;

/**
 * Rapport mensuel du site (RAPPORT.md).
 *
 * Phase R1 : envoye aux super admins seulement, pour valider le rendu. En R3,
 * il partira aux comptes ROLE_ADMIN du site, par le cron OVH le 3 du mois.
 */
#[AsCommand(
    name: 'app:report:monthly',
    description: 'Monthly site report (stats of the previous month)',
)]
class MonthlyReportCommand extends Command
{
    public function __construct(
        private readonly MonthlyReportBuilder $builder,
        private readonly Environment $twig,
        private readonly SystemMailerService $mailer,
        private readonly Connection $db,
        #[Autowire('%env(REPORT_CONTACT_EMAIL)%')]
        private readonly string $contactEmail,
        #[Autowire('%kernel.project_dir%')]
        private readonly string $projectDir,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            ->addOption('month', null, InputOption::VALUE_REQUIRED, 'Month to report, YYYY-MM (default: previous month)')
            ->addOption('to', null, InputOption::VALUE_REQUIRED, 'Send to this address only (default: super admins)')
            ->addOption('html', null, InputOption::VALUE_NONE, 'Write the e-mail to var/report-YYYY-MM.html instead of sending it');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $monthOption = $input->getOption('month');
        if ($monthOption !== null && !preg_match('/^\d{4}-(0[1-9]|1[0-2])$/', $monthOption)) {
            $io->error('--month attend le format YYYY-MM.');
            return Command::FAILURE;
        }
        $month = $monthOption !== null
            ? new \DateTimeImmutable($monthOption . '-01')
            : new \DateTimeImmutable('first day of last month');

        $report = $this->builder->build($month);
        $html = $this->twig->render('emails/monthly_report.html.twig', [
            'report' => $report,
            'contact_email' => trim($this->contactEmail) ?: null,
        ]);

        $io->text($report['summary']);

        if ($input->getOption('html')) {
            $path = $this->projectDir . '/var/report-' . $report['month']->format('Y-m') . '.html';
            file_put_contents($path, $html);
            $io->success("Rapport ecrit dans {$path}");
            return Command::SUCCESS;
        }

        $recipients = $input->getOption('to') ? [$input->getOption('to')] : $this->superAdminEmails();
        if ($recipients === []) {
            $io->warning('Aucun super admin : rien envoye.');
            return Command::SUCCESS;
        }

        $email = $this->mailer->createEmail(sprintf('%s — votre site en %s', $this->mailer->getSiteName(), $report['month_label']))
            ->html($html);
        foreach ($recipients as $recipient) {
            $email->addTo($recipient);
        }
        $this->mailer->send($email);

        $io->success('Rapport envoye a ' . implode(', ', $recipients));

        return Command::SUCCESS;
    }

    /**
     * @return list<string>
     */
    private function superAdminEmails(): array
    {
        return $this->db->fetchFirstColumn("SELECT email FROM user WHERE roles LIKE '%ROLE_SUPER_ADMIN%'");
    }
}
