<?php

namespace App\Service;

use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Address;
use Symfony\Component\Mime\Email;

class SystemMailerService
{
    public function __construct(
        private readonly MailerInterface $mailer,
        private readonly SiteContext $siteContext,
        private readonly string $senderEmail = 'noreply@comwebsolutions.fr',
        private readonly string $senderName = 'ComWeb Solutions',
    ) {
    }

    public function createEmail(string $subject): Email
    {
        $site = $this->siteContext->getCurrentSite();
        $siteName = $site?->getName() ?? $this->senderName;
        $replyTo = $site?->getEmail();

        $email = (new Email())
            ->from(new Address($this->senderEmail, $siteName))
            ->subject($subject);

        if ($replyTo) {
            $email->replyTo($replyTo);
        }

        return $email;
    }

    public function send(Email $email): void
    {
        $this->mailer->send($email);
    }

    public function getSiteName(): string
    {
        return $this->siteContext->getCurrentSite()?->getName() ?? $this->senderName;
    }

    public function getSiteEmail(): ?string
    {
        return $this->siteContext->getCurrentSite()?->getEmail();
    }
}
