<?php

namespace App\Service;

use App\Entity\Article;
use App\Repository\UserRepository;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Email;

/**
 * Envoie un email de notification aux utilisateurs abonnés
 * quand un nouvel article est publié.
 */
class ArticleNotificationService
{
    public function __construct(
        private readonly MailerInterface $mailer,
        private readonly UserRepository $userRepository,
        private readonly SiteContext $siteContext,
    ) {
    }

    /**
     * Notifie les utilisateurs abonnés (articles = true) qu'un article vient d'être publié.
     */
    public function notifySubscribers(Article $article): void
    {
        $subscribers = $this->userRepository->findBy(['subscribeArticles' => true]);

        if (empty($subscribers)) {
            return;
        }

        $site = $this->siteContext->getCurrentSite();
        $siteName = $site?->getName() ?? 'Blog & Web';
        $siteEmail = $site?->getEmail() ?? 'noreply@blogweb.fr';

        foreach ($subscribers as $user) {
            $email = $user->getEmail();
            if (!$email) {
                continue;
            }

            $message = (new Email())
                ->from($siteEmail)
                ->to($email)
                ->subject("{$siteName} — Nouvel article : {$article->getTitle()}")
                ->html($this->buildEmailBody($article, $siteName, $user->getFirstName()));

            $this->mailer->send($message);
        }
    }

    private function buildEmailBody(Article $article, string $siteName, ?string $firstName): string
    {
        $greeting = $firstName ? "Bonjour {$firstName}," : 'Bonjour,';
        $title = htmlspecialchars($article->getTitle(), ENT_QUOTES, 'UTF-8');
        $excerpt = htmlspecialchars($article->getFeaturedText() ?? '', ENT_QUOTES, 'UTF-8');

        return <<<HTML
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #0455C0;">{$siteName}</h2>
            <p>{$greeting}</p>
            <p>Un nouvel article vient d'être publié :</p>
            <h3>{$title}</h3>
            <p>{$excerpt}</p>
            <p style="margin-top: 20px; font-size: 0.9em; color: #666;">
                Vous recevez cet email car vous êtes abonné aux notifications d'articles.
                Vous pouvez modifier vos préférences depuis votre profil.
            </p>
        </div>
        HTML;
    }
}
