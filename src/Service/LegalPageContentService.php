<?php

namespace App\Service;

use App\Entity\Page;
use App\Enum\SystemPageEnum;
use App\Repository\PageRepository;
use Doctrine\ORM\EntityManagerInterface;

class LegalPageContentService
{
    public function __construct(
        private readonly PageRepository $pageRepository,
        private readonly EntityManagerInterface $em,
    ) {
    }

    public function createIfNotExists(SystemPageEnum $type): Page
    {
        $existing = $this->pageRepository->findSystemPage($type->value);
        if ($existing !== null) {
            return $existing;
        }

        $page = new Page();
        $page->setTitle($type->title());
        $page->setSlug($type->slug());
        $page->setIsSystem(true);
        $page->setSystemKey($type->value);
        $page->setPublished(true);
        $page->setVisibility('public');
        $page->setTemplate('full-width');
        $page->setCreatedAt(new \DateTime());
        $page->setContent($this->getDefaultContent($type));
        $page->setSeoDescription($this->getSeoDescription($type));
        $page->setNoIndex(true);

        $this->em->persist($page);

        return $page;
    }

    private function getSeoDescription(SystemPageEnum $type): string
    {
        return match ($type) {
            SystemPageEnum::MENTIONS_LEGALES => 'Mentions légales du site. Éditeur, hébergeur, propriété intellectuelle et contact.',
            SystemPageEnum::POLITIQUE_CONFIDENTIALITE => 'Politique de confidentialité. Données collectées, cookies, droits RGPD et contact DPO.',
            SystemPageEnum::CGV => 'Conditions générales de vente. Prix, commande, paiement, livraison, rétractation et garanties.',
            SystemPageEnum::CGU => "Conditions générales d'utilisation. Accès au service, inscription, propriété intellectuelle et responsabilité.",
        };
    }

    public function getDefaultContent(SystemPageEnum $type): string
    {
        return match ($type) {
            SystemPageEnum::MENTIONS_LEGALES => $this->getMentionsLegales(),
            SystemPageEnum::POLITIQUE_CONFIDENTIALITE => $this->getPolitiqueConfidentialite(),
            SystemPageEnum::CGV => $this->getCgv(),
            SystemPageEnum::CGU => $this->getCgu(),
        };
    }

