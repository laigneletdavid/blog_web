<?php

namespace App\Security;

use App\Entity\User;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\Security\Core\Exception\CustomUserMessageAuthenticationException;
use Symfony\Component\Security\Http\Authenticator\Passport\Badge\UserBadge;
use Symfony\Component\Security\Http\Event\CheckPassportEvent;

/**
 * Blocks login for users who have not verified their email address.
 * ROLE_ADMIN, ROLE_FREELANCE, ROLE_SUPER_ADMIN are exempt (created via CLI).
 */
class CheckVerifiedUserSubscriber implements EventSubscriberInterface
{
    private const EXEMPT_ROLES = ['ROLE_ADMIN', 'ROLE_FREELANCE', 'ROLE_SUPER_ADMIN'];

    public static function getSubscribedEvents(): array
    {
        return [
            CheckPassportEvent::class => ['onCheckPassport', -10],
        ];
    }

    public function onCheckPassport(CheckPassportEvent $event): void
    {
        $passport = $event->getPassport();

        $badge = $passport->getBadge(UserBadge::class);
        if (!$badge instanceof UserBadge) {
            return;
        }

        $user = $badge->getUser();
        if (!$user instanceof User) {
            return;
        }

        if ($user->isVerified()) {
            return;
        }

        // Exempt admin roles (created via CLI, no email verification needed)
        foreach ($user->getRoles() as $role) {
            if (in_array($role, self::EXEMPT_ROLES, true)) {
                return;
            }
        }

        throw new CustomUserMessageAuthenticationException(
            'Veuillez confirmer votre adresse email avant de vous connecter. Consultez votre boite de reception.'
        );
    }
}
