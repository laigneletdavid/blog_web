<?php

namespace App\Command;

use App\Entity\Service;
use App\Repository\ServiceRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;
use Symfony\Component\String\Slugger\AsciiSlugger;

/**
 * Importe l'offre du site statique BM NOTAIRE dans les services.
 *
 * Les 33 pages de detail partagent une structure rigoureusement identique
 * (d-hero, d-intro, d-steps, d-docs, d-faq, d-cta), ce qui permet de les lire
 * mecaniquement plutot que de ressaisir le tout a la main.
 *
 * Le rattachement suit les liens des pages de pole, et non le prefixe des
 * fichiers : « Famille & Patrimoine » couvre aussi bien famille-*.html que
 * patrimoine-*.html, ce qu'un decoupage par nom de fichier manquerait.
 *
 * La commande est rejouable : un service deja importe est mis a jour, jamais
 * duplique. Le bloc d'appel a l'action, identique sur les 33 pages, n'est pas
 * repris : il appartient au gabarit, pas au contenu.
 */
#[AsCommand(
    name: 'app:import:bm-notaire',
    description: 'Importe les poles et prestations depuis le site statique BM NOTAIRE',
)]
class ImportBmNotaireCommand extends Command
{
    /** Pages de pole, dans l'ordre d'affichage souhaite. */
    private const POLES = [
        'immobilier.html' => 'Immobilier',
        'famille.html' => 'Famille & patrimoine',
        'entreprise.html' => 'Entreprise',
        'droit-rural.html' => 'Droit rural',
    ];

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly ServiceRepository $services,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            ->addArgument('source', InputArgument::REQUIRED, 'Dossier contenant les fichiers HTML du site')
            ->addOption('dry-run', null, InputOption::VALUE_NONE, 'Analyse et rapport, sans rien ecrire')
            ->addOption('prefixe', null, InputOption::VALUE_REQUIRED, 'Prefixe des slugs crees', '');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $source = rtrim((string) $input->getArgument('source'), '/\\');
        $simulation = (bool) $input->getOption('dry-run');
        $prefixe = (string) $input->getOption('prefixe');

        if (!is_dir($source)) {
            $io->error("Dossier introuvable : $source");

            return Command::FAILURE;
        }

        $io->title('Import BM NOTAIRE' . ($simulation ? ' — simulation' : ''));

        $position = 0;
        $cree = 0;
        $maj = 0;
        $ignores = [];
        $traitees = [];

        foreach (self::POLES as $fichier => $titrePole) {
            $chemin = $source . '/' . $fichier;
            if (!is_file($chemin)) {
                $ignores[] = "$fichier (absent)";
                continue;
            }

            $html = $this->lire($chemin);
            $pole = $this->majService(
                $this->slug($fichier, $prefixe),
                $titrePole,
                $this->extraireChapo($html) ?? '',
                $this->blocsPole($html),
                null,
                $position += 10,
                $simulation,
                $cree,
                $maj,
            );

            $io->section($titrePole);

            $rang = 0;
            foreach ($this->sousPages($html) as $sousFichier) {
                $cheminSous = $source . '/' . $sousFichier;
                if (!is_file($cheminSous)) {
                    $ignores[] = $sousFichier;
                    continue;
                }

                $htmlSous = $this->lire($cheminSous);

                // Une prestation se reconnait a sa structure, pas a son nom de
                // fichier : les pages de parcours (rendez-vous, votre-projet)
                // sont liees depuis les poles sans en faire partie.
                if ($this->section($htmlSous, 'd-hero') === '') {
                    continue;
                }

                $titre = $this->extraireTitre($htmlSous);
                if ($titre === null) {
                    $ignores[] = "$sousFichier (titre introuvable)";
                    continue;
                }

                $this->majService(
                    $this->slug($sousFichier, $prefixe),
                    $titre,
                    $this->extraireChapo($htmlSous) ?? '',
                    $this->blocsDetail($htmlSous),
                    $pole,
                    $rang += 10,
                    $simulation,
                    $cree,
                    $maj,
                );

                $traitees[] = $sousFichier;
                $io->writeln(sprintf('   %-46s %s', $titre, $sousFichier));
            }
        }

        if (!$simulation) {
            $this->em->flush();
        }

        $io->newLine();
        $io->success(sprintf(
            '%d service(s) cree(s), %d mis a jour%s',
            $cree,
            $maj,
            $simulation ? ' — rien n\'a ete ecrit' : '',
        ));

        $orphelines = [];
        foreach (glob($source . '/*.html') ?: [] as $chemin) {
            $nom = basename($chemin);
            if (in_array($nom, $traitees, true) || array_key_exists($nom, self::POLES)) {
                continue;
            }
            if ($this->section($this->lire($chemin), 'd-hero') !== '') {
                $orphelines[] = $nom;
            }
        }
        if ($orphelines !== []) {
            $io->warning(
                "Prestations qu'aucun pole ne lie, donc non importees.
"
                . "Elles sont tout aussi inaccessibles sur le site d'origine :
  - "
                . implode("
  - ", $orphelines),
            );
        }

        if ($ignores !== []) {
            $io->warning("Pages ignorees :\n  - " . implode("\n  - ", $ignores));
        }

        return Command::SUCCESS;
    }

