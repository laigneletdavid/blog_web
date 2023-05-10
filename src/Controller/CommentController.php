<?php

namespace App\Controller;

use App\Entity\Comment;
use App\Form\Type\CommentType;
use App\Repository\ArticleRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class CommentController extends AbstractController
{
    #[Route('/comment', name: 'app_comment')]
    public function addComment(Request $request,  EntityManagerInterface $em,  ArticleRepository $articleRepository): Response
    {


        return $this->render('comment/index.html.twig', [
            'controller_name' => 'CommentController',
        ]);
    }
}
