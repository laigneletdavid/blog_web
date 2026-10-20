<?php

namespace App\Service;

use App\Entity\Site;
use App\Enum\SeoReachEnum;
use App\Enum\SeoStatus;
use App\Model\SeoCheck;
use App\Model\SeoDocument;
use App\Model\SeoReport;
use App\Repository\ArticleRepository;
use App\Repository\PageRepository;
use App\Repository\ServiceRepository;
use Symfony\Component\String\UnicodeString;

/**
 * Controles croises entre la fiche Referencement (ce que l'admin veut) et le
 * contenu publie (ce que le site dit). Deterministe : pas d'IA, les constats
 * sont des pistes (orange), jamais des fautes (rouge).
 */
class SeoIntentChecker
{
    private const MAX_LISTED = 5;

    // Mots ignores dans la comparaison : articles, prepositions, tournures de requete
    private const STOP_WORDS = [
        'a', 'au', 'aux', 'de', 'du', 'des', 'd', 'l', 'la', 'le', 'les', 'un', 'une',
        'et', 'ou', 'en', 'pour', 'par', 'sur', 'dans', 'avec',
        'pres', 'chez', 'moi', 'mon', 'ma', 'mes', 'votre', 'vos', 'notre', 'nos',
    ];

    public function __construct(
        private readonly PageRepository $pageRepository,
        private readonly ServiceRepository $serviceRepository,
        private readonly ArticleRepository $articleRepository,
        private readonly SiteContext $siteContext,
    ) {
    }

    public function check(Site $site): SeoReport
    {
        return $this->checkAgainst($site, $this->collectDocuments());
    }

    /**
     * @param SeoDocument[] $documents
     */
    public function checkAgainst(Site $site, array $documents): SeoReport
    {
        $checks = [$this->checkProfile($site)];

        $reach = SeoReachEnum::tryFrom((string) $site->getSeoReach());
        $isLocal = $reach === SeoReachEnum::LOCAL || $reach === SeoReachEnum::REGIONAL;

        if ($isLocal) {
            $checks[] = $this->checkCoordinates($site);
            $checks[] = $this->checkAreas($site, $documents);
            $checks[] = $this->checkBusinessType($site);
        }

        $checks[] = $this->checkPriorities($site, $documents);
        $checks[] = $this->checkCustomerWords($site, $documents);

        return new SeoReport(array_values(array_filter($checks)));
    }

    private function checkProfile(Site $site): SeoCheck
    {
        $missing = [];
        if ($this->isBlank($site->getSeoActivity())) {
            $missing[] = 'ce que vous proposez';
        }
        if ($site->getSeoReach() === null) {
            $missing[] = 'la portée';
        }

        if ($missing !== []) {
            return new SeoCheck('profile', 'Votre fiche', SeoStatus::ORANGE, 'À compléter : ' . implode(' et ', $missing) . '. Les contrôles ci-dessous en dépendent.');
        }

        return new SeoCheck('profile', 'Votre fiche', SeoStatus::GREEN, 'Renseignée');
    }

    private function checkCoordinates(Site $site): SeoCheck
    {
        $missing = [];
        if ($this->isBlank($site->getAddress1())) {
            $missing[] = 'l\'adresse';
        }
        if ($this->isBlank($site->getTown())) {
            $missing[] = 'la ville';
        }
        if ($this->isBlank($site->getOpeningHours())) {
            $missing[] = 'les horaires';
        }

        if ($missing !== []) {
            return new SeoCheck('coordinates', 'Coordonnées', SeoStatus::ORANGE, 'Vous visez une clientèle de proximité, mais il manque ' . $this->joinFr($missing) . ' (dans Identité du site et ci-dessous). Google s\'en sert pour vous situer.');
        }

        return new SeoCheck('coordinates', 'Coordonnées', SeoStatus::GREEN, 'Adresse, ville et horaires renseignés');
    }

    /**
     * @param SeoDocument[] $documents
     */
    private function checkAreas(Site $site, array $documents): SeoCheck
    {
        $areas = $site->getSeoAreaList();

        if ($areas === []) {
            return new SeoCheck('areas', 'Villes visées', SeoStatus::ORANGE, 'Indiquez les villes ou la zone où vous voulez être trouvé.');
        }

        // Les villes doivent apparaitre la ou Google les lit en premier : titres et descriptions
        $haystacks = [$site->getDefaultSeoTitle(), $site->getDefaultSeoDescription(), $site->getTitle()];
        foreach ($documents as $doc) {
            array_push($haystacks, $doc->title, $doc->seoTitle, $doc->seoDescription);
        }

        $missing = array_filter($areas, fn (string $area) => !$this->foundIn($area, $haystacks));

        if ($missing !== []) {
            return new SeoCheck('areas', 'Villes visées', SeoStatus::ORANGE, $this->listMissing($missing) . ' : absent(es) de tous les titres et descriptions. Citez-les dans le titre ou la description des pages concernées.');
        }

        return new SeoCheck('areas', 'Villes visées', SeoStatus::GREEN, 'Toutes citées dans au moins un titre ou une description');
    }

    private function checkBusinessType(Site $site): SeoCheck
    {
        $type = $site->getBusinessType();

        if ($type === null || $type === '' || $type === 'Organization') {
            return new SeoCheck('business_type', 'Type d\'activité Google', SeoStatus::ORANGE, 'Le type « Organisation » est très général. Choisissez un type plus précis dans la fiche entreprise Google ci-dessous.');
        }

        return new SeoCheck('business_type', 'Type d\'activité Google', SeoStatus::GREEN, 'Précisé');
    }

