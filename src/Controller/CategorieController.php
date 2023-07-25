<?php

namespace App\Controller;


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
        if (!$categorie) {
            return $this->redirectToRoute('app_home');
        }
        $lastArticle = $articleRepository->lastArticle()['0'];
        $catLast = $lastArticle->getCategories()->toArray();
        $articles = $categorie->getArticles()->toArray();
        foreach ( $articles as $article) {
            $cat = $article->getCategories()->toArray();
        }

       return $this->render('categorie/show.html.twig', [
            'categorie' => $categorie,
            'articles' => $articles,
            'categories' => $categorieRepository->findAll(),
            'title_page' => 'Catégories',
        ]);
    }
}
