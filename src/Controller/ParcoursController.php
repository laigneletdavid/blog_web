<?php

namespace App\Controller;

use App\Service\SeoService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Pages de parcours de l'etude.
 *
 * Elles partent du besoin plutot que de la branche du droit : un visiteur qui
 * veut vendre une maison n'a pas a savoir que cela releve du droit immobilier.
 * Leur mise en page vient du lot livre, elles sont donc servies par des
 * gabarits et non par le contenu editorial.
 */
class ParcoursController extends AbstractController
{
    public function __construct(
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/votre-projet', name: 'app_votre_projet')]
    public function votreProjet(): Response
    {
        return $this->render('parcours/votre-projet.html.twig', [
            'title_page' => 'Votre projet',
            'seo' => $this->seoService->resolveForPage('Votre projet'),
        ]);
    }
}