    /**
     * @param SeoDocument[] $documents
     */
    private function checkPriorities(Site $site, array $documents): ?SeoCheck
    {
        $priorities = $site->getSeoPriorityList();

        if ($priorities === []) {
            return null;
        }

        // Une priorite merite sa propre page : on cherche dans les titres des pages et services
        $haystacks = [];
        foreach ($documents as $doc) {
            if ($doc->dedicated) {
                array_push($haystacks, $doc->title, $doc->seoTitle);
            }
        }

        $missing = array_filter($priorities, fn (string $p) => !$this->foundIn($p, $haystacks));

        if ($missing !== []) {
            return new SeoCheck('priorities', 'Vos priorités', SeoStatus::ORANGE, $this->listMissing($missing) . ' : aucune page ni service ne porte ce titre. Une page dédiée par priorité aide Google à vous associer à ce sujet.');
        }

        return new SeoCheck('priorities', 'Vos priorités', SeoStatus::GREEN, 'Chacune a sa page ou son service');
    }

    /**
     * @param SeoDocument[] $documents
     */
    private function checkCustomerWords(Site $site, array $documents): ?SeoCheck
    {
        $words = $site->getSeoCustomerWordList();

        if ($words === []) {
            return null;
        }

        $haystacks = [$site->getDefaultSeoTitle(), $site->getDefaultSeoDescription(), $site->getTitle()];
        foreach ($documents as $doc) {
            array_push($haystacks, $doc->title, $doc->seoTitle, $doc->seoDescription, $doc->content);
        }

        $missing = array_filter($words, fn (string $w) => !$this->foundIn($w, $haystacks));

        if ($missing !== []) {
            return new SeoCheck('customer_words', 'Mots de vos clients', SeoStatus::ORANGE, $this->listMissing($missing) . ' : n\'apparaît nulle part sur le site. Utilisez ces mots dans vos textes, tels que vos clients les tapent.');
        }

        return new SeoCheck('customer_words', 'Mots de vos clients', SeoStatus::GREEN, 'Tous présents sur le site');
    }

    /**
     * @return SeoDocument[]
     */
    private function collectDocuments(): array
    {
        $documents = [];

        foreach ($this->pageRepository->findAllPublished() as $page) {
            $documents[] = new SeoDocument($page->getTitle(), $page->getSeoTitle(), $page->getSeoDescription(), $page->getContent(), true);
        }

        if ($this->siteContext->hasModule('services')) {
            foreach ($this->serviceRepository->findAllActive() as $service) {
                $documents[] = new SeoDocument(
                    $service->getTitle(),
                    $service->getSeoTitle(),
                    $service->getSeoDescription() ?? $service->getShortDescription(),
                    $service->getContent(),
                    true,
                );
            }
        }

        if ($this->siteContext->hasModule('blog')) {
            foreach ($this->articleRepository->findAllPublished() as $article) {
                $documents[] = new SeoDocument($article->getTitle(), $article->getSeoTitle(), $article->getSeoDescription(), $article->getContent(), false);
            }
        }

        return $documents;
    }

    /**
     * Vrai si tous les mots significatifs de $needle figurent dans un meme texte,
     * dans n'importe quel ordre, sans tenir compte des accents ni des majuscules.
     * "notaire saint-martory" trouve "notaire a Saint-Martory" ; "Pau" ne trouve pas "Paul".
     *
     * @param array<string|null> $haystacks
     */
    private function foundIn(string $needle, array $haystacks): bool
    {
        $words = $this->significantWords($needle);
        if ($words === []) {
            return true;
        }

        foreach ($haystacks as $haystack) {
            if ($haystack === null || $haystack === '') {
                continue;
            }

            $available = array_flip($this->words($haystack));
            if (array_diff($words, array_keys($available)) === []) {
                return true;
            }
        }

        return false;
    }

    /**
     * @return string[] mots sans accents ni majuscules, ponctuation retiree
     */
    private function words(string $text): array
    {
        $text = html_entity_decode(strip_tags($text), ENT_QUOTES | ENT_HTML5, 'UTF-8');
        $text = (new UnicodeString($text))->ascii()->lower()->toString();

        return preg_split('/[^a-z0-9]+/', $text, -1, PREG_SPLIT_NO_EMPTY) ?: [];
    }

    /**
     * @return string[] mots de $text hors mots vides ("de", "a", "pres de chez moi"...)
     */
    private function significantWords(string $text): array
    {
        return array_values(array_unique(array_diff($this->words($text), self::STOP_WORDS)));
    }

    /**
     * @param string[] $items
     */
    private function listMissing(array $items): string
    {
        $items = array_values($items);
        $quoted = array_map(static fn (string $i) => '« ' . $i . ' »', array_slice($items, 0, self::MAX_LISTED));
        $rest = count($items) - count($quoted);

        if ($rest > 0) {
            return implode(', ', $quoted) . ' et ' . $rest . ' autre(s)';
        }

        return $this->joinFr($quoted);
    }

    /**
     * @param string[] $items
     */
    private function joinFr(array $items): string
    {
        if (count($items) <= 1) {
            return implode('', $items);
        }

        $last = array_pop($items);

        return implode(', ', $items) . ' et ' . $last;
    }

    private function isBlank(?string $value): bool
    {
        return $value === null || trim($value) === '';
    }
}
