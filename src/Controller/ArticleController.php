<?php

namespace App\Controller;

use App\Entity\Article;
use App\Entity\Comment;
use App\Form\Type\CommentType;
use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use App\Repository\PageViewRepository;
use App\Security\Voter\ContentVoter;
use App\Service\SeoService;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/article', name: 'app_article_')]
class ArticleController extends AbstractController
{
    use BlogListeTrait;

    public function __construct(
        private readonly SeoService $seoService,
        private readonly SiteContext $siteContext,
    ) {
    }

    #[Route('/', name: 'show_all')]
    public function showAll(Request $request, ArticleRepository $articleRepository, CategorieRepository $categorieRepository): Response
    {
        if (!$this->siteContext->hasModule('blog')) {
            throw $this->createNotFoundException();
        }

        $categorieSlug = $request->query->get('categorie');
        // Le filtre par categorie a son adresse propre : /categorie/{slug}.
        // L'ancienne forme ?categorie= y renvoie (sauf combinee a un mois).
        if ($categorieSlug && !$request->query->getInt('month')) {
            $categorie = $categorieRepository->findOneBy(['slug' => $categorieSlug]);
            if ($categorie !== null) {
                $params = ['slug' => $categorie->getSlug()];
                if ($request->query->getInt('page', 1) > 1) {
                    $params['page'] = $request->query->getInt('page');
                }

                return $this->redirectToRoute('app_categorie_show', $params, Response::HTTP_MOVED_PERMANENTLY);
            }
        }

        return $this->renderBlogListe($request, $articleRepository, $categorieRepository);
    }

    #[Route('/{slug}', name: 'show')]
    public function show(?Article $article, Request $request, EntityManagerInterface $em, ArticleRepository $articleRepository, PageViewRepository $pageViewRepository): Response
    {
        if (!$this->siteContext->hasModule('blog')) {
            throw $this->createNotFoundException();
        }

        if (!$article) {
            throw $this->createNotFoundException('Article introuvable.');
        }

        // Un brouillon n'est pas en ligne. Il reste ouvert a qui peut editer le
        // contenu, pour relire un article avant publication.
        if ($article->isPublished() !== true && !$this->isGranted('ROLE_AUTHOR')) {
            throw $this->createNotFoundException('Article introuvable.');
        }

        if (!$this->isGranted(ContentVoter::VIEW, $article)) {
            return $this->render('_partials/_restricted_access.html.twig', [
                'title' => $article->getTitle(),
                'visibility' => $article->getVisibility(),
                'seo' => $this->seoService->resolveForPage($article->getTitle()),
            ], new Response('', 403));
        }

        $commentForm = null;
        $user = $this->getUser();

        if ($user) {
            $comment = new Comment($article);
            $comment->setCreatedAt(new \DateTime());
            $comment->setUser($user);
            $commentForm = $this->createForm(CommentType::class, $comment);
            $commentForm->handleRequest($request);

            if ($commentForm->isSubmitted() && $commentForm->isValid()) {
                $em->persist($comment);
                $em->flush();

                $this->addFlash('success', 'Commentaire publie avec succes.');

                return $this->redirectToRoute('app_article_show', [
                    'slug' => $article->getSlug(),
                ]);
            }
        }

        // Articles connexes (meme categorie)
        $relatedArticles = $articleRepository->findRelated($article, 3);

        $viewCount = $pageViewRepository->countViewsByUrl('/article/' . $article->getSlug());

        return $this->render('article/show.html.twig', [
            'title_page' => 'Article',
            'article' => $article,
            'commentForm' => $commentForm,
            'relatedArticles' => $relatedArticles,
            'viewCount' => $viewCount,
            'seo' => $this->seoService->resolve($article),
        ]);
    }
}
