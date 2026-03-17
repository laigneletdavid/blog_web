<?php

namespace App\Controller;

use App\Repository\ServiceRepository;
use App\Service\SeoService;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class ServiceController extends AbstractController
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/services', name: 'app_service_index')]
    public function index(ServiceRepository $serviceRepository): Response
    {
        if (!$this->siteContext->hasModule('services')) {
            throw $this->createNotFoundException();
        }

        return $this->render('service/index.html.twig', [
            'title_page' => 'Nos services',
            'services' => $serviceRepository->findAllActive(),
            'seo' => $this->seoService->resolveForPage('Services'),
        ]);
    }

    #[Route('/service/{slug}', name: 'app_service_show')]
    public function show(string $slug, ServiceRepository $serviceRepository): Response
    {
        if (!$this->siteContext->hasModule('services')) {
            throw $this->createNotFoundException();
        }

        $service = $serviceRepository->findOneActiveBySlug($slug);
        if (!$service) {
            throw $this->createNotFoundException('Service introuvable.');
        }

        // Page détail uniquement si le service a du contenu TipTap
        if (empty($service->getBlocks())) {
            return $this->redirectToRoute('app_service_index');
        }

        return $this->render('service/show.html.twig', [
            'title_page' => $service->getTitle(),
            'service' => $service,
            'seo' => $this->seoService->resolveForPage($service->getTitle()),
        ]);
    }
}
