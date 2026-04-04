<?php

namespace App\Controller;

use App\Entity\DirectoryEntry;
use App\Form\DirectoryEntryType;
use App\Repository\DirectoryCategoryRepository;
use App\Repository\DirectoryEntryRepository;
use App\Service\SeoService;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;
use Symfony\Component\String\Slugger\SluggerInterface;

class DirectoryController extends AbstractController
{
    public function __construct(
        private readonly SiteContext $siteContext,
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/annuaire', name: 'app_directory')]
    public function index(
        Request $request,
        DirectoryEntryRepository $entryRepository,
        DirectoryCategoryRepository $categoryRepository,
    ): Response {
        if (!$this->siteContext->hasModule('directory')) {
            throw $this->createNotFoundException();
        }

        $directoryCategories = $categoryRepository->findAllActive();
        $categorySlug = $request->query->get('categorie');
        $search = $request->query->get('q', '');
        $activeCategory = null;

        if ($categorySlug) {
            foreach ($directoryCategories as $cat) {
                if ($cat->getSlug() === $categorySlug) {
                    $activeCategory = $cat;
                    break;
                }
            }
        }

        if ($search !== '') {
            $entries = $entryRepository->searchActive($search);
        } elseif ($activeCategory) {
            $entries = $entryRepository->findActiveByCategory($activeCategory);
        } else {
            $entries = $entryRepository->findAllActive();
        }

        return $this->render('directory/index.html.twig', [
            'title_page' => 'Annuaire',
            'entries' => $entries,
            'directoryCategories' => $directoryCategories,
            'activeCategory' => $activeCategory,
            'search' => $search,
            'seo' => $this->seoService->resolveForPage('Annuaire'),
        ]);
    }

    #[Route('/annuaire/ma-fiche', name: 'app_directory_my_entry', priority: 1)]
    #[IsGranted('ROLE_USER')]
    public function myEntry(
        Request $request,
        DirectoryEntryRepository $entryRepository,
        EntityManagerInterface $em,
        SluggerInterface $slugger,
    ): Response {
        if (!$this->siteContext->hasModule('directory')) {
            throw $this->createNotFoundException();
        }

        $entry = $entryRepository->findByUser($this->getUser());
        if (!$entry) {
            $this->addFlash('warning', 'Aucune fiche ne vous est associee. Contactez un administrateur.');

            return $this->redirectToRoute('app_directory');
        }

        $form = $this->createForm(DirectoryEntryType::class, $entry);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            /** @var UploadedFile|null $photoFile */
            $photoFile = $form->get('photoFile')->getData();
            if ($photoFile) {
                $filename = strtolower($slugger->slug($entry->getLastName())) . '-' . uniqid() . '.' . $photoFile->guessExtension();
                $photoFile->move($this->getParameter('medias_directory'), $filename);
                $entry->setPhoto($filename);
            }

            $em->flush();
            $this->addFlash('success', 'Votre fiche a ete mise a jour.');

            return $this->redirectToRoute('app_directory_my_entry');
        }

        return $this->render('directory/edit.html.twig', [
            'title_page' => 'Ma fiche',
            'entry' => $entry,
            'form' => $form,
        ]);
    }

    #[Route('/annuaire/{slug}', name: 'app_directory_show')]
    public function show(
        string $slug,
        DirectoryEntryRepository $entryRepository,
    ): Response {
        if (!$this->siteContext->hasModule('directory')) {
            throw $this->createNotFoundException();
        }

        $entry = $entryRepository->findOneActiveBySlug($slug);
        if (!$entry) {
            throw $this->createNotFoundException('Fiche introuvable.');
        }

        return $this->render('directory/show.html.twig', [
            'title_page' => $entry->getDisplayName(),
            'entry' => $entry,
            'seo' => $this->seoService->resolve($entry),
        ]);
    }
}
