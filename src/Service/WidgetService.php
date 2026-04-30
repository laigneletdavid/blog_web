<?php

namespace App\Service;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use App\Repository\EventRepository;
use App\Repository\TagGroupRepository;
use App\Repository\TagRepository;

class WidgetService
{
    public function __construct(
        private CategorieRepository $categorieRepository,
        private ArticleRepository $articleRepository,
        private TagRepository $tagRepository,
        private TagGroupRepository $tagGroupRepository,
        private EventRepository $eventRepository,
    )
    {
    }

    /**
     * @return Categorie[]
     */
    public function findCategories(): array
    {
        return $this->categorieRepository->findBy( [], ['name' => 'ASC']);
    }

    /**
     * @return Article[]
     */
    public function findLastArticle(): array
    {
        return $this->articleRepository->lastArticle();
    }

    /**
     * Archives : mois/annee avec nombre d'articles.
     *
     * @return array<array{year: int, month: int, count: int}>
     */
    public function findArchives(): array
    {
        return $this->articleRepository->findArchiveMonths();
    }

    /**
     * @return array<array{0: \App\Entity\Tag, articleCount: int}>
     */
    public function findTagCloud(): array
    {
        return $this->tagRepository->findAllWithArticleCount();
    }

    /**
     * Prochains événements (pour widget sidebar).
     *
     * @return \App\Entity\Event[]
     */
    public function findUpcomingEvents(int $limit = 3): array
    {
        return $this->eventRepository->findUpcoming($limit);
    }

    /**
     * Nuage de tags filtre par famille (TagGroup) et par contexte d'usage.
     *
     * Utilise pour le widget reutilisable {% include 'widgets/tag_cloud_by_family.html.twig' %}
     * qu'on peut placer dans un footer, une sidebar, une homepage...
     *
     * Si la famille n'existe pas (slug invalide ou pas encore creee), retourne un tableau vide
     * — le template affiche alors rien (pas d'erreur cote front).
     *
     * @param string      $familySlug Slug de la TagGroup (ex: 'villes', 'metiers')
     * @param string      $context    'directory' (defaut) ou 'articles' — source du count
     * @param int|null    $limit      Limite optionnelle (les tags les plus utilises en premier si limit donne)
     *
     * @return array{group: \App\Entity\TagGroup|null, rows: array<array{0: \App\Entity\Tag, directoryCount?: int, articleCount?: int}>}
     */
    public function findTagCloudByFamily(string $familySlug, string $context = 'directory', ?int $limit = null): array
    {
        $group = $this->tagGroupRepository->findOneBy(['slug' => $familySlug]);

        if ($group === null) {
            return ['group' => null, 'rows' => []];
        }

        $rows = match ($context) {
            'articles' => $this->tagRepository->findCloudByGroupForArticles($group),
            default => $this->tagRepository->findCloudForDirectory($group),
        };

        // Optionnel : tri par count desc + limit
        if ($limit !== null && $limit > 0) {
            usort($rows, function ($a, $b) use ($context) {
                $countKey = $context === 'articles' ? 'articleCount' : 'directoryCount';
                return ($b[$countKey] ?? 0) <=> ($a[$countKey] ?? 0);
            });
            $rows = array_slice($rows, 0, $limit);
        }

        return ['group' => $group, 'rows' => $rows];
    }
}