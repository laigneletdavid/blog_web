<?php

namespace App\Controller;

use App\Entity\Categorie;
use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Liste des articles du blog, commune a /article/ et a /categorie/{slug} :
 * meme gabarit (pills, pagination), articles publies seulement.
 * Le controleur qui l'utilise doit avoir $seoService.
 */
trait BlogListeTrait
{
    private function renderBlogListe(Request $request, ArticleRepository $articleRepository, CategorieRepository $categorieRepository, ?Categorie $categorie = null): Response
    {
        $page = max(1, $request->query->getInt('page', 1));
        $month = $request->query->getInt('month') ?: null;
        $year = $request->query->getInt('year') ?: null;
        $categorieSlug = $categorie?->getSlug() ?? $request->query->get('categorie');

        // Article featured (uniquement page 1 sans filtre)
        $featuredArticle = null;
        $excludeId = null;
        if ($page === 1 && !$month && !$year && !$categorieSlug) {
            $featuredArticle = $articleRepository->findFeatured();
            $excludeId = $featuredArticle?->getId();
        }

        $perPage = 9;
        $paginator = $articleRepository->findPublishedPaginated($page, $perPage, $month, $year, $categorieSlug, $excludeId);
        $totalPages = max(1, (int) ceil(count($paginator) / $perPage));
        // L'article mis en avant est exclu de la liste : il compte quand meme
        $totalArticles = count($paginator) + ($featuredArticle !== null ? 1 : 0);

        // Categories pour les pills de filtrage
        $blogCategories = $categorieRepository->findAllWithPublishedArticleCount();

        // Titre dynamique
        $titlePage = $categorie?->getName() ?? 'Tous les articles';
        if ($month && $year) {
            $monthNames = ['', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
            $titlePage = sprintf('Articles de %s %d', $monthNames[$month] ?? '', $year);
        }

        // Options seo.blog.* : seulement pour la liste complete, pas pour un mois
        $seo = $categorie !== null
            ? $this->seoService->resolve($categorie)
            : $this->seoService->resolveForPage($titlePage, null, ($month && $year) ? null : 'blog');

        if ($page > 1 || $totalArticles === 0) {
            $seo['noIndex'] = true;
        }

        return $this->render('article/show_all.html.twig', [
            'title_page' => $titlePage,
            'text_page' => 'Blog',
            'articles' => $paginator,
            'currentPage' => $page,
            'totalPages' => $totalPages,
            'filterMonth' => $month,
            'filterYear' => $year,
            'filterCategorie' => $categorieSlug,
            'categorie' => $categorie,
            'featuredArticle' => $featuredArticle,
            'blogCategories' => $blogCategories,
            'totalArticles' => $totalArticles,
            'seo' => $seo,
        ]);
    }
}