    // ---------------------------------------------------------------- lecture

    private function lire(string $chemin): string
    {
        return (string) file_get_contents($chemin);
    }

    private function slug(string $fichier, string $prefixe): string
    {
        $base = preg_replace('/\.html$/', '', basename($fichier));

        return (new AsciiSlugger())->slug($prefixe . $base)->lower()->toString();
    }

    /** Sous-pages liees par une page de pole, dans leur ordre d'apparition. */
    private function sousPages(string $html): array
    {
        preg_match_all('/href="([a-z0-9-]+-[a-z0-9-]+\.html)"/i', $html, $m);
        $vues = [];
        foreach ($m[1] as $f) {
            if (!in_array($f, $vues, true) && !array_key_exists($f, self::POLES)) {
                $vues[] = $f;
            }
        }

        return $vues;
    }

    private function section(string $html, string $classe): string
    {
        return preg_match('/<section class="' . $classe . '".*?<\/section>/s', $html, $m) ? $m[0] : '';
    }

    private function extraireTitre(string $html): ?string
    {
        if (preg_match('/<h1[^>]*>(.*?)<\/h1>/s', $html, $m)) {
            return $this->texte($m[1]);
        }

        return null;
    }

    /**
     * Chapeau du hero.
     *
     * Sur une page de pole, le premier paragraphe est l'intitule de rubrique
     * (« BM NOTAIRE · EXPERTISE ») : c'est celui porteur de la classe xp-intro
     * qu'il faut retenir. Sur une prestation, le premier paragraphe est le bon.
     */
    private function extraireChapo(string $html): ?string
    {
        $hero = $this->section($html, 'xp-hero');
        if ($hero !== '') {
            if (preg_match('/<p class="xp-intro"[^>]*>(.*?)<\/p>/s', $hero, $m)) {
                $t = $this->texte($m[1]);

                return $t !== '' ? $t : null;
            }

            return null;
        }

        $hero = $this->section($html, 'd-hero');
        if ($hero !== '' && preg_match('/<p[^>]*>(.*?)<\/p>/s', $hero, $m)) {
            $t = $this->texte($m[1]);

            return $t !== '' ? $t : null;
        }

        return null;
    }

    private function texte(string $html): string
    {
        $t = preg_replace('/<br\s*\/?>/i', ' ', $html);
        $t = html_entity_decode(strip_tags((string) $t), ENT_QUOTES | ENT_HTML5, 'UTF-8');

        return trim(preg_replace('/\s+/u', ' ', $t) ?? '');
    }

    // ------------------------------------------------------------ construction

    private function paragraphe(string $texte): array
    {
        return ['type' => 'paragraph', 'content' => [['type' => 'text', 'text' => $texte]]];
    }

    private function titre(string $texte, int $niveau = 3): array
    {
        return [
            'type' => 'heading',
            'attrs' => ['level' => $niveau],
            'content' => [['type' => 'text', 'text' => $texte]],
        ];
    }

    private function liste(array $elements, bool $ordonnee): array
    {
        return [
            'type' => $ordonnee ? 'orderedList' : 'bulletList',
            'content' => array_map(
                fn (string $e): array => ['type' => 'listItem', 'content' => [$this->paragraphe($e)]],
                $elements,
            ),
        ];
    }

    /**
     * Corps d'une page de pole.
     *
     * Deux temps : la vision d'ensemble, puis les axes d'accompagnement. Ces
     * axes changent d'un pole a l'autre -- « Vente, Acquisition, Foncier »
     * pour l'immobilier, « Anticiper, Transmettre, Regler » pour la famille --
     * ils relevent donc du contenu et non du gabarit.
     */
    private function blocsPole(string $html): array
    {
        $contenu = [];

        foreach ($this->paragraphes($this->section($html, 'xp-overview')) as $p) {
            $contenu[] = $this->paragraphe($p);
        }

        $detail = $this->section($html, 'xp-detail');

        // Le chapeau de la section seulement : les paragraphes des cartes
        // reviendraient sinon une seconde fois, en bas, dans les axes.
        $chapeau = preg_replace('#<article class="xp-card">.*?</article>#s', '', $detail) ?? '';
        foreach ($this->paragraphes($chapeau) as $p) {
            $contenu[] = $this->paragraphe($p);
        }

        $axes = $this->axes($detail);
        if ($axes !== []) {
            $contenu[] = $this->titre('Notre accompagnement');
            $contenu[] = $this->liste($axes, false);
        }

        return $contenu !== [] ? ['type' => 'doc', 'content' => $contenu] : [];
    }

