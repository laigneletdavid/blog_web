<?php

namespace App\Command;

use App\Service\MonthlyReportBuilder;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\DependencyInjection\Attribute\Autowire;

/**
 * Seule tache planifiee du site : le cron OVH lance scripts/cron.sh chaque
 * semaine, qui lance cette commande. Les taches s'ajoutent ici, sans
 * retourner dans l'interface OVH de chaque site.
 *
 * - chaque semaine : alertes aux super admins (rien si tout va bien) ;
 * - une fois par mois, au premier passage du mois : purge des statistiques,
 *   rapport du mois ecoule aux admins du site, rotation du journal.
 *
 * var/cron.json garde le dernier passage (controle par deploy-ovh.sh) et le
 * dernier mois traite : un passage manque est rattrape au suivant, et le
 * rapport ne part jamais deux fois.
 */
#[AsCommand(
    name: 'app:cron',
    description: 'Weekly scheduled tasks (run by scripts/cron.sh from the OVH cron)',
)]
class CronCommand extends Command
{
    public function __construct(
        #[Autowire('%kernel.project_dir%/var/cron.json')]
        private readonly string $stateFile,
        #[Autowire('%kernel.logs_dir%/%kernel.environment%.log')]
        private readonly string $logFile,
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $state = $this->readState();
        $failures = 0;
        $output->writeln('=== cron ' . date('Y-m-d H:i:s'));

        $failures += $this->runTask('app:report:alerts', [], $output);

        $lastMonth = (new \DateTimeImmutable('first day of last month'))->format('Y-m');
        if (($state['month_done'] ?? null) !== $lastMonth) {
            $monthFailures = $this->runTask('app:stat:purge', [], $output);

            // Mois d'avant la mesure par le navigateur : chiffres faux, pas de rapport aux clients
            if ($lastMonth . '-01' >= MonthlyReportBuilder::MEASURED_SINCE) {
                $monthFailures += $this->runTask('app:report:monthly', ['--month' => $lastMonth, '--admins' => true], $output);
            } else {
                $output->writeln("--- rapport de {$lastMonth} non envoye : mois anterieur a la mesure par le navigateur");
            }

            // Mois marque traite seulement si tout a marche : sinon nouvel essai la semaine suivante
            if ($monthFailures === 0) {
                $state['month_done'] = $lastMonth;
                $this->rotateLog($output);
            }
            $failures += $monthFailures;
        }

        $state['last_run'] = date(\DATE_ATOM);
        $state['last_status'] = $failures === 0 ? 'ok' : $failures . ' echec(s)';
        file_put_contents($this->stateFile, json_encode($state, \JSON_PRETTY_PRINT) . "\n");

        $output->writeln('=== fin : ' . $state['last_status']);

        // Code d'erreur : le cron OVH previent par e-mail
        return $failures === 0 ? Command::SUCCESS : Command::FAILURE;
    }

    /**
     * @param array<string, mixed> $arguments
     *
     * @return int 0 si la tache a reussi, 1 sinon
     */
    private function runTask(string $name, array $arguments, OutputInterface $output): int
    {
        $output->writeln("--- {$name}");
        try {
            $taskInput = new ArrayInput($arguments);
            $taskInput->setInteractive(false);
            $code = $this->getApplication()->find($name)->run($taskInput, $output);
        } catch (\Throwable $e) {
            $output->writeln("ERREUR {$name} : " . $e->getMessage());

            return 1;
        }

        return $code === Command::SUCCESS ? 0 : 1;
    }

    /**
     * Journal du mois precedent garde en .old, le reste efface : prod.log
     * grossissait sans fin (204 Mo sur bw_pro_dici en novembre 2026). Les
     * alertes viennent de lire la semaine, avant cette rotation.
     */
    private function rotateLog(OutputInterface $output): void
    {
        if (is_file($this->logFile) && rename($this->logFile, $this->logFile . '.old')) {
            $output->writeln('--- journal archive dans ' . basename($this->logFile) . '.old');
        }
    }

    /**
     * @return array<string, string>
     */
    private function readState(): array
    {
        $content = is_readable($this->stateFile) ? file_get_contents($this->stateFile) : false;
        $state = $content !== false ? json_decode($content, true) : null;

        return is_array($state) ? $state : [];
    }
}
