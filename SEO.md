# Plan SEO - Blog&Web CMS

> Audit realise le 20/05/2026 — remontee beta-testeur lesprodici.fr (9 643+ pages, score SEO 29/100)

**Statut : TERMINE** — Toutes les phases implementees et commitees sur main (21/05/2026).

| Phase | Commit | Description |
|-------|--------|-------------|
| P1 | `947db3e` | SeoTrait Tag/Service, filtrage sitemap, canonical auto |
| P2 | `9976bf0` | Sitemap index multi-fichiers, JSON-LD (Organization, Product, Event, Service, LocalBusiness, CreativeWork), BreadcrumbList partout, fix blocs SEO perdus (event/portfolio/directory/faq), fix FAQPage JSON-LD orphelin |
| P3 | `8fee975` | ProductCategory noindex, aide contextuelle admin SEO |

### Bloc 2 — SEO avance (branche develop, 16/06/2026)

| Sous-phase | Commits | Description |
|------------|---------|-------------|
| Tests | `f4406d0` | 36 tests unitaires (SeoAnalyzer, SlugChangeListener, SlugRedirectListener) |
| Media | `79f0d0b` | Dimensions width/height sur Media, alt contextuel automatique (Media.name + titre SEO), templates enrichis |
| SEO UI | `38bb5fe` | Couleurs feux tricolores adoucies, panneau SEO repositionne, commande crawl simulation |
| Schema.org | `3bb4ffb` | Fiche entreprise Google (businessType, priceRange, openingHours), reseaux sociaux (sameAs), OG image enrichi (width/height/alt), JSON-LD Organization dynamique |
| Aide | `f334a5f` | Aide contextuelle Site mise a jour (fiche entreprise, reseaux sociaux, tips horaires) |

> **Note** : dns-prefetch (prevu P3 dans le plan initial) a ete fait en P2. Les items P4 du plan initial (dns-prefetch, ProductCategory noindex, aide admin) ont ete absorbes dans P2/P3.

---

## Sommaire

