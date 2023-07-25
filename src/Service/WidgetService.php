<?php

namespace App\Service;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;

class WidgetService
{
    public function __construct(
        private CategorieRepository $categorieRepository,
        private ArticleRepository $articleRepository,
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

}