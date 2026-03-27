<?php

namespace App\Controller\Admin\Trait;

use EasyCorp\Bundle\EasyAdminBundle\Config\KeyValueStore;

/**
 * Provides contextual help panel data for EasyAdmin CrudControllers.
 *
 * Usage: use this trait in a CrudController, then implement getHelpData().
 */
trait AdminHelpTrait
{
    /**
     * Returns the help data for this CRUD section.
     *
     * @return array{title: string, sections: array<array{title: string, content: string}>, tips: string[]}|null
     */
    abstract protected function getHelpData(): ?array;

    public function configureResponseParameters(KeyValueStore $responseParameters): KeyValueStore
    {
        $responseParameters = parent::configureResponseParameters($responseParameters);
        $responseParameters->set('admin_help', $this->getHelpData());

        return $responseParameters;
    }
}
