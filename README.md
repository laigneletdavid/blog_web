# BlogWeb — CMS Symfony cle en main

CMS professionnel pret a deployer pour chaque client. Site propre, securise, SEO integre, personnalisable, installable en 30 minutes.

---

## Fonctionnalites

### Gestion de contenu

- **Articles de blog** — Editeur visuel TipTap (gras, italique, titres, listes, images, videos YouTube, citations, blocs de code). Sauvegarde automatique du brouillon toutes les 30 secondes. Publication avec notification email aux abonnes.
- **Pages** — Pages personnalisees (A propos, Nos services...) + pages systeme (mentions legales, confidentialite, CGV). 3 mises en page : standard, pleine largeur, sidebar gauche.
- **Categories** — Organisation des articles par thematique avec couleur et image. Un article peut appartenir a plusieurs categories.
- **Tags** — Classification fine des articles par mots-cles.
- **Medias** — Bibliotheque d'images avec conversion WebP automatique, generation de 3 tailles responsives (480px, 800px, 1200px), texte alternatif pour l'accessibilite et le SEO.
- **Commentaires** — Systeme de commentaires pour les articles, reserve aux utilisateurs connectes. Moderation dans l'admin.

### Modules activables

Chaque module s'active independamment selon les besoins du client :

| Module | Description |
|--------|-------------|
| **Blog** | Articles, categories, tags, commentaires, archives, article vedette |
| **Services** | Fiches de services/prestations |
| **Catalogue** | Fiches produits avec variantes (taille, duree, formule), categories produits, galerie photos, tarification HT/TTC |
| **E-commerce** | Panier, commandes, paiement Stripe, suivi commandes |
| **Evenements** | Agenda avec evenements a venir, evenements passes, evenements vedettes |
| **Annuaire** | Annuaire des membres avec recherche (entreprise, poste, telephone) |
| **Pages privees** | Visibilite par role (public, membres, admin) sur les articles et pages |

### SEO integre

- **Champs SEO** sur chaque article, page et categorie (titre SEO, meta description, mots-cles, noIndex, URL canonique)
- **Sitemap XML** automatique (`/sitemap.xml`) avec priorites et dates de modification
- **robots.txt** dynamique
- **Open Graph** (Facebook, LinkedIn) et **Twitter Cards** automatiques
- **Schema.org JSON-LD** (Article + BreadcrumbList)
- **Fallback chain** : champs SEO de l'entite > titre/description du contenu > valeurs par defaut du site
- **Google Analytics** et **Google Search Console** configurables dans l'admin
- **Images WebP** + **lazy-loading** natif pour la performance

### Themes et personnalisation

- **6 themes inclus** : Default, Corporate, Artisan, Vitrine, Starter, Moderne
- **Personnalisation sans code** : couleurs (primaire, secondaire, accent), polices (20 Google Fonts), logo, favicon
- **CSS custom properties** : la personnalisation s'applique a tous les themes sans rebuild
- **Preview live** des themes avant activation (desktop, tablette, mobile)
- **Images du theme** : hero, about, galerie configurables dans l'admin

### Administration

- **Dashboard** avec KPI (visites jour/mois, articles publies, pages, commentaires), graphique des visites 30 jours (Chart.js), derniers articles et commentaires, actions rapides
- **Tips contextuels** rotatifs sur le dashboard (15 astuces qui tournent a chaque visite)
- **Aide contextuelle** : bouton `?` sur chaque section de l'admin avec panneau lateral d'aide
- **Page Guide** complete (`/admin/guide`) avec 8 sections en accordeon
- **Menu organise** : Contenu | Modules | Communaute | Reglages | Aide
- **Gestionnaire de navigation** drag & drop pour header, footer nav, footer legal

### Formulaire de contact

- **4 couches de securite** : CSRF, honeypot (champ piege invisible), rate limiting (3/min par IP), reCAPTCHA v3 (optionnel)
- **Validation** server-side complete (NotBlank, Email, longueur min/max)
- **Sanitization** HTML sur tous les champs
- **Envoi** via Brevo SMTP avec reply-to vers l'expediteur

### Securite

- **Roles et permissions** : `ROLE_USER` < `ROLE_AUTHOR` < `ROLE_ADMIN` < `ROLE_FREELANCE` < `ROLE_SUPER_ADMIN`
- **`#[IsGranted]`** explicite sur chaque CrudController (defense en profondeur)
- **Verification email** obligatoire a l'inscription (token-based, comptes admin CLI exempts)
- **Reset password** securise par token (ResetPasswordBundle)
- **Protection IDOR** : ownership check sur les profils utilisateur
- **Sanitization XSS** : HtmlSanitizer via Doctrine listener sur les contenus
- **CSRF** active globalement
- **Mot de passe** : minimum 12 caracteres, hash auto
- **Login throttling** : 5 tentatives/minute
- **Headers securite** Nginx : X-Content-Type-Options, X-Frame-Options, X-XSS-Protection, Referrer-Policy

