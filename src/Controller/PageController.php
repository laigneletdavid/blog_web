<?php

namespace App\Controller;

use App\Entity\Page;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/page', name: 'app_page_')]
class PageController extends AbstractController
{
    #[Route('/{slug}', name: 'show')]
    public function show(?Page $page): Response
    {
        if (!$page) {
            throw $this->createNotFoundException('Page introuvable.');
        }

        return $this->render('page/show.html.twig', [
            'page' => $page,
            'title_page' => $page->getTitle() ?? 'Page',
            'text_page' => '',
        ]);
    }
}
