<?php

namespace App\Controller;

use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

/**
 * /blog et /blog/ : 301 vers la liste des articles (/article/).
 *
 * Adresse que les visiteurs et Google essaient d'eux-memes ; sans route, elle
 * finissait en 404 (constate dans la Search Console de comwebsolutions.fr).
 * Une seule redirection, avec ou sans barre finale, query string conservee.
 * Sans module blog, la page n'existe pas : 404.
 */
class BlogRedirectController extends AbstractController
{
    public function __construct(
        private readonly SiteContext $siteContext,
    ) {
    }

    #[Route('/blog{barre}', name: 'app_blog_redirect', requirements: ['barre' => '/?'], defaults: ['barre' => ''], methods: ['GET', 'HEAD'])]
    public function __invoke(Request $request): RedirectResponse
    {
        if (!$this->siteContext->hasModule('blog')) {
            throw $this->createNotFoundException();
        }

        $cible = $this->generateUrl('app_article_show_all');
        $query = $request->getQueryString();

        return $this->redirect($query ? $cible . '?' . $query : $cible, Response::HTTP_MOVED_PERMANENTLY);
    }
}
