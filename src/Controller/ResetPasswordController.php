<?php

namespace App\Controller;

use App\Entity\User;
use App\Form\PassType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bridge\Twig\Mime\TemplatedEmail;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Address;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Attribute\Route;
use SymfonyCasts\Bundle\ResetPassword\Controller\ResetPasswordControllerTrait;
use SymfonyCasts\Bundle\ResetPassword\Exception\ResetPasswordExceptionInterface;
use SymfonyCasts\Bundle\ResetPassword\ResetPasswordHelperInterface;

#[Route('/reset-password')]
class ResetPasswordController extends AbstractController
{
    use ResetPasswordControllerTrait;

    public function __construct(
        private readonly ResetPasswordHelperInterface $resetPasswordHelper,
        private readonly EntityManagerInterface $em,
    ) {
    }

    #[Route('', name: 'app_forgot_password_request')]
    public function request(Request $request, MailerInterface $mailer): Response
    {
        if ($request->isMethod('POST')) {
            $email = $request->request->get('email', '');
            $user = $this->em->getRepository(User::class)->findOneBy(['email' => $email]);

            // Always redirect to check-email to avoid user enumeration
            if ($user) {
                try {
                    $resetToken = $this->resetPasswordHelper->generateResetToken($user);

                    $emailMessage = (new TemplatedEmail())
                        ->from(new Address('noreply@blogweb.fr', 'Blog & Web'))
                        ->to($user->getEmail())
                        ->subject('Réinitialisation de votre mot de passe')
                        ->htmlTemplate('reset_password/email.html.twig')
                        ->context([
                            'resetToken' => $resetToken,
                        ]);

                    $mailer->send($emailMessage);

                    $this->setTokenObjectInSession($resetToken);
                } catch (ResetPasswordExceptionInterface) {
                    // Silent fail to avoid user enumeration
                }
            }

            return $this->redirectToRoute('app_check_email');
        }

        return $this->render('reset_password/request.html.twig');
    }

    #[Route('/check-email', name: 'app_check_email')]
    public function checkEmail(): Response
    {
        $resetToken = $this->getTokenObjectFromSession();
        $tokenLifetime = $resetToken ? $this->resetPasswordHelper->getTokenLifetime() : null;

        return $this->render('reset_password/check_email.html.twig', [
            'tokenLifetime' => $tokenLifetime,
        ]);
    }

    #[Route('/reset/{token}', name: 'app_reset_password')]
    public function reset(
        Request $request,
        UserPasswordHasherInterface $hasher,
        ?string $token = null,
    ): Response {
        if ($token) {
            $this->storeTokenInSession($token);
            return $this->redirectToRoute('app_reset_password');
        }

        $token = $this->getTokenFromSession();
        if (!$token) {
            throw $this->createNotFoundException('No reset password token found.');
        }

        try {
            /** @var User $user */
            $user = $this->resetPasswordHelper->validateTokenAndFetchUser($token);
        } catch (ResetPasswordExceptionInterface) {
            $this->addFlash('danger', 'Le lien de réinitialisation est invalide ou a expiré. Veuillez réessayer.');
            return $this->redirectToRoute('app_forgot_password_request');
        }

        $form = $this->createForm(PassType::class, $user);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->resetPasswordHelper->removeResetRequest($token);

            $user->setPassword($hasher->hashPassword($user, $form->get('password')->getData()));
            $this->em->flush();

            $this->cleanSessionAfterReset();

            $this->addFlash('success', 'Votre mot de passe a été réinitialisé. Vous pouvez vous connecter.');
            return $this->redirectToRoute('app_login');
        }

        return $this->render('reset_password/reset.html.twig', [
            'form' => $form,
        ]);
    }
}
