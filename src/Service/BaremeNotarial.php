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
 * Cette classe porte donc la date de reference et l'integralite des valeurs
 * chiffrees. Les gabarits les recoivent en JSON et n'en inventent aucune :
 * ce fichier est le seul endroit a relire pour verifier ou mettre a jour un
 * taux, et la seule chose a modifier quand un texte change.
 *
 * Le calcul, lui, reste dans les gabarits : il est interactif et ne fait pas
 * d'aller-retour serveur.
 *
 * Convention des tranches : [plafond, taux], le plafond null valant « et
 * au-dela ». JSON ne sait pas ecrire l'infini, le JavaScript le retablit.
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
     * Les valeurs ci-dessous sont celles du dossier remis par l'etude ; leur
     * date n'y figurait pas, et je ne l'invente pas.
     */
    private const DATE_BAREME = null;

    /** Taux de TVA sur les emoluments. */
    private const TVA = 0.20;

    /**
     * Emolument proportionnel du notaire, bareme national reglemente.
     * Sert aux frais d'acquisition et, sous une autre grille, aux donations.
     */
    private const EMOLUMENTS_ACQUISITION = [
        [6500, 0.0387],
        [17000, 0.01596],
        [60000, 0.01064],
        [null, 0.00799],
    ];

    /** Bareme progressif en ligne directe, commun aux donations et successions. */
    private const BAREME_LIGNE_DIRECTE = [
        [8072, 0.05],
        [12109, 0.10],
        [15932, 0.15],
        [552324, 0.20],
        [902838, 0.30],
        [1805677, 0.40],
        [null, 0.45],
    ];

    /** Abattement supplementaire en faveur d'une personne handicapee. */
    private const ABATTEMENT_HANDICAP = 159325;

    /**
     * Abattement de plus-value pour duree de detention, au titre de l'impot
     * sur le revenu. Rien jusqu'a l'annee de depart comprise, puis un taux
     * annuel jusqu'a la derniere annee du bareme progressif.
     */
    private const ABATTEMENT_PV_IR = [
        'depart' => 5,
        'parAn' => 0.06,
        'exoneration' => 21,
    ];

    /**
     * Idem au titre des prelevements sociaux : meme depart, taux plus faible,
     * une annee charniere a taux propre, puis un rythme accelere.
     */
    private const ABATTEMENT_PV_PS = [
        'depart' => 5,
        'parAn' => 0.0165,
        'anneeCharniere' => 22,
        'tauxCharniere' => 0.016,
        'parAnEnsuite' => 0.09,
    ];

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

    /**
     * Valeurs chiffrees d'un simulateur, destinees a son gabarit.
     *
     * @return array<string, mixed>
     */
    public function pour(string $slug): array
    {
        return match ($slug) {
            'frais-acquisition' => $this->fraisAcquisition(),
            'donation' => $this->donation(),
            'succession' => $this->succession(),
            'plus-value' => $this->plusValue(),
            'viager' => $this->viager(),
            default => [],
        };
    }

    /**
     * @return array<string, mixed>
     */
    private function fraisAcquisition(): array
    {
        return [
            'emoluments' => self::EMOLUMENTS_ACQUISITION,
            // L'emolument proportionnel ne peut exceder cette part du prix.
            'plafondEmoluments' => 0.10,
            // Droits de mutation dans l'ancien. Le taux normal correspond aux
            // departements ayant applique la hausse temporaire.
            'mutationNormale' => 6.32,
            'mutationPrimo' => 5.81,
            // Taxe de publicite fonciere reduite, regime du neuf.
            'tpfNeuf' => 0.00715,
            'securiteImmobiliere' => 0.001,
            'tva' => self::TVA,
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function succession(): array
    {
        return [
            'ligneDirecte' => self::BAREME_LIGNE_DIRECTE,
            // Freres et soeurs : deux taux, de part et d'autre d'un seuil.
            'freres' => ['seuil' => 24430, 'tauxBas' => 0.35, 'tauxHaut' => 0.45],
            'neveu' => 0.55,
            'parent4' => 0.55,
            'autre' => 0.60,
            'abattements' => [
                'enfant' => 100000,
                'frere' => 15932,
                'neveu' => 7967,
                'parent4' => 1594,
                'autre' => 1594,
            ],
            'handicap' => self::ABATTEMENT_HANDICAP,
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function donation(): array
    {
        return [
            'ligneDirecte' => self::BAREME_LIGNE_DIRECTE,
            // Entre epoux et partenaires de PACS, les premieres tranches
            // different de la ligne directe.
            'epoux' => [
                [8072, 0.05],
                [15932, 0.10],
                [31865, 0.15],
                [552324, 0.20],
                [902838, 0.30],
                [1805677, 0.40],
                [null, 0.45],
            ],
            'freres' => ['seuil' => 24430, 'tauxBas' => 0.35, 'tauxHaut' => 0.45],
            'neveu' => 0.55,
            'autre' => 0.60,
            'abattements' => [
                'enfant' => 100000,
                'parent' => 100000,
                'petit' => 31865,
                'arriere' => 5310,
                'epoux' => 80724,
                'frere' => 15932,
                'neveu' => 7967,
            ],
            'handicap' => self::ABATTEMENT_HANDICAP,
            // Don familial de somme d'argent (art. 790 G du CGI).
            'don790G' => [
                'montant' => 31865,
                'ageDonateurMax' => 80,
                'ageDonataireMin' => 18,
            ],
            // Valeur de la nue-propriete selon l'age de l'usufruitier :
            // [age revolu en deca duquel la part s'applique, part].
            'usufruit' => [
                [21, 0.90], [31, 0.80], [41, 0.70], [51, 0.60], [61, 0.50],
                [71, 0.40], [81, 0.30], [91, 0.20], [null, 0.10],
            ],
            // Emoluments : la grille des actes portant sur une somme d'argent
            // est plus basse que celle des autres donations et des partages.
            'emolumentsActe' => [
                [6500, 0.04931],
                [17000, 0.02034],
                [60000, 0.01356],
                [null, 0.01017],
            ],
            'emolumentsArgent' => [
                [6500, 0.02367],
                [17000, 0.00976],
                [60000, 0.00651],
                [null, 0.00488],
            ],
            'tva' => self::TVA,
            // Frais propres a une donation immobiliere.
            'immobilier' => [
                'tpf' => 0.006,
                'fraisAssiette' => 0.0237,
                'securiteImmobiliere' => 0.001,
            ],
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function plusValue(): array
    {
        return [
            'tauxIr' => 0.19,
            'tauxPrelevementsSociaux' => 0.172,
            'abattementIr' => self::ABATTEMENT_PV_IR,
            'abattementPrelevementsSociaux' => self::ABATTEMENT_PV_PS,
            // Surtaxe sur les plus-values elevees : [plancher, plafond, taux].
            'surtaxe' => [
                [50000, 100000, 0.02],
                [100000, 150000, 0.03],
                [150000, 200000, 0.04],
                [200000, 250000, 0.05],
                [250000, null, 0.06],
            ],
            // Forfaits ouverts au vendeur a defaut de justificatifs.
            'forfaitFraisAcquisition' => 0.075,
            'forfaitTravaux' => 0.15,
            // Le forfait travaux suppose cette duree de detention.
            'forfaitTravauxDureeMin' => 5,
            // Durees au terme desquelles l'abattement atteint 100 %. Elles
            // sont deduites des taux ci-dessus et non saisies : un taux
            // corrige deplace la duree, sans que le texte de la page mente.
            'exonerationIrAns' => $this->dureeExonerationIr(),
            'exonerationPrelevementsSociauxAns' => $this->dureeExonerationPrelevementsSociaux(),
        ];
    }

    /**
     * Annee a partir de laquelle l'abattement pour l'impot sur le revenu
     * est total : la premiere qui suit la derniere annee du bareme progressif.
     */
    private function dureeExonerationIr(): int
    {
        return self::ABATTEMENT_PV_IR['exoneration'] + 1;
    }

    /**
     * Idem pour les prelevements sociaux, dont le rythme s'accelere apres
     * l'annee charniere. On cumule jusqu'a atteindre 100 %.
     */
    private function dureeExonerationPrelevementsSociaux(): int
    {
        ['depart' => $depart, 'parAn' => $parAn, 'anneeCharniere' => $charniere,
            'tauxCharniere' => $tauxCharniere, 'parAnEnsuite' => $parAnEnsuite] = self::ABATTEMENT_PV_PS;

        $cumul = $parAn * ($charniere - 1 - $depart) + $tauxCharniere;

        return $charniere + (int) ceil((1 - $cumul) / $parAnEnsuite);
    }

    /**
     * @return array<string, mixed>
     */
    private function viager(): array
    {
        return [
            // Durees statistiques pedagogiques, volontairement lissees :
            // [age, duree en annees]. Interpolation lineaire entre deux ages.
            'esperance' => [
                [60, 26], [65, 22], [70, 18], [75, 14], [80, 10],
                [85, 7], [90, 5], [95, 3.5], [100, 2],
            ],
            'dureePlancher' => 1.5,
            // Taux actuariel servant a capitaliser la rente.
            'tauxActuariel' => 0.02,
            // Majoration indicative d'une rente maintenue sur deux tetes.
            'majorationReversion' => 0.10,
            'ageMin' => 40,
            'ageMax' => 105,
        ];
    }
}
