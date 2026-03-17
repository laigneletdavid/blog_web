<?php

namespace App\Controller;

use App\Repository\ArticleRepository;
use App\Repository\TagRepository;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\Routing\Attribute\Route;

class TagController extends AbstractController
{
    public function __construct(
        private TagRepository $tagRepository,
        private ArticleRepository $articleRepository,
        private SiteContext $siteContext,
    )
    {
    }

    #[Route('/tag/{slug}', name: 'app_tag_show')]
    public function show(string $slug, Request $request): Response
    {
        if (!$this->siteContext->hasModule('blog')) {
            throw $this->createNotFoundException();
        }

        $tag = $this->tagRepository->findOneBy(['slug' => $slug]);
        if (!$tag) {
            throw $this->createNotFoundException();
        }

        $page = max(1, $request->query->getInt('page', 1));
        $articles = $this->articleRepository->findPublishedByTag($tag, $page, 9);
        $totalPages = (int) ceil(count($articles) / 9);

        return $this->render('tag/show.html.twig', [
            'tag' => $tag,
            'articles' => $articles,
            'currentPage' => $page,
            'totalPages' => $totalPages,
        ]);
    }
}
