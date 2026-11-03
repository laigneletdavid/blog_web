<?php

namespace App\Twig;

use App\Service\AdminModeService;
use Twig\Extension\AbstractExtension;
use Twig\TwigFunction;

/**
 * Fonctions Twig propres a l'admin.
 */
class AdminExtension extends AbstractExtension
{
    public function __construct(
        private readonly AdminModeService $adminMode,
    ) {
    }

    public function getFunctions(): array
    {
        return [
            new TwigFunction('is_admin_expert', [$this->adminMode, 'isExpert']),
        ];
    }
}
