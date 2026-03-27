<?php

namespace App\Controller;

use App\Repository\UserRepository;
use App\Service\SeoService;
use App\Service\SiteContext;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

class DirectoryController extends AbstractController
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/annuaire', name: 'app_directory')]
    #[IsGranted('ROLE_USER')]
    public function index(Request $request, UserRepository $userRepository): Response
    {
        if (!$this->siteContext->hasModule('directory')) {
            throw $this->createNotFoundException();
        }

        $search = $request->query->get('q', '');
        $members = $userRepository->findDirectoryMembers($search);

        return $this->render('directory/index.html.twig', [
            'members' => $members,
            'search' => $search,
            'seo' => $this->seoService->resolveForPage('Annuaire des membres'),
        ]);
    }
}
