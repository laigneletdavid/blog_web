<?php

namespace App\Controller;

use App\Repository\MenuRepository;
use App\Repository\PageRepository;
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
    public function index(
        ServiceRepository $serviceRepository,
        MenuRepository $menuRepository,
        PageRepository $pageRepository,
    ): Response {
        if (!$this->siteContext->hasModule('services')) {
            throw $this->createNotFoundException();
        }

        $services = $serviceRepository->findAllActive();

        // Le titre suit l'intitule du menu : un site qui renomme "Services" en
        // "Expertises" ou "Prestations" attend le meme mot sur la page.
        $title = $menuRepository->findSystemByLocationAndKey('header', 'services')?->getName()
            ?? 'Services';

        // Introduction editable, facultative : page systeme de cle "services_intro".
        // Absente par defaut, donc aucun changement pour les sites qui n'en creent pas.
        // Elle est affichee meme non publiee : c'est un fragment de cette page, pas
        // une page autonome, et la laisser depubliee evite le contenu duplique.
        $intro = $pageRepository->findSystemPage('services_intro');

        $seo = $this->seoService->resolveForPage($title);

        if (count($services) === 0) {
            $seo['noIndex'] = true;
        }

        return $this->render('service/index.html.twig', [
            'title_page' => $title,
            'services' => $services,
            'intro' => $intro,
            'seo' => $seo,
        ]);
    }

    #[Route('/service/{slug}', name: 'app_service_show')]
    public function show(
        string $slug,
        ServiceRepository $serviceRepository,
        MenuRepository $menuRepository,
    ): Response {
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
            // Le fil d'ariane reprend l'intitule du menu, comme la page d'index.
            'section_title' => $menuRepository->findSystemByLocationAndKey('header', 'services')?->getName()
                ?? 'Services',
            'seo' => $this->seoService->resolve($service),
        ]);
    }
}
