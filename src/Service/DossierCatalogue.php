<?php

namespace App\Service;

/**
 * Catalogue des parcours de preparation de dossier.
 *
 * Le lot livre ce catalogue en JavaScript, et son script de messagerie se
 * contentait de recopier ce que le navigateur lui renvoyait : intitules des
 * questions et liste des pieces comprises. On le tient donc ici, cote serveur.
 *
 * Le questionnaire reste rendu par le navigateur -- il s'adapte au fil des
 * clics -- mais a la transmission, seules les reponses du visiteur sont
 * reprises de sa requete. Les intitules, eux, sont relus dans ce catalogue a
 * partir de la cle du projet.
 */
class DossierCatalogue
{
    /**
     * @return array<string, array{
     *     label: string,
     *     intro: string,
     *     fields: list<array{0: string, 1: string, 2: string, 3?: list<string>}>,
     *     docs: list<string>
     * }>
     */
    public function all(): array
    {
        return [
            'vente' => [
                'label' => 'Vente immobilière',
                'intro' => 'Quelques éléments sur le bien permettent d’anticiper les premières vérifications.',
                'fields' => [
                    ['type', 'Type de bien', 'select', ['Maison', 'Appartement', 'Terrain', 'Bien professionnel', 'Autre']],
                    ['copro', 'Le bien est-il en copropriété ?', 'select', ['Non', 'Oui', 'Je ne sais pas']],
                    ['occupation', 'Le bien est-il occupé ?', 'select', ['Non', 'Oui, par le vendeur', 'Oui, par un locataire', 'Autre']],
                    ['pret', 'Existe-t-il encore un prêt ou une garantie sur le bien ?', 'select', ['Non', 'Oui', 'Je ne sais pas']],
                    ['specific', 'Division, servitude, travaux récents ou particularité connue ?', 'textarea'],
                ],
                'docs' => [
                    'Titre de propriété',
                    'Dernier avis de taxe foncière',
                    'Diagnostics déjà disponibles',
                    'Plans, bornage ou documents fonciers disponibles',
                    'Si copropriété : documents en votre possession relatifs à la copropriété',
                    'Si prêt en cours : références de l’établissement prêteur',
                ],
            ],
            'achat' => [
                'label' => 'Acquisition immobilière',
                'intro' => 'Précisons le bien recherché et l’état d’avancement de votre acquisition.',
                'fields' => [
                    ['type', 'Type de bien', 'select', ['Maison', 'Appartement', 'Terrain', 'Bien professionnel', 'Autre']],
                    ['stage', 'Où en êtes-vous ?', 'select', ['Recherche en cours', 'Offre envisagée', 'Offre acceptée', 'Avant-contrat à préparer', 'Avant-contrat déjà signé']],
                    ['finance', 'Financement envisagé', 'select', ['Sans emprunt', 'Avec emprunt', 'À déterminer']],
                    ['together', 'Achetez-vous seul ou à plusieurs ?', 'select', ['Seul', 'En couple', 'À plusieurs', 'Via une société / SCI', 'À déterminer']],
                    ['specific', 'Un point particulier à anticiper ?', 'textarea'],
                ],
                'docs' => [
                    'Pièce d’identité',
                    'Coordonnées complètes des acquéreurs',
                    'Offre ou annonce du bien si disponible',
                    'Avant-contrat s’il est déjà signé',
                    'Éléments de financement disponibles',
                    'Informations sur votre situation matrimoniale ou votre projet de société si pertinent',
                ],
            ],
            'succession' => [
                'label' => 'Succession',
                'intro' => 'Ces renseignements donnent une première vision de la situation familiale et patrimoniale.',
                'fields' => [
                    ['date', 'Date du décès', 'date'],
                    ['lien', 'Votre lien avec la personne décédée', 'select', ['Conjoint / partenaire', 'Enfant / descendant', 'Parent / ascendant', 'Frère / sœur', 'Autre héritier', 'Mandataire / autre']],
                    ['testament', 'Un testament ou une donation entre époux est-il connu ?', 'select', ['Oui', 'Non', 'Je ne sais pas']],
                    ['immo', 'La succession comprend-elle un ou plusieurs biens immobiliers ?', 'select', ['Oui', 'Non', 'Je ne sais pas']],
                    ['etranger', 'Existe-t-il un élément à l’étranger ?', 'select', ['Non', 'Oui : résidence, nationalité ou bien à l’étranger', 'Je ne sais pas']],
                    ['specific', 'Autre élément utile : héritier difficile à joindre, indivision, dettes, entreprise…', 'textarea'],
                ],
                'docs' => [
                    'Acte de décès',
                    'Livret de famille de la personne décédée',
                    'Pièces d’identité et coordonnées des héritiers connus',
                    'Contrat de mariage, PACS ou jugement de divorce s’il y a lieu',
                    'Testament ou donation entre époux si vous en disposez',
                    'Titres de propriété des biens immobiliers',
                    'Relevés ou coordonnées des banques, placements et assurances connus',
                    'Éléments relatifs aux dettes et charges connus',
                ],
            ],
            'transmission' => [
                'label' => 'Donation / transmission',
                'intro' => 'Définissons ce que vous souhaitez transmettre et à qui.',
                'fields' => [
                    ['benef', 'À qui souhaitez-vous transmettre ?', 'select', ['Enfant(s)', 'Petit(s)-enfant(s)', 'Conjoint / partenaire', 'Autre membre de la famille', 'Autre']],
                    ['asset', 'Que souhaitez-vous transmettre ?', 'select', ['Somme d’argent', 'Bien immobilier', 'Parts de société / SCI', 'Portefeuille / valeurs mobilières', 'Plusieurs types de biens', 'À déterminer']],
                    ['timing', 'Votre objectif principal', 'select', ['Aider maintenant', 'Anticiper la succession', 'Répartir entre plusieurs bénéficiaires', 'Transmettre progressivement', 'À déterminer']],
                    ['usufruit', 'Souhaitez-vous conserver l’usage ou les revenus du bien ?', 'select', ['Oui', 'Non', 'À étudier']],
                    ['specific', 'Une situation familiale ou patrimoniale particulière ?', 'textarea'],
                ],
                'docs' => [
                    'Pièces d’identité',
                    'Livret de famille',
                    'Contrat de mariage ou PACS le cas échéant',
                    'Titres de propriété des biens concernés',
                    'Évaluation ou éléments de valeur disponibles',
                    'Statuts et répartition du capital pour des titres de société',
                    'Éléments sur les donations antérieures si disponibles',
                ],
            ],
            'couple' => [
                'label' => 'Couple / organisation familiale',
                'intro' => 'Le bon outil dépend de votre situation actuelle et de votre projet.',
                'fields' => [
                    ['status', 'Votre situation actuelle', 'select', ['Célibataire', 'Concubinage', 'PACS', 'Mariage', 'Séparation / divorce en cours']],
                    ['goal', 'Votre projet', 'select', ['Se marier', 'Se pacser', 'Choisir / modifier un régime matrimonial', 'Protéger le conjoint / partenaire', 'Acheter ensemble', 'Organiser une séparation', 'Autre']],
                    ['children', 'Y a-t-il des enfants ?', 'select', ['Non', 'Oui, communs', 'Oui, d’une précédente union', 'Oui, communs et d’une précédente union']],
                    ['immo', 'Possédez-vous déjà un bien immobilier ?', 'select', ['Non', 'Oui, ensemble', 'Oui, séparément', 'Plusieurs biens']],
                    ['specific', 'Une question particulière ?', 'textarea'],
                ],
                'docs' => [
                    'Pièces d’identité',
                    'Livret de famille le cas échéant',
                    'Contrat de mariage ou convention de PACS existante',
                    'Titres de propriété des biens concernés',
                    'Éléments sur les sociétés ou actifs importants si le projet les concerne',
                ],
            ],
            'patrimoine' => [
                'label' => 'Patrimoine / SCI',
                'intro' => 'Quelques repères permettent d’identifier la structure à étudier.',
                'fields' => [
                    ['goal', 'Votre objectif principal', 'select', ['Acquérir un bien à plusieurs', 'Créer / organiser une SCI', 'Transmettre un patrimoine', 'Organiser un démembrement', 'Réorganiser un patrimoine existant', 'Autre']],
                    ['assets', 'Patrimoine principalement concerné', 'select', ['Immobilier', 'Parts de société / SCI', 'Liquidités / placements', 'Patrimoine mixte']],
                    ['family', 'Le projet associe-t-il des membres de votre famille ?', 'select', ['Oui', 'Non', 'À déterminer']],
                    ['existing', 'Une société existe-t-elle déjà ?', 'select', ['Non', 'Oui, SCI', 'Oui, autre société', 'À déterminer']],
                    ['specific', 'Décrivez brièvement l’objectif recherché', 'textarea'],
                ],
                'docs' => [
                    'Pièces d’identité des personnes concernées',
                    'Situation familiale',
                    'Titres de propriété des biens concernés',
                    'Statuts et derniers documents sociaux des sociétés existantes',
                    'Éléments de valorisation disponibles',
                    'Informations sur les emprunts liés aux biens ou sociétés',
                ],
            ],
            'entreprise' => [
                'label' => 'Entreprise',
                'intro' => 'Situez l’opération envisagée pour préparer le rendez-vous.',
                'fields' => [
                    ['goal', 'Votre projet', 'select', ['Créer une structure', 'Acquérir une activité / un fonds', 'Céder une activité / un fonds', 'Transmettre l’entreprise', 'Organiser une holding', 'Immobilier d’entreprise', 'Autre']],
                    ['form', 'Structure actuelle', 'select', ['Aucune / création', 'Entreprise individuelle', 'SARL / EURL', 'SAS / SASU', 'SCI', 'Autre société']],
                    ['partners', 'Y a-t-il plusieurs associés ou futurs associés ?', 'select', ['Non', 'Oui', 'À déterminer']],
                    ['property', 'L’opération comprend-elle de l’immobilier ?', 'select', ['Non', 'Oui', 'À déterminer']],
                    ['specific', 'Précisez votre projet ou votre calendrier', 'textarea'],
                ],
                'docs' => [
                    'Pièces d’identité des dirigeants / associés concernés',
                    'Statuts à jour si une société existe',
                    'Extrait d’immatriculation ou informations d’identification de la structure',
                    'Derniers éléments comptables disponibles selon le projet',
                    'Titre ou bail des locaux si concernés',
                    'Projet, offre ou protocole existant le cas échéant',
                ],
            ],
            'rural' => [
                'label' => 'Droit rural',
                'intro' => 'Identifions le foncier, l’exploitation et les personnes concernées.',
                'fields' => [
                    ['goal', 'Votre projet', 'select', ['Bail rural', 'Bail à long terme', 'Acquisition / vente de foncier', 'GFA', 'Transmission agricole', 'Droit de préemption', 'Projet photovoltaïque / convention', 'Autre']],
                    ['status', 'Votre qualité', 'select', ['Propriétaire', 'Exploitant / preneur', 'Acquéreur', 'Cédant', 'Héritier / famille', 'Autre']],
                    ['occupied', 'Les parcelles sont-elles exploitées ou louées ?', 'select', ['Non', 'Oui', 'En partie', 'Je ne sais pas']],
                    ['company', 'Une structure agricole est-elle concernée ?', 'select', ['Non', 'GAEC', 'EARL', 'SCEA', 'GFA', 'Autre', 'Je ne sais pas']],
                    ['specific', 'Parcelles, exploitation ou difficulté particulière', 'textarea'],
                ],
                'docs' => [
                    'Pièces d’identité',
                    'Titres de propriété des parcelles concernées',
                    'Baux, conventions ou états des lieux existants',
                    'Références cadastrales / plans disponibles',
                    'Statuts des structures agricoles concernées',
                    'Éléments sur l’exploitation et les droits existants',
                ],
            ],
            'autre' => [
                'label' => 'Autre demande',
                'intro' => 'Décrivez votre situation : l’étude vous orientera vers le bon interlocuteur.',
                'fields' => [
                    ['subject', 'Objet de votre demande', 'text'],
                    ['specific', 'Décrivez votre situation et ce que vous souhaitez obtenir', 'textarea'],
                ],
                'docs' => [
                    'Pièce d’identité',
                    'Tout acte, courrier ou document directement lié à votre demande',
                    'Coordonnées des autres personnes ou professionnels déjà concernés par le dossier',
                ],
            ],
        ];
    }

