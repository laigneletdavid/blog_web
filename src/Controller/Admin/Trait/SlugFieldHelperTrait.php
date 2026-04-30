<?php

namespace App\Controller\Admin\Trait;

use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;

/**
 * Helper pour configurer un SlugField selon le role connecte.
 *
 * Probleme : un slug expose en edition est dangereux pour un admin client
 * qui ne comprend pas l'impact (modification = URL cassee, 404 sur tous les
 * liens externes, casse possible des liens internes du menu).
 *
 * Strategie :
 * - **ROLE_ADMIN ou inferieur** : `hideOnForm()` — pas modifiable depuis le CRUD.
 *   Le client cree son contenu, le slug se genere automatiquement et reste fige.
 * - **ROLE_FREELANCE+ (revendeur, super admin)** : visible avec un help d'avertissement
 *   fort. Conserve la flexibilite pour optimiser les URLs SEO.
 *
 * Pour modifier un slug en tant qu'admin client, passer par un super admin / freelance,
 * ou (plus tard) via le systeme de redirections 301 automatiques (cf. backlog CLAUDE4).
 */
trait SlugFieldHelperTrait
{
    /**
     * @param string      $targetFieldName Nom du champ source (ex: 'title', 'name', 'company')
     * @param string|null $description     Texte d'aide contextuel optionnel (ex: 'Sert d\'ancre dans /faq#slug')
     * @param bool        $hideOnIndex     Cacher dans la liste (defaut true)
     */
    protected function slugField(
        string $targetFieldName,
        ?string $description = null,
        bool $hideOnIndex = true,
    ): SlugField {
        $field = SlugField::new('slug')
            ->setTargetFieldName($targetFieldName);

        if ($hideOnIndex) {
            $field->hideOnIndex();
        }

        if ($this->isGranted('ROLE_FREELANCE')) {
            $warning = '<strong style="color:#dc3545;">⚠ Modifier ce champ change l\'URL publique.</strong> '
                . 'Les liens externes existants (Google, partages, bookmarks) retourneront une 404. '
                . 'À modifier uniquement en connaissance de cause.';
            $help = $description !== null && $description !== ''
                ? $description . '<br>' . $warning
                : $warning;
            $field->setHelp($help);
        } else {
            // Admin client (ROLE_ADMIN, ROLE_AUTHOR, ROLE_USER) : slug invisible en edition.
            $field->hideOnForm();
        }

        return $field;
    }
}
