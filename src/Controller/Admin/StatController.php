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

    #[Route('/export/rapport.csv', name: 'admin_stats_export_csv')]
    public function exportCsv(Request $request): StreamedResponse
    {
        $period = $request->query->getString('period', '30d');
        $data = $this->statService->fullReportData($period);
        $periodLabel = $this->periodLabel($period);

        $response = new StreamedResponse(function () use ($data, $periodLabel) {
            $h = fopen('php://output', 'w');
            // BOM UTF-8 pour Excel
            fwrite($h, "\xEF\xBB\xBF");
            $sep = ';';

            // --- Vue d'ensemble ---
            fputcsv($h, ['=== VUE D\'ENSEMBLE (' . $periodLabel . ') ==='], $sep);
            fputcsv($h, ['Indicateur', 'Valeur'], $sep);
            $b = $data['behavior'];
            fputcsv($h, ['Duree moyenne (s)', $b['avg_duration'] ?? ''], $sep);
            fputcsv($h, ['Taux de rebond (%)', $b['bounce_rate'] ?? ''], $sep);
            fputcsv($h, ['Pages / session', $b['avg_depth'] ?? ''], $sep);
            fputcsv($h, ['Scroll moyen (%)', $b['avg_scroll'] ?? ''], $sep);
            fputcsv($h, [], $sep);

            // --- Entonnoir ---
            fputcsv($h, ['=== ENTONNOIR DE CONVERSION ==='], $sep);
            fputcsv($h, ['Etape', 'Nombre', 'Taux'], $sep);
            $f = $data['funnel'];
            fputcsv($h, ['Visiteurs uniques', $f['visitors'], '100%'], $sep);
            fputcsv($h, ['> 1 page visitee', $f['engaged'], $f['visitors'] > 0 ? round($f['engaged'] / $f['visitors'] * 100, 1) . '%' : '0%'], $sep);
            fputcsv($h, ['Vu page contact', $f['saw_contact'], $f['visitors'] > 0 ? round($f['saw_contact'] / $f['visitors'] * 100, 1) . '%' : '0%'], $sep);
            fputcsv($h, ['Conversions', $f['converted'], ($f['rate'] ?? 0) . '%'], $sep);
            fputcsv($h, [], $sep);

            // --- Sources ---
            fputcsv($h, ['=== ACQUISITION — SOURCES ==='], $sep);
            fputcsv($h, ['Source', 'Sessions', 'Part (%)'], $sep);
            $totalSrc = array_sum(array_column($data['sources'], 'cnt'));
            foreach ($data['sources'] as $s) {
                fputcsv($h, [
                    ucfirst(str_replace('_', ' ', $s['source'])),
                    $s['cnt'],
                    $totalSrc > 0 ? round($s['cnt'] / $totalSrc * 100, 1) : 0,
                ], $sep);
            }
            fputcsv($h, [], $sep);

            // --- Pages d'entree ---
            fputcsv($h, ['=== ACQUISITION — PAGES D\'ENTREE ==='], $sep);
            fputcsv($h, ['Page', 'Sessions'], $sep);
            foreach ($data['landingPages'] as $lp) {
                fputcsv($h, [$lp['landing_page'], $lp['cnt']], $sep);
            }
            fputcsv($h, [], $sep);

            // --- Comportement par page ---
            fputcsv($h, ['=== COMPORTEMENT — DETAIL PAR PAGE ==='], $sep);
            fputcsv($h, ['Page', 'Vues', 'Duree moy. (s)', 'Scroll (%)', 'Rebond (%)'], $sep);
            foreach ($data['topPages'] as $p) {
                fputcsv($h, [
                    $p['url'],
                    $p['views'],
                    $p['avg_duration'] ?? '',
                    $p['avg_scroll'] ?? '',
                    $p['bounce_rate'] ?? '',
                ], $sep);
            }
            fputcsv($h, [], $sep);

            // --- Pages de sortie ---
            fputcsv($h, ['=== COMPORTEMENT — PAGES DE SORTIE ==='], $sep);
            fputcsv($h, ['Page', 'Sorties', 'Taux sortie (%)'], $sep);
            foreach ($data['exitPages'] as $ep) {
                fputcsv($h, [$ep['exit_page'], $ep['exit_sessions'], $ep['exit_rate']], $sep);
            }
            fputcsv($h, [], $sep);

            // --- Conversions KPI ---
            fputcsv($h, ['=== CONVERSIONS — RESUME ==='], $sep);
            fputcsv($h, ['Type', 'Nombre'], $sep);
            $c = $data['counts'];
            fputcsv($h, ['Appels (tel)', $c['phone_click']], $sep);
            fputcsv($h, ['Emails (mailto)', $c['email_click']], $sep);
            fputcsv($h, ['Formulaires', $c['form_submit']], $sep);
            fputcsv($h, ['Total', $c['total']], $sep);
            fputcsv($h, [], $sep);

            // --- Pages qui convertissent ---
            fputcsv($h, ['=== CONVERSIONS — PAGES MOTEUR ==='], $sep);
            fputcsv($h, ['Page', 'Conversions'], $sep);
            foreach ($data['conversionPages'] as $cp) {
                fputcsv($h, [$cp['page_url'], $cp['cnt']], $sep);
            }
            fputcsv($h, [], $sep);

            // --- Detail conversions ---
            fputcsv($h, ['=== CONVERSIONS — DETAIL ==='], $sep);
            fputcsv($h, ['Date', 'Type', 'Page', 'Source', 'Detail'], $sep);
            foreach ($data['conversions'] as $row) {
                fputcsv($h, [
                    $row['date'],
                    $row['type'],
                    $row['page_url'],
                    $row['source'] ?? 'direct',
                    $row['detail'] ?? '',
                ], $sep);
            }

            fclose($h);
        });

        $filename = 'rapport_stats_' . date('Y-m-d') . '.csv';
        $response->headers->set('Content-Type', 'text/csv; charset=UTF-8');
        $response->headers->set('Content-Disposition', "attachment; filename=\"{$filename}\"");

        return $response;
    }

    #[Route('/export/rapport.pdf', name: 'admin_stats_export_pdf')]
    public function exportPdf(Request $request): Response
    {
        $period = $request->query->getString('period', '30d');
        $data = $this->statService->fullReportData($period);

        $html = $this->renderView('admin/stats/export_rapport_pdf.html.twig', [
            'periodLabel' => $this->periodLabel($period),
            'behavior' => $data['behavior'],
            'sources' => $data['sources'],
            'landingPages' => $data['landingPages'],
            'funnel' => $data['funnel'],
            'counts' => $data['counts'],
            'topPages' => $data['topPages'],
            'exitPages' => $data['exitPages'],
            'conversionPages' => $data['conversionPages'],
            'conversions' => $data['conversions'],
        ]);

        $options = new Options();
        $options->set('isRemoteEnabled', false);
        $options->set('defaultFont', 'DejaVu Sans');

        $dompdf = new Dompdf($options);
        $dompdf->loadHtml($html);
        $dompdf->setPaper('A4', 'portrait');
        $dompdf->render();

        $filename = 'rapport_stats_' . date('Y-m-d') . '.pdf';

        return new Response($dompdf->output(), 200, [
            'Content-Type' => 'application/pdf',
            'Content-Disposition' => "attachment; filename=\"{$filename}\"",
        ]);
    }

    private function periodLabel(string $period): string
    {
        return match ($period) {
            'today' => "Aujourd'hui",
            '7d' => '7 derniers jours',
            '30d' => '30 derniers jours',
            'month' => 'Ce mois',
            'quarter' => 'Ce trimestre',
            'year' => "Cette annee",
            default => $period,
        };
    }
}