    /**
     * Les neuf entrees de la grille de choix, dans l'ordre du lot.
     *
     * @return list<array{cle: string, titre: string, chapo: string}>
     */
    public function entrees(): array
    {
        return [
            ['cle' => 'vente', 'titre' => 'Je vends', 'chapo' => 'Maison, appartement, terrain ou bien professionnel.'],
            ['cle' => 'achat', 'titre' => 'J’achète', 'chapo' => 'Acquisition, avant-contrat et financement.'],
            ['cle' => 'succession', 'titre' => 'Une succession', 'chapo' => 'Décès, héritiers, patrimoine et règlement.'],
            ['cle' => 'transmission', 'titre' => 'Je transmets', 'chapo' => 'Donation, donation-partage, anticipation.'],
            ['cle' => 'couple', 'titre' => 'Mon couple', 'chapo' => 'Mariage, PACS, régime matrimonial.'],
            ['cle' => 'patrimoine', 'titre' => 'Mon patrimoine', 'chapo' => 'SCI, démembrement, organisation patrimoniale.'],
            ['cle' => 'entreprise', 'titre' => 'Mon entreprise', 'chapo' => 'Création, cession, transmission.'],
            ['cle' => 'rural', 'titre' => 'Projet rural', 'chapo' => 'Bail, foncier, GFA, transmission agricole.'],
            ['cle' => 'autre', 'titre' => 'Autre demande', 'chapo' => 'Décrivez-nous simplement votre situation.'],
        ];
    }

