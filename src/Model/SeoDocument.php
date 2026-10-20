<?php

namespace App\Model;

/**
 * Vue simplifiee d'un contenu du site (page, service, article) pour les
 * controles croises de la fiche Referencement.
 */
final class SeoDocument
{
    /**
     * @param bool $dedicated true pour une page ou un service (peut porter une priorite a elle seule), false pour un article
     */
    public function __construct(
        public readonly ?string $title,
        public readonly ?string $seoTitle,
        public readonly ?string $seoDescription,
        public readonly ?string $content,
        public readonly bool $dedicated,
    ) {
    }
}
