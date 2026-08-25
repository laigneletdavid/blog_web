<?php

namespace App\Command;

use App\Service\SiteContext;
use App\Service\StaticMapService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;
use Symfony\Component\String\Slugger\AsciiSlugger;

#[AsCommand(
    name: 'app:map:generate',
    description: 'Genere la carte statique du site a partir de son adresse',
)]
class GenerateMapCommand extends Command
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly StaticMapService $staticMap,
        private readonly EntityManagerInterface $em,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            ->addOption('style', 's', InputOption::VALUE_REQUIRED, 'Fond de carte : ' . implode(', ', array_keys(StaticMapService::STYLES)), 'positron')
            ->addOption('zoom', 'z', InputOption::VALUE_REQUIRED, 'Niveau de zoom (12 quartier large, 18 rue)', '16')
            ->addOption('lat', null, InputOption::VALUE_REQUIRED, 'Latitude, si le geocodage tombe a cote')
            ->addOption('lon', null, InputOption::VALUE_REQUIRED, 'Longitude, si le geocodage tombe a cote')
            ->addOption('width', null, InputOption::VALUE_REQUIRED, 'Largeur en pixels', '900')
            ->addOption('height', null, InputOption::VALUE_REQUIRED, 'Hauteur en pixels', '560')
            ->addOption('no-update', null, InputOption::VALUE_NONE, "Ne pas associer l'image au site")
            ->setHelp(<<<'HELP'
                Assemble des tuiles raster autour de l'adresse du site et enregistre une
                image dans public/documents/medias, puis l'associe au site.

                L'interet d'une image plutot qu'un cadre : aucun service tiers n'est appele
                quand un visiteur ouvre la page. Pas de cle d'API, pas de cookie tiers, et
                la carte ne peut pas devenir un cadre vide si un fournisseur ferme son point
                d'entree — ce qui est arrive successivement a Google et a OpenStreetMap.

                  php bin/console app:map:generate
                  php bin/console app:map:generate --style=dark --zoom=17
                  php bin/console app:map:generate --lat=43.139507 --lon=0.937192

                L'attribution exigee par la licence est incrustee dans l'image.
                HELP);
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $site = $this->siteContext->getCurrentSite();
        if ($site === null) {
            $io->error('Aucun site configure.');

            return Command::FAILURE;
        }

        $style = (string) $input->getOption('style');
        if (!isset(StaticMapService::STYLES[$style])) {
            $io->error(sprintf('Fond inconnu "%s".', $style));
            $io->listing(array_map(
                static fn (string $key, array $cfg): string => sprintf('%-18s %s', $key, $cfg['label']),
                array_keys(StaticMapService::STYLES),
                StaticMapService::STYLES,
            ));

            return Command::FAILURE;
        }

        // Coordonnees : fournies a la main, sinon deduites de l'adresse du site.
        $lat = $input->getOption('lat');
        $lon = $input->getOption('lon');

        if ($lat !== null && $lon !== null) {
            $lat = (float) $lat;
            $lon = (float) $lon;
            $io->text(sprintf('Coordonnees fournies : %.6f, %.6f', $lat, $lon));
        } else {
            $address = trim(implode(' ', array_filter([
                $site->getAddress1(),
                $site->getAddress2(),
                $site->getPostCode(),
                $site->getTown(),
            ])));

            if ($address === '') {
                $io->error("Le site n'a pas d'adresse : renseignez-la dans Reglages, ou passez --lat et --lon.");

                return Command::FAILURE;
            }

            $io->text(sprintf('Geocodage de : %s', $address));
            $found = $this->staticMap->geocode($address);

            if ($found === null) {
                $io->error('Adresse introuvable. Passez --lat et --lon pour forcer les coordonnees.');

                return Command::FAILURE;
            }

            $lat = $found['lat'];
            $lon = $found['lon'];
            $io->text(sprintf('Trouve : %.6f, %.6f (%s)', $lat, $lon, $found['display']));
            $io->note('Verifiez le marqueur sur la carte produite : le geocodage vise parfois la rue et non le batiment.');
        }

        // AsciiSlugger plutot qu'un preg_replace : il translittere les accents
        // au lieu de les remplacer par des tirets.
        $slug = (new AsciiSlugger())->slug($site->getName() ?? 'site')->lower()->toString();
        $fileName = 'carte-' . ($slug !== '' ? $slug : 'site');

        try {
            $result = $this->staticMap->generate(
                $lat,
                $lon,
                $fileName,
                $style,
                (int) $input->getOption('zoom'),
                (int) $input->getOption('width'),
                (int) $input->getOption('height'),
            );
        } catch (\Throwable $e) {
            $io->error($e->getMessage());

            return Command::FAILURE;
        }

        if ($result['failed'] > 0) {
            $io->warning(sprintf('%d tuile(s) manquante(s) : des zones peuvent etre vides.', $result['failed']));
        }

        if (!$input->getOption('no-update')) {
            $site->setGoogleMaps($result['path']);
            $this->em->flush();
        }

        $io->success(sprintf(
            'Carte generee : %s (%d tuiles, %d ko)',
            $result['path'],
            $result['tiles'],
            (int) ($result['bytes'] / 1024),
        ));

        if ($input->getOption('no-update')) {
            $io->text("Le site n'a pas ete modifie (--no-update).");
        }

        return Command::SUCCESS;
    }
}
