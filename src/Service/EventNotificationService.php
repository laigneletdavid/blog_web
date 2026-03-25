<?php

namespace App\Service;

use App\Entity\Event;
use App\Repository\UserRepository;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Email;

/**
 * Envoie un email de notification aux utilisateurs abonnés
 * quand un nouvel événement est créé ou activé.
 */
class EventNotificationService
{
    public function __construct(
        private readonly MailerInterface $mailer,
        private readonly UserRepository $userRepository,
        private readonly SiteContext $siteContext,
    ) {
    }

    /**
     * Notifie les utilisateurs abonnés (events = true) qu'un événement est disponible.
     */
    public function notifySubscribers(Event $event): void
    {
        $subscribers = $this->userRepository->findBy(['subscribeEvents' => true]);

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
                ->subject("{$siteName} — Nouvel événement : {$event->getTitle()}")
                ->html($this->buildEmailBody($event, $siteName, $user->getFirstName()));

            $this->mailer->send($message);
        }
    }

    private function buildEmailBody(Event $event, string $siteName, ?string $firstName): string
    {
        $greeting = $firstName ? "Bonjour {$firstName}," : 'Bonjour,';
        $title = htmlspecialchars($event->getTitle(), ENT_QUOTES, 'UTF-8');
        $description = htmlspecialchars($event->getShortDescription() ?? '', ENT_QUOTES, 'UTF-8');
        $date = $event->getDateStart()?->format('d/m/Y à H:i') ?? '';
        $location = htmlspecialchars($event->getLocation() ?? '', ENT_QUOTES, 'UTF-8');

        $locationLine = $location ? "<p><strong>Lieu :</strong> {$location}</p>" : '';

        return <<<HTML
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #0455C0;">{$siteName}</h2>
            <p>{$greeting}</p>
            <p>Un nouvel événement est prévu :</p>
            <h3>{$title}</h3>
            <p><strong>Date :</strong> {$date}</p>
            {$locationLine}
            <p>{$description}</p>
            <p style="margin-top: 20px; font-size: 0.9em; color: #666;">
                Vous recevez cet email car vous êtes abonné aux notifications d'événements.
                Vous pouvez modifier vos préférences depuis votre profil.
            </p>
        </div>
        HTML;
    }
}
