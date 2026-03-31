<?php

namespace App\Service;

use App\Entity\Article;
use App\Repository\SubscriberRepository;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Email;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

/**
 * Envoie un email de notification aux abonnes
 * quand un nouvel article est publie.
 */
class ArticleNotificationService
{
    public function __construct(
        private readonly MailerInterface $mailer,
        private readonly SubscriberRepository $subscriberRepository,
        private readonly SiteContext $siteContext,
        private readonly UrlGeneratorInterface $urlGenerator,
    ) {
    }

    /**
     * Notifie les subscribers actifs abonnes aux articles.
     */
    public function notifySubscribers(Article $article): void
    {
        $subscribers = $this->subscriberRepository->findActiveArticleSubscribers();

        if (empty($subscribers)) {
            return;
        }

        $site = $this->siteContext->getCurrentSite();
        $siteName = $site?->getName() ?? 'Blog & Web';
        $siteEmail = $site?->getEmail() ?? 'noreply@blogweb.fr';

        foreach ($subscribers as $subscriber) {
            $email = $subscriber->getEmail();

            $unsubscribeUrl = $this->urlGenerator->generate('app_unsubscribe', [
                'token' => $subscriber->getToken(),
            ], UrlGeneratorInterface::ABSOLUTE_URL);

            $manageUrl = $this->urlGenerator->generate('app_subscribe_manage', [
                'token' => $subscriber->getToken(),
            ], UrlGeneratorInterface::ABSOLUTE_URL);

            $message = (new Email())
                ->from($siteEmail)
                ->to($email)
                ->subject("{$siteName} — Nouvel article : {$article->getTitle()}")
                ->html($this->buildEmailBody($article, $siteName, $unsubscribeUrl, $manageUrl));

            $this->mailer->send($message);
        }
    }

    private function buildEmailBody(
        Article $article,
        string $siteName,
        string $unsubscribeUrl,
        string $manageUrl,
    ): string {
        $title = htmlspecialchars($article->getTitle(), ENT_QUOTES, 'UTF-8');
        $excerpt = htmlspecialchars($article->getFeaturedText() ?? '', ENT_QUOTES, 'UTF-8');

        return <<<HTML
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #0455C0;">{$siteName}</h2>
            <p>Bonjour,</p>
            <p>Un nouvel article vient d'etre publie :</p>
            <h3>{$title}</h3>
            <p>{$excerpt}</p>
            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
            <p style="font-size: 0.85em; color: #999; text-align: center;">
                <a href="{$manageUrl}" style="color: #0455C0;">Gerer mes preferences</a>
                &nbsp;|&nbsp;
                <a href="{$unsubscribeUrl}" style="color: #999;">Se desabonner</a>
            </p>
        </div>
        HTML;
    }
}