    private function getMentionsLegales(): string
    {
        return <<<'HTML'
<p><em>Dernière mise à jour : {{DATE}}</em></p>

<h2>1. Éditeur du site</h2>
<table>
<tbody>
<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>
<tr><td><strong>Forme juridique</strong></td><td>{{FORME_JURIDIQUE}}</td></tr>
<tr><td><strong>Siège social</strong></td><td>{{ADRESSE}}</td></tr>
<tr><td><strong>SIRET</strong></td><td>{{SIRET}}</td></tr>
<tr><td><strong>N° TVA</strong></td><td>{{TVA}}</td></tr>
<tr><td><strong>Capital social</strong></td><td>{{CAPITAL}}</td></tr>
<tr><td><strong>Directeur de publication</strong></td><td>{{NOM_DIRECTEUR}}</td></tr>
<tr><td><strong>Contact</strong></td><td>{{EMAIL_CONTACT}}</td></tr>
<tr><td><strong>Téléphone</strong></td><td>{{TELEPHONE}}</td></tr>
</tbody>
</table>

<h2>2. Hébergement</h2>
<table>
<tbody>
<tr><td><strong>Hébergeur</strong></td><td>{{NOM_HEBERGEUR}}</td></tr>
<tr><td><strong>Adresse</strong></td><td>{{ADRESSE_HEBERGEUR}}</td></tr>
<tr><td><strong>Site web</strong></td><td>{{URL_HEBERGEUR}}</td></tr>
</tbody>
</table>
<p>L'ensemble des données sont hébergées en France, conformément au RGPD.</p>

<h2>3. Propriété intellectuelle</h2>
<p>L'ensemble du contenu de ce site (textes, images, vidéos, logos, icônes, sons, logiciels, etc.) est protégé par les lois françaises et internationales relatives à la propriété intellectuelle.</p>
<p>Toute reproduction, représentation, modification, publication ou dénaturation, totale ou partielle, du site ou de son contenu, par quelque procédé que ce soit, est interdite sans autorisation préalable écrite (articles L.335-2 et suivants du Code de la propriété intellectuelle).</p>

<h2>4. Protection des données</h2>
<ul>
<li>Hébergement 100 % France</li>
<li>Aucun transfert de données hors UE</li>
<li>Données personnelles jamais revendues</li>
</ul>
<p><strong>Contact DPO :</strong> {{EMAIL_DPO}}</p>
<p>Voir la <a href="/politique-de-confidentialite">Politique de confidentialité</a> pour les détails complets.</p>

<h2>5. Cookies</h2>
<table>
<thead>
<tr><th>Cookie</th><th>Type</th><th>Finalité</th><th>Consentement</th></tr>
</thead>
<tbody>
<tr><td>Session PHP</td><td>Essentiel</td><td>Authentification</td><td>Non requis</td></tr>
<tr><td>CSRF</td><td>Essentiel</td><td>Sécurité formulaires</td><td>Non requis</td></tr>
<tr><td>Google Analytics</td><td>Analytique</td><td>Mesure d'audience</td><td><strong>Requis</strong></td></tr>
<tr><td>Préférences cookies</td><td>Fonctionnel</td><td>Mémoriser votre choix</td><td>Non requis</td></tr>
</tbody>
</table>
<p>Vous pouvez gérer vos préférences via le bandeau de cookies affiché lors de votre première visite.</p>

<h2>6. Limitation de responsabilité</h2>
<p>L'éditeur s'efforce de fournir des informations aussi précises que possible. Toutefois, il ne pourra être tenu responsable des omissions, inexactitudes ou carences dans la mise à jour de ces informations.</p>
<p>L'éditeur décline toute responsabilité en cas d'interruption du site, de survenance de bugs ou d'incompatibilité du site avec certains matériels ou configurations.</p>

<h2>7. Droit applicable et litiges</h2>
<p>Les présentes mentions légales sont régies par le droit français. En cas de litige, une solution amiable sera recherchée avant toute action judiciaire. Les tribunaux français seront seuls compétents.</p>
<p><strong>Médiation consommation :</strong> Conformément à l'article L612-1 du Code de la consommation, le consommateur peut recourir gratuitement à un médiateur de la consommation. Médiateur : {{MEDIATEUR}}.</p>

<h2>8. Contact</h2>
<table>
<tbody>
<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>
<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — {{ADRESSE}}</td></tr>
<tr><td><strong>Téléphone</strong></td><td>{{TELEPHONE}}</td></tr>
</tbody>
</table>
HTML;
    }

