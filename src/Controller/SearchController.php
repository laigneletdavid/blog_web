<?php

namespace App\Controller;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Entity\Page;
use App\Entity\Product;
use App\Service\SeoService;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\ORM\Tools\Pagination\Paginator;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class SearchController extends AbstractController
{
    private const PER_PAGE = 10;

    public function __construct(
        private EntityManagerInterface $em,
        private SiteContext $siteContext,
    ) {
    }

    #[Route('/search', name: 'app_search')]
    public function search(Request $request): JsonResponse
    {
        $keyword = trim($request->query->get('q', ''));

        if (mb_strlen($keyword) < 2) {
            return $this->json([], Response::HTTP_BAD_REQUEST);
        }

        $results = array_merge(
            iterator_to_array($this->searchCategorie($keyword)),
            iterator_to_array($this->searchArticle($keyword)),
            iterator_to_array($this->searchPage($keyword)),
            $this->siteContext->hasModule('catalogue') ? iterator_to_array($this->searchProduct($keyword)) : [],
        );

        return $this->json([
            'results' => $results,
            'keyword' => $keyword,
            'seeAllUrl' => $this->generateUrl('app_search_results', ['q' => $keyword]),
        ]);
    }

    #[Route('/recherche', name: 'app_search_results')]
    public function results(Request $request, SeoService $seoService): Response
    {
        $keyword = trim($request->query->get('q', ''));
        $page = max(1, $request->query->getInt('page', 1));

        $articles = [];
        $pages = [];
        $categories = [];
        $products = [];
        $totalArticles = 0;

        if (mb_strlen($keyword) >= 2) {
            $articlesPaginator = $this->searchArticlePaginated($keyword, $page);
            $totalArticles = count($articlesPaginator);
            $articles = $articlesPaginator;
            $pages = $this->searchPageEntities($keyword);
            $categories = $this->searchCategorieEntities($keyword);
            if ($this->siteContext->hasModule('catalogue')) {
                $products = $this->searchProductEntities($keyword);
            }
        }

        return $this->render('search/results.html.twig', [
            'keyword' => $keyword,
            'articles' => $articles,
            'pages' => $pages,
            'categories' => $categories,
            'products' => $products,
            'totalArticles' => $totalArticles,
            'currentPage' => $page,
            'totalPages' => $totalArticles > 0 ? (int) ceil($totalArticles / self::PER_PAGE) : 1,
            'seo' => $seoService->resolveForPage($keyword ? 'Recherche : ' . $keyword : 'Recherche'),
        ]);
    }

    // --- JSON dropdown methods (existing) ---

    private function searchArticle(string $keyword): iterable
    {
        $qb = $this->em->createQueryBuilder();
        $qb->from(Article::class, 'a')
            ->select('a.title', 'a.slug')
            ->where('a.published = TRUE')
            ->andWhere('a.title LIKE :kw OR a.content LIKE :kw')
            ->setParameter('kw', '%' . $keyword . '%')
            ->setMaxResults(10);

        foreach ($qb->getQuery()->toIterable() as $result) {
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
        $qb->from(Page::class, 'p')
            ->select('p.title', 'p.slug')
            ->where('p.title LIKE :kw OR p.content LIKE :kw')
            ->setParameter('kw', '%' . $keyword . '%')
            ->setMaxResults(10);

        foreach ($qb->getQuery()->toIterable() as $result) {
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
        $qb->from(Categorie::class, 'c')
            ->select('c.name', 'c.slug')
            ->where('c.name LIKE :kw')
            ->setParameter('kw', '%' . $keyword . '%')
            ->setMaxResults(10);

        foreach ($qb->getQuery()->toIterable() as $result) {
            yield [
                'type' => 'categorie',
                'text' => $result['name'],
                'url' => $this->generateUrl('app_categorie_show', ['slug' => $result['slug']]),
            ];
        }
    }

    // --- HTML results page methods ---

    private function searchArticlePaginated(string $keyword, int $page): Paginator
    {
        $qb = $this->em->createQueryBuilder();
        $qb->from(Article::class, 'a')
            ->select('a')
            ->leftJoin('a.featured_media', 'm')->addSelect('m')
            ->leftJoin('a.categories', 'c')->addSelect('c')
            ->where('a.published = TRUE')
            ->andWhere('a.title LIKE :kw OR a.content LIKE :kw OR a.featured_text LIKE :kw')
            ->setParameter('kw', '%' . $keyword . '%')
            ->orderBy('a.created_at', 'DESC')
            ->setFirstResult(($page - 1) * self::PER_PAGE)
            ->setMaxResults(self::PER_PAGE);

        return new Paginator($qb->getQuery());
    }

    private function searchPageEntities(string $keyword): array
    {
        $qb = $this->em->createQueryBuilder();
        $qb->from(Page::class, 'p')
            ->select('p')
            ->where('p.title LIKE :kw OR p.content LIKE :kw')
            ->setParameter('kw', '%' . $keyword . '%')
            ->orderBy('p.title', 'ASC')
            ->setMaxResults(20);

        return $qb->getQuery()->getResult();
    }

    private function searchCategorieEntities(string $keyword): array
    {
        $qb = $this->em->createQueryBuilder();
        $qb->from(Categorie::class, 'c')
            ->select('c')
            ->where('c.name LIKE :kw')
            ->setParameter('kw', '%' . $keyword . '%')
            ->orderBy('c.name', 'ASC')
            ->setMaxResults(20);

        return $qb->getQuery()->getResult();
    }

    // --- Product search methods ---

    private function searchProduct(string $keyword): iterable
    {
        $qb = $this->em->createQueryBuilder();
        $qb->from(Product::class, 'p')
            ->select('p.title', 'p.slug')
            ->where('p.isActive = TRUE')
            ->andWhere('p.title LIKE :kw OR p.shortDescription LIKE :kw')
            ->setParameter('kw', '%' . $keyword . '%')
            ->setMaxResults(10);

        foreach ($qb->getQuery()->toIterable() as $result) {
            yield [
                'type' => 'produit',
                'text' => $result['title'],
                'url' => $this->generateUrl('app_product_show', ['slug' => $result['slug']]),
            ];
        }
    }

    private function searchProductEntities(string $keyword): array
    {
        $qb = $this->em->createQueryBuilder();
        $qb->from(Product::class, 'p')
            ->select('p')
            ->leftJoin('p.image', 'i')->addSelect('i')
            ->leftJoin('p.category', 'c')->addSelect('c')
            ->where('p.isActive = TRUE')
            ->andWhere('p.title LIKE :kw OR p.shortDescription LIKE :kw')
            ->setParameter('kw', '%' . $keyword . '%')
            ->orderBy('p.position', 'ASC')
            ->setMaxResults(20);

        return $qb->getQuery()->getResult();
    }
}
