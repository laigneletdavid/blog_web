<?php

namespace App\Command;

use App\Repository\MediaRepository;
use App\Service\MediaProcessorService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:media:regenerate-sizes',
    description: 'Regenerate WebP and responsive image sizes for all media',
)]
class RegenerateMediaSizesCommand extends Command
{
    public function __construct(
        private readonly MediaRepository $mediaRepository,
        private readonly MediaProcessorService $mediaProcessor,
        private readonly EntityManagerInterface $em,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            ->addOption('force', 'f', InputOption::VALUE_NONE, 'Force regeneration even if files exist')
            ->addOption('dry-run', null, InputOption::VALUE_NONE, 'Show what would be processed without actually doing it');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $force = $input->getOption('force');
        $dryRun = $input->getOption('dry-run');

        $medias = $this->mediaRepository->findAll();
        $total = count($medias);
        $processed = 0;
        $skipped = 0;
        $failed = 0;

        $io->title('Regeneration des images WebP et responsives');
        $io->text(sprintf('Traitement de %d medias...', $total));

        if ($dryRun) {
            $io->note('Mode dry-run : aucune modification ne sera effectuee.');
        }

        $io->progressStart($total);

        foreach ($medias as $media) {
            $fileName = $media->getFileName();

            if (!$fileName || !$this->mediaProcessor->isSupported($fileName)) {
                $skipped++;
                $io->progressAdvance();
                continue;
            }

            if ($dryRun) {
                $io->progressAdvance();
                $processed++;
                continue;
            }

            $webpFileName = $this->mediaProcessor->process($media, $force);

            if ($webpFileName) {
                $media->setWebpFileName($webpFileName);
                $processed++;
            } else {
                $failed++;
            }

            $io->progressAdvance();
        }

        if (!$dryRun) {
            $this->em->flush();
        }

        $io->progressFinish();

        $io->success(sprintf(
            'Termine : %d traites, %d ignores, %d echoues (sur %d)',
            $processed,
            $skipped,
            $failed,
            $total,
        ));

        return Command::SUCCESS;
    }
}
