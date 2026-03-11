<?php

namespace App\EventListener;

use App\Entity\Article;
use App\Entity\Page;
use App\Service\BlockRenderer;
use Doctrine\Bundle\DoctrineBundle\Attribute\AsDoctrineListener;
use Doctrine\ORM\Event\PrePersistEventArgs;
use Doctrine\ORM\Event\PreUpdateEventArgs;
use Doctrine\ORM\Events;
use Symfony\Component\HtmlSanitizer\HtmlSanitizerInterface;

#[AsDoctrineListener(event: Events::prePersist)]
#[AsDoctrineListener(event: Events::preUpdate)]
class ContentSanitizeListener
{
    public function __construct(
        private readonly HtmlSanitizerInterface $appContentSanitizer,
        private readonly BlockRenderer $blockRenderer,
    ) {
    }

    public function prePersist(PrePersistEventArgs $args): void
    {
        $this->process($args->getObject());
    }

    public function preUpdate(PreUpdateEventArgs $args): void
    {
        $this->process($args->getObject());
    }

    private function process(object $entity): void
    {
        if (!$entity instanceof Article && !$entity instanceof Page) {
            return;
        }

        $blocks = $entity->getBlocks();

        if (!empty($blocks)) {
            // Compiler le JSON TipTap → HTML et stocker dans content (cache)
            $html = $this->blockRenderer->toHtml($blocks);
            $entity->setContent($this->appContentSanitizer->sanitize($html));
        } else {
            // Pas de blocks → sanitiser le content brut (rétrocompatibilité)
            $content = $entity->getContent();
            if ($content !== null && $content !== '') {
                $entity->setContent($this->appContentSanitizer->sanitize($content));
            } elseif ($content === null) {
                // Nouvel article sans contenu — éviter une erreur DB (colonne NOT NULL)
                $entity->setContent('');
            }
        }
    }
}
