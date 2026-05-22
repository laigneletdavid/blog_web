<?php

namespace App\Controller\Api;

use App\Entity\PageView;
use App\Entity\StatConversion;
use App\Repository\StatSessionRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/api/stat')]
class StatApiController extends AbstractController
{
    private const ALLOWED_CONVERSION_TYPES = ['phone_click', 'email_click'];

    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly StatSessionRepository $sessionRepository,
    ) {
    }

    /**
     * Heartbeat : met a jour duration_seconds + ended_at de la session.
     * Appele toutes les 15s par stat-tracker.js via sendBeacon.
     */
    #[Route('/ping', name: 'api_stat_ping', methods: ['POST'])]
    public function ping(Request $request): Response
    {
        $data = $this->decodePayload($request);
        if (!$data) {
            return new Response('', 204);
        }

        $session = $this->findSession($data['token'] ?? '');
        if (!$session) {
            return new Response('', 204);
        }

        $duration = (int) ($data['duration'] ?? 0);
        if ($duration < 0 || $duration > 3600) {
            return new Response('', 204);
        }

        // Trouver la derniere page_view de cette session
        $pageView = $this->em->getRepository(PageView::class)->findOneBy(
            ['session' => $session],
            ['id' => 'DESC'],
        );

        if ($pageView) {
            $pageView->setDurationSeconds($duration);
        }

        $session->setEndedAt(new \DateTimeImmutable());
        $this->em->flush();

        return new Response('', 204);
    }

    /**
     * Scroll : met a jour scroll_max_pct sur la page_view courante.
     * Appele au beforeunload par stat-tracker.js via sendBeacon.
     */
    #[Route('/scroll', name: 'api_stat_scroll', methods: ['POST'])]
    public function scroll(Request $request): Response
    {
        $data = $this->decodePayload($request);
        if (!$data) {
            return new Response('', 204);
        }

        $session = $this->findSession($data['token'] ?? '');
        if (!$session) {
            return new Response('', 204);
        }

        $scrollPct = (int) ($data['scrollPct'] ?? 0);
        if ($scrollPct < 0 || $scrollPct > 100) {
            return new Response('', 204);
        }

        $pageView = $this->em->getRepository(PageView::class)->findOneBy(
            ['session' => $session],
            ['id' => 'DESC'],
        );

        if ($pageView) {
            // Garder le max entre l'existant et la nouvelle valeur
            $current = $pageView->getScrollMaxPct() ?? 0;
            $pageView->setScrollMaxPct(max($current, $scrollPct));
        }

        $this->em->flush();

        return new Response('', 204);
    }

    /**
     * Conversion : enregistre un clic tel: ou mailto:.
     * Appele par stat-tracker.js au click sur les liens concernes.
     */
    #[Route('/conversion', name: 'api_stat_conversion', methods: ['POST'])]
    public function conversion(Request $request): Response
    {
        $data = $this->decodePayload($request);
        if (!$data) {
            return new Response('', 204);
        }

        $session = $this->findSession($data['token'] ?? '');

        $type = $data['type'] ?? '';
        if (!in_array($type, self::ALLOWED_CONVERSION_TYPES, true)) {
            return new Response('', 204);
        }

        $pageUrl = mb_substr($data['pageUrl'] ?? '/', 0, 500);

        $conversion = new StatConversion();
        $conversion->setSession($session);
        $conversion->setType($type);
        $conversion->setPageUrl($pageUrl);

        $this->em->persist($conversion);
        $this->em->flush();

        return new Response('', 204);
    }

    private function decodePayload(Request $request): ?array
    {
        $content = $request->getContent();
        if (!$content) {
            return null;
        }

        try {
            $data = json_decode($content, true, 8, JSON_THROW_ON_ERROR);
        } catch (\JsonException) {
            return null;
        }

        return is_array($data) ? $data : null;
    }

    private function findSession(string $token): ?\App\Entity\StatSession
    {
        if (!$token || strlen($token) !== 64) {
            return null;
        }

        return $this->sessionRepository->findOneBy(['sessionToken' => $token]);
    }
}