### Notifications

- **Email aux abonnes** a la publication d'un article (via Brevo)
- **Formulaire de contact** envoie au email configure dans l'identite du site
- **Mailpit** en dev pour capturer tous les emails sans les envoyer

### Recherche

- **Barre de recherche** avec dropdown AJAX temps reel (articles, pages, categories)
- **Page resultats** dediee (`/recherche`) avec pagination, highlighting des termes, badges par type de contenu
- **Progressive enhancement** : fonctionne sans JavaScript (formulaire HTML classique)

### Images responsives

- **3 tailles WebP** generees automatiquement a l'upload (480px, 800px, 1200px)
- **srcset/sizes** automatique dans les templates et l'editeur TipTap
- **lazy-loading** natif sur toutes les images

---

## Stack technique

| Composant | Technologie |
|-----------|-------------|
| Backend | PHP 8.4 / Symfony 7.4 LTS |
| ORM | Doctrine ORM 3.3 + Migrations |
| Admin | EasyAdmin Bundle 4.12 |
| Editeur | TipTap (ProseMirror) |
| Frontend | Webpack Encore + Bootstrap 5.3 + Stimulus |
| Templates | Twig 3 |
| Base de donnees | MariaDB 11 |
| Infra | Docker (PHP-FPM 8.4 + Nginx + MariaDB 11 + Mailpit) |
| Mailer | Brevo (symfony/brevo-mailer) |
| Paiement | Stripe (optionnel, module e-commerce) |
| Graphiques | Chart.js (dashboard admin) |
| Anti-spam | reCAPTCHA v3 (optionnel) |

---

## Roles utilisateurs

| Role | Qui | Acces |
|------|-----|-------|
| **Utilisateur** | Visiteur inscrit | Lecture, commentaires, profil, annuaire |
| **Auteur** | Redacteur | Articles, pages, medias (creation/edition) |
| **Admin** | Admin client | Gestion complete du site (users, menus, categories, tags, config) |
| **Freelance** | Revendeur | Themes, couleurs, polices + tout ce que fait Admin |
| **Super Admin** | David | Modules, infra, acces total |

---

## Installation

Voir **[SETUP.md](SETUP.md)** pour le process complet.

```bash
git clone git@github.com:laigneletdavid/blog_web.git client-x && cd client-x
cp .env.local.example .env.local   # Editer APP_SECRET, DATABASE_URL, MAILER_DSN
make up && make db && make assets
docker compose exec php php bin/console app:client:setup
docker compose exec php php bin/console app:module:enable blog
docker compose exec php php bin/console app:recaptcha:setup
```

---

## Commandes disponibles

| Commande | Description |
|----------|-------------|
| `app:client:setup` | Installation complete (site + admin + pages legales + menus) |
| `app:module:enable <module>` | Active un module |
| `app:module:disable <module>` | Desactive un module |
| `app:recaptcha:setup` | Configure reCAPTCHA v3 |
| `app:menu:sync` | Resynchronise les menus systeme |

---

## Architecture

```
blog_web/
├── docker/                    # Docker config (PHP, Nginx)
├── assets/                    # JS/SCSS (Webpack Encore)
│   ├── admin/                 # TipTap editor, dashboard Chart.js, menu manager
│   └── css/base/              # Styles front (variables, blocks, composants)
├── src/
│   ├── Controller/            # Controllers front + admin (EasyAdmin CRUDs)
│   ├── Entity/                # Entites Doctrine (Article, Page, Site, User...)
│   ├── Service/               # Services metier (SiteContext, ThemeService, SEO, Stats...)
│   ├── Security/              # Authenticator, email verification subscriber
│   └── Command/               # CLI (client:setup, recaptcha:setup, modules...)
├── templates/
│   ├── themes/                # 6 themes (default, corporate, artisan, vitrine, starter, moderne)
│   ├── admin/                 # Dashboard, guide, aide contextuelle
│   └── ...                    # Templates front (articles, pages, contact, recherche)
├── SETUP.md                   # Process d'installation client
├── CLAUDE.md                  # Spec technique detaillee (pour Claude Code)
└── README.md                  # Ce fichier
```
