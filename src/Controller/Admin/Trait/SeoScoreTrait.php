<?php

namespace App\Controller\Admin\Trait;

use App\Service\SeoAnalyzer;
use EasyCorp\Bundle\EasyAdminBundle\Config\KeyValueStore;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

trait SeoScoreTrait
{
    abstract private function getSeoAnalyzer(): SeoAnalyzer;

    protected function seoScoreField(): TextField
    {
        $analyzer = $this->getSeoAnalyzer();

        return TextField::new('seoScore', 'SEO')
            ->setVirtual(true)
            ->setTemplatePath('admin/field/seo_score.html.twig')
            ->formatValue(fn ($value, $entity) => $analyzer->analyze($entity))
            ->hideOnForm();
    }

    protected function addSeoReportToResponse(KeyValueStore $responseParameters): KeyValueStore
    {
        $entity = $responseParameters->get('entity')?->getInstance();

        if ($entity !== null && method_exists($entity, 'getSeoTitle')) {
            $responseParameters->set('seo_report', $this->getSeoAnalyzer()->analyze($entity));
        }

        return $responseParameters;
    }
}
