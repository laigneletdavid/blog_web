<?php

namespace App\Controller;

use App\Entity\User;
use App\Form\RegistrationFormType;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Email;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Attribute\Route;
use SymfonyCasts\Bundle\VerifyEmail\VerifyEmailHelperInterface;

class RegistrationController extends AbstractController
{
    #[Route('/register', name: 'app_register')]
    public function register(
        Request $request,
        UserPasswordHasherInterface $userPasswordHasher,
        EntityManagerInterface $entityManager,
        VerifyEmailHelperInterface $verifyEmailHelper,
        MailerInterface $mailer,
        SiteContext $siteContext,
    ): Response {
        $user = new User();
        $form = $this->createForm(RegistrationFormType::class, $user);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $user->setPassword(
                $userPasswordHasher->hashPassword(
                    $user,
                    $form->get('plainPassword')->getData()
                )
            );

            $entityManager->persist($user);
            $entityManager->flush();

            $signatureComponents = $verifyEmailHelper->generateSignature(
                'app_verify_email',
                (string) $user->getId(),
                $user->getEmail(),
                ['id' => $user->getId()],
            );

            $site = $siteContext->getCurrentSite();
            $siteName = $site?->getName() ?? 'Blog & Web';
            $siteEmail = $site?->getEmail() ?? 'noreply@blogweb.fr';

            $email = (new Email())
                ->from($siteEmail)
                ->to($user->getEmail())
                ->subject("{$siteName} — Confirmez votre adresse email")
                ->html(sprintf(
                    '<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                        <h2 style="color: #2563EB;">%s</h2>
                        <p>Bonjour,</p>
                        <p>Merci pour votre inscription. Veuillez confirmer votre adresse email en cliquant sur le lien ci-dessous :</p>
                        <p><a href="%s" style="display: inline-block; padding: 12px 24px; background: #2563EB; color: #fff; text-decoration: none; border-radius: 6px;">Confirmer mon email</a></p>
                        <p style="font-size: 0.9em; color: #666;">Ce lien expire dans 1 heure.</p>
                    </div>',
                    htmlspecialchars($siteName, ENT_QUOTES, 'UTF-8'),
                    $signatureComponents->getSignedUrl(),
                ));

            $mailer->send($email);

            $this->addFlash(
                'success',
                'Votre compte a été créé. Un email de confirmation vous a été envoyé.'
            );

            return $this->redirectToRoute('app_login');
        }

        return $this->render('registration/register.html.twig', [
            'registrationForm' => $form->createView(),
        ]);
    }
}
