<?php

namespace App\Controller;

use Doctrine\DBAL\Connection;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class HealthController extends AbstractController
{
    #[Route('/healthz', name: 'app_health')]
    public function __invoke(Connection $connection): JsonResponse
    {
        $status = ['status' => 'ok'];
        $httpCode = Response::HTTP_OK;

        // Database check
        try {
            $connection->executeQuery('SELECT 1');
            $status['db'] = 'ok';
        } catch (\Throwable) {
            $status['db'] = 'error';
            $status['status'] = 'degraded';
            $httpCode = Response::HTTP_SERVICE_UNAVAILABLE;
        }

        // Disk check
        $freeSpace = @disk_free_space('/var/www/html');
        if ($freeSpace !== false && $freeSpace > 100 * 1024 * 1024) { // > 100MB
            $status['disk'] = 'ok';
        } else {
            $status['disk'] = 'low';
            $status['status'] = 'degraded';
            $httpCode = Response::HTTP_SERVICE_UNAVAILABLE;
        }

        return new JsonResponse($status, $httpCode);
    }
}
