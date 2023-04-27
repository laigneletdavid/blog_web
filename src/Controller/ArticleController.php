<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;


#[Route('/article', name: 'app_article_')]
class ArticleController extends AbstractController
{
    #[Route('/', name: 'show_all')]
    public function showAll(): Response
    {
        return $this->render('article/show_all.html.twig', [
            'title_page' => 'ShowAll',
            'text_page' => 'TextPage',
        ]);
    }

    #[Route('/{slug}', name: 'show')]
    public function show(): Response
    {
        return $this->render('article/show.html.twig', [
            'title_page' => 'ShowArticle',
            'text_page' => 'TextPage',
        ]);
    }
}
