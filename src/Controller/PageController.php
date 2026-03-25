<?php

namespace App\Controller;

use App\Entity\Page;
use App\Security\Voter\ContentVoter;
use App\Service\SeoService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/page', name: 'app_page_')]
class PageController extends AbstractController
{
    public function __construct(
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/{slug}', name: 'show')]
    public function show(?Page $page): Response
    {
        if (!$page) {
            throw $this->createNotFoundException('Page introuvable.');
        }

        if (!$this->isGranted(ContentVoter::VIEW, $page)) {
            return $this->render('_partials/_restricted_access.html.twig', [
                'title' => $page->getTitle(),
                'visibility' => $page->getVisibility(),
                'seo' => $this->seoService->resolveForPage($page->getTitle()),
            ], new Response('', 403));
        }

        return $this->render('page/show.html.twig', [
            'page' => $page,
            'title_page' => $page->getTitle() ?? 'Page',
            'text_page' => '',
            'seo' => $this->seoService->resolve($page),
        ]);
    }
}
