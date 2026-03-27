<?php

namespace App\Controller;

use App\Repository\FaqRepository;
use App\Service\SeoService;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class FaqController extends AbstractController
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/faq', name: 'app_faq_index')]
    public function index(FaqRepository $faqRepository): Response
    {
        if (!$this->siteContext->hasModule('faq')) {
            throw $this->createNotFoundException();
        }

        $groups = $faqRepository->findAllActiveGroupedByCategory();

        return $this->render('faq/index.html.twig', [
            'title_page' => 'Foire aux questions',
            'groups' => $groups,
            'seo' => $this->seoService->resolveForPage('FAQ'),
        ]);
    }
}
