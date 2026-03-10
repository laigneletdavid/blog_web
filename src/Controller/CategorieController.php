<?php

namespace App\Controller;

use App\Entity\Categorie;
use App\Repository\CategorieRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/categorie', name: 'app_categorie_')]
class CategorieController extends AbstractController
{
    #[Route('/{slug}', name: 'show')]
    public function show(?Categorie $categorie, CategorieRepository $categorieRepository): Response
    {
        if (!$categorie) {
            throw $this->createNotFoundException('Catégorie introuvable.');
        }

        return $this->render('categorie/show.html.twig', [
            'categorie' => $categorie,
            'articles' => $categorie->getArticles()->toArray(),
            'categories' => $categorieRepository->findAll(),
            'title_page' => $categorie->getName(),
        ]);
    }
}
