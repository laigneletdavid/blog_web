<?php

namespace App\Tests\Unit\EventListener;

use App\Entity\Article;
use App\Entity\Page;
use App\Entity\SlugRedirect;
use App\EventListener\SlugChangeListener;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\ORM\Event\PostFlushEventArgs;
use Doctrine\ORM\Event\PreUpdateEventArgs;
use PHPUnit\Framework\TestCase;

class SlugChangeListenerTest extends TestCase
{
    private SlugChangeListener $listener;

    protected function setUp(): void
    {
        $this->listener = new SlugChangeListener();
    }

    /**
     * Un flush complet : preUpdate pendant le flush, puis postFlush a la fin.
     */
    private function flush(object $entity, EntityManagerInterface $em, array $changeSet): void
    {
        $this->listener->preUpdate(new PreUpdateEventArgs($entity, $em, $changeSet));
        $this->listener->postFlush(new PostFlushEventArgs($em));
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
        $em->expects($this->once())->method('flush');

        $this->flush($article, $em, $changeSet);
    }

    public function testRedirectEnregistreeApresLeFlushPasPendant(): void
    {
        $article = new Article();
        $em = $this->createMock(EntityManagerInterface::class);
        $changeSet = ['slug' => ['ancien-slug', 'nouveau-slug']];

        // Doctrine n'insere pas une entite persistee pendant preUpdate
        $em->expects($this->never())->method('persist');

        $this->listener->preUpdate(new PreUpdateEventArgs($article, $em, $changeSet));
    }

    public function testSansChangementPostFlushNeFlushePas(): void
    {
        $em = $this->createMock(EntityManagerInterface::class);

        $em->expects($this->never())->method('flush');

        $this->listener->postFlush(new PostFlushEventArgs($em));
    }

    public function testPasDeChangementSlugNePersistePas(): void
    {
        $article = new Article();
        $em = $this->createMock(EntityManagerInterface::class);
        $changeSet = ['title' => ['Ancien', 'Nouveau']];

        $em->expects($this->never())->method('persist');

        $this->flush($article, $em, $changeSet);
    }

    public function testSlugVideNePersistePas(): void
    {
        $article = new Article();
        $em = $this->createMock(EntityManagerInterface::class);
        $changeSet = ['slug' => ['', 'nouveau-slug']];

        $em->expects($this->never())->method('persist');

        $this->flush($article, $em, $changeSet);
    }

    public function testSlugNullNePersistePas(): void
    {
        $article = new Article();
        $em = $this->createMock(EntityManagerInterface::class);
        $changeSet = ['slug' => [null, 'nouveau-slug']];

        $em->expects($this->never())->method('persist');

        $this->flush($article, $em, $changeSet);
    }

    public function testEntiteNonSuivieIgnoree(): void
    {
        $entity = new \stdClass();
        $em = $this->createMock(EntityManagerInterface::class);
        $changeSet = ['slug' => ['old', 'new']];

        $em->expects($this->never())->method('persist');

        $this->flush($entity, $em, $changeSet);
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

        $this->flush($page, $em, $changeSet);
    }
}
