<?php

namespace App\Command;

use App\Service\SeoAnalyzer;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:seo:crawl-simulation',
    description: 'Simule un crawl SEO et affiche les pages indexables vs noindex',
)]
class SeoCrawlSimulationCommand extends Command
{
    private const ENTITY_MAP = [
        'Article' => ['class' => \App\Entity\Article::class, 'prefix' => '/article/'],
        'Page' => ['class' => \App\Entity\Page::class, 'prefix' => '/page/'],
        'Categorie' => ['class' => \App\Entity\Categorie::class, 'prefix' => '/categorie/'],
        'Tag' => ['class' => \App\Entity\Tag::class, 'prefix' => '/tag/'],
        'Service' => ['class' => \App\Entity\Service::class, 'prefix' => '/service/'],
        'Product' => ['class' => \App\Entity\Product::class, 'prefix' => '/catalogue/'],
        'Event' => ['class' => \App\Entity\Event::class, 'prefix' => '/evenement/'],
        'PortfolioItem' => ['class' => \App\Entity\PortfolioItem::class, 'prefix' => '/realisation/'],
        'DirectoryEntry' => ['class' => \App\Entity\DirectoryEntry::class, 'prefix' => '/annuaire/'],
    ];

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly SeoAnalyzer $analyzer,
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $io->title('Simulation de crawl SEO');

        $totalIndexable = 0;
        $totalNoIndex = 0;
        $totalRed = 0;
        $totalOrange = 0;
        $totalGreen = 0;
        $rows = [];

        foreach (self::ENTITY_MAP as $label => $config) {
            $repo = $this->em->getRepository($config['class']);
            $entities = $repo->findAll();
            $count = count($entities);
            $indexable = 0;
            $noIndex = 0;
            $red = 0;
            $orange = 0;
            $green = 0;

            foreach ($entities as $entity) {
                $isNoIndex = method_exists($entity, 'isNoIndex') && $entity->isNoIndex();

                if ($isNoIndex) {
                    $noIndex++;
                } else {
                    $indexable++;
                }

                $report = $this->analyzer->analyze($entity);
                match ($report->status->value) {
                    'red' => $red++,
                    'orange' => $orange++,
                    'green' => $green++,
                };
            }

            $rows[] = [
                $label,
                $count,
                $indexable,
                $noIndex,
                "<fg=green>{$green}</>",
                "<fg=yellow>{$orange}</>",
                "<fg=red>{$red}</>",
            ];

            $totalIndexable += $indexable;
            $totalNoIndex += $noIndex;
            $totalRed += $red;
            $totalOrange += $orange;
            $totalGreen += $green;
        }

        $io->table(
            ['Type', 'Total', 'Indexable', 'NoIndex', 'Vert', 'Orange', 'Rouge'],
            $rows,
        );

        $total = $totalIndexable + $totalNoIndex;

        $io->section('Resume');
        $io->listing([
            "Pages totales : {$total}",
            "Indexables (crawlables) : {$totalIndexable}",
            "NoIndex : {$totalNoIndex}",
            "Score vert : {$totalGreen}",
            "Score orange : {$totalOrange}",
            "Score rouge : {$totalRed}",
        ]);

        if ($totalRed > 0) {
            $io->warning("{$totalRed} page(s) avec un score SEO rouge — a corriger en priorite.");
        }

        if ($totalIndexable > 0) {
            $pctGreen = round($totalGreen / $total * 100);
            $io->success("Taux de sante SEO : {$pctGreen}% vert sur {$total} pages.");
        } else {
            $io->note('Aucune page trouvee en base.');
        }

        return Command::SUCCESS;
    }
}