    private function getPolitiqueConfidentialite(): string
    {
        return <<<'HTML'
<p><em>Dernière mise à jour : {{DATE}}</em></p>

<h2>1. Responsable du traitement</h2>
<table>
<tbody>
<tr><td><strong>Entité</strong></td><td>{{RAISON_SOCIALE}}</td></tr>
<tr><td><strong>Représentant</strong></td><td>{{NOM_DIRECTEUR}}</td></tr>
<tr><td><strong>Siège</strong></td><td>{{ADRESSE}}</td></tr>
<tr><td><strong>SIRET</strong></td><td>{{SIRET}}</td></tr>
<tr><td><strong>DPO</strong></td><td>{{EMAIL_DPO}}</td></tr>
</tbody>
</table>

<h2>2. Données collectées</h2>

<h3>2.1 Compte utilisateur</h3>
<table>
<thead>
<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>
</thead>
<tbody>
<tr><td>Nom, prénom</td><td>Identification</td><td>Durée du compte</td></tr>
<tr><td>Email</td><td>Identification, notifications</td><td>Durée du compte + 3 ans</td></tr>
<tr><td>Mot de passe (hashé)</td><td>Authentification</td><td>Durée du compte</td></tr>
</tbody>
</table>

<h3>2.2 Formulaire de contact</h3>
<table>
<thead>
<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>
</thead>
<tbody>
<tr><td>Nom, email</td><td>Répondre à la demande</td><td>3 ans</td></tr>
<tr><td>Message</td><td>Traitement de la demande</td><td>3 ans</td></tr>
</tbody>
</table>

<h3>2.3 Commentaires</h3>
<table>
<thead>
<tr><th>Donnée</th><th>Finalité</th><th>Conservation</th></tr>
</thead>
<tbody>
<tr><td>Nom, contenu</td><td>Affichage public</td><td>Durée de publication</td></tr>
</tbody>
</table>

<h3>2.4 Données techniques</h3>
<p>Adresse IP (hashée SHA-256), navigateur, pages visitées — conservées 12 mois à des fins de sécurité et de statistiques anonymes.</p>

<h3>2.5 Paiement</h3>
<p>Les données de paiement ne sont <strong>pas stockées</strong> par ce site. Elles sont gérées par Stripe (certifié PCI-DSS).</p>

<h2>3. Finalités du traitement</h2>
<ul>
<li>Gestion des comptes utilisateurs</li>
<li>Envoi de notifications relatives aux articles et au site</li>
<li>Traitement des demandes de contact</li>
<li>Amélioration du site via des statistiques de visite anonymisées</li>
<li>Gestion des commandes et paiements (si module e-commerce actif)</li>
</ul>

<h2>4. Base légale</h2>
<table>
<thead>
<tr><th>Traitement</th><th>Base légale (RGPD)</th></tr>
</thead>
<tbody>
<tr><td>Compte utilisateur</td><td>Exécution du contrat (art. 6.1.b)</td></tr>
<tr><td>Contact</td><td>Consentement (art. 6.1.a)</td></tr>
<tr><td>Cookies analytics</td><td>Consentement (art. 6.1.a)</td></tr>
<tr><td>Sécurité / logs</td><td>Intérêt légitime (art. 6.1.f)</td></tr>
<tr><td>Facturation</td><td>Obligation légale (art. 6.1.c)</td></tr>
</tbody>
</table>

<h2>5. Ce que nous ne faisons PAS</h2>
<ul>
<li>Vendre ou louer vos données à des tiers</li>
<li>Faire de la publicité ciblée</li>
<li>Faire du profilage marketing</li>
<li>Transférer vos données hors de l'Union Européenne (hors sous-traitants certifiés)</li>
</ul>

<h2>6. Cookies</h2>

<h3>Cookies essentiels (sans consentement)</h3>
<table>
<thead>
<tr><th>Cookie</th><th>Finalité</th></tr>
</thead>
<tbody>
<tr><td>Session PHP (PHPSESSID)</td><td>Authentification, panier</td></tr>
<tr><td>CSRF token</td><td>Sécurité des formulaires</td></tr>
<tr><td>Préférences cookies</td><td>Mémoriser votre choix</td></tr>
</tbody>
</table>

<h3>Cookies analytiques (avec consentement)</h3>
<table>
<thead>
<tr><th>Cookie</th><th>Finalité</th><th>Durée</th></tr>
</thead>
<tbody>
<tr><td>Google Analytics (_ga, _gid)</td><td>Mesure d'audience</td><td>13 mois max</td></tr>
</tbody>
</table>
<p>Les cookies analytiques ne sont déposés <strong>qu'après votre consentement explicite</strong> via le bandeau affiché lors de votre première visite. Vous pouvez retirer votre consentement à tout moment en supprimant vos cookies.</p>

<h2>7. Sous-traitants</h2>
<table>
<thead>
<tr><th>Prestataire</th><th>Pays</th><th>Finalité</th></tr>
</thead>
<tbody>
<tr><td>{{NOM_HEBERGEUR}}</td><td>France</td><td>Hébergement</td></tr>
<tr><td>Brevo</td><td>France</td><td>Envoi d'emails</td></tr>
<tr><td>Stripe</td><td>USA*</td><td>Paiement sécurisé</td></tr>
<tr><td>Google Analytics</td><td>USA*</td><td>Audience (avec consentement)</td></tr>
</tbody>
</table>
<p><em>* Certifiés EU-US Data Privacy Framework</em></p>

<h2>8. Vos droits RGPD</h2>
<table>
<thead>
<tr><th>Droit</th><th>Comment l'exercer</th></tr>
</thead>
<tbody>
<tr><td>Accès</td><td>Espace personnel ou {{EMAIL_DPO}}</td></tr>
<tr><td>Rectification</td><td>Espace personnel</td></tr>
<tr><td>Suppression</td><td>Espace personnel ou {{EMAIL_DPO}}</td></tr>
<tr><td>Portabilité</td><td>{{EMAIL_DPO}}</td></tr>
<tr><td>Opposition</td><td>{{EMAIL_DPO}}</td></tr>
<tr><td>Limitation</td><td>{{EMAIL_DPO}}</td></tr>
</tbody>
</table>
<p><strong>Délai de réponse :</strong> 30 jours maximum.</p>
<p>En cas de difficulté, vous pouvez adresser une réclamation auprès de la <strong>CNIL</strong> : <a href="https://www.cnil.fr" target="_blank" rel="noopener">www.cnil.fr</a> — 3 Place de Fontenoy, 75334 Paris Cedex 07.</p>

<h2>9. Sécurité</h2>
<table>
<tbody>
<tr><td><strong>Transfert</strong></td><td>HTTPS / TLS 1.3</td></tr>
<tr><td><strong>Mots de passe</strong></td><td>Hashés (bcrypt/argon2)</td></tr>
<tr><td><strong>IP visiteurs</strong></td><td>Hashées SHA-256 (anonymisées)</td></tr>
<tr><td><strong>Accès admin</strong></td><td>Protégé par authentification + CSRF</td></tr>
</tbody>
</table>

<h2>10. Modifications</h2>
<p>Cette politique peut être mise à jour. En cas de changement significatif, les utilisateurs inscrits seront informés par email. La date de mise à jour figure en haut de page.</p>

<h2>11. Contact</h2>
<table>
<tbody>
<tr><td><strong>DPO</strong></td><td>{{EMAIL_DPO}}</td></tr>
<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — {{ADRESSE}}</td></tr>
</tbody>
</table>
HTML;
    }

