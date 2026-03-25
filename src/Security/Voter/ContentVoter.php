<?php

namespace App\Security\Voter;

use App\Entity\Article;
use App\Entity\Page;
use App\Enum\VisibilityEnum;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\Voter\Voter;
use Symfony\Component\Security\Core\Role\RoleHierarchyInterface;

class ContentVoter extends Voter
{
    public const VIEW = 'CONTENT_VIEW';

    public function __construct(
        private readonly RoleHierarchyInterface $roleHierarchy,
    ) {
    }

    protected function supports(string $attribute, mixed $subject): bool
    {
        return $attribute === self::VIEW && ($subject instanceof Page || $subject instanceof Article);
    }

    protected function voteOnAttribute(string $attribute, mixed $subject, TokenInterface $token): bool
    {
        $visibility = VisibilityEnum::tryFrom($subject->getVisibility()) ?? VisibilityEnum::PUBLIC;

        if ($visibility === VisibilityEnum::PUBLIC) {
            return true;
        }

        $user = $token->getUser();
        if (!$user) {
            return false;
        }

        $requiredRole = $visibility->requiredRole();
        if ($requiredRole === null) {
            return true;
        }

        $reachableRoles = $this->roleHierarchy->getReachableRoleNames($token->getRoleNames());

        return in_array($requiredRole, $reachableRoles, true);
    }
}
