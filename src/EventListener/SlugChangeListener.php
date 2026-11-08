<?php

namespace App\EventListener;

use App\Entity\SlugRedirect;
use Doctrine\Bundle\DoctrineBundle\Attribute\AsDoctrineListener;
use Doctrine\ORM\Event\PostFlushEventArgs;
use Doctrine\ORM\Event\PreUpdateEventArgs;
use Doctrine\ORM\Events;

/**
 * Enregistre une redirection 301 quand le slug d'un contenu change.
 *
 * Doctrine n'insere pas une entite persistee pendant preUpdate dans le flush en
 * cours : la redirection etait perdue a chaque fois. Elle est donc mise de cote
 * ici, puis enregistree une fois le flush termine.
 */
#[AsDoctrineListener(event: Events::preUpdate)]
#[AsDoctrineListener(event: Events::postFlush)]
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

    /** @var SlugRedirect[] */
    private array $pending = [];

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

        $this->pending[] = $redirect;
    }

    public function postFlush(PostFlushEventArgs $args): void
    {
        if ($this->pending === []) {
            return;
        }

        // Vide avant le flush : le second flush redeclenche postFlush
        $pending = $this->pending;
        $this->pending = [];

        $em = $args->getObjectManager();
        foreach ($pending as $redirect) {
            $em->persist($redirect);
        }
        $em->flush();
    }
}
