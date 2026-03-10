<?php

namespace App\EventListener;

use App\Entity\Article;
use App\Entity\Page;
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
    ) {
    }

    public function prePersist(PrePersistEventArgs $args): void
    {
        $this->sanitize($args->getObject());
    }

    public function preUpdate(PreUpdateEventArgs $args): void
    {
        $this->sanitize($args->getObject());
    }

    private function sanitize(object $entity): void
    {
        if ($entity instanceof Article || $entity instanceof Page) {
            $content = $entity->getContent();
            if ($content !== null) {
                $entity->setContent($this->appContentSanitizer->sanitize($content));
            }
        }
    }
}
