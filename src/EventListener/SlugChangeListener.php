<?php

namespace App\EventListener;

use App\Entity\SlugRedirect;
use Doctrine\Bundle\DoctrineBundle\Attribute\AsDoctrineListener;
use Doctrine\ORM\Event\PreUpdateEventArgs;
use Doctrine\ORM\Events;

#[AsDoctrineListener(event: Events::preUpdate)]
class SlugChangeListener
{
    private const SLUG_ENTITIES = [
        'App\Entity\Article' => 'article',
        'App\Entity\Page' => 'page',
        'App\Entity\Categorie' => 'categorie',
        'App\Entity\Tag' => 'tag',
        'App\Entity\Service' => 'service',
        'App\Entity\Product' => 'product',
        'App\Entity\Event' => 'event',
        'App\Entity\PortfolioItem' => 'portfolio',
        'App\Entity\DirectoryEntry' => 'directory',
    ];

    public function preUpdate(PreUpdateEventArgs $args): void
    {
        $entity = $args->getObject();
        $class = $entity::class;

        if (!isset(self::SLUG_ENTITIES[$class])) {
            return;
        }

        if (!$args->hasChangedField('slug')) {
            return;
        }

        $oldSlug = $args->getOldValue('slug');
        $newSlug = $args->getNewValue('slug');

        if ($oldSlug === null || $oldSlug === '' || $oldSlug === $newSlug) {
            return;
        }

        $redirect = new SlugRedirect();
        $redirect->setEntityType(self::SLUG_ENTITIES[$class]);
        $redirect->setOldSlug($oldSlug);
        $redirect->setNewSlug($newSlug);

        $em = $args->getObjectManager();
        $em->persist($redirect);
    }
}
