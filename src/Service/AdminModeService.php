<?php

namespace App\Service;

use App\Entity\User;
use Symfony\Bundle\SecurityBundle\Security;

/**
 * Mode de l'admin pour l'utilisateur connecte.
 *
 * Mode simple par defaut : seuls les champs utiles au quotidien sont affiches.
 * Le mode expert (preference enregistree sur User) ajoute les reglages
 * techniques : adresse de la page, URL canonique, mots-cles, modules...
 */
class AdminModeService
{
    public function __construct(
        private readonly Security $security,
    ) {
    }

    public function isExpert(): bool
    {
        $user = $this->security->getUser();

        return $user instanceof User && $user->isAdminExpert();
    }
}
