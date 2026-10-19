<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Redirections propres a l'etude.
 *
 * Le CMS publie une page d'index de l'offre. La maquette n'en a pas : son
 * menu « Expertises » mene a la galerie de l'accueil, et les fils d'Ariane
 * remontent au pole, jamais a un sommaire. La page restait donc en ligne
 * sans qu'aucun lien n'y mene, avec le contenu de demonstration du CMS.
 *
 * On la renvoie vers la galerie. La route porte une priorite superieure a
 * celle du CMS pour passer devant sans rien modifier sur main : les autres
 * clients gardent leur index.
 */
class RedirectionController extends AbstractController
{
    #[Route('/services', name: 'app_bm_expertises', priority: 10)]
    public function expertises(): RedirectResponse
    {
        // Redirection temporaire tant que le site se construit : elle reste
        // reversible d'un rechargement. A passer en 301 a la mise en ligne
        // si l'adresse doit disparaitre pour de bon.
        return $this->redirect($this->generateUrl('app_home') . '#expertises');
    }
}
