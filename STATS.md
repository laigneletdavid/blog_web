# Plan Module Statistiques - Blog&Web CMS

> Redige le 20/05/2026 — Objectif : passer d'un compteur de pages vues a un vrai outil d'analyse comportementale

---

## Sommaire

1. [Existant et limites](#1-existant-et-limites)
2. [Architecture BDD cible](#2-architecture-bdd-cible)
3. [Niveau 1 — Acquisition](#3-niveau-1--acquisition)
4. [Niveau 2 — Comportement](#4-niveau-2--comportement)
5. [Niveau 3 — Parcours](#5-niveau-3--parcours)
6. [Niveau 4 — Conversion](#6-niveau-4--conversion)
7. [UX/UI du dashboard admin](#7-uxui-du-dashboard-admin)
8. [RGPD — Ce qu'on peut faire et ne pas faire](#8-rgpd--ce-quon-peut-faire-et-ne-pas-faire)
9. [Plan d'implementation](#9-plan-dimplementation)
10. [Fichiers a modifier/creer](#10-fichiers-a-modifiercreer)

---

## 1. Existant et limites

### Ce qu'on a

- **1 entite** : `PageView` (url, ipHash, userAgent, referer, isBot, createdAt)
- **1 subscriber** : `PageViewSubscriber` (kernel.response, filtre bots 25+ patterns, exclut admins)
- **1 service** : `AdminStatsService` (agrege les KPI pour le dashboard)
- **1 dashboard** : KPI cards + chart 30j (Chart.js) + top pages filtrable par periode
- **RGPD** : IP hashee par jour (`sha256(ip + date)`), pas de cookie traceur
- **Google Analytics** : optionnel, conditionne au cookie consent

### Ce qui manque

| Besoin | Etat |
|--------|------|
| Sessions (regrouper les pages vues d'un visiteur) | Inexistant |
| Source d'acquisition classifiee (SEO, social, direct...) | Referer brut stocke mais pas parse |
| Parametres UTM | Non captures |
| Duree sur la page | Inexistant (pas de JS de tracking) |
| Profondeur de scroll | Inexistant |
| Taux de rebond | Impossible sans sessions |
| Parcours visiteur (page precedente, suivante) | Inexistant |
| Conversions (clic tel, mailto, formulaire) | Inexistant |
| Stockage des formulaires de contact | Le formulaire est envoye par email mais PAS stocke en BDD |

---

## 2. Architecture BDD cible

On passe de **1 table** a **4 tables** (3 nouvelles + enrichissement de l'existante).

### Table `stat_session` (NOUVELLE)

Regroupe les page views d'un meme visiteur pendant une visite.

```
stat_session
├── id                  INT AUTO_INCREMENT PK
├── session_token       VARCHAR(64) UNIQUE     -- Cookie first-party _bw_sid
├── started_at          DATETIME_IMMUTABLE     -- Premiere page vue
├── ended_at            DATETIME_IMMUTABLE     -- Derniere activite (mis a jour par ping JS)
├── source              VARCHAR(30)            -- Enum: seo_google, seo_bing, social_linkedin,
│                                                 social_facebook, social_other, direct,
│                                                 email, referral, other
├── source_detail       VARCHAR(500) NULL      -- Referer brut ou utm_source
├── utm_campaign        VARCHAR(255) NULL      -- Parametre utm_campaign
├── utm_medium          VARCHAR(100) NULL      -- Parametre utm_medium
├── landing_page        VARCHAR(500)           -- Premiere URL visitee
├── exit_page           VARCHAR(500)           -- Derniere URL (mis a jour)
├── page_count          SMALLINT DEFAULT 1     -- Nombre de pages vues (incremente)
├── ip_hash             VARCHAR(64)            -- Meme hash que page_view (RGPD)
├── user_agent          VARCHAR(500) NULL
├── is_bot              TINYINT DEFAULT 0
├── device_type         VARCHAR(10) NULL       -- desktop, mobile, tablet (parse du UA)
│
├── INDEX idx_session_started (started_at)
├── INDEX idx_session_source (source)
├── INDEX idx_session_token (session_token)
├── INDEX idx_session_bot (is_bot)
```

### Table `page_view` (ENRICHIE)

Ajouter des colonnes a la table existante.

```
page_view (colonnes ajoutees)
├── session_id          INT NULL FK → stat_session(id)   -- Rattachement a la session
├── previous_url        VARCHAR(500) NULL                -- Page precedente dans la session
├── sequence_number     SMALLINT DEFAULT 1               -- Ordre dans la session (1, 2, 3...)
├── duration_seconds    SMALLINT NULL                    -- Duree sur la page (via JS ping)
├── scroll_max_pct      TINYINT NULL                     -- Scroll max atteint (0-100)
│
├── INDEX idx_pageview_session (session_id)
```

### Table `stat_conversion` (NOUVELLE)

Enregistre les actions "business" (leads).

```
stat_conversion
├── id                  INT AUTO_INCREMENT PK
├── session_id          INT NULL FK → stat_session(id)
├── type                VARCHAR(20)            -- phone_click, email_click, form_submit
├── page_url            VARCHAR(500)           -- Page ou la conversion a eu lieu
├── detail              TEXT NULL               -- Sujet du formulaire, ou NULL pour clics
├── created_at          DATETIME_IMMUTABLE
│
├── INDEX idx_conversion_session (session_id)
├── INDEX idx_conversion_type (type)
├── INDEX idx_conversion_created (created_at)
```

### Table `contact_message` (NOUVELLE)

Stocker les soumissions de formulaire de contact (aujourd'hui c'est juste un email envoye, rien en BDD).

```
contact_message
├── id                  INT AUTO_INCREMENT PK
├── session_id          INT NULL FK → stat_session(id)   -- Lien avec la session du visiteur
├── name                VARCHAR(100)
├── firstname           VARCHAR(100)
├── email               VARCHAR(255)
├── subject             VARCHAR(255)
├── message             TEXT
├── ip_hash             VARCHAR(64)                      -- RGPD : hash, pas IP en clair
├── source_page         VARCHAR(500) NULL                -- Depuis quelle page le formulaire a ete soumis
├── created_at          DATETIME_IMMUTABLE
├── is_read             TINYINT DEFAULT 0                -- Lu/non lu dans l'admin
│
├── INDEX idx_contact_created (created_at)
├── INDEX idx_contact_read (is_read)
```

Note : cette table sert AUSSI pour le dashboard contact dans l'admin (lister les messages recus, marquer comme lu, etc.). Double usage.

---

## 3. Niveau 1 — Acquisition

### Objectif

Repondre a : "D'ou viennent mes visiteurs ?"

### Donnees collectees

A chaque nouvelle session, on parse le referer et les parametres UTM pour classifier la source :

```php
// Logique de classification dans un service SourceClassifier
public function classify(?string $referer, ?string $utmSource, ?string $utmMedium): array
{
    // 1. UTM prioritaire (liens campagne)
    if ($utmSource) {
        return match(true) {
            str_contains($utmSource, 'newsletter') => ['email', $utmSource],
            str_contains($utmSource, 'linkedin')   => ['social_linkedin', $utmSource],
            str_contains($utmSource, 'facebook')    => ['social_facebook', $utmSource],
            default                                  => ['other', $utmSource],
        };
    }

    // 2. Parse du referer
    if (!$referer) return ['direct', null];

    $host = parse_url($referer, PHP_URL_HOST) ?? '';
    return match(true) {
        str_contains($host, 'google')   => ['seo_google', $referer],
        str_contains($host, 'bing')     => ['seo_bing', $referer],
        str_contains($host, 'linkedin') => ['social_linkedin', $referer],
        str_contains($host, 'facebook') => ['social_facebook', $referer],
        str_contains($host, 'instagram')=> ['social_other', $referer],
        str_contains($host, 'twitter')  => ['social_other', $referer],
        $host !== ''                     => ['referral', $referer],
        default                          => ['direct', null],
    };
}
```

### Rendu UX admin

**Composant : Donut chart "Sources de trafic"**

```
┌─────────────────────────────────────────────┐
│  Sources de trafic          [7j ▼] [2026 ▼] │
│                                              │
│       ┌──────┐   SEO Google ████████ 62%     │
│      /  donut \  Direct     ████     18%     │
│     │  chart   │ LinkedIn   ███      12%     │
│      \        /  Email      ██        5%     │
│       └──────┘   Autre      █         3%     │
│                                              │
└─────────────────────────────────────────────┘
```

- Chart.js doughnut, memes couleurs que le design system existant
- Filtre par periode (reprendre le pattern `<select>` du top pages actuel)
- Au hover sur une part : nombre de sessions + pourcentage

**Composant : Top pages d'entree**

```
┌──────────────────────────────────────────────┐
│  Pages d'entree             [7j ▼] [2026 ▼]  │
│──────────────────────────────────────────────│
│  /                                    145     │
│  /article/comment-apparaitre-google    89     │
│  /services                             34     │
│  /contact                              22     │
│  /article/refonte-site-web             18     │
└──────────────────────────────────────────────┘
```

- Meme pattern que le "Top pages" actuel mais filtre sur `landing_page` de `stat_session`
- Ajouter un indicateur de tendance (fleche haut/bas vs periode precedente) — phase 2

---

## 4. Niveau 2 — Comportement

### Objectif

Repondre a : "Comment se comportent mes visiteurs ?"

### Donnees collectees

**Cote serveur** (dans `PageViewSubscriber`) :
- `sequence_number` : incremente a chaque page vue dans la session
- `previous_url` : URL de la page precedente (depuis la session en cours)
- `page_count` sur `stat_session` : incremente

**Cote client** (nouveau fichier JS `stat-tracker.js`) :

```javascript
// Heartbeat : ping toutes les 15s tant que l'onglet est actif
// Met a jour duration_seconds sur la page_view courante
setInterval(() => {
    if (!document.hidden) {
        navigator.sendBeacon('/api/stat/ping', JSON.stringify({
            token: sessionToken,
            pageViewId: currentPageViewId,
            duration: Math.round((Date.now() - pageEnteredAt) / 1000)
        }));
    }
}, 15000);

// Scroll tracking : envoie le max scroll atteint
// Ecoute l'evenement scroll, stocke le max localement,
// envoie au beforeunload via sendBeacon
let maxScroll = 0;
window.addEventListener('scroll', () => {
    const pct = Math.round(
        (window.scrollY + window.innerHeight) / document.body.scrollHeight * 100
    );
    maxScroll = Math.max(maxScroll, pct);
});

window.addEventListener('beforeunload', () => {
    navigator.sendBeacon('/api/stat/scroll', JSON.stringify({
        pageViewId: currentPageViewId,
        scrollPct: maxScroll
    }));
});
```

**API endpoints** (nouveau `StatApiController`) :
- `POST /api/stat/ping` → met a jour `duration_seconds` + `ended_at` de la session
- `POST /api/stat/scroll` → met a jour `scroll_max_pct`
- `POST /api/stat/conversion` → insere dans `stat_conversion`

### Metriques calculees

```
Duree moyenne par page = AVG(duration_seconds) WHERE duration_seconds IS NOT NULL

Taux de rebond = COUNT(sessions WHERE page_count = 1) / COUNT(sessions) * 100

Profondeur moyenne = AVG(page_count) sur les sessions

Scroll moyen = AVG(scroll_max_pct) pour une URL donnee
```

### Rendu UX admin

**Composant : 4 KPI cards comportementales** (meme style que les KPI existants)

```
┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ ⏱ 2m 34s     │ │ ↩ 42%        │ │ 📄 3.2 pages │ │ 📜 68%       │
│ Duree moy.   │ │ Taux rebond  │ │ Profondeur   │ │ Scroll moy.  │
│ ▲ +12%       │ │ ▼ -5%        │ │ ▲ +0.4       │ │ ▲ +8%        │
└──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘
```

- Sous chaque valeur : evolution vs periode precedente (fleche + pourcentage + couleur vert/rouge)
- Couleurs : `#2563eb` (duree), `#d97706` (rebond), `#7c3aed` (profondeur), `#16a34a` (scroll)

**Composant : Graphe temporel comportement** (comme le chart 30j actuel)

```
┌─────────────────────────────────────────────────────────────┐
│  Comportement des 30 derniers jours    [Duree ▼]            │
│                                                              │
│  4min ┤                                                      │
│  3min ┤          ╱╲     ╱╲                                   │
│  2min ┤    ╱╲  ╱    ╲ ╱    ╲    ╱╲                          │
│  1min ┤  ╱    ╲╱      ╲      ╲╱    ╲                        │
│  0min ┼──────────────────────────────────                    │
│       20 avr                              20 mai             │
└─────────────────────────────────────────────────────────────┘
```

- Chart.js line, meme structure que `visitsChart` existant
- Dropdown pour switcher la metrique : Duree moy., Taux de rebond, Profondeur, Scroll moy.
- Une seule courbe a la fois (pas surcharger)

**Composant : Detail par page** (tableau enrichi)

Remplacer le tableau "Top pages" actuel (qui ne montre que URL + vues) par un tableau plus riche :

```
┌───────────────────────────────────────────────────────────────────────────┐
│  Pages les plus vues                              [7j ▼] [2026 ▼]        │
│─────────────────────────────────────────────────────────────────────────│
│  Page                              Vues   Duree moy.  Scroll  Rebond    │
│  /                                  412   0:45        32%     68%       │
│  /article/apparaitre-google         189   3:12        84%     22%  ★   │
│  /services                           87   1:08        56%     45%       │
│  /contact                            64   2:24        72%     12%  ★   │
│  /article/refonte-site-web           52   2:48        78%     28%  ★   │
└───────────────────────────────────────────────────────────────────────────┘
```

- ★ = pages avec un bon score d'engagement (duree > 2min ET scroll > 70%)
- Cliquer sur une ligne ouvre le detail de la page (mini-fiche)
- Colonnes triables

---

## 5. Niveau 3 — Parcours

### Objectif

Repondre a : "Comment les visiteurs naviguent dans le site ?"

### Donnees utilisees

Les champs `previous_url` et `sequence_number` de `page_view` + `landing_page`/`exit_page` de `stat_session`.

### Metriques calculees

```sql
-- Top pages suivantes pour une page X
SELECT pv.url AS next_page, COUNT(*) AS cnt
FROM page_view pv
WHERE pv.previous_url = '/article/xxx'
  AND pv.is_bot = 0
GROUP BY pv.url
ORDER BY cnt DESC
LIMIT 5;

-- Top pages precedentes pour une page X
SELECT pv.previous_url, COUNT(*) AS cnt
FROM page_view pv
WHERE pv.url = '/article/xxx'
  AND pv.previous_url IS NOT NULL
  AND pv.is_bot = 0
GROUP BY pv.previous_url
ORDER BY cnt DESC
LIMIT 5;

-- Taux de sortie pour une page X
SELECT
    COUNT(DISTINCT s.id) AS sessions_avec_page,
    COUNT(DISTINCT CASE WHEN s.exit_page = '/article/xxx' THEN s.id END) AS sessions_sortie
FROM stat_session s
JOIN page_view pv ON pv.session_id = s.id
WHERE pv.url = '/article/xxx' AND s.is_bot = 0;
-- Taux de sortie = sessions_sortie / sessions_avec_page * 100
```

### Rendu UX admin

**Composant : Mini-flux de parcours** (dans la fiche detail d'une page)

Plutot qu'un Sankey diagram complexe (trop lourd pour des petits clients), on fait un **flux simplifie en 3 colonnes** :

```
┌─────────────────────────────────────────────────────────────┐
│  Parcours autour de : /article/apparaitre-google            │
│                                                              │
│  ← D'ou viennent-ils       PAGE        Ou vont-ils →       │
│                                                              │
│  / (accueil)     ███ 42%              /contact      ███ 28% │
│  SEO Google      ██  31%    ┌──┐      /services     ██  22% │
│  /blog           █   15%    │  │      /blog          █  18% │
│  /services       █    8%    └──┘      Sortie ↗      ██  24% │
│  Autre           ░    4%              Autre          █   8% │
│                                                              │
│  Taux de sortie : 24%    Duree moy. : 3m12                  │
└─────────────────────────────────────────────────────────────┘
```

- 3 colonnes : sources a gauche, page au centre, destinations a droite
- Barres horizontales proportionnelles (CSS simple, pas de lib externe)
- "Sortie" = le visiteur quitte le site sur cette page
- "SEO Google" = c'est une page d'entree directe (landing_page)
- Accessible depuis le tableau "Detail par page" en cliquant sur une ligne

**Composant : Pages de sortie problematiques** (tableau)

```
┌──────────────────────────────────────────────────────────────┐
│  ⚠ Pages ou les visiteurs quittent le site    [30j ▼]        │
│────────────────────────────────────────────────────────────│
│  Page                              Taux sortie   Sessions   │
│  /tarifs                              72%           45       │
│  /article/devis-site-web              58%           31       │
│  /services                            45%           87       │
│  /contact (apres soumission)          38%           64  ✓    │
└──────────────────────────────────────────────────────────────┘
```

- ✓ = sortie "normale" (la page contact apres soumission, c'est attendu)
- Les autres = opportunites d'amelioration (ajouter un CTA, ameliorer le contenu)

---

## 6. Niveau 4 — Conversion

### Definition d'une conversion

On definit **3 types de conversion**, tous clairs et mesurables :

| Type | Declencheur | Comment on le detecte |
|------|------------|----------------------|
| `phone_click` | Clic sur un lien `tel:` | JS : listener sur `a[href^="tel:"]` → `POST /api/stat/conversion` |
| `email_click` | Clic sur un lien `mailto:` | JS : listener sur `a[href^="mailto:"]` → `POST /api/stat/conversion` |
| `form_submit` | Formulaire de contact valide | Cote serveur dans `HomeController::contact()`, apres validation reussie |

Note : `form_submit` est la conversion la plus fiable. Les clics `tel:` et `mailto:` sont des **intentions** (le visiteur peut annuler apres le clic). Mais c'est le mieux qu'on puisse faire cote web.

### Tracking JS des clics

```javascript
// Dans stat-tracker.js
document.addEventListener('click', (e) => {
    const link = e.target.closest('a[href^="tel:"], a[href^="mailto:"]');
    if (!link) return;

    const type = link.href.startsWith('tel:') ? 'phone_click' : 'email_click';
    navigator.sendBeacon('/api/stat/conversion', JSON.stringify({
        token: sessionToken,
        type: type,
        pageUrl: window.location.pathname,
    }));
});
```

### Tracking serveur des formulaires

```php
// Dans HomeController::contact(), apres l'envoi du mail reussi :
$contactMessage = new ContactMessage();
$contactMessage->setName($data['name']);
$contactMessage->setFirstname($data['firstname']);
$contactMessage->setEmail($data['email']);
$contactMessage->setSubject($data['subject']);
$contactMessage->setMessage($data['message']);
$contactMessage->setIpHash($ipHash);
$contactMessage->setSourcePage($request->headers->get('Referer'));
// Rattacher la session si cookie present
if ($sessionToken = $request->cookies->get('_bw_sid')) {
    $session = $sessionRepo->findOneBy(['sessionToken' => $sessionToken]);
    $contactMessage->setSession($session);
}
$em->persist($contactMessage);

// Aussi inserer une stat_conversion
$conversion = new StatConversion();
$conversion->setSession($session);
$conversion->setType('form_submit');
$conversion->setPageUrl('/contact');
$conversion->setDetail($data['subject']);
$em->persist($conversion);
```

### Rendu UX admin

**Composant : KPI conversions** (3 cards)

```
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ 📞 12        │ │ 📧 8         │ │ 📝 23        │
│ Appels       │ │ Emails       │ │ Formulaires  │
│ ce mois      │ │ ce mois      │ │ ce mois      │
│ ▲ +3         │ │ ═ stable     │ │ ▲ +7         │
└──────────────┘ └──────────────┘ └──────────────┘
```

**Composant : Taux de conversion global**

```
┌──────────────────────────────────────────────────────────────────┐
│  Entonnoir de conversion                         [30j ▼]         │
│                                                                   │
│  Visiteurs uniques     ████████████████████████████████  1 245    │
│  > 2 pages vues        ████████████████████             682 (55%)│
│  Vu page contact       ████████████                      312 (25%)│
│  Conversions           ████                               43 (3.5%)│
│                                                                   │
│  Taux de conversion global : 3.5%                                │
└──────────────────────────────────────────────────────────────────┘
```

- Barres decroissantes (entonnoir horizontal)
- Pourcentages par rapport au premier niveau
- Simple a comprendre pour un client non-technique

**Composant : Tableau des conversions recentes** (le "qui a converti ?")

```
┌───────────────────────────────────────────────────────────────────────────────┐
│  Conversions recentes                                        [30j ▼]          │
│──────────────────────────────────────────────────────────────────────────────│
│  Date          Source          Parcours resume              Type      Detail  │
│  20/05 14:38   SEO Google      / → Services → Contact      📝 Form  "Devis" │
│  19/05 09:12   LinkedIn        Article SEO → Contact        📞 Appel  —      │
│  18/05 16:45   Direct          / → Tarifs                   📧 Email  —      │
│  17/05 11:20   SEO Google      Article → Services → Contact 📝 Form  "RDV"   │
└───────────────────────────────────────────────────────────────────────────────┘
```

- Le parcours resume est reconstruit depuis `page_view` filtre par `session_id`, ordonne par `sequence_number`
- Maximum 5 etapes affichees, avec `...` si plus
- Cliquer sur une ligne de formulaire ouvre le detail du message (depuis `contact_message`)

**Composant : Pages qui convertissent**

```
┌────────────────────────────────────────────────────────────┐
│  Pages moteur (derniere page avant conversion)   [30j ▼]   │
│──────────────────────────────────────────────────────────│
│  /services                              15 conversions     │
│  /article/apparaitre-google              8 conversions     │
│  /tarifs                                 7 conversions     │
│  /contact                                6 conversions     │
│  /article/refonte-site-web               4 conversions     │
└────────────────────────────────────────────────────────────┘
```

---

## 7. UX/UI du dashboard admin

### Architecture des ecrans

Aujourd'hui, tout est sur une seule page `/admin`. On va garder le dashboard principal allege et ajouter une **section Stats dediee** dans le menu EasyAdmin.

```
/admin                          → Dashboard (KPI existants + resume stats)
/admin/stats                    → Vue d'ensemble stats (4 KPI comportement + sources)
/admin/stats/acquisition        → Detail acquisition (sources, UTM, pages d'entree)
/admin/stats/comportement       → Detail comportement (duree, scroll, rebond par page)
/admin/stats/conversions        → Conversions + entonnoir + tableau "qui a converti"
/admin/stats/page/{url}         → Fiche detail d'une page (parcours + metriques)
/admin/messages                 → Liste des messages de contact recus (CRUD)
```

### Enrichissement du dashboard principal

On ne surcharge pas le dashboard existant. On ajoute juste **un bloc resume** sous le chart 30j :

```
┌────────────────────────────────────────────────────────────────┐
│  Resume mensuel                                    Voir tout → │
│                                                                 │
│  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐               │
│  │ 62%    │  │ 42%    │  │ 2m34   │  │ 43     │               │
│  │ SEO    │  │ Rebond │  │ Duree  │  │ Leads  │               │
│  └────────┘  └────────┘  └────────┘  └────────┘               │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

- 4 mini-KPI en une ligne (source principale, taux rebond, duree moy., conversions du mois)
- Lien "Voir tout →" vers `/admin/stats`

### Design system

Reutiliser les composants CSS existants :
- `.bw-kpi` + `.bw-kpi--compact` pour les KPI cards
- `.bw-card` + `.bw-card__header` + `.bw-card__body` pour les sections
- Chart.js (deja en place) pour les graphiques
- Palette existante : bleu `#2563eb`, orange `#d97706`, vert `#16a34a`, violet `#7c3aed`, rose `#db2777`
- Ajouter `.bw-funnel` pour l'entonnoir de conversion (barres horizontales degrades)
- Ajouter `.bw-flow` pour le mini-flux de parcours (3 colonnes)

### Filtre global de periode

Pattern identique au "Top pages" actuel : `<select>` dans le header de la card.
Periodes disponibles : Aujourd'hui, 7 jours, 30 jours, Ce mois, Ce trimestre, Cette annee.

Implementer le filtre via query params (`?period=7d&year=2026`) pour que l'URL soit partageable/bookmarkable.

---

## 8. RGPD — Ce qu'on peut faire et ne pas faire

### Ce qui est OK (interet legitime, pas besoin de consentement)

| Donnee | Base legale | Justification |
|--------|-------------|---------------|
| IP hashee par jour | Interet legitime | Pas de donnee personnelle (hash irreversible + sel journalier) |
| Pages vues (URL, timestamp) | Interet legitime | Donnee anonyme, aucune identification possible |
| User-Agent (parse device) | Interet legitime | Statistique technique, pas d'identification |
| Referer HTTP | Interet legitime | Donne la source, pas l'identite |
| Cookie first-party `_bw_sid` | Interet legitime | Cookie technique de session, pas traceur publicitaire. Expire en 30 min. Pas de tracking cross-site |
| Duree, scroll, parcours | Interet legitime | Donnees comportementales anonymes rattachees a la session |
| Conversions (type, page) | Interet legitime | Statistique d'usage, pas d'identification |

**Pourquoi l'interet legitime fonctionne ici :**
Le RGPD distingue les cookies "strictement necessaires" et les cookies "traceurs". Un cookie first-party de session analytics (sans identification, sans cross-site, sans partage a des tiers) releve de l'interet legitime du responsable de traitement, **a condition que** :
- Il ne permet pas d'identifier une personne physique
- Il n'est pas partage avec des tiers
- Il expire en session (ou courte duree)
- L'IP n'est pas stockee en clair

C'est exactement la position de la CNIL sur les outils de mesure d'audience "exemptes de consentement" (cf. recommandation Matomo/Piwik).

### Ce qui NECESSITE le consentement ou une base legale specifique

| Donnee | Base legale necessaire | Notre approche |
|--------|----------------------|----------------|
| Formulaire de contact (nom, email, message) | Consentement (soumission volontaire du formulaire) | L'utilisateur soumet le formulaire = consentement explicite. Stocker en BDD = OK |
| Clic sur lien tel/mailto | Interet legitime | On ne stocke PAS le numero/email clique, juste le fait qu'un clic a eu lieu sur la page X |
| Google Analytics | Consentement (cookie tiers) | Deja gere via le cookie consent banner existant |

### Cas specifique : relier session + formulaire de contact

**Question : peut-on afficher le parcours d'un visiteur qui a soumis un formulaire ?**

**Oui, sous conditions :**
1. L'utilisateur a volontairement soumis le formulaire (acte positif = consentement pour le traitement de sa demande)
2. On relie la session anonyme a la soumission de formulaire via le `session_id`
3. La session ne contient PAS de donnee personnelle (juste des URLs et timestamps)
4. Le parcours reconstitue montre "/ → /services → /contact" — ce sont des URLs, pas des donnees personnelles
5. Le seul moment ou on a une identite, c'est le formulaire lui-meme (nom, email) — et le visiteur l'a fourni volontairement

**Ce qu'on NE fait PAS :**
- On ne stocke jamais l'IP en clair
- On ne fait PAS de reverse DNS pour identifier l'entreprise (ce serait un autre niveau de traitement)
- On ne partage AUCUNE donnee avec des tiers
- On ne track PAS les visiteurs qui ne soumettent pas de formulaire (ils restent 100% anonymes)
- On ne fait PAS de profilage (pas de score, pas de categorisation automatique)

### Mentions a ajouter

Mettre a jour la page "Politique de confidentialite" (generee par le CMS) pour mentionner :
- L'utilisation de cookies de mesure d'audience first-party (exemptes de consentement CNIL)
- Le stockage des messages de formulaire de contact
- La duree de conservation (recommande : 13 mois pour les stats, 3 ans pour les messages contact)

---

## 9. Plan d'implementation

### Phase 1 — Fondations (sessions + sources)

**Objectif :** Regrouper les pages vues en sessions, classifier les sources.

| Tache | Fichier | Detail |
|-------|---------|--------|
| Creer entite `StatSession` | `src/Entity/StatSession.php` | Schema defini en section 2 |
| Creer entite `ContactMessage` | `src/Entity/ContactMessage.php` | Schema defini en section 2 |
| Enrichir entite `PageView` | `src/Entity/PageView.php` | Ajouter session_id, previous_url, sequence_number, duration_seconds, scroll_max_pct |
| Migration Doctrine | `migrations/VersionXXX.php` | Creer stat_session, contact_message, ALTER page_view |
| Creer `SourceClassifier` | `src/Service/SourceClassifier.php` | Logique de classification referer/UTM |
| Modifier `PageViewSubscriber` | `src/EventSubscriber/PageViewSubscriber.php` | Creer/rattacher session, poser cookie `_bw_sid`, capturer UTM, previous_url |
| Stocker formulaires contact | `src/Controller/HomeController.php` | Persister `ContactMessage` en BDD + creer `StatConversion` |
| CRUD messages admin | `src/Controller/Admin/ContactMessageCrudController.php` | Liste, detail, marquer comme lu |

### Phase 2 — Tracking JS comportemental

**Objectif :** Mesurer duree, scroll, clics conversion.

| Tache | Fichier | Detail |
|-------|---------|--------|
| Creer `stat-tracker.js` | `assets/js/stat-tracker.js` | Heartbeat 15s, scroll tracking, click tracking tel/mailto |
| Creer `StatApiController` | `src/Controller/Api/StatApiController.php` | Endpoints POST /api/stat/ping, /scroll, /conversion |
| Creer entite `StatConversion` | `src/Entity/StatConversion.php` | Schema defini en section 2 |
| Migration | `migrations/VersionXXX.php` | Creer stat_conversion |
| Inclure le JS | `templates/base.html.twig` | Charger stat-tracker.js sur toutes les pages front |

### Phase 3 — Dashboard stats

**Objectif :** Afficher les metriques dans l'admin.

| Tache | Fichier | Detail |
|-------|---------|--------|
| Creer `StatService` | `src/Service/StatService.php` | Requetes d'agregation (sources, comportement, conversions, parcours) |
| Creer `StatController` | `src/Controller/Admin/StatController.php` | Routes /admin/stats, /admin/stats/acquisition, etc. |
| Templates stats | `templates/admin/stats/*.html.twig` | Vue ensemble, acquisition, comportement, conversions, fiche page |
| SCSS stats | `assets/admin/admin-stats.scss` | Classes .bw-funnel, .bw-flow, charts additionnels |
| Enrichir dashboard | `templates/admin/dashboard.html.twig` | Bloc resume mensuel avec lien vers stats |
| Charts Chart.js | `assets/admin/admin-stats.js` | Donut sources, line comportement, barres entonnoir |

### Phase 4 — Finitions

| Tache | Detail |
|-------|--------|
| Purge automatique | Command Symfony pour supprimer les stats > 13 mois (RGPD) |
| Export CSV | Bouton d'export des conversions pour le client |
| Detection comportementale bots | Completer la detection UA par : > 30 pages en 60s = bot |
| Mise a jour politique confidentialite | Template de la page legale generee par le CMS |

---

## 10. Fichiers a modifier/creer

### Entites (+ migrations)

| Fichier | Action |
|---------|--------|
| `src/Entity/StatSession.php` | **CREER** |
| `src/Entity/StatConversion.php` | **CREER** |
| `src/Entity/ContactMessage.php` | **CREER** |
| `src/Entity/PageView.php` | **MODIFIER** — ajouter 5 colonnes |

### Services

| Fichier | Action |
|---------|--------|
| `src/Service/SourceClassifier.php` | **CREER** — classification referer/UTM |
| `src/Service/StatService.php` | **CREER** — requetes d'agregation pour le dashboard stats |
| `src/Service/AdminStatsService.php` | **MODIFIER** — ajouter resume mensuel (source principale, rebond, conversions) |

### Controllers

| Fichier | Action |
|---------|--------|
| `src/EventSubscriber/PageViewSubscriber.php` | **MODIFIER** — gestion sessions, cookie, UTM, previous_url |
| `src/Controller/Api/StatApiController.php` | **CREER** — endpoints ping/scroll/conversion |
| `src/Controller/Admin/StatController.php` | **CREER** — pages stats admin |
| `src/Controller/Admin/ContactMessageCrudController.php` | **CREER** — CRUD messages contact |
| `src/Controller/HomeController.php` | **MODIFIER** — persister ContactMessage + StatConversion |

### Repositories

| Fichier | Action |
|---------|--------|
| `src/Repository/StatSessionRepository.php` | **CREER** |
| `src/Repository/StatConversionRepository.php` | **CREER** |
| `src/Repository/ContactMessageRepository.php` | **CREER** |
| `src/Repository/PageViewRepository.php` | **MODIFIER** — requetes enrichies (duree, scroll, parcours) |

### Templates

| Fichier | Action |
|---------|--------|
| `templates/admin/stats/index.html.twig` | **CREER** — vue d'ensemble |
| `templates/admin/stats/acquisition.html.twig` | **CREER** — detail sources |
| `templates/admin/stats/comportement.html.twig` | **CREER** — detail comportement |
| `templates/admin/stats/conversions.html.twig` | **CREER** — conversions + entonnoir |
| `templates/admin/stats/page_detail.html.twig` | **CREER** — fiche page avec parcours |
| `templates/admin/dashboard.html.twig` | **MODIFIER** — ajouter bloc resume stats |

### Assets

| Fichier | Action |
|---------|--------|
| `assets/js/stat-tracker.js` | **CREER** — heartbeat, scroll, click tracking |
| `assets/admin/admin-stats.js` | **CREER** — charts Chart.js pour les pages stats |
| `assets/admin/admin-stats.scss` | **CREER** — styles .bw-funnel, .bw-flow |
| `templates/base.html.twig` | **MODIFIER** — inclure stat-tracker.js |

### Commandes

| Fichier | Action |
|---------|--------|
| `src/Command/StatPurgeCommand.php` | **CREER** — purge > 13 mois (RGPD), a planifier en cron |
