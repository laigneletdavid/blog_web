<?php

namespace App\Service;

use App\Entity\Trait\SeoTrait;
use App\Enum\SeoStatus;
use App\Model\SeoCheck;
use App\Model\SeoReport;

class SeoAnalyzer
{
    public function analyze(object $entity): SeoReport
    {
        $checks = [];

        $checks[] = $this->checkSeoTitle($entity);
        $checks[] = $this->checkSeoDescription($entity);
        $checks[] = $this->checkContent($entity);
        $checks[] = $this->checkHeadings($entity);
        $checks[] = $this->checkImage($entity);
        $checks[] = $this->checkSlug($entity);

        return new SeoReport(array_filter($checks));
    }

    private function checkSeoTitle(object $entity): SeoCheck
    {
        $seoTitle = $entity->getSeoTitle();
        $title = $this->getTitle($entity);

        if ($seoTitle === null || $seoTitle === '') {
            if ($title !== null && $title !== '') {
                return new SeoCheck(
                    'seo_title',
                    'Titre SEO',
                    SeoStatus::RED,
                    'Absent — le titre de l\'entité sera utilisé par défaut. Rédigez un titre SEO optimisé (30-60 car.).',
                    true,
                );
            }

            return new SeoCheck(
                'seo_title',
                'Titre SEO',
                SeoStatus::RED,
                'Absent. Rédigez un titre SEO de 30 à 60 caractères.',
                true,
            );
        }

        $len = mb_strlen($seoTitle);

        if ($len < 30) {
            return new SeoCheck('seo_title', 'Titre SEO', SeoStatus::ORANGE, "Trop court ({$len} car.). Visez 30-60 caractères.");
        }

        if ($len > 60) {
            return new SeoCheck('seo_title', 'Titre SEO', SeoStatus::ORANGE, "Trop long ({$len} car.). Visez 30-60 caractères, Google tronque au-delà.");
        }

        return new SeoCheck('seo_title', 'Titre SEO', SeoStatus::GREEN, "OK ({$len} car.)");
    }

    private function checkSeoDescription(object $entity): SeoCheck
    {
        $desc = $entity->getSeoDescription();

        if ($desc === null || $desc === '') {
            return new SeoCheck(
                'seo_description',
                'Meta description',
                SeoStatus::RED,
                'Absente. Rédigez une meta description de 120 à 160 caractères pour améliorer le taux de clic.',
                true,
            );
        }

        $len = mb_strlen($desc);

        if ($len < 120) {
            return new SeoCheck('seo_description', 'Meta description', SeoStatus::ORANGE, "Trop courte ({$len} car.). Visez 120-160 caractères.");
        }

        if ($len > 160) {
            return new SeoCheck('seo_description', 'Meta description', SeoStatus::ORANGE, "Trop longue ({$len} car.). Google tronque au-delà de 160.");
        }

        return new SeoCheck('seo_description', 'Meta description', SeoStatus::GREEN, "OK ({$len} car.)");
    }

    private function checkContent(object $entity): ?SeoCheck
    {
        $content = $this->getContent($entity);

        if ($content === null) {
            return null;
        }

        $text = strip_tags($content);
        $words = str_word_count($text, 0, 'àâéèêëïîôùûüçÀÂÉÈÊËÏÎÔÙÛÜÇ');

        if ($words < 150) {
            return new SeoCheck(
                'content',
                'Contenu',
                SeoStatus::RED,
                "Très mince ({$words} mots). Visez au moins 300 mots pour un bon référencement.",
                true,
            );
        }

        if ($words < 300) {
            return new SeoCheck('content', 'Contenu', SeoStatus::ORANGE, "Correct mais léger ({$words} mots). 300+ mots est l'idéal.");
        }

        return new SeoCheck('content', 'Contenu', SeoStatus::GREEN, "OK ({$words} mots)");
    }

    private function checkHeadings(object $entity): ?SeoCheck
    {
        $content = $this->getContent($entity);

        if ($content === null) {
            return null;
        }

        $text = strip_tags($content);
        $words = str_word_count($text, 0, 'àâéèêëïîôùûüçÀÂÉÈÊËÏÎÔÙÛÜÇ');

        if ($words < 300) {
            return null;
        }

        $h2Count = preg_match_all('/<h2[\s>]/i', $content);

        if ($h2Count === 0) {
            return new SeoCheck('headings', 'Sous-titres', SeoStatus::ORANGE, 'Aucun sous-titre H2 sur un contenu long. Structurez avec des H2 pour améliorer la lisibilité et le SEO.');
        }

        return new SeoCheck('headings', 'Sous-titres', SeoStatus::GREEN, "{$h2Count} sous-titre(s) H2 détecté(s)");
    }

    private function checkImage(object $entity): SeoCheck
    {
        $image = $this->getImage($entity);

        if ($image === null) {
            return new SeoCheck('image', 'Image mise en avant', SeoStatus::RED, 'Aucune image mise en avant. Ajoutez-en une pour les réseaux sociaux et les résultats Google.', true);
        }

        return new SeoCheck('image', 'Image mise en avant', SeoStatus::GREEN, 'Présente');
    }

    private function checkSlug(object $entity): ?SeoCheck
    {
        if (!method_exists($entity, 'getSlug')) {
            return null;
        }

        $slug = $entity->getSlug();

        if ($slug === null || $slug === '') {
            return new SeoCheck('slug', 'URL (slug)', SeoStatus::ORANGE, 'Slug vide — sera généré automatiquement.');
        }

        if (preg_match('/^[a-z0-9]+$/', $slug) && mb_strlen($slug) > 20) {
            return new SeoCheck('slug', 'URL (slug)', SeoStatus::ORANGE, 'Le slug semble auto-généré (hash). Personnalisez-le pour un meilleur SEO.');
        }

        if (mb_strlen($slug) > 80) {
            return new SeoCheck('slug', 'URL (slug)', SeoStatus::ORANGE, 'Slug très long (' . mb_strlen($slug) . ' car.). Raccourcissez-le pour plus de lisibilité.');
        }

        return new SeoCheck('slug', 'URL (slug)', SeoStatus::GREEN, 'OK');
    }

    private function getTitle(object $entity): ?string
    {
        if (method_exists($entity, 'getTitle')) {
            return $entity->getTitle();
        }

        if (method_exists($entity, 'getName')) {
            return $entity->getName();
        }

        return null;
    }

    private function getContent(object $entity): ?string
    {
        if (method_exists($entity, 'getContent')) {
            $content = $entity->getContent();
            if ($content !== null && $content !== '') {
                return $content;
            }
        }

        if (method_exists($entity, 'getDescription')) {
            $desc = $entity->getDescription();
            if ($desc !== null && $desc !== '') {
                return $desc;
            }
        }

        return null;
    }

    private function getImage(object $entity): ?object
    {
        if (method_exists($entity, 'getFeaturedMedia')) {
            return $entity->getFeaturedMedia();
        }

        if (method_exists($entity, 'getImage')) {
            return $entity->getImage();
        }

        return null;
    }
}