    private function getCgv(): string
    {
        return <<<'HTML'
<p><em>Dernière mise à jour : {{DATE}}</em></p>

<h2>1. Objet</h2>
<p>Les présentes Conditions Générales de Vente (CGV) régissent les ventes de produits et/ou services effectuées via ce site internet. Toute commande implique l'acceptation sans réserve des présentes CGV.</p>

<h2>2. Vendeur</h2>
<table>
<tbody>
<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>
<tr><td><strong>SIRET</strong></td><td>{{SIRET}}</td></tr>
<tr><td><strong>Adresse</strong></td><td>{{ADRESSE}}</td></tr>
<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>
</tbody>
</table>

<h2>3. Prix</h2>
<ul>
<li>Les prix sont indiqués en euros {{TTC_OU_HT}}</li>
<li>Les tarifs sont ceux en vigueur au moment de la validation de la commande</li>
<li>Le vendeur se réserve le droit de modifier ses prix à tout moment</li>
<li>Les frais de livraison sont indiqués avant validation de la commande</li>
</ul>

<h2>4. Commande</h2>
<p>Le processus de commande comprend les étapes suivantes :</p>
<ol>
<li>Sélection des produits et ajout au panier</li>
<li>Vérification du panier</li>
<li>Identification (connexion ou création de compte)</li>
<li>Choix du mode de livraison</li>
<li>Validation et paiement sécurisé</li>
</ol>
<p>Un email de confirmation est envoyé après chaque commande.</p>

<h2>5. Paiement</h2>
<ul>
<li>Le paiement est exigible immédiatement à la commande</li>
<li>Moyens acceptés : carte bancaire via <strong>Stripe</strong> (certifié PCI-DSS)</li>
<li>Les données de paiement ne sont pas stockées par le site</li>
<li>Les transactions sont sécurisées par chiffrement SSL/TLS</li>
</ul>

<h2>6. Livraison</h2>
<table>
<thead>
<tr><th>Élément</th><th>Détail</th></tr>
</thead>
<tbody>
<tr><td><strong>Zones de livraison</strong></td><td>{{ZONES_LIVRAISON}}</td></tr>
<tr><td><strong>Délais</strong></td><td>{{DELAIS_LIVRAISON}}</td></tr>
<tr><td><strong>Frais</strong></td><td>{{FRAIS_LIVRAISON}}</td></tr>
<tr><td><strong>Transporteur</strong></td><td>{{TRANSPORTEUR}}</td></tr>
</tbody>
</table>
<p>En cas de retard de livraison, le client sera informé dans les meilleurs délais.</p>

<h2>7. Droit de rétractation</h2>
<p>Conformément à l'article L221-18 du Code de la consommation, le consommateur dispose d'un délai de <strong>14 jours</strong> à compter de la réception du produit pour exercer son droit de rétractation, sans avoir à justifier de motifs ni à payer de pénalités.</p>
<ul>
<li>Notifier par email à {{EMAIL_CONTACT}} ou par courrier</li>
<li>Retourner le produit dans son état d'origine sous 14 jours</li>
<li>Remboursement sous 14 jours après réception du retour</li>
</ul>
<p><strong>Exceptions :</strong> produits personnalisés, périssables, descellés (hygiène), contenus numériques téléchargés.</p>

<h2>8. Garanties</h2>
<p>Les produits bénéficient de :</p>
<ul>
<li><strong>Garantie légale de conformité</strong> (articles L217-4 et suivants du Code de la consommation) — 2 ans à compter de la livraison</li>
<li><strong>Garantie des vices cachés</strong> (articles 1641 et suivants du Code civil) — 2 ans à compter de la découverte du vice</li>
</ul>

<h2>9. Responsabilité</h2>
<p>Le vendeur ne saurait être tenu responsable de l'inexécution du contrat en cas de force majeure, de perturbation ou de grève totale ou partielle des services postaux et moyens de transport et/ou communications.</p>

<h2>10. Réclamations et litiges</h2>
<p>En cas de litige, une solution amiable sera recherchée avant toute action judiciaire.</p>
<p><strong>Médiation consommation :</strong> Conformément à l'article L612-1 du Code de la consommation, le consommateur peut recourir gratuitement à un médiateur. Médiateur : {{MEDIATEUR}}.</p>
<p><strong>Droit applicable :</strong> droit français. Tribunaux français compétents.</p>

<h2>11. Contact</h2>
<table>
<tbody>
<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>
<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — {{ADRESSE}}</td></tr>
<tr><td><strong>Téléphone</strong></td><td>{{TELEPHONE}}</td></tr>
</tbody>
</table>
HTML;
    }

