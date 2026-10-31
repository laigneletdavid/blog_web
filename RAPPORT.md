# Plan rapport mensuel - Blog&Web CMS

> Cahier des charges du 31/10/2026 (David). Rien n'est code.

**Statut : R1 livree (31/10/2026)** — `app:report:monthly` (`MonthlyReportBuilder`,
`templates/emails/monthly_report.html.twig`), envoi aux super admins seulement.
Clics d'itineraire comptes (`directions_click`).

```bash
php bin/console app:report:monthly --html                  # var/report-YYYY-MM.html, rien n'est envoye
php bin/console app:report:monthly --month=2026-10 --to=moi@exemple.fr
```

`REPORT_CONTACT_EMAIL` (`.env.local`) : adresse du bouton « Me contacter ».

Deux envois distincts :

- **Rapport mensuel**, pour le client (ROLE_ADMIN du site) : une page, lisible en
  2 minutes, sans jargon.
- **Alertes hebdo**, pour le super admin seulement, et seulement en cas d'anomalie.

---

## Sommaire

1. [Le rapport mensuel](#1-le-rapport-mensuel)
2. [Les alertes hebdo](#2-les-alertes-hebdo)
3. [D'ou viennent les chiffres](#3-dou-viennent-les-chiffres)
4. [Points a trancher](#4-points-a-trancher)
5. [Architecture proposee](#5-architecture-proposee)
6. [Phases](#6-phases)

---

## 1. Le rapport mensuel

Envoi entre le 3 et le 5 du mois. Une page.

### 1.1 En-tete : le mois en une phrase

- Trois chiffres cles, avec leur fleche d'evolution par rapport au mois precedent :
  visiteurs (module stats), apparitions dans Google et clics depuis Google
  (Search Console).
- Une phrase de synthese generee par LintellO : « Bon mois : votre site a ete vu
  1 240 fois dans Google (+18 %). » Avant LintellO, une phrase a partir de modeles.

### 1.2 Votre visibilite dans Google (Search Console)

- Impressions et clics, formules simplement : « votre site est apparu X fois »,
  « X personnes ont clique ».
- Position moyenne traduite : « en moyenne en page 2 ».
- Courbe des clics sur 6 mois glissants.

### 1.3 Ce que les gens tapent pour vous trouver (Search Console)

- Les 5 premieres requetes, avec clics et position.
- La nouvelle requete du mois, mise en avant.

### 1.4 Vos pages qui marchent (module + Search Console)

- Les 3 a 5 pages les plus vues.
- L'article du mois et ses premiers resultats.

### 1.5 Les opportunites (Search Console)

- Requetes en positions 8 a 20 avec beaucoup d'impressions : « Vous etes presque
  en premiere page sur… ».
- Elles donnent le sujet propose pour le mois suivant.

### 1.6 Vos visiteurs et vos contacts (module)

- Visiteurs uniques, sources regroupees (Google, acces direct, reseaux sociaux,
  autres sites), part mobile.
- Contacts generes : appels (`tel:`), formulaires, e-mails (`mailto:`), itineraires.

Exemple de rendu :

```
312 visiteurs (+12 %), dont 58 % via Google · 70 % sur mobile
9 appels · 4 formulaires · 2 itineraires
```

### 1.7 Sante du site : feu vert, orange ou rouge

Pages indexees, erreurs Search Console, certificat SSL, vitesse. Le detail
seulement si quelque chose ne va pas.

### 1.8 Le mois prochain

Une ou deux actions concretes, et un bouton « Valider le sujet » ou « Me contacter ».

### A eviter

Taux de rebond, CTR detaille, plus de 5 lignes par tableau, mots anglais.

---

## 2. Les alertes hebdo

Pour le super admin seulement, envoyees uniquement en cas d'anomalie :

- impressions en chute de plus de 50 % ;
- erreurs de couverture dans Search Console ;
- site en panne ou SSL qui expire ;
- aucun article depuis plus de 30 jours ;
- grand ecart entre les visites venues de Google (module) et les clics Search
  Console : signe d'un probleme de mesure.

A ajouter (constats d'octobre 2026) : erreurs critiques dans `var/log/prod.log`
(admin bw_pro_dici en panne sans que personne le sache), taille des tables de
stats, compteur de robots qui s'envole (vague en cours), cron de purge qui ne
tourne plus.

---

## 3. D'ou viennent les chiffres

| Donnee | Source | Existe ? |
|--------|--------|----------|
| Visiteurs, visiteurs uniques | `page_view`, `stat_session` (visites confirmees par le navigateur, robots exclus) | oui |
| Sources regroupees | `stat_session.source` (`SourceClassifier`) | oui, regroupement a faire |
| Part mobile | `stat_session.device_type` | oui |
| Pages les plus vues | `page_view` | oui |
| Appels, e-mails | `stat_conversion` : `phone_click`, `email_click` | oui |
| Formulaires | `stat_conversion` : `form_submit`, `landing_form_submit` | oui |
| Itineraires | clics vers Google Maps / OpenStreetMap | **non** |
| Article du mois | `article` publie dans le mois + ses vues | oui |
| Impressions, clics, position, requetes | API Search Console `searchanalytics.query` | **non** |
| Pages indexees, erreurs de couverture | API Search Console (URL Inspection / sitemaps) | **non** |
| Vitesse | API PageSpeed Insights | **non** |
| Certificat SSL | lecture du certificat depuis le serveur | **non** |

Exclusions deja en place cote module : robots (user-agent, cadence par IP,
JavaScript non execute), sessions admin (ROLE_AUTHOR).

---

## 4. Points a trancher

1. **Acces Search Console.** TRANCHE (31/10) — oui, mais en phase 2, avec l'API
   LintellO : au plus simple (un compte de service unique, ajoute en lecture a
   chaque propriete « Domaine », pas d'OAuth par client). Search Console est
   surtout un atout pour LintellO : il pourra proposer des modifications du site
   pour gagner des places. Emplacement de la cle JSON a fixer en phase 2.
2. **Copie mensuelle des donnees Search Console** dans la base : Search Console ne
   garde que 16 mois, et la courbe 6 mois glissants doit pouvoir etre recalculee.
3. **Seuil des opportunites** : impressions minimales selon la taille du site
   (proportionnel aux impressions totales du mois ?).
4. **Destinataires** : TRANCHE (31/10) — tous les comptes ROLE_ADMIN du site.
5. **Boutons « Valider le sujet » / « Me contacter »** : TRANCHE (31/10) — liens
   mailto vers David, site et sujet pre-remplis. Rien a developper.
6. **Itineraires** : TRANCHE (31/10) — oui, clics sur les liens de carte comptes
   comme contact (nouveau type de conversion `directions_click`).
7. **Argument CNIL** (statistiques sans bandeau de consentement) : verifier les
   conditions point par point avant de le promettre. Atouts actuels : pas de
   user-agent stocke, IP hachee avec la date, robots exclus, cookie first-party
   de 30 min, conservation 13 mois.
8. **Part LintellO** : phrase de synthese, commentaire des opportunites, sujet
   propose. Les donnees du rapport doivent etre un tableau structure, que LintellO
   recoit tel quel (comme la fiche Referencement).

---

## 5. Architecture proposee

- `MonthlyReportBuilder` : construit un objet `MonthlyReport` (donnees seules,
  aucune mise en forme) a partir du module et de Search Console.
- `SearchConsoleClient` : `searchanalytics.query`, dimensions `query` et `page`,
  mois M et M-1 ; ecrit la copie mensuelle en base.
- `app:report:monthly` : construit et envoie (Brevo), lancee par le cron OVH le
  3 du mois. `--dry-run` pour voir le rapport sans l'envoyer.
- `app:report:alerts` : controles hebdo, n'envoie rien si tout va bien.
- E-mail en Twig, une colonne, lisible sur mobile ; meme rendu en page HTML dans
  l'admin (« Voir le rapport du mois »).
- Plus tard : `LintellOClient` remplace les phrases a modeles.

Un seul script cron par serveur pour la purge, les alertes et le rapport (le
planificateur OVH limite le nombre de taches).

---

## 6. Phases

| Phase | Contenu |
|-------|---------|
| R1 | Rapport sans Search Console : visiteurs, sources, mobile, pages, contacts (itineraires compris), sante (SSL, dernier article). Envoi au super admin seulement, pour valider le rendu |
| R2 | Avec l'API LintellO : Search Console (compte de service, copie mensuelle, sections 1.2, 1.3, 1.5, chiffres Google de l'en-tete), synthese et sujet du mois, propositions de modifications du site pour le referencement |
| R3 | Envoi aux admins du site (cron OVH le 3 du mois), boutons mailto |
| R4 | Alertes hebdo super admin |
