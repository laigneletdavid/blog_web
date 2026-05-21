<?php

namespace App\Controller\Admin;

use App\Service\StatService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Dompdf\Dompdf;
use Dompdf\Options;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\StreamedResponse;
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

    #[Route('/export/conversions', name: 'admin_stats_export_conversions')]
    public function exportConversions(Request $request): StreamedResponse
    {
        $period = $request->query->getString('period', '30d');
        $rows = $this->statService->exportConversions($period);

        $response = new StreamedResponse(function () use ($rows) {
            $handle = fopen('php://output', 'w');
            // BOM UTF-8 pour Excel
            fwrite($handle, "\xEF\xBB\xBF");
            fputcsv($handle, ['Date', 'Type', 'Page', 'Source', 'Detail'], ';');

            foreach ($rows as $row) {
                fputcsv($handle, [
                    $row['date'],
                    $row['type'],
                    $row['page_url'],
                    $row['source'] ?? 'direct',
                    $row['detail'] ?? '',
                ], ';');
            }

            fclose($handle);
        });

        $filename = 'conversions_' . date('Y-m-d') . '.csv';
        $response->headers->set('Content-Type', 'text/csv; charset=UTF-8');
        $response->headers->set('Content-Disposition', "attachment; filename=\"{$filename}\"");

        return $response;
    }

    #[Route('/export/conversions.pdf', name: 'admin_stats_export_conversions_pdf')]
    public function exportConversionsPdf(Request $request): Response
    {
        $period = $request->query->getString('period', '30d');

        $periodLabels = [
            'today' => "Aujourd'hui",
            '7d' => '7 derniers jours',
            '30d' => '30 derniers jours',
        ];

        $html = $this->renderView('admin/stats/export_conversions_pdf.html.twig', [
            'periodLabel' => $periodLabels[$period] ?? $period,
            'counts' => $this->statService->conversionCounts($period),
            'funnel' => $this->statService->conversionFunnel($period),
            'pages' => $this->statService->conversionPages($period),
            'rows' => $this->statService->exportConversions($period),
        ]);

        $options = new Options();
        $options->set('isRemoteEnabled', false);
        $options->set('defaultFont', 'DejaVu Sans');

        $dompdf = new Dompdf($options);
        $dompdf->loadHtml($html);
        $dompdf->setPaper('A4', 'portrait');
        $dompdf->render();

        $filename = 'conversions_' . date('Y-m-d') . '.pdf';

        return new Response($dompdf->output(), 200, [
            'Content-Type' => 'application/pdf',
            'Content-Disposition' => "attachment; filename=\"{$filename}\"",
        ]);
    }
}