1. [Etat des lieux](#1-etat-des-lieux)
2. [P1 — Corrections critiques](#2-p1--corrections-critiques)
3. [P2 — Ameliorations importantes](#3-p2--ameliorations-importantes)
4. [P3 — Optimisations](#4-p3--optimisations)
5. [Recapitulatif des fichiers a modifier](#5-recapitulatif-des-fichiers-a-modifier)

---

## 1. Etat des lieux

### Matrice SEO par entite

| Entite           | SeoTrait | Route publique                  | Sitemap | Filtre noIndex sitemap | Pagination | Canonical auto |
|------------------|:--------:|--------------------------------|:-------:|:----------------------:|:----------:|:--------------:|
| Article          |    oui   | `/article/{slug}`              |   oui   |          oui           |  oui (9/p) |      non       |
| Page             |    oui   | `/page/{slug}`                 |   oui   |          oui           |    non     |      non       |
| Categorie        |    oui   | `/categorie/{slug}`            |   oui   |        **NON**         |    non     |      non       |
| Tag              |  **NON** | `/tag/{slug}`                  |   non   |          N/A           |  oui (9/p) |      non       |
| TagGroup         |  **NON** | aucune                         |   non   |          N/A           |    N/A     |      N/A       |
| Service          |  **NON** | `/service/{slug}`              |   oui   |        **NON**         |    non     |      non       |
| Product          |    oui   | `/catalogue/{slug}`            |   oui   |          oui           |    non     |      non       |
| ProductCategory  |  **NON** | `/catalogue/categorie/{slug}`  |   non   |          N/A           |    non     |      non       |
| Event            |    oui   | `/evenement/{slug}`            |   oui   |          oui           |  oui (6/p) |      non       |
| PortfolioItem    |    oui   | `/realisation/{slug}`          |   oui   |          oui           |    non     |      non       |
| PortfolioCategory|  **NON** | aucune (filtre sur index)      |   non   |          N/A           |    non     |      non       |
| DirectoryEntry   |    oui   | `/annuaire/{slug}`             |   oui   |          oui           |    non     |      non       |
| DirectoryCategory|  **NON** | aucune (filtre sur index)      |   non   |          N/A           |    non     |      non       |
| Faq              |  **NON** | `/faq` (index seul)            |   oui   |          N/A           |    non     |      non       |
| FaqCategory      |  **NON** | aucune (groupe sur index)      |   non   |          N/A           |    non     |      non       |

### Points forts existants

- Images responsive (srcset/sizes/webp + lazy loading + fetchpriority pour LCP)
- Open Graph + Twitter Cards avec fallbacks (logo site)
- JSON-LD Article, WebPage, FAQPage, BreadcrumbList (article, page, categorie, faq)
- Hierarchie H1/H2/H3 correcte sur toutes les pages
- Google Fonts non-bloquantes (display=swap, preconnect)
- Breadcrumbs HTML sur 32+ templates

### Problemes identifies

- **Tag et Service** : pages publiques sans aucun controle SEO (pas de meta, pas de noIndex, pas de canonical)
- **Sitemap monolithique** : un seul fichier, pas de limite 50K URLs, pas de sitemap index
- **Sitemap non filtre** : categories et services inclus meme si `noIndex = true`
- **Canonical absent** : `<link rel="canonical">` uniquement si rempli manuellement (99% des pages n'en ont pas)
- **Pagination sans canonical** : `/tag/{slug}?page=2` vu comme page distincte par Google
- **JSON-LD manquants** : Organization, Product, Event non implementes
- **BreadcrumbList JSON-LD** : present sur 4 templates mais breadcrumb HTML sur 32+

---

## 2. P1 — Corrections critiques

### 2.1 Ajouter SeoTrait a l'entite Tag

**Fichiers a modifier :**

**`src/Entity/Tag.php`** — Ajouter le trait et l'import :
```php
use App\Entity\Trait\SeoTrait;

class Tag
{
    use SeoTrait;
    // ... reste inchange
}
```

Particularite : mettre `noIndex = true` par defaut pour les tags (contrairement aux autres entites ou c'est `false`).
Surcharger la propriete dans Tag.php :
```php
#[ORM\Column(type: 'boolean', options: ['default' => true])]
private bool $noIndex = true;
```

**`src/Controller/Admin/TagCrudController.php`** — Ajouter le panel SEO (copier le pattern de `CategorieCrudController`) :
```php
// Apres le champ tagGroup, ajouter :
yield FormField::addPanel('SEO')
    ->setIcon('fa fa-search')
    ->collapsible()
    ->renderCollapsed();

yield TextField::new('seoTitle', 'Titre SEO')
    ->setHelp('Max 70 caracteres. Laissez vide = nom du tag.')
    ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
    ->hideOnIndex();

yield TextareaField::new('seoDescription', 'Meta description')
    ->setHelp('Max 160 caracteres.')
    ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]])
    ->hideOnIndex();

yield TextField::new('seoKeywords', 'Mots-cles')
    ->hideOnIndex();

yield BooleanField::new('noIndex', 'Masquer des moteurs')
    ->setHelp('Active par defaut. Desactivez pour indexer un tag strategique.')
    ->hideOnIndex();

yield TextField::new('canonicalUrl', 'URL canonique')
    ->hideOnIndex();
```

**`src/Controller/TagController.php`** — Utiliser SeoService au lieu du title hardcode :
```php
// Injecter SeoService dans le constructeur
private readonly SeoService $seoService,

// Dans show(), ajouter dans le render :
'seo' => $this->seoService->resolve($tag),
```

**`templates/tag/show.html.twig`** — Supprimer le bloc `seo_title` hardcode (le base.html.twig prendra le relais via la variable `seo`).

**Migration** : generer une migration Doctrine pour ajouter les 5 colonnes SEO a la table `tag`.
Pour les tags existants, la migration doit mettre `no_index = true` (valeur par defaut choisie).

---

### 2.2 Ajouter SeoTrait a l'entite Service

**`src/Entity/Service.php`** — Ajouter le trait :
```php
use App\Entity\Trait\SeoTrait;

class Service
{
    use SeoTrait;
    // ... reste inchange
}
```

**`src/Controller/Admin/ServiceCrudController.php`** — Ajouter le panel SEO (meme pattern que Categorie).

**`src/Controller/ServiceController.php`** — Remplacer `resolveForPage()` par `resolve()` :
```php
// Avant (ligne 54) :
'seo' => $this->seoService->resolveForPage($service->getTitle()),

// Apres :
'seo' => $this->seoService->resolve($service),
```

**Migration** : ajouter les 5 colonnes SEO a la table `service`. Valeur par defaut `no_index = false` (les services sont du contenu editorial, contrairement aux tags).

---

### 2.3 Corriger le filtrage noIndex dans le sitemap

**`src/Controller/SitemapController.php`** :

Pour les categories (ligne 34), remplacer `findAll()` par une methode filtree :
```php
// Avant :
$categories = $categorieRepository->findAll();

// Apres :
$categories = $categorieRepository->findAllForSitemap();
```

Pour les services (ligne 35), remplacer `findAllActive()` par une methode filtree :
```php
// Avant :
$services = $siteContext->hasModule('services') ? $serviceRepository->findAllActive() : [];

// Apres :
$services = $siteContext->hasModule('services') ? $serviceRepository->findAllActiveForSitemap() : [];
```

**`src/Repository/CategorieRepository.php`** — Ajouter :
```php
/**
 * Categories indexables pour le sitemap (exclut noIndex).
 */
public function findAllForSitemap(): array
{
    return $this->createQueryBuilder('c')
        ->andWhere('c.noIndex = false')
        ->orderBy('c.name', 'ASC')
        ->getQuery()
        ->getResult();
}
```

**`src/Repository/ServiceRepository.php`** — Ajouter :
```php
/**
 * Services actifs et indexables pour le sitemap.
 */
public function findAllActiveForSitemap(): array
{
    return $this->createQueryBuilder('s')
        ->andWhere('s.isActive = true')
        ->andWhere('s.noIndex = false')
        ->orderBy('s.position', 'ASC')
        ->getQuery()
        ->getResult();
}
```

---

### 2.4 Sitemap Index multi-fichiers

Remplacer le sitemap monolithique par un **sitemap index** qui pointe vers des sous-sitemaps.
Google limite un sitemap a **50 000 URLs** et **50 Mo**. Avec des milliers de tags/produits/fiches annuaire, on risque de depasser.

**Architecture cible :**

```
GET /sitemap.xml          → sitemap index (liste des sous-sitemaps)
GET /sitemap-pages.xml    → pages + pages legales
GET /sitemap-articles.xml → articles publies, non noIndex
GET /sitemap-categories.xml → categories non noIndex
GET /sitemap-services.xml → services actifs, non noIndex (si module actif)
GET /sitemap-products.xml → produits non noIndex (si module actif)
GET /sitemap-events.xml   → evenements actifs, non noIndex (si module actif)
GET /sitemap-portfolio.xml → realisations actives, non noIndex (si module actif)
GET /sitemap-directory.xml → fiches annuaire actives, non noIndex (si module actif)
GET /sitemap-tags.xml     → tags non noIndex (si module blog actif)
GET /sitemap-misc.xml     → home, blog index, contact, faq
```

**`src/Controller/SitemapController.php`** — Refactorer :

```php
#[Route('/sitemap.xml', name: 'app_sitemap', defaults: ['_format' => 'xml'])]
public function index(SiteContext $siteContext): Response
{
    // Generer la liste des sous-sitemaps disponibles
    $sitemaps = ['pages', 'articles', 'categories', 'misc'];

    if ($siteContext->hasModule('services')) $sitemaps[] = 'services';
    if ($siteContext->hasModule('catalogue')) $sitemaps[] = 'products';
    if ($siteContext->hasModule('events')) $sitemaps[] = 'events';
    if ($siteContext->hasModule('portfolio')) $sitemaps[] = 'portfolio';
    if ($siteContext->hasModule('directory')) $sitemaps[] = 'directory';
    if ($siteContext->hasModule('blog')) $sitemaps[] = 'tags';

    $response = $this->render('sitemap/index.xml.twig', [
        'sitemaps' => $sitemaps,
    ]);
    $response->headers->set('Content-Type', 'application/xml');

    return $response;
}

#[Route('/sitemap-{type}.xml', name: 'app_sitemap_section', defaults: ['_format' => 'xml'])]
public function section(string $type, ...repositories...): Response
{
    // Switch sur $type, charger les entites correspondantes
    // Rendre le template sitemap/section.xml.twig
}
```

**`templates/sitemap/index.xml.twig`** — Nouveau template sitemap index :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    {% for type in sitemaps %}
    <sitemap>
        <loc>{{ absolute_url(path('app_sitemap_section', {type: type})) }}</loc>
    </sitemap>
    {% endfor %}
</sitemapindex>
```

**`templates/sitemap/section.xml.twig`** — Nouveau template sous-sitemap :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    {% for url in urls %}
    <url>
        <loc>{{ url.loc }}</loc>
        {% if url.lastmod|default(null) %}
        <lastmod>{{ url.lastmod|date('Y-m-d') }}</lastmod>
        {% endif %}
        <changefreq>{{ url.changefreq }}</changefreq>
        <priority>{{ url.priority }}</priority>
    </url>
    {% endfor %}
</urlset>
```

**`templates/robots/index.txt.twig`** — Verifier que le Sitemap pointe vers `/sitemap.xml` (deja le cas normalement).

---

## 3. P2 — Ameliorations importantes

### 3.1 Canonical URL automatique sur toutes les pages

Aujourd'hui, `<link rel="canonical">` n'est affiche que si `seo.canonicalUrl` est rempli manuellement. 99% des pages n'ont donc pas de canonical.

**`templates/base.html.twig`** (lignes 35-37) — Remplacer :
```twig
{# Avant : #}
{% if seo.canonicalUrl|default('') is not empty %}
<link rel="canonical" href="{{ seo.canonicalUrl }}">
{% endif %}

{# Apres : #}
{% set _canonical = seo.canonicalUrl|default('') is not empty
    ? seo.canonicalUrl
    : url(app.request.attributes.get('_route'), app.request.attributes.get('_route_params')) %}
<link rel="canonical" href="{{ _canonical }}">
```

Logique : si le champ `canonicalUrl` est rempli manuellement, on l'utilise. Sinon, on genere l'URL propre de la route courante (sans query params comme `?page=2`, `?utm_source=...`).

La fonction `url()` avec les `_route_params` reconstruit l'URL clean de la route, sans les query strings.

---

### 3.2 Pagination : canonical vers page 1

Les pages paginees (`/tag/{slug}?page=2`, `/article?page=3`, etc.) doivent avoir un canonical pointant vers la page 1 (sans `?page=`).

C'est deja gere par la solution 3.1 ci-dessus : `url(_route, _route_params)` ne contient pas les query params, donc `/tag/{slug}?page=2` aura automatiquement un canonical vers `/tag/{slug}`.

Google a deprecie `rel="next/prev"` en 2019. Le canonical vers page 1 est la bonne pratique actuelle.

---

### 3.3 JSON-LD Organization (site-wide) — IMPLEMENTE Bloc 2

**`templates/base.html.twig`** — JSON-LD Organization dynamique avec @type configurable :

- `@type` dynamique depuis `site.businessType` (Organization, Store, Restaurant, ProfessionalService, etc.)
- `contactPoint` structure (telephone + email)
- `sameAs` alimente par les URLs Facebook, Instagram, LinkedIn, Twitter/X
- `priceRange` (€ a €€€€)
- `openingHours` (un horaire par ligne, format `Lu-Ve 09:00-18:00`)
- `address` avec `addressCountry: "FR"`

Les champs sont configurables dans l'admin : panneau "Fiche entreprise (Google)" + panneau "Reseaux sociaux" (collapsibles).

Les pages enfant (article, product, etc.) surchargeront ce bloc avec leur propre schema + l'Organization.

---

### 3.4 JSON-LD Product

**`templates/product/show.html.twig`** — Ajouter dans le bloc `jsonld` :
```twig
{% block jsonld %}
{{ parent() }}
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "Product",
    "name": "{{ product.title }}",
    "description": "{{ seo.description|default('')|e('js') }}",
    {% if product.featuredMedia %}
    "image": "{{ absolute_url(asset('documents/medias/' ~ product.featuredMedia.fileName)) }}",
    {% endif %}
    {% if product.price|default(null) %}
    "offers": {
        "@type": "Offer",
        "price": "{{ product.price }}",
        "priceCurrency": "EUR",
        "availability": "https://schema.org/InStock"
    }
    {% endif %}
}
</script>
{% endblock %}
```

---

### 3.5 JSON-LD Event

**`templates/event/show.html.twig`** — Ajouter dans le bloc `jsonld` :
```twig
{% block jsonld %}
{{ parent() }}
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "Event",
    "name": "{{ event.title }}",
    "description": "{{ seo.description|default('')|e('js') }}",
    "startDate": "{{ event.dateStart|date('c') }}",
    {% if event.dateEnd|default(null) %}
    "endDate": "{{ event.dateEnd|date('c') }}",
    {% endif %}
    {% if event.location|default('') is not empty %}
    "location": {
        "@type": "Place",
        "name": "{{ event.location|e('js') }}"
    },
    {% endif %}
    {% if event.featuredMedia %}
    "image": "{{ absolute_url(asset('documents/medias/' ~ event.featuredMedia.fileName)) }}"
    {% endif %}
}
</script>
{% endblock %}
```

---

### 3.6 BreadcrumbList JSON-LD : aligner sur le HTML

Actuellement le breadcrumb HTML est sur 32+ templates mais le JSON-LD BreadcrumbList n'est que sur 4 (article, page, categorie, faq).

**Creer un partial Twig reutilisable** `templates/_partials/jsonld_breadcrumb.html.twig` :
```twig
{# Attend une variable `breadcrumb_items` = [{name, url}, ...] #}
{% if breadcrumb_items|default([])|length > 0 %}
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        {% for item in breadcrumb_items %}
        {
            "@type": "ListItem",
            "position": {{ loop.index }},
            "name": "{{ item.name|e('js') }}",
            "item": "{{ item.url }}"
        }{% if not loop.last %},{% endif %}
        {% endfor %}
    ]
}
</script>
{% endif %}
```

L'inclure dans tous les templates qui ont un breadcrumb HTML : service/show, product/show, event/show, portfolio/show, directory/show.

---

### 3.7 Exclure les pages vides du sitemap

Une categorie ou un tag avec 0 article = thin content. Ne pas l'inclure dans le sitemap.

**`src/Repository/CategorieRepository.php`** — Modifier `findAllForSitemap()` :
```php
public function findAllForSitemap(): array
{
    return $this->createQueryBuilder('c')
        ->innerJoin('c.articles', 'a')    // exclut categories sans articles
        ->andWhere('a.status = :published')
        ->andWhere('c.noIndex = false')
        ->setParameter('published', 'published')
        ->groupBy('c.id')
        ->orderBy('c.name', 'ASC')
        ->getQuery()
        ->getResult();
}
```

Pour les tags (dans le futur sitemap-tags.xml), meme logique : exclure les tags sans contenu publie.

---

## 4. P3 — Optimisations

### 4.1 dns-prefetch

**`templates/base.html.twig`** — Ajouter dans le `<head>` apres les `<link rel="preconnect">` :
```html
<link rel="dns-prefetch" href="//fonts.googleapis.com">
<link rel="dns-prefetch" href="//fonts.gstatic.com">
<link rel="dns-prefetch" href="//www.googletagmanager.com">
```

---

### 4.2 ProductCategory : noindex global

Les pages `/catalogue/categorie/{slug}` sont des pages de listing filtrees, pas du contenu editorial.
Deux options :
- **Option A** : Ajouter `<meta name="robots" content="noindex, follow">` dans le template `product/index.html.twig` quand un filtre categorie est actif
- **Option B** (plus complet) : Ajouter SeoTrait a ProductCategory

Recommandation : **Option A** pour commencer (rapide, pas de migration BDD).

---

### 4.3 Aide contextuelle admin pour le SEO

Mettre a jour le `getHelpData()` des CrudControllers pour mentionner les bonnes pratiques SEO :

- **TagCrudController** : expliquer que les tags sont `noIndex` par defaut et pourquoi
- **ServiceCrudController** : rappeler de remplir le titre SEO et meta description
- **CategorieCrudController** : deja en place (bon modele a suivre)

---

## 5. Recapitulatif des fichiers a modifier

### Entites (+ migrations)

| Fichier | Modification |
|---------|-------------|
| `src/Entity/Tag.php` | Ajouter `use SeoTrait` + surcharge `noIndex = true` par defaut |
| `src/Entity/Service.php` | Ajouter `use SeoTrait` |

→ **1 migration Doctrine** pour les 2 entites (10 colonnes au total)

### Controllers

| Fichier | Modification |
|---------|-------------|
| `src/Controller/SitemapController.php` | Refactorer en sitemap index + sous-sitemaps, filtrer noIndex |
| `src/Controller/TagController.php` | Injecter SeoService, passer `seo` au template |
| `src/Controller/ServiceController.php` | Remplacer `resolveForPage()` par `resolve()` |

### Admin CrudControllers

| Fichier | Modification |
|---------|-------------|
| `src/Controller/Admin/TagCrudController.php` | Ajouter panel SEO (fields seoTitle, seoDescription, etc.) |
| `src/Controller/Admin/ServiceCrudController.php` | Ajouter panel SEO |

### Repositories

| Fichier | Modification |
|---------|-------------|
| `src/Repository/CategorieRepository.php` | Ajouter `findAllForSitemap()` (filtre noIndex + vides) |
| `src/Repository/ServiceRepository.php` | Ajouter `findAllActiveForSitemap()` (filtre noIndex) |
| `src/Repository/TagRepository.php` | Ajouter `findAllForSitemap()` (filtre noIndex + vides) |

### Templates

| Fichier | Modification |
|---------|-------------|
| `templates/base.html.twig` | Canonical auto + Organization JSON-LD + dns-prefetch |
| `templates/sitemap/index.xml.twig` | Transformer en sitemap index |
| `templates/sitemap/section.xml.twig` | **Nouveau** — template sous-sitemap generique |
| `templates/tag/show.html.twig` | Supprimer `seo_title` hardcode, laisser base.html.twig gerer |
| `templates/product/show.html.twig` | Ajouter JSON-LD Product |
| `templates/event/show.html.twig` | Ajouter JSON-LD Event |
| `templates/_partials/jsonld_breadcrumb.html.twig` | **Nouveau** — partial BreadcrumbList reutilisable |
| `templates/service/show.html.twig` | Inclure jsonld_breadcrumb |
| `templates/product/show.html.twig` | Inclure jsonld_breadcrumb |
| `templates/event/show.html.twig` | Inclure jsonld_breadcrumb |
| `templates/portfolio/show.html.twig` | Inclure jsonld_breadcrumb |
| `templates/directory/show.html.twig` | Inclure jsonld_breadcrumb |

### Ordre d'implementation recommande

```
Phase 1 — Corriger les fuites (1 PR)
  1. SeoTrait sur Tag + Service (entites + migration)
  2. CrudControllers admin (panel SEO)
  3. Controllers front (SeoService)
  4. Filtre noIndex dans sitemap (repositories)
  5. Template tag/show.html.twig

Phase 2 — Sitemap index (1 PR)
  6. Refactorer SitemapController
  7. Nouveaux templates sitemap index + section
  8. Exclure pages vides

Phase 3 — Canonical + JSON-LD (1 PR)
  9. Canonical auto dans base.html.twig
  10. Organization JSON-LD dans base.html.twig
  11. Product JSON-LD
  12. Event JSON-LD
  13. Partial BreadcrumbList + inclusion

Phase 4 — Finitions (1 PR)
  14. dns-prefetch
  15. ProductCategory noindex
  16. Aide contextuelle admin
```
