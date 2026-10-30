<?php

namespace App\Command;

use Doctrine\DBAL\Connection;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

/**
 * Supprime les statistiques de plus de N mois (13 par defaut, RGPD).
 *
 * Par paquets, avec une pause entre deux : un seul DELETE sur des millions
 * de lignes bloque la base mutualisee (cas Pros d'Ici, octobre 2026).
 * Lancee chaque semaine par scripts/cron-stat-purge.php (voir DEPLOY_REFERENCE.md).
 */
#[AsCommand(
    name: 'app:stat:purge',
    description: 'Purge stat data older than 13 months (RGPD compliance)',
)]
class StatPurgeCommand extends Command
{
    private const BATCH_SIZE = 10000;
    private const PAUSE_MICROSECONDS = 200000;

    /** Table => colonne de date. Ordre : conversions et visites avant les sessions qu'elles referencent */
    private const TABLES = [
        'stat_conversion' => 'created_at',
        'page_view' => 'created_at',
        'stat_session' => 'started_at',
        'stat_bot_daily' => 'day',
    ];

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

        $counts = [];
        foreach (self::TABLES as $table => $column) {
            $counts[$table] = (int) $this->db->fetchOne(
                "SELECT COUNT(*) FROM {$table} WHERE {$column} < :cutoff",
                ['cutoff' => $cutoff],
            );
        }

        $io->table(
            ['Table', 'Rows to purge'],
            array_map(null, array_keys($counts), array_values($counts)),
        );

        if (array_sum($counts) === 0) {
            $io->success('Nothing to purge.');
            return Command::SUCCESS;
        }

        if ($dryRun) {
            $io->success('Dry run complete. Use without --dry-run to actually delete.');
            return Command::SUCCESS;
        }

        foreach (self::TABLES as $table => $column) {
            if ($counts[$table] === 0) {
                continue;
            }

            $deleted = 0;
            do {
                $batch = $this->db->executeStatement(
                    "DELETE FROM {$table} WHERE {$column} < :cutoff LIMIT " . self::BATCH_SIZE,
                    ['cutoff' => $cutoff],
                );
                $deleted += $batch;
                if ($batch === self::BATCH_SIZE) {
                    usleep(self::PAUSE_MICROSECONDS);
                }
            } while ($batch === self::BATCH_SIZE);

            $io->text("{$table}: {$deleted} rows deleted.");
        }

        $io->success("Purge complete. Data before {$cutoff} has been removed.");

        return Command::SUCCESS;
    }
}
