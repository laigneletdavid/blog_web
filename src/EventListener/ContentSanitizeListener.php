<?php

namespace App\EventListener;

use App\Entity\SanitizableContentInterface;
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
        if (!$entity instanceof SanitizableContentInterface) {
            return;
        }

        $blocks = $entity->getBlocks();

        if (!empty($blocks)) {
            $html = $this->blockRenderer->toHtml($blocks);
            $entity->setContent($this->appContentSanitizer->sanitize($html));
        } else {
            $content = $entity->getContent();
            if ($content !== null && $content !== '') {
                $entity->setContent($this->appContentSanitizer->sanitize($content));
            } elseif ($content === null) {
                $entity->setContent('');
            }
        }
    }
}
