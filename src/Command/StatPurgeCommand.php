<?php

namespace App\Command;

use Doctrine\DBAL\Connection;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:stat:purge',
    description: 'Purge stat data older than 13 months (RGPD compliance)',
)]
class StatPurgeCommand extends Command
{
    public function __construct(
        private readonly Connection $db,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            ->addOption('months', 'm', InputOption::VALUE_REQUIRED, 'Number of months to keep', '13')
            ->addOption('dry-run', null, InputOption::VALUE_NONE, 'Show what would be deleted without deleting');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $months = (int) $input->getOption('months');
        $dryRun = (bool) $input->getOption('dry-run');

        if ($months < 1) {
            $io->error('Months must be at least 1.');
            return Command::FAILURE;
        }

        $cutoff = (new \DateTimeImmutable())->modify("-{$months} months")->format('Y-m-d H:i:s');

        $io->title("Purge stats older than {$months} months (before {$cutoff})");

        if ($dryRun) {
            $io->note('DRY RUN — nothing will be deleted.');
        }

        // Count what will be purged
        $conversions = (int) $this->db->fetchOne(
            'SELECT COUNT(*) FROM stat_conversion WHERE created_at < :cutoff',
            ['cutoff' => $cutoff],
        );
        $pageViews = (int) $this->db->fetchOne(
            'SELECT COUNT(*) FROM page_view WHERE created_at < :cutoff',
            ['cutoff' => $cutoff],
        );
        $sessions = (int) $this->db->fetchOne(
            'SELECT COUNT(*) FROM stat_session WHERE started_at < :cutoff',
            ['cutoff' => $cutoff],
        );

        $io->table(
            ['Table', 'Rows to purge'],
            [
                ['stat_conversion', $conversions],
                ['page_view', $pageViews],
                ['stat_session', $sessions],
            ],
        );

        if ($conversions + $pageViews + $sessions === 0) {
            $io->success('Nothing to purge.');
            return Command::SUCCESS;
        }

        if ($dryRun) {
            $io->success('Dry run complete. Use without --dry-run to actually delete.');
            return Command::SUCCESS;
        }

        // Delete in order: conversions → page_views → sessions (FK constraints)
        $deleted = $this->db->executeStatement(
            'DELETE FROM stat_conversion WHERE created_at < :cutoff',
            ['cutoff' => $cutoff],
        );
        $io->text("stat_conversion: {$deleted} rows deleted.");

        $deleted = $this->db->executeStatement(
            'DELETE FROM page_view WHERE created_at < :cutoff',
            ['cutoff' => $cutoff],
        );
        $io->text("page_view: {$deleted} rows deleted.");

        $deleted = $this->db->executeStatement(
            'DELETE FROM stat_session WHERE started_at < :cutoff',
            ['cutoff' => $cutoff],
        );
        $io->text("stat_session: {$deleted} rows deleted.");

        $io->success("Purge complete. Data before {$cutoff} has been removed.");

        return Command::SUCCESS;
    }
}
