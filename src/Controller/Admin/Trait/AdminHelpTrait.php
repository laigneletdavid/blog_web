<?php

namespace App\Controller\Admin\Trait;

use EasyCorp\Bundle\EasyAdminBundle\Config\KeyValueStore;

trait AdminHelpTrait
{
    /**
     * @return array{title: string, sections: array<array{title: string, content: string}>, tips: string[]}|null
     */
    abstract protected function getHelpData(): ?array;

    public function configureResponseParameters(KeyValueStore $responseParameters): KeyValueStore
    {
        $responseParameters = parent::configureResponseParameters($responseParameters);
        $responseParameters->set('admin_help', $this->getHelpData());

        if (method_exists($this, 'addSeoReportToResponse')) {
            $responseParameters = $this->addSeoReportToResponse($responseParameters);
        }

        return $responseParameters;
    }
}
