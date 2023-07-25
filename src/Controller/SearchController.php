<?php

namespace App\Controller;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Entity\Page;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class SearchController extends AbstractController
{
    public function __construct(
        private EntityManagerInterface $em,
    ) {
    }

    #[Route('/search', name: 'app_search')]
    public function search(Request $request): JsonResponse
    {
        $keyword = trim($request->query->get('q', ''));

        if (mb_strlen($keyword) < 2 ) {
            return $this->json([], Response::HTTP_BAD_REQUEST);
        }

        $results = array_merge(
            iterator_to_array($this->searchCategorie($keyword)),
            iterator_to_array($this->searchArticle($keyword)),
            iterator_to_array($this->searchPage($keyword)),
        );

        return $this->json([
            'results' => $results,
            'keyword' => $keyword,
        ]);
    }

    private function searchArticle(string $keyword): iterable
    {
        $qb = $this->em->createQueryBuilder();
        $qb->from(Article::class, 'a');
        $qb->select('a.title', 'a.slug');
        $qb->where('a.title LIKE :WkeywordW OR a.content LIKE :WkeywordW');
        $qb->setParameter('WkeywordW', '%'.$keyword.'%');
        $qb->setMaxResults(10);

        foreach ( $qb->getQuery()->toIterable() as $result ) {
            yield [
                'type' => 'article',
                'text' => $result['title'],
                'url' => $this->generateUrl('app_article_show', ['slug' => $result['slug']]),
            ];
        }
    }

    private function searchPage(string $keyword): iterable
    {
        $qb = $this->em->createQueryBuilder();
        $qb->from(Page::class, 'p');
        $qb->select('p.title', 'p.slug');
        $qb->where('p.title LIKE :WkeywordW OR p.content LIKE :WkeywordW');
        $qb->setParameter('WkeywordW', '%'.$keyword.'%');
        $qb->setMaxResults(10);

        foreach ( $qb->getQuery()->toIterable() as $result ) {
            yield [
                'type' => 'page',
                'text' => $result['title'],
                'url' => $this->generateUrl('app_page_show', ['slug' => $result['slug']]),
            ];
        }
    }

    private function searchCategorie(string $keyword): iterable
    {
        $qb = $this->em->createQueryBuilder();
        $qb->from(Categorie::class, 'c');
        $qb->select('c.name', 'c.slug');
        $qb->where('c.name LIKE :WkeywordW');
        $qb->setParameter('WkeywordW', '%'.$keyword.'%');
        $qb->setMaxResults(10);

        foreach ( $qb->getQuery()->toIterable() as $result ) {
            yield [
                'type' => 'categorie',
                'text' => $result['name'],
                'url' => $this->generateUrl('app_categorie_show', ['slug' => $result['slug']]),
            ];
        }
    }

}