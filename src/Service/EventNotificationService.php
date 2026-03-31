<?php

namespace App\Service;

use App\Entity\Event;
use App\Repository\SubscriberRepository;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Email;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

/**
 * Envoie un email de notification aux abonnes
 * quand un nouvel evenement est cree ou active.
 */
class EventNotificationService
{
    public function __construct(
        private readonly MailerInterface $mailer,
        private readonly SubscriberRepository $subscriberRepository,
        private readonly SiteContext $siteContext,
        private readonly UrlGeneratorInterface $urlGenerator,
    ) {
    }

    /**
     * Notifie les subscribers actifs abonnes aux evenements.
     */
    public function notifySubscribers(Event $event): void
    {
        $subscribers = $this->subscriberRepository->findActiveEventSubscribers();

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
                ->subject("{$siteName} — Nouvel evenement : {$event->getTitle()}")
                ->html($this->buildEmailBody($event, $siteName, $unsubscribeUrl, $manageUrl));

            $this->mailer->send($message);
        }
    }

    private function buildEmailBody(
        Event $event,
        string $siteName,
        string $unsubscribeUrl,
        string $manageUrl,
    ): string {
        $title = htmlspecialchars($event->getTitle(), ENT_QUOTES, 'UTF-8');
        $description = htmlspecialchars($event->getShortDescription() ?? '', ENT_QUOTES, 'UTF-8');
        $date = $event->getDateStart()?->format('d/m/Y a H:i') ?? '';
        $location = htmlspecialchars($event->getLocation() ?? '', ENT_QUOTES, 'UTF-8');

        $locationLine = $location ? "<p><strong>Lieu :</strong> {$location}</p>" : '';

        return <<<HTML
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #0455C0;">{$siteName}</h2>
            <p>Bonjour,</p>
            <p>Un nouvel evenement est prevu :</p>
            <h3>{$title}</h3>
            <p><strong>Date :</strong> {$date}</p>
            {$locationLine}
            <p>{$description}</p>
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
