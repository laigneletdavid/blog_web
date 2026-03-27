<?php

namespace App\Controller;

use App\Enum\SystemPageEnum;
use App\Repository\PageRepository;
use App\Service\SeoService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class LegalController extends AbstractController
{
    private const TYPE_TO_SYSTEM_KEY = [
        'mentions-legales' => 'mentions-legales',
        'politique-de-confidentialite' => 'politique-confidentialite',
        'conditions-generales-de-vente' => 'cgv',
        'conditions-generales-utilisation' => 'cgu',
    ];

    public function __construct(
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/{type}', name: 'app_legal_page',
        requirements: ['type' => 'mentions-legales|politique-de-confidentialite|conditions-generales-de-vente|conditions-generales-utilisation'],
        priority: -10)]
    public function show(string $type, PageRepository $pageRepository): Response
    {
        $systemKey = self::TYPE_TO_SYSTEM_KEY[$type] ?? null;
        if ($systemKey === null) {
            throw $this->createNotFoundException();
        }

        $page = $pageRepository->findSystemPage($systemKey);
        if ($page === null || !$page->isPublished()) {
            throw $this->createNotFoundException();
        }

        return $this->render('page/show.html.twig', [
            'page' => $page,
            'title_page' => $page->getTitle(),
            'text_page' => '',
            'seo' => $this->seoService->resolve($page),
        ]);
    }
}
