<?php

namespace App\Service;

use App\Controller\Admin\ContactMessageCrudController;
use App\Controller\Admin\DashboardController;
use App\Controller\Admin\MediaCrudController;
use App\Controller\Admin\SeoSettingsCrudController;
use App\Entity\Media;
use App\Enum\SeoStatus;
use App\Repository\ContactMessageRepository;
use App\Repository\PageViewRepository;
use Doctrine\ORM\EntityManagerInterface;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use Symfony\Bundle\SecurityBundle\Security;

/**
 * Accueil de l'admin : ce qui demande l'attention (a faire) et trois chiffres
 * cles. Chaque tache porte son lien direct vers l'ecran qui la regle.
 */
class AdminTodoService
{
    public function __construct(
        private readonly ContactMessageRepository $contactMessageRepository,
        private readonly PageViewRepository $pageViewRepository,
        private readonly EntityManagerInterface $em,
        private readonly ContentHubService $contentHub,
        private readonly SeoIntentChecker $seoIntentChecker,
        private readonly SiteContext $siteContext,
        private readonly Security $security,
        private readonly AdminUrlGenerator $adminUrlGenerator,
    ) {
    }

    /**
     * @return list<array{label: string, action: string, url: string, tone: string}>
     *         tone : "urgent" (quelqu'un attend une reponse) ou "info"
     */
    public function getTodos(): array
    {
        $todos = [];
        $isAdmin = $this->security->isGranted('ROLE_ADMIN');

        if ($isAdmin) {
            $unread = $this->contactMessageRepository->countUnread();
            if ($unread > 0) {
                $todos[] = [
                    'label' => $unread . ' ' . ($unread > 1 ? 'demandes de contact non lues' : 'demande de contact non lue'),
                    'action' => 'Lire',
                    'url' => $this->crudUrl(ContactMessageCrudController::class),
                    'tone' => 'urgent',
                ];
            }
        }

        // Brouillons d'articles et de pages : on reprend le dernier modifie
        $drafts = array_values(array_filter(
            $this->contentHub->getItems(),
            static fn (array $item) => !$item['published'] && in_array($item['type'], ['article', 'page'], true),
        ));
        if (count($drafts) === 1) {
            $todos[] = ['label' => 'Brouillon en cours : « ' . $drafts[0]['title'] . ' »', 'action' => 'Reprendre', 'url' => $drafts[0]['editUrl'], 'tone' => 'info'];
        } elseif (count($drafts) > 1) {
            $todos[] = ['label' => count($drafts) . ' brouillons en cours, dont « ' . $drafts[0]['title'] . ' »', 'action' => 'Reprendre', 'url' => $drafts[0]['editUrl'], 'tone' => 'info'];
        }

        if ($isAdmin) {
            $site = $this->siteContext->getCurrentSite();
            if ($site !== null) {
                $orange = count(array_filter(
                    $this->seoIntentChecker->check($site)->checks,
                    static fn ($check) => $check->status !== SeoStatus::GREEN,
                ));
                if ($orange > 0) {
                    $todos[] = [
                        'label' => 'Référencement : ' . $orange . ' ' . ($orange > 1 ? 'pistes' : 'piste') . ' d\'amélioration',
                        'action' => 'Voir',
                        'url' => $this->crudUrl(SeoSettingsCrudController::class, Action::EDIT, $site->getId()),
                        'tone' => 'info',
                    ];
                }
            }
        }

        $missingAlt = (int) $this->em->getRepository(Media::class)->createQueryBuilder('m')
            ->select('COUNT(m.id)')
            ->where('m.alt IS NULL')
            ->getQuery()
            ->getSingleScalarResult();
        if ($missingAlt > 0) {
            $todos[] = [
                'label' => $missingAlt . ' ' . ($missingAlt > 1 ? 'images sans texte alternatif' : 'image sans texte alternatif'),
                'action' => 'Compléter',
                'url' => $this->crudUrl(MediaCrudController::class),
                'tone' => 'info',
            ];
        }

        return $todos;
    }

    /**
     * @return array{visitsMonth: int, contactsMonth: int, topPage: ?array{url: string, views: int}}
     */
    public function getKeyFigures(): array
    {
        $top = $this->pageViewRepository->topPages(1, 'month');
        $first = $top[0] ?? null;

        return [
            'visitsMonth' => $this->pageViewRepository->countThisMonth(),
            'contactsMonth' => $this->contactMessageRepository->countSince(new \DateTimeImmutable('first day of this month 00:00')),
            'topPage' => $first ? ['url' => (string) $first['url'], 'views' => (int) $first['views']] : null,
        ];
    }

    private function crudUrl(string $crud, string $action = Action::INDEX, ?int $id = null): string
    {
        $generator = $this->adminUrlGenerator->unsetAll()
            ->setDashboard(DashboardController::class)
            ->setController($crud)
            ->setAction($action);

        if ($id !== null) {
            $generator->setEntityId($id);
        }

        return $generator->generateUrl();
    }
}