    private function getCgu(): string
    {
        return <<<'HTML'
<p><em>Dernière mise à jour : {{DATE}}</em></p>

<h2>1. Objet</h2>
<p>Les présentes Conditions Générales d'Utilisation (CGU) régissent l'accès et l'utilisation de ce site internet. En accédant au site, vous acceptez sans réserve les présentes CGU.</p>

<h2>2. Éditeur</h2>
<table>
<tbody>
<tr><td><strong>Raison sociale</strong></td><td>{{RAISON_SOCIALE}}</td></tr>
<tr><td><strong>SIRET</strong></td><td>{{SIRET}}</td></tr>
<tr><td><strong>Adresse</strong></td><td>{{ADRESSE}}</td></tr>
<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>
</tbody>
</table>

<h2>3. Accès au service</h2>
<ul>
<li>Le site est accessible gratuitement à tout utilisateur disposant d'un accès internet</li>
<li>Les frais d'accès et d'utilisation du réseau de télécommunication sont à la charge de l'utilisateur</li>
<li>L'éditeur se réserve le droit de suspendre ou interrompre l'accès pour maintenance</li>
</ul>

<h2>4. Inscription</h2>
<p>L'accès à certaines fonctionnalités du site nécessite une inscription. L'utilisateur s'engage à :</p>
<ul>
<li>Fournir des informations exactes et complètes</li>
<li>Mettre à jour ses informations en cas de changement</li>
<li>Préserver la confidentialité de son mot de passe (12 caractères minimum)</li>
<li>Notifier immédiatement toute utilisation non autorisée de son compte</li>
</ul>
<p>L'éditeur se réserve le droit de supprimer tout compte ne respectant pas les présentes CGU.</p>

<h2>5. Services proposés</h2>
<p>Le site propose les services suivants :</p>
<ul>
<li>Publication et consultation de contenus (articles, pages, services)</li>
<li>Formulaire de contact</li>
<li>Inscription aux notifications</li>
<li>Commentaires sur les articles</li>
<li>{{SERVICES_SUPPLEMENTAIRES}}</li>
</ul>

<h2>6. Propriété intellectuelle</h2>
<p>L'ensemble du contenu du site est protégé par le droit de la propriété intellectuelle :</p>
<ul>
<li>Textes, images, vidéos, logos, icônes, sons, logiciels</li>
<li>Charte graphique et design du site</li>
<li>Bases de données</li>
</ul>
<p>Toute reproduction non autorisée constitue une contrefaçon sanctionnée par les articles L335-2 et suivants du Code de la Propriété Intellectuelle.</p>

<h2>7. Comportement de l'utilisateur</h2>
<p>L'utilisateur s'engage à ne pas :</p>
<ul>
<li>Publier de contenu illicite, diffamatoire, injurieux ou discriminatoire</li>
<li>Porter atteinte à la vie privée d'autrui</li>
<li>Tenter d'accéder à des zones non autorisées du site</li>
<li>Utiliser le site à des fins commerciales non autorisées</li>
<li>Collecter des données personnelles d'autres utilisateurs</li>
</ul>

<h2>8. Responsabilité</h2>
<p>L'éditeur s'efforce de fournir des informations aussi précises que possible, mais ne garantit pas :</p>
<ul>
<li>L'exactitude, la complétude ou l'actualité des informations publiées</li>
<li>La disponibilité permanente du site</li>
<li>L'absence de virus ou de défauts de fonctionnement</li>
</ul>
<p>L'éditeur décline toute responsabilité pour les dommages directs ou indirects résultant de l'utilisation du site.</p>

<h2>9. Liens hypertextes</h2>
<p>Le site peut contenir des liens vers des sites tiers. L'éditeur n'est pas responsable du contenu de ces sites et n'exerce aucun contrôle sur eux.</p>

<h2>10. Données personnelles</h2>
<p>Le traitement des données personnelles est décrit dans notre <a href="/politique-de-confidentialite">Politique de confidentialité</a>, accessible depuis le pied de page du site.</p>

<h2>11. Modification des CGU</h2>
<p>L'éditeur se réserve le droit de modifier les présentes CGU à tout moment. Les utilisateurs inscrits seront informés par email de toute modification substantielle. La date de mise à jour figure en haut de page.</p>

<h2>12. Droit applicable</h2>
<p>Les présentes CGU sont régies par le droit français. En cas de litige, les tribunaux français seront compétents.</p>

<h2>13. Contact</h2>
<table>
<tbody>
<tr><td><strong>Email</strong></td><td>{{EMAIL_CONTACT}}</td></tr>
<tr><td><strong>Courrier</strong></td><td>{{RAISON_SOCIALE}} — {{ADRESSE}}</td></tr>
</tbody>
</table>
HTML;
    }
}
