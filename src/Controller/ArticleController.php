<?php

namespace App\Controller;

use App\Entity\Article;
use App\Entity\Comment;
use App\Form\Type\CommentType;
use App\Repository\ArticleRepository;
use App\Repository\CategorieRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;



#[Route('/article', name: 'app_article_')]
class ArticleController extends AbstractController
{
    #[Route('/', name: 'show_all')]
    public function showAll(ArticleRepository $articleRepository, CategorieRepository $categorieRepository): Response
    {
        return $this->render('article/show_all.html.twig', [
            'title_page' => 'ShowAll',
            'text_page' => 'TextPage',
            'articles' => $articleRepository->findAllPublished(),
            'widget_article' => $articleRepository->lastArticle()['0'],
            'categories' => $categorieRepository->findAll(),
        ]);
    }

    #[Route('/{slug}', name: 'show')]
    public function show(?Article $article, ArticleRepository $articleRepository, CategorieRepository $categorieRepository, Request $request,  EntityManagerInterface $em): Response
    {


        $slug = $article->getSlug();

        if (!$article) {
            return $this->redirectToRoute('app_home');
        }

        $comment = new Comment($article);
        $comment->setCreatedAt(new \DateTime());
        $comment->setArticle($article);
        //$comment->setUser('1');

        $commentForm = $this->createForm(CommentType::class, $comment);
        $commentForm->handleRequest($request);

        if($commentForm->isSubmitted() && $commentForm->isValid()) {

            $em->persist($comment);
            $em->flush();
            return $this->redirectToRoute('app_article_show', [
                'slug' => $slug,
                ]);
        }

        return $this->renderForm('article/show.html.twig', [
            'title_page' => 'Article',
            'article' => $article,
            'widget_article' => $articleRepository->lastArticle()['0'],
            'categories' => $categorieRepository->findAll(),
            'commentForm' => $commentForm,
        ]);
    }
}
