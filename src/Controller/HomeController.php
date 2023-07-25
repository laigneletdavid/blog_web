<?php

namespace App\Controller;

use App\Form\FindUserType;
use App\Repository\ArticleRepository;
use App\Repository\MenuRepository;
use App\Repository\UserRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class HomeController extends AbstractController
{
    #[Route('/', name: 'app_home')]
    public function index(ArticleRepository $articleRepository): Response
    {

        return $this->render('home/index.html.twig', [
            'title_page' => 'Feet Trip',
            'text_page' => 'Un nouveau monde s\'ouvre à vous !',
            'articles' => $articleRepository->homeArticles(),
        ]);

    }

    #[Route('/contact', name: 'app_contact')]
    public function contact(): Response
    {
        return $this->render('home/contact.html.twig', [
            'title_page' => 'Contact',
            'text_page' => 'Envoyez-moi un message',
        ]);
    }

    #[Route('/find', name: 'app_home_find', methods: ['GET', 'POST'])]
    public function find(Request $request, UserRepository $userRepository): Response
    {
        $email = null;
        $user = null;
        $form = $this->createForm(FindUserType::class);
        $catch = $form->handleRequest($request);

        // Je dois ici aller voir si l'email existe dans la base, s'il existe je renvoie vers le formulaire de password sinon je reste là avec message d'erreur
        if ($form->isSubmitted() && $form->isValid()) {

            $email = $catch->getData()['email'];
            $user = $userRepository->findOneBy( ['email' => $email,]);
            if ($user !== null){

                return $this->redirectToRoute('app_user_edit_pass', ['id' => $user->getId()], Response::HTTP_SEE_OTHER);
            }
            else {
                $this->addFlash(
                    'warning',
                    'Nous ne trouvons pas votre adresse e-mail, veuillez recommencer ou créer un compte.'
                );
            }
        }

        return $this->render('user/find.html.twig', [
            'form' => $form->createView(),
        ]);
    }
}
