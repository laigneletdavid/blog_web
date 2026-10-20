<?php

namespace App\Service;

/**
 * Bareme applique par les simulateurs de l'etude.
 *
 * Les montants affiches par un simulateur reposent sur des taux, des
 * tranches et des abattements fixes par la loi et par arrete. Ils changent.
 * Un visiteur qui lit un chiffre doit pouvoir savoir de quand il date, et
 * l'etude doit pouvoir le verifier sans relire du JavaScript.
 *
 * Cette classe porte donc la date de reference, et les gabarits l'affichent.
 * Tant qu'elle n'est pas renseignee, les pages l'annoncent explicitement
 * plutot que de laisser croire a un chiffre a jour.
 */
class BaremeNotarial
{
    /**
     * Date d'entree en vigueur du bareme applique.
     *
     * A RENSEIGNER PAR L'ETUDE, au format AAAA-MM-JJ, apres verification des
     * taux contre les textes en vigueur. Tant que cette valeur est nulle,
     * les simulateurs annoncent un bareme en cours de validation.
     *
     * Les valeurs actuellement utilisees sont celles du dossier remis par
     * l'etude ; leur date n'y figurait pas, et je ne l'invente pas.
     */
    private const DATE_BAREME = null;

    public function date(): ?\DateTimeImmutable
    {
        if (null === self::DATE_BAREME) {
            return null;
        }

        $date = \DateTimeImmutable::createFromFormat('Y-m-d', self::DATE_BAREME);

        return false !== $date ? $date : null;
    }

    public function estValide(): bool
    {
        return null !== $this->date();
    }

    /**
     * Mention affichee sous chaque simulateur.
     */
    public function mention(): string
    {
        $date = $this->date();

        if (null === $date) {
            return 'Barème en cours de validation par l’étude.';
        }

        $mois = [
            1 => 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
            'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
        ];

        return sprintf(
            'Barème applicable au %s %s %s.',
            '1' === $date->format('j') ? '1er' : $date->format('j'),
            $mois[(int) $date->format('n')],
            $date->format('Y')
        );
    }
}
