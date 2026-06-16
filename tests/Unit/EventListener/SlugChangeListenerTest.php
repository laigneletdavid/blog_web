<?php

namespace App\Tests\Unit\EventListener;

use App\Entity\Article;
use App\Entity\Page;
use App\Entity\SlugRedirect;
use App\EventListener\SlugChangeListener;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\ORM\Event\PreUpdateEventArgs;
use PHPUnit\Framework\TestCase;

class SlugChangeListenerTest extends TestCase
{
    private SlugChangeListener $listener;

    protected function setUp(): void
    {
        $this->listener = new SlugChangeListener();
    }

    public function testSlugChangeCreeRedirect(): void
    {
        $article = new Article();
        $em = $this->createMock(EntityManagerInterface::class);
        $changeSet = ['slug' => ['ancien-slug', 'nouveau-slug']];

        $em->expects($this->once())
            ->method('persist')
            ->with($this->callback(function (SlugRedirect $redirect) {
                return $redirect->getEntityType() === 'article'
                    && $redirect->getOldSlug() === 'ancien-slug'
                    && $redirect->getNewSlug() === 'nouveau-slug';
            }));

        $args = new PreUpdateEventArgs($article, $em, $changeSet);
        $this->listener->preUpdate($args);
    }

    public function testPasDeChangementSlugNePersistePas(): void
    {
        $article = new Article();
        $em = $this->createMock(EntityManagerInterface::class);
        $changeSet = ['title' => ['Ancien', 'Nouveau']];

        $em->expects($this->never())->method('persist');

        $args = new PreUpdateEventArgs($article, $em, $changeSet);
        $this->listener->preUpdate($args);
    }

    public function testSlugVideNePersistePas(): void
    {
        $article = new Article();
        $em = $this->createMock(EntityManagerInterface::class);
        $changeSet = ['slug' => ['', 'nouveau-slug']];

        $em->expects($this->never())->method('persist');

        $args = new PreUpdateEventArgs($article, $em, $changeSet);
        $this->listener->preUpdate($args);
    }

    public function testSlugNullNePersistePas(): void
    {
        $article = new Article();
        $em = $this->createMock(EntityManagerInterface::class);
        $changeSet = ['slug' => [null, 'nouveau-slug']];

        $em->expects($this->never())->method('persist');

        $args = new PreUpdateEventArgs($article, $em, $changeSet);
        $this->listener->preUpdate($args);
    }

    public function testEntiteNonSuivieIgnoree(): void
    {
        $entity = new \stdClass();
        $em = $this->createMock(EntityManagerInterface::class);
        $changeSet = ['slug' => ['old', 'new']];

        $em->expects($this->never())->method('persist');

        $args = new PreUpdateEventArgs($entity, $em, $changeSet);
        $this->listener->preUpdate($args);
    }

    public function testPageSlugChangeCreeRedirect(): void
    {
        $page = new Page();
        $em = $this->createMock(EntityManagerInterface::class);
        $changeSet = ['slug' => ['ancienne-page', 'nouvelle-page']];

        $em->expects($this->once())
            ->method('persist')
            ->with($this->callback(function (SlugRedirect $redirect) {
                return $redirect->getEntityType() === 'page'
                    && $redirect->getOldSlug() === 'ancienne-page'
                    && $redirect->getNewSlug() === 'nouvelle-page';
            }));

        $args = new PreUpdateEventArgs($page, $em, $changeSet);
        $this->listener->preUpdate($args);
    }
}
