<?php

namespace App\Controller\Api;

use App\Service\VisitRecorder;
use App\Service\VisitTicket;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Cookie;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Confirmation d'une visite par le navigateur (stat-tracker.js, au chargement).
 *
 * Adresse volontairement neutre (« /api/vue ») : les bloqueurs de publicite
 * filtrent les URL contenant stat, track ou analytics, et les visiteurs qui
 * en utilisent un ne seraient plus comptes.
 */
class VisitApiController extends AbstractController
{
    public function __construct(
        private readonly VisitTicket $visitTicket,
        private readonly VisitRecorder $visitRecorder,
    ) {
    }

    #[Route('/api/vue', name: 'api_visit', methods: ['POST'])]
    public function visit(Request $request): Response
    {
        $response = new Response('', 204);

        if ($this->isGranted('ROLE_AUTHOR')) {
            return $response;
        }

        try {
            $data = json_decode($request->getContent(), true, 4, JSON_THROW_ON_ERROR);
        } catch (\JsonException) {
            return $response;
        }

        $path = is_array($data) ? $this->visitTicket->verify((string) ($data['ticket'] ?? '')) : null;
        if ($path === null) {
            return $response;
        }

        parse_str(ltrim((string) ($data['query'] ?? ''), '?'), $query);
        $utm = array_filter(
            array_intersect_key($query, array_flip(['utm_source', 'utm_medium', 'utm_campaign'])),
            'is_string',
        );

        $sessionToken = $this->visitRecorder->record(
            $path,
            $request->cookies->get(VisitRecorder::COOKIE_NAME),
            $request->headers->get('User-Agent') ? mb_substr($request->headers->get('User-Agent'), 0, 500) : null,
            $request->getClientIp() ?? '0.0.0.0',
            is_string($data['referrer'] ?? null) && $data['referrer'] !== '' ? $data['referrer'] : null,
            $utm,
            ($data['webdriver'] ?? false) === true,
        );

        if ($sessionToken !== null) {
            $response->headers->setCookie(
                Cookie::create(VisitRecorder::COOKIE_NAME)
                    ->withValue($sessionToken)
                    ->withExpires(time() + VisitRecorder::SESSION_TIMEOUT)
                    ->withPath('/')
                    ->withHttpOnly(false)
                    ->withSameSite('lax')
            );
        }

        return $response;
    }
}