    /**
     * Axes d'accompagnement d'un pole, sous la forme « Intitule — propos ».
     *
     * @return string[]
     */
    private function axes(string $section): array
    {
        preg_match_all(
            '/<article class="xp-card">.*?<h3>(.*?)<\/h3>\s*<p>(.*?)<\/p>/s',
            $section,
            $m,
            PREG_SET_ORDER,
        );

        $out = [];
        foreach ($m as $carte) {
            $titre = $this->texte($carte[1]);
            $propos = $this->texte($carte[2]);
            if ($titre !== '') {
                $out[] = $propos !== '' ? $titre . ' — ' . $propos : $titre;
            }
        }

        return $out;
    }

    /**
     * Corps d'une prestation : presentation, parcours, pieces a reunir.
     *
     * L'appel a l'action est volontairement laisse de cote : strictement
     * identique sur les 33 pages, il releve du gabarit.
     */
    private function blocsDetail(string $html): array
    {
        $contenu = [];

        foreach ($this->paragraphes($this->section($html, 'd-intro')) as $p) {
            $contenu[] = $this->paragraphe($p);
        }

        $etapes = $this->etapes($html);
        if ($etapes !== []) {
            $contenu[] = $this->titre('Votre dossier, étape par étape');
            $contenu[] = $this->liste($etapes, true);
        }

        $pieces = $this->pieces($html);
        if ($pieces !== []) {
            $contenu[] = $this->titre('Les premiers éléments à réunir');
            $contenu[] = $this->liste($pieces, false);
            $contenu[] = $this->paragraphe(
                'Cette liste constitue un point de départ. Les pièces réellement nécessaires '
                . 'sont précisées après examen de votre situation.',
            );
        }

        $questions = $this->questions($html);
        if ($questions !== []) {
            $contenu[] = $this->titre('Avant le rendez-vous');
            foreach ($questions as [$q, $r]) {
                $contenu[] = $this->titre($q, 4);
                $contenu[] = $this->paragraphe($r);
            }
        }

        return $contenu !== [] ? ['type' => 'doc', 'content' => $contenu] : [];
    }

    /**
     * Questions frequentes d'une prestation.
     *
     * Elles sont communes aux pages d'une meme famille -- cinq jeux de trois
     * pour trente-trois pages. On les recopie sur chacune, comme le fait le
     * site d'origine : l'etude peut ainsi en ajuster une sans toucher aux
     * autres.
     *
     * @return array<int, array{0: string, 1: string}>
     */
    private function questions(string $html): array
    {
        $faq = $this->section($html, 'd-faq');
        if ($faq === '') {
            return [];
        }

        preg_match_all('#<h3[^>]*>(.*?)</h3>\s*<p[^>]*>(.*?)</p>#s', $faq, $m, PREG_SET_ORDER);

        $out = [];
        foreach ($m as $couple) {
            $q = $this->texte($couple[1]);
            $r = $this->texte($couple[2]);
            if ($q !== '' && $r !== '') {
                $out[] = [$q, $r];
            }
        }

        return $out;
    }

    private function paragraphes(string $section): array
    {
        if ($section === '') {
            return [];
        }
        preg_match_all('/<p[^>]*>(.*?)<\/p>/s', $section, $m);
        $out = [];
        foreach ($m[1] as $p) {
            $t = $this->texte($p);
            if ($t !== '') {
                $out[] = $t;
            }
        }

        return $out;
    }

    /** Libelles du parcours, portes par les <b> de chaque etape. */
    private function etapes(string $html): array
    {
        // <b(espace|fin)> et non <b[^>]*> : ce dernier avale les <br>, dont la
        // capture remonte alors jusqu'au titre de la section.
        preg_match_all('/<b(?:\s[^>]*)?>(.*?)<\/b>/s', $this->section($html, 'd-steps'), $m);

        return array_values(array_filter(array_map(fn ($e) => $this->texte($e), $m[1])));
    }

    /** Pieces a reunir : les <span> de la section, hors numero de section. */
    private function pieces(string $html): array
    {
        preg_match_all('/<span[^>]*>(.*?)<\/span>/s', $this->section($html, 'd-docs'), $m);
        $out = [];
        foreach ($m[1] as $s) {
            $t = $this->texte($s);
            // « 03 / PREPARER » est l'intitule de la section, pas une piece.
            if ($t !== '' && !preg_match('#^\d+\s*/#u', $t)) {
                $out[] = $t;
            }
        }

        return $out;
    }

    // ------------------------------------------------------------ persistance

    private function majService(
        string $slug,
        string $titre,
        string $chapo,
        array $blocs,
        ?Service $parent,
        int $position,
        bool $simulation,
        int &$cree,
        int &$maj,
    ): ?Service {
        $service = $this->services->findOneBy(['slug' => $slug]);
        $nouveau = $service === null;

        if ($simulation) {
            $nouveau ? $cree++ : $maj++;

            return $service;
        }

        if ($nouveau) {
            $service = new Service();
            $service->setSlug($slug);
            $cree++;
        } else {
            $maj++;
        }

        $service->setTitle($titre);
        $service->setShortDescription($chapo);
        $service->setBlocks($blocs !== [] ? $blocs : null);
        $service->setParent($parent);
        $service->setPosition($position);
        $service->setIsActive(true);

        $this->em->persist($service);

        return $service;
    }
}
