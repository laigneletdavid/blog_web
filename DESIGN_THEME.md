# Design Theme — Specifications visuelles par theme

> Ce fichier decrit l'architecture du systeme multi-themes et les regles d'implementation.
> Pour les specs detaillees de chaque theme, voir `templates/themes/{slug}/DESIGN.md`.

---

## Architecture commune

### Ce qui est GLOBAL (partage par tous les themes)

- `article/show.html.twig` — page detail article
- `page/show.html.twig` — page detail
- `article/item.html.twig` — card article (composant reutilisable)
- `article/article_liste_large.html.twig` — card article featured
- `widgets/*.html.twig` — sidebar (TOC, subscribe, tags, categories, last articles, archives)
- `search/results.html.twig` — resultats de recherche
- `article.scss`, `article_list.scss`, `blocks.scss`, `widgets.scss`, `toc.scss` — styles globaux

### Ce qui est SPECIFIQUE par theme

- `themes/{slug}/_header.html.twig` + `_footer.html.twig`
- `themes/{slug}/home.html.twig` + `blog.html.twig` + `contact.html.twig`
- `themes/{slug}/theme.css` — styles specifiques (classes prefixees `.theme-{slug}`)
- `themes/{slug}/theme.yaml` — variables CSS + config + Google Fonts
- `themes/{slug}/DESIGN.md` — specifications visuelles detaillees

### Comment ca marche

Les pages globales utilisent les CSS custom properties (`--primary`, `--bg`, etc.) pour le rendu de base.
Chaque theme personnalise ces pages via des **overrides CSS** dans `theme.css`, prefixes par `.theme-{slug}`.

Le body a la classe `theme-{slug}` (ex: `theme-corporate`, `theme-artisan`), ce qui active les overrides.

---

## Variables CSS du systeme (13 variables)

### Sur Site (personnalisables par client dans admin) — 5

| Variable | Description | Defaut |
|----------|-------------|--------|
| `--primary` | Couleur principale | Depend du theme |
| `--secondary` | Couleur secondaire | Depend du theme |
| `--accent` | Couleur d'accent | Depend du theme |
| `--font-family` | Police body | Depend du theme |
| `--font-family-secondary` | Police titres (nullable) | Depend du theme |

### Dans theme.yaml uniquement (fixees par theme) — 6

| Variable | Description |
|----------|-------------|
| `--bg` | Fond principal |
| `--surface` | Cards, zones elevees |
| `--border` | Separateurs |
| `--text` | Texte principal |
| `--text-muted` | Texte secondaire |
| `--radius` | Border-radius |

### Meta-config YAML (non CSS, influencent le HTML) — 2

| Config | Valeurs possibles |
|--------|-------------------|
| `buttonStyle` | filled / outline / gradient / pill |
| `headerStyle` | sticky-white / sticky-transparent / static |

---

## Themes disponibles

| Slug | Nom | Cible | Police | Fond |
|------|-----|-------|--------|------|
| `default` | Default | Blog/vitrine polyvalent | Inter | Blanc |
| `corporate` | Corporate | PME, B2B, cabinets | Montserrat + Playfair Display | Blanc |
| `artisan` | Artisan | Commerces locaux, restaurants | Lato + Playfair Display | Creme |
| `vitrine` | Vitrine | Professions liberales, coachs | DM Sans | Blanc |
| `starter` | Starter | Blog personnel, minimaliste | Inter | Blanc |
| `moderne` | Moderne | Startups, tech, SaaS | Space Grotesk | Noir (dark mode) |

---

## Regles d'implementation

### Pour chaque nouveau composant global

1. Ecrire les styles de base dans le SCSS global (`article.scss`, `widgets.scss`, etc.)
2. Utiliser UNIQUEMENT des CSS custom properties (`var(--primary)`, `var(--text)`, etc.)
3. Ajouter des overrides dans chaque `theme.css` pour les specificites :
   - Polices (serif vs sans-serif pour les titres)
   - Radius specifiques
   - Effets de hover differents
   - Structures alternatives (liste vs grille pour Starter)
   - Dark mode pour Moderne

### Pattern CSS pour les overrides theme

```css
/* Dans theme.css */
.theme-corporate .article-detail__title {
    font-family: var(--font-family-secondary, var(--font-family));
}

.theme-starter .share-sticky,
.theme-starter .share-mobile {
    display: none; /* Starter = pas de partage */
}

.theme-moderne .article-detail__content blockquote {
    border-image: linear-gradient(to bottom, var(--primary), var(--accent)) 1;
}
```

### Classe theme sur le body

Le body a la classe `theme-{slug}` (ex: `theme-corporate`, `theme-artisan`).
Tous les overrides dans `theme.css` sont prefixes par `.theme-{slug}`.

### Priorite des personnalisations

1. **theme.yaml `variables`** → CSS custom properties fixees par le theme
2. **Site entity** (admin Apparence) → `--primary`, `--secondary`, `--accent`, `--font-family` — override les defaults du theme
3. **theme.css** → styles structurels specifiques au theme (layout, typo, animations)
4. **SCSS global** → styles de base partages

Le client modifie couleurs/polices (niveau 2), le dev/freelance choisit le theme (niveau 1+3).

### Injection des variables

Les variables sont injectees dans `base.html.twig` via un block `<style>:root { ... }</style>` inline.
Les variables du theme (`--bg`, `--surface`, etc.) sont lues depuis `theme.yaml`.
Les variables du client (`--primary`, `--secondary`, etc.) sont lues depuis l'entite `Site`.

**Important** : les variables gerees par le systeme de themes ne doivent PAS etre declarees dans les fichiers SCSS (sinon le CSS compile ecrase l'inline style). Seules les variables supplementaires (`--primary-light`, `--shadow-*`, etc.) restent dans `variables.scss`.

---

## Overrides implementes par theme

Chaque `theme.css` contient des sections d'overrides pour :

- **Article Show** : titres (serif/sans), blockquote, badges, tags, share buttons, comments, author card, TOC
- **Blog Listing** : cards (radius, hover, layout), featured, filters, header
- **Page Show** : hero, titre, blockquote
- **Widgets** : sidebar cards, register, tag pills
- **Home** : sections specifiques au theme (hero, services, about, etc.)

Voir `templates/themes/{slug}/DESIGN.md` pour les specs detaillees de chaque theme.
