<?php

namespace App\Model;

/**
 * Interface marqueur pour les entités liées à un site/tenant.
 *
 * Préparation multi-tenant : quand on ajoutera un champ site_id
 * + Doctrine Filter global, toutes les entités implémentant cette
 * interface seront automatiquement filtrées par site.
 *
 * Pour l'instant : interface vide, sert uniquement de convention.
 */
interface TenantAwareInterface
{
}
