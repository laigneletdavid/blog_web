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

        $services = $serviceRepository->findRootsActive();

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

        // Page détail uniquement si le service a du contenu : blocs TipTap, ou
        // HTML seul quand le texte a été écrit en SQL (comme pour Page)
        if (!$service->hasDetail()) {
            return $this->redirectToRoute('app_service_index');
        }

        // Fil d'ariane : la rubrique du menu qui contient la fiche (« Le Web »),
        // sinon l'index des services. Une rubrique sans page (« # ») est citee
        // sans lien, et le JSON-LD la saute (Google veut une URL par niveau).
        $sectionTitle = $menuRepository->findSystemByLocationAndKey('header', 'services')?->getName() ?? 'Services';
        $sectionUrl = $this->generateUrl('app_service_index');
        $entree = $menuRepository->findOneBy(['service' => $service, 'location' => 'header']);
        if ($entree?->getParent() !== null) {
            $rubrique = $entree->getParent();
            $sectionTitle = $rubrique->getName();
            $sectionUrl = match (true) {
                $rubrique->getPage()?->getSlug() !== null => $this->generateUrl('app_page_show', ['slug' => $rubrique->getPage()->getSlug()]),
                $rubrique->getTarget() === 'url' && !in_array($rubrique->getUrl(), [null, '', '#'], true) => $rubrique->getUrl(),
                default => null,
            };
        }

        return $this->render('service/show.html.twig', [
            'title_page' => $service->getTitle(),
            'service' => $service,
            // Arborescence exposee au template : le rendu commun l'ignore, une
            // surcouche peut s'en servir pour un sommaire ou un fil d'ariane
            // a trois niveaux. Vide sur un site dont l'offre est a plat.
            'children' => $service->getChildren(),
            'parent' => $service->getParent(),
            'section_title' => $sectionTitle,
            'section_url' => $sectionUrl,
            'seo' => $this->seoService->resolve($service),
        ]);
    }
}
