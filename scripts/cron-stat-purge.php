<?php

/*
 * Purge hebdomadaire des statistiques, pour le planificateur d'OVH.
 *
 * Le cron OVH execute un fichier PHP sans arguments : ce script lance
 * app:stat:purge comme le ferait bin/console. A declarer dans
 * Hebergement > Taches planifiees - Cron (voir DEPLOY_REFERENCE.md).
 */

use App\Kernel;
use Symfony\Bundle\FrameworkBundle\Console\Application;
use Symfony\Component\Console\Input\ArrayInput;
use Symfony\Component\Dotenv\Dotenv;

$root = dirname(__DIR__);
require $root . '/vendor/autoload.php';

(new Dotenv())->bootEnv($root . '/.env');

$kernel = new Kernel($_SERVER['APP_ENV'], (bool) $_SERVER['APP_DEBUG']);
$application = new Application($kernel);
$application->setAutoExit(false);

exit($application->run(new ArrayInput(['command' => 'app:stat:purge', '--no-interaction' => true])));
