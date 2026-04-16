<?php

namespace App\Field;

use EasyCorp\Bundle\EasyAdminBundle\Contracts\Field\FieldInterface;
use EasyCorp\Bundle\EasyAdminBundle\Field\FieldTrait;
use Symfony\Component\Form\Extension\Core\Type\TextType;

/**
 * Champ EasyAdmin pour choisir une icone parmi celles disponibles
 * dans templates/icons/.
 *
 * Stocke uniquement le nom de l'icone (ex: "search") dans la BDD.
 * Affiche un input texte + bouton "Choisir une icone" + preview en live.
 *
 * Le picker JS est dans assets/admin/icon-picker.js et reutilise
 * l'endpoint /admin/api/icons.
 */
final class IconPickerField implements FieldInterface
{
    use FieldTrait;

    public static function new(string $propertyName, ?string $label = null): self
    {
        return (new self())
            ->setProperty($propertyName)
            ->setLabel($label)
            ->setFormType(TextType::class)
            ->setFormTypeOption('attr', [
                'data-icon-picker' => 'true',
                'autocomplete' => 'off',
                'placeholder' => 'Cliquez sur "Choisir" pour selectionner une icone',
            ])
            ->setHelp('Nom d\'icone Bootstrap Icons (ex : search, envelope, gear). Cliquez sur "Choisir" pour parcourir.')
            ->addCssClass('field-icon-picker');
    }
}