    public function has(string $cle): bool
    {
        return isset($this->all()[$cle]);
    }

    /**
     * @return array{label: string, intro: string, fields: list<array<mixed>>, docs: list<string>}|null
     */
    public function get(string $cle): ?array
    {
        return $this->all()[$cle] ?? null;
    }

    /**
     * Relit les reponses du visiteur a l'aune du catalogue.
     *
     * Le navigateur poste des couples « nom technique => valeur ». On ne
     * reprend que les noms connus du parcours, et l'intitule affiche dans le
     * courriel vient d'ici, jamais de la requete.
     *
     * @param array<string, mixed> $reponses
     *
     * @return list<array{0: string, 1: string}>
     */
    public function relire(string $cle, array $reponses): array
    {
        $parcours = $this->get($cle);
        if (null === $parcours) {
            return [];
        }

        $lignes = [];
        foreach ($parcours['fields'] as $champ) {
            [$nom, $intitule, $type] = [$champ[0], $champ[1], $champ[2]];
            $valeur = trim((string) ($reponses[$nom] ?? ''));
            if ('' === $valeur) {
                continue;
            }

            // Pour les listes deroulantes, la valeur doit figurer parmi les
            // choix proposes : rien n'empeche de poster autre chose.
            if ('select' === $type && !in_array($valeur, $champ[3] ?? [], true)) {
                continue;
            }

            $lignes[] = [$intitule, mb_substr($valeur, 0, 1200)];
        }

        return $lignes;
    }

    /**
     * Les pieces cochees, relues dans le catalogue a partir de leur rang.
     *
     * @param list<mixed> $rangs
     *
     * @return list<string>
     */
    public function pieces(string $cle, array $rangs): array
    {
        $docs = $this->get($cle)['docs'] ?? [];
        $retenues = [];
        foreach ($rangs as $rang) {
            if (is_numeric($rang) && isset($docs[(int) $rang])) {
                $retenues[] = $docs[(int) $rang];
            }
        }

        return $retenues;
    }
}
