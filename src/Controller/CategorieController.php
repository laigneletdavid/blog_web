<?php

namespace App\Controller;

use App\Entity\Categorie;
use App\Repository\CategorieRepository;
use App\Service\SeoService;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/categorie', name: 'app_categorie_')]
class CategorieController extends AbstractController
{
    public function __construct(
        private readonly SeoService $seoService,
        private readonly SiteContext $siteContext,
    ) {
    }

    #[Route('/{slug}', name: 'show')]
    public function show(?Categorie $categorie, CategorieRepository $categorieRepository): Response
    {
        if (!$this->siteContext->hasModule('blog')) {
            throw $this->createNotFoundException();
        }

        if (!$categorie) {
            throw $this->createNotFoundException('Catégorie introuvable.');
        }

        return $this->render('categorie/show.html.twig', [
            'categorie' => $categorie,
            'articles' => $categorie->getArticles()->toArray(),
            'categories' => $categorieRepository->findAll(),
            'title_page' => $categorie->getName(),
            'seo' => $this->seoService->resolve($categorie),
        ]);
    }
}
