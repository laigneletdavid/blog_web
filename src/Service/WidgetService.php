<?php

namespace App\Service;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use App\Repository\TagRepository;

class WidgetService
{
    public function __construct(
        private CategorieRepository $categorieRepository,
        private ArticleRepository $articleRepository,
        private TagRepository $tagRepository,
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
}