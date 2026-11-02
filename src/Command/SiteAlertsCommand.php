<?php

namespace App\Command;

use App\Service\SiteAlertChecker;
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
 * Alertes hebdo du site (RAPPORT.md, phase R4), pour les super admins seulement.
 *
 * Aucun e-mail quand tout va bien : un message qui arrive veut toujours dire
 * qu'il y a quelque chose a faire.
 */
#[AsCommand(
    name: 'app:report:alerts',
    description: 'Weekly site checks, e-mailed to super admins only when something is wrong',
)]
class SiteAlertsCommand extends Command
{
    public function __construct(
        private readonly SiteAlertChecker $checker,
        private readonly Environment $twig,
        private readonly SystemMailerService $mailer,
        private readonly Connection $db,
        #[Autowire('%env(APP_PRIMARY_HOST)%')]
        private readonly string $primaryHost,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            ->addOption('to', null, InputOption::VALUE_REQUIRED, 'Send to this address only (default: super admins)')
            ->addOption('dry-run', null, InputOption::VALUE_NONE, 'List the alerts without sending anything');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $alerts = $this->checker->check();

        if ($alerts === []) {
            $io->success('Aucune alerte : rien envoye.');
            return Command::SUCCESS;
        }

        foreach ($alerts as $alert) {
            $io->text(sprintf('[!] %s — %s', $alert['title'], $alert['detail']));
        }

        if ($input->getOption('dry-run')) {
            $io->note(count($alerts) . ' alerte(s), rien envoye (--dry-run).');
            return Command::SUCCESS;
        }

        $recipients = $input->getOption('to')
            ? [$input->getOption('to')]
            : $this->db->fetchFirstColumn("SELECT email FROM user WHERE roles LIKE '%ROLE_SUPER_ADMIN%'");
        if ($recipients === []) {
            $io->warning('Aucun super admin : rien envoye.');
            return Command::SUCCESS;
        }

        $siteName = $this->mailer->getSiteName();
        $html = $this->twig->render('emails/site_alerts.html.twig', [
            'alerts' => $alerts,
            'site_name' => $siteName,
            'site_url' => trim($this->primaryHost) !== '' ? 'https://' . trim($this->primaryHost) : null,
        ]);

        $email = $this->mailer->createEmail(sprintf('[Alerte] %s — %d point%s à vérifier', $siteName, count($alerts), count($alerts) > 1 ? 's' : ''))
            ->html($html);
        foreach ($recipients as $recipient) {
            $email->addTo($recipient);
        }
        $this->mailer->send($email);

        $io->success(count($alerts) . ' alerte(s) envoyee(s) a ' . implode(', ', $recipients));

        return Command::SUCCESS;
    }
}
