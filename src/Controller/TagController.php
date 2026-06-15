<?php

namespace App\Controller;

use App\Repository\ArticleRepository;
use App\Repository\DirectoryEntryRepository;
use App\Repository\PortfolioItemRepository;
use App\Repository\ProductRepository;
use App\Repository\TagRepository;
use App\Service\SeoService;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class TagController extends AbstractController
{
    public function __construct(
        private TagRepository $tagRepository,
        private ArticleRepository $articleRepository,
        private DirectoryEntryRepository $directoryEntryRepository,
        private SiteContext $siteContext,
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/tag/{slug}', name: 'app_tag_show')]
    public function show(string $slug, Request $request): Response
    {
        $tag = $this->tagRepository->findOneBy(['slug' => $slug]);
        if (!$tag) {
            throw $this->createNotFoundException();
        }

        // Compteurs multi-source pour decider quelles sections afficher.
        $counts = $this->tagRepository->getMultiSourceCounts($tag);

        $hasBlog = $this->siteContext->hasModule('blog');
        $hasDirectory = $this->siteContext->hasModule('directory');

        // Articles : pagination uniquement si le blog est actif.
        $articles = [];
        $currentPage = 1;
        $totalPages = 0;
        if ($hasBlog && $counts['articles'] > 0) {
            $currentPage = max(1, $request->query->getInt('page', 1));
            $articles = $this->articleRepository->findPublishedByTag($tag, $currentPage, 9);
            $totalPages = (int) ceil($counts['articles'] / 9);
        }

        // Annuaire : liste complete (les fiches actives sont peu nombreuses en general).
        $directoryEntries = [];
        if ($hasDirectory && $counts['directory'] > 0) {
            $directoryEntries = $this->directoryEntryRepository->findActiveByTag($tag);
        }

        $seo = $this->seoService->resolve($tag);

        $totalContent = array_sum($counts);
        if ($totalContent === 0) {
            $seo['noIndex'] = true;
        }

        return $this->render('tag/show.html.twig', [
            'tag' => $tag,
            'counts' => $counts,
            'hasBlog' => $hasBlog,
            'hasDirectory' => $hasDirectory,
            'articles' => $articles,
            'currentPage' => $currentPage,
            'totalPages' => $totalPages,
            'directoryEntries' => $directoryEntries,
            'seo' => $seo,
        ]);
    }
}
