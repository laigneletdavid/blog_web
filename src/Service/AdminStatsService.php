<?php

namespace App\Service;

use App\Repository\ArticleRepository;
use App\Repository\CommentRepository;
use App\Repository\PageRepository;
use App\Repository\PageViewRepository;

class AdminStatsService
{
    public function __construct(
        private readonly PageViewRepository $pageViewRepository,
        private readonly ArticleRepository $articleRepository,
        private readonly PageRepository $pageRepository,
        private readonly CommentRepository $commentRepository,
    ) {
    }

    /**
     * @return array{
     *     viewsToday: int,
     *     viewsMonth: int,
     *     uniqueToday: int,
     *     articlesPublished: int,
     *     articlesDrafts: int,
     *     pagesPublished: int,
     *     commentsCount: int,
     *     recentArticles: array,
     *     recentComments: array,
     *     dailyStats: array
     * }
     */
    public function getDashboardStats(): array
    {
        return [
            'viewsToday' => $this->pageViewRepository->countToday(),
            'viewsMonth' => $this->pageViewRepository->countThisMonth(),
            'uniqueToday' => $this->pageViewRepository->uniqueVisitorsToday(),
            'articlesPublished' => $this->articleRepository->countPublished(),
            'articlesDrafts' => $this->articleRepository->countDrafts(),
            'pagesPublished' => $this->pageRepository->countPublished(),
            'commentsCount' => $this->commentRepository->countAll(),
            'recentArticles' => $this->articleRepository->findRecentPublished(5),
            'recentComments' => $this->commentRepository->findRecent(5),
            'dailyStats' => $this->pageViewRepository->dailyStats(30),
        ];
    }
}
