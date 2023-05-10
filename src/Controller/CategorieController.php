<?php

namespace App\Controller;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

#[Route('/categorie', name: 'app_categorie_')]
class CategorieController extends AbstractController
{
    #[Route('/{slug}', name: 'show')]
    public function show(?Categorie $categorie, CategorieRepository $categorieRepository, ArticleRepository $articleRepository): Response
    {

        //  dd($articleRepository->lastArticle()['0']);
        if (!$categorie) {
            return $this->redirectToRoute('app_home');
        }

        return $this->render('categorie/show.html.twig', [
            'categorie' => $categorie,
            'categories' => $categorieRepository->findAll(),
            'title_page' => 'Catégories',
            'widget_article' => $articleRepository->lastArticle()['0'],
        ]);
    }
}
