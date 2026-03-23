<?php

namespace App\Controller;

use App\Entity\Article;
use App\Entity\Comment;
use App\Form\Type\CommentType;
use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use App\Security\Voter\ContentVoter;
use App\Service\SeoService;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/article', name: 'app_article_')]
class ArticleController extends AbstractController
{
    public function __construct(
        private readonly SeoService $seoService,
        private readonly SiteContext $siteContext,
    ) {
    }

    #[Route('/', name: 'show_all')]
    public function showAll(Request $request, ArticleRepository $articleRepository, CategorieRepository $categorieRepository): Response
    {
        if (!$this->siteContext->hasModule('blog')) {
            throw $this->createNotFoundException();
        }

        $page = max(1, $request->query->getInt('page', 1));
        $month = $request->query->getInt('month') ?: null;
        $year = $request->query->getInt('year') ?: null;
        $categorieSlug = $request->query->get('categorie');

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

        // Categories pour les pills de filtrage
        $blogCategories = $categorieRepository->findAllWithPublishedArticleCount();

        // Titre dynamique
        $titlePage = 'Tous les articles';
        if ($month && $year) {
            $monthNames = ['', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
            $titlePage = sprintf('Articles de %s %d', $monthNames[$month] ?? '', $year);
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
            'featuredArticle' => $featuredArticle,
            'blogCategories' => $blogCategories,
            'totalArticles' => count($paginator),
            'seo' => $this->seoService->resolveForPage($titlePage),
        ]);
    }

    #[Route('/{slug}', name: 'show')]
    public function show(?Article $article, Request $request, EntityManagerInterface $em, ArticleRepository $articleRepository): Response
    {
        if (!$this->siteContext->hasModule('blog')) {
            throw $this->createNotFoundException();
        }

        if (!$article) {
            throw $this->createNotFoundException('Article introuvable.');
        }

        if (!$this->isGranted(ContentVoter::VIEW, $article)) {
            return $this->render('_partials/_restricted_access.html.twig', [
                'title' => $article->getTitle(),
                'visibility' => $article->getVisibility(),
                'seo' => $this->seoService->resolveForPage($article->getTitle()),
            ], new Response('', 403));
        }

        $commentForm = null;
        $user = $this->getUser();

        if ($user) {
            $comment = new Comment($article);
            $comment->setCreatedAt(new \DateTime());
            $comment->setUser($user);
            $commentForm = $this->createForm(CommentType::class, $comment);
            $commentForm->handleRequest($request);

            if ($commentForm->isSubmitted() && $commentForm->isValid()) {
                $em->persist($comment);
                $em->flush();

                $this->addFlash('success', 'Commentaire publie avec succes.');

                return $this->redirectToRoute('app_article_show', [
                    'slug' => $article->getSlug(),
                ]);
            }
        }

        // Articles connexes (meme categorie)
        $relatedArticles = $articleRepository->findRelated($article, 3);

        return $this->render('article/show.html.twig', [
            'title_page' => 'Article',
            'article' => $article,
            'commentForm' => $commentForm,
            'relatedArticles' => $relatedArticles,
            'seo' => $this->seoService->resolve($article),
        ]);
    }
}
