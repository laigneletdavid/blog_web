<?php

namespace App\Controller;

use App\Repository\EventRepository;
use App\Service\SeoService;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class EventController extends AbstractController
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/evenements', name: 'app_event_index')]
    public function index(Request $request, EventRepository $eventRepository): Response
    {
        if (!$this->siteContext->hasModule('events')) {
            throw $this->createNotFoundException();
        }

        $upcoming = $eventRepository->findUpcoming(50);

        // Pagination événements passés
        $page = max(1, $request->query->getInt('page', 1));
        $limit = 6;
        $offset = ($page - 1) * $limit;
        $pastEvents = $eventRepository->findPast($limit, $offset);
        $totalPast = $eventRepository->countPast();
        $totalPages = (int) ceil($totalPast / $limit);

        return $this->render('event/index.html.twig', [
            'title_page' => 'Événements',
            'upcoming' => $upcoming,
            'pastEvents' => $pastEvents,
            'currentPage' => $page,
            'totalPages' => $totalPages,
            'seo' => $this->seoService->resolveForPage('Événements'),
        ]);
    }

    #[Route('/evenement/{slug}', name: 'app_event_show')]
    public function show(string $slug, EventRepository $eventRepository): Response
    {
        if (!$this->siteContext->hasModule('events')) {
            throw $this->createNotFoundException();
        }

        $event = $eventRepository->findOneActiveBySlug($slug);
        if (!$event) {
            throw $this->createNotFoundException('Événement introuvable.');
        }

        return $this->render('event/show.html.twig', [
            'title_page' => $event->getTitle(),
            'event' => $event,
            'seo' => $this->seoService->resolve($event),
        ]);
    }
}
