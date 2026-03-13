<?php

namespace App\Controller;

use App\Form\Type\ContactType;
use App\Repository\ArticleRepository;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Email;
use Symfony\Component\Routing\Attribute\Route;

class HomeController extends AbstractController
{
    #[Route('/', name: 'app_home')]
    public function index(ArticleRepository $articleRepository): Response
    {
        return $this->render('home/index.html.twig', [
            'title_page' => 'Blog & Web',
            'text_page' => 'Un CMS proche de vous !',
            'articles' => $articleRepository->homeArticles(),
        ]);
    }

    #[Route('/contact', name: 'app_contact')]
    public function contact(Request $request, MailerInterface $mailer, SiteContext $siteContext): Response
    {
        $form = $this->createForm(ContactType::class);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $data = $form->getData();

            $site = $siteContext->getCurrentSite();
            $recipientEmail = $site?->getEmail() ?? 'contact@blogweb.fr';
            $siteName = $site?->getName() ?? 'Blog & Web';

            $email = (new Email())
                ->from('noreply@blogweb.fr')
                ->replyTo($data['email'])
                ->to($recipientEmail)
                ->subject("[{$siteName}] Contact : {$data['subject']}")
                ->html(sprintf(
                    '<p><strong>De :</strong> %s %s (%s)</p><p><strong>Sujet :</strong> %s</p><hr><p>%s</p>',
                    htmlspecialchars($data['firstname'], ENT_QUOTES, 'UTF-8'),
                    htmlspecialchars($data['name'], ENT_QUOTES, 'UTF-8'),
                    htmlspecialchars($data['email'], ENT_QUOTES, 'UTF-8'),
                    htmlspecialchars($data['subject'], ENT_QUOTES, 'UTF-8'),
                    nl2br(htmlspecialchars($data['message'], ENT_QUOTES, 'UTF-8'))
                ));

            $mailer->send($email);

            $this->addFlash('success', 'Votre message a bien été envoyé. Nous vous répondrons dans les plus brefs délais.');

            return $this->redirectToRoute('app_contact');
        }

        return $this->render('home/contact.html.twig', [
            'title_page' => 'Formulaire de contact',
            'text_page' => 'Envoyez-moi un message',
            'contactForm' => $form,
        ]);
    }
}
