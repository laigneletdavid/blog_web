<?php

namespace App\Controller\Admin;

use App\Service\StatService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[Route('/admin/stats')]
#[IsGranted('ROLE_ADMIN')]
class StatController extends AbstractController
{
    public function __construct(
        private readonly StatService $statService,
    ) {
    }

    #[Route('', name: 'admin_stats_index')]
    public function index(Request $request): Response
    {
        $period = $request->query->getString('period', '30d');

        return $this->render('admin/stats/index.html.twig', [
            'period' => $period,
            'behavior' => $this->statService->behaviorKpi($period),
            'sources' => $this->statService->sourceBreakdown($period),
            'funnel' => $this->statService->conversionFunnel($period),
            'conversions' => $this->statService->conversionCounts($period),
            'topPages' => $this->statService->topPagesEnriched($period, 10),
        ]);
    }

    #[Route('/acquisition', name: 'admin_stats_acquisition')]
    public function acquisition(Request $request): Response
    {
        $period = $request->query->getString('period', '30d');

        return $this->render('admin/stats/acquisition.html.twig', [
            'period' => $period,
            'sources' => $this->statService->sourceBreakdown($period),
            'landingPages' => $this->statService->topLandingPages($period),
        ]);
    }

    #[Route('/comportement', name: 'admin_stats_comportement')]
    public function comportement(Request $request): Response
    {
        $period = $request->query->getString('period', '30d');
        $metric = $request->query->getString('metric', 'duration');

        return $this->render('admin/stats/comportement.html.twig', [
            'period' => $period,
            'metric' => $metric,
            'behavior' => $this->statService->behaviorKpi($period),
            'timeline' => $this->statService->behaviorTimeline($metric),
            'topPages' => $this->statService->topPagesEnriched($period, 15),
        ]);
    }

    #[Route('/conversions', name: 'admin_stats_conversions')]
    public function conversions(Request $request): Response
    {
        $period = $request->query->getString('period', '30d');

        return $this->render('admin/stats/conversions.html.twig', [
            'period' => $period,
            'counts' => $this->statService->conversionCounts($period),
            'funnel' => $this->statService->conversionFunnel($period),
            'recent' => $this->statService->recentConversions(),
            'pages' => $this->statService->conversionPages($period),
        ]);
    }

    #[Route('/page', name: 'admin_stats_page_detail')]
    public function pageDetail(Request $request): Response
    {
        $url = $request->query->getString('url', '/');
        $period = $request->query->getString('period', '30d');

        return $this->render('admin/stats/page_detail.html.twig', [
            'url' => $url,
            'period' => $period,
            'flow' => $this->statService->pageFlow($url, $period),
        ]);
    }
}
