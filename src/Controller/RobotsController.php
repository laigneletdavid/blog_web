<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class RobotsController extends AbstractController
{
    #[Route('/robots.txt', name: 'app_robots')]
    public function index(): Response
    {
        $response = $this->render('robots/index.txt.twig');
        $response->headers->set('Content-Type', 'text/plain');

        return $response;
    }
}
