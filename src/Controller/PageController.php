<?php

namespace App\Controller;

use App\Entity\ContactMessage;
use App\Entity\Page;
use App\Entity\StatConversion;
use App\Form\Type\LandingContactType;
use App\Repository\StatSessionRepository;
use App\Security\Voter\ContentVoter;
use App\Service\RecaptchaValidator;
use App\Service\SeoService;
use App\Service\SiteContext;
use App\Service\SystemMailerService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\RateLimiter\RateLimiterFactory;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/page', name: 'app_page_')]
class PageController extends AbstractController
{
    public function __construct(
        private readonly SeoService $seoService,
    ) {
    }

    #[Route('/{slug}', name: 'show', methods: ['GET', 'POST'])]
    public function show(
        ?Page $page,
        Request $request,
        SiteContext $siteContext,
        SystemMailerService $systemMailer,
        RecaptchaValidator $recaptchaValidator,
        EntityManagerInterface $em,
        StatSessionRepository $sessionRepository,
        #[Autowire(service: 'limiter.contact_limiter')] RateLimiterFactory $contactLimiter,
    ): Response {
        if (!$page) {
            throw $this->createNotFoundException('Page introuvable.');
        }

        // Un brouillon n'est pas en ligne. Il reste ouvert a qui peut editer le
        // contenu, pour relire une page avant publication.
        if ($page->isPublished() !== true && !$this->isGranted('ROLE_AUTHOR')) {
            throw $this->createNotFoundException('Page introuvable.');
        }

        if (!$this->isGranted(ContentVoter::VIEW, $page)) {
            return $this->render('_partials/_restricted_access.html.twig', [
                'title' => $page->getTitle(),
                'visibility' => $page->getVisibility(),
                'seo' => $this->seoService->resolveForPage($page->getTitle()),
            ], new Response('', 403));
        }

        if ($page->getTemplate() === 'landing') {
            return $this->showLanding($page, $request, $siteContext, $systemMailer, $recaptchaValidator, $em, $sessionRepository, $contactLimiter);
        }

        return $this->render('page/show.html.twig', [
            'page' => $page,
            'title_page' => $page->getTitle() ?? 'Page',
            'text_page' => '',
            'seo' => $this->seoService->resolve($page),
        ]);
    }

    private function showLanding(
        Page $page,
        Request $request,
        SiteContext $siteContext,
        SystemMailerService $systemMailer,
        RecaptchaValidator $recaptchaValidator,
        EntityManagerInterface $em,
        StatSessionRepository $sessionRepository,
        RateLimiterFactory $contactLimiter,
    ): Response {
        $form = $this->createForm(LandingContactType::class);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            if ($form->get('website')->getData()) {
                $this->addFlash('success', 'Merci ! Nous vous recontacterons très vite.');

                return $this->redirectToRoute('app_page_show', ['slug' => $page->getSlug()]);
            }

            $recaptchaToken = $request->request->get('g-recaptcha-response');
            if (!$recaptchaValidator->validate($recaptchaToken, 'landing_contact')) {
                $this->addFlash('error', 'La vérification anti-spam a échoué. Veuillez réessayer.');

                return $this->redirectToRoute('app_page_show', ['slug' => $page->getSlug()]);
            }

            $limiter = $contactLimiter->create($request->getClientIp());
            if (!$limiter->consume()->isAccepted()) {
                $this->addFlash('error', 'Trop de messages envoyés. Veuillez réessayer dans quelques minutes.');

                return $this->redirectToRoute('app_page_show', ['slug' => $page->getSlug()]);
            }

            $data = $form->getData();

            $utmSource = $form->get('utm_source')->getData();
            $utmMedium = $form->get('utm_medium')->getData();
            $utmCampaign = $form->get('utm_campaign')->getData();
            $utmInfo = array_filter([
                'utm_source' => $utmSource,
                'utm_medium' => $utmMedium,
                'utm_campaign' => $utmCampaign,
            ]);

            $site = $siteContext->getCurrentSite();
            $recipientEmail = $site?->getEmail() ?? 'contact@comwebsolutions.fr';
            $siteName = $systemMailer->getSiteName();

            $subjectLine = sprintf('[%s] Landing : %s', $siteName, $page->getTitle());
            $utmLine = $utmInfo ? '<p><strong>UTM :</strong> ' . htmlspecialchars(http_build_query($utmInfo), ENT_QUOTES, 'UTF-8') . '</p>' : '';

            $email = $systemMailer->createEmail($subjectLine)
                ->replyTo($data['email'])
                ->to($recipientEmail)
                ->html(sprintf(
                    '<p><strong>De :</strong> %s (%s)</p><p><strong>Activité :</strong> %s</p><p><strong>Page :</strong> %s</p>%s',
                    htmlspecialchars($data['name'], ENT_QUOTES, 'UTF-8'),
                    htmlspecialchars($data['email'], ENT_QUOTES, 'UTF-8'),
                    htmlspecialchars($data['activity'], ENT_QUOTES, 'UTF-8'),
                    htmlspecialchars($page->getTitle(), ENT_QUOTES, 'UTF-8'),
                    $utmLine
                ));

            $systemMailer->send($email);

            $ip = $request->getClientIp() ?? '0.0.0.0';
            $sourcePage = '/page/' . $page->getSlug();
            if ($utmInfo) {
                $sourcePage .= '?' . http_build_query($utmInfo);
            }

            $contactMessage = new ContactMessage();
            $contactMessage->setFirstname('');
            $contactMessage->setName($data['name']);
            $contactMessage->setEmail($data['email']);
            $contactMessage->setSubject(sprintf('Landing: %s — %s', $page->getTitle(), $data['activity']));
            $contactMessage->setMessage($data['activity']);
            $contactMessage->setIpHash(hash('sha256', $ip . date('Y-m-d')));
            $contactMessage->setSourcePage($sourcePage);

            $session = null;
            $sessionToken = $request->cookies->get('_bw_sid');
            if ($sessionToken) {
                $session = $sessionRepository->findOneBy(['sessionToken' => $sessionToken]);
                $contactMessage->setSession($session);
            }

            $em->persist($contactMessage);

            $conversion = new StatConversion();
            $conversion->setSession($session);
            $conversion->setType('landing_form_submit');
            $conversion->setPageUrl('/page/' . $page->getSlug());
            $conversion->setDetail($page->getTitle());
            $em->persist($conversion);

            $em->flush();

            $this->addFlash('success', 'Merci ! Nous vous recontacterons très vite.');

            return $this->redirectToRoute('app_page_show', ['slug' => $page->getSlug()]);
        }

        return $this->render('page/show_landing.html.twig', [
            'page' => $page,
            'landingForm' => $form,
            'seo' => $this->seoService->resolve($page),
            'recaptcha_site_key' => $recaptchaValidator->isEnabled() ? $recaptchaValidator->getSiteKey() : null,
        ]);
    }
}
