# Theme Moderne — Specifications visuelles

## Identite

- **Cible** : Startups, tech, SaaS, agences digitales
- **Ambiance** : Dark mode, futuriste, premium tech
- **Mot-cle design** : Neon, glass, glow

## Palette

| Variable | Valeur | Usage |
|----------|--------|-------|
| `--primary` | `#7C3AED` (violet vif) | CTAs, accents principaux |
| `--secondary` | `#F59E0B` (ambre) | Badges, alertes |
| `--accent` | `#06B6D4` (cyan) | Gradients, decorations |
| `--bg` | `#0A0A0A` (noir profond) | Fond sombre |
| `--surface` | `#1A1A2E` (bleu nuit) | Cards, zones elevees |
| `--border` | `#2D2D44` (gris violet) | Separateurs subtils |
| `--text` | `#E4E4E7` (gris clair) | Texte principal |
| `--text-muted` | `#A1A1AA` (gris moyen) | Texte secondaire |
| `--radius` | `1rem` | Arrondis genereux |

## Typographie

- **Body + Titres** : Space Grotesk 400/500/600/700 — tech, geometrique
- **Pas de serif** — coherence tech

## Composants visuels

### Hero (home)
- Glow sphere radial-gradient en haut a droite (opacity 0.15)
- Badge pill avec border semi-transparent `--primary`
- Titre Space Grotesk bold, letter-spacing -0.03em
- Image hero avec border 1px `--border`
- CTA : bouton gradient primary→accent

### Features
- Cards avec glow effect : sphere radiale invisible, apparait au hover (opacity 0.15)
- Numeros surdimensionnes en `--primary` opacity 0.5
- Hover : border-color → primary, translateY(-3px)

### Galerie
- Grille 2 colonnes, items avec border `--border`
- Overlay gradient transparent→noir au hover (opacity transition)
- Texte blanc en bas, font-weight 600
- Zoom image scale(1.05)

### Stats
- Chiffres en **gradient text** (primary→accent) — `-webkit-background-clip: text`
- Labels uppercase, letter-spacing
- Border-top/bottom pour delimiter

### Boutons
- Style : `gradient` (primary→accent) — `buttonStyle: gradient`
- Hover : opacity 0.9, translateY(-1px)
- Pas de border visible

### Header
- Background rgba noir + backdrop-filter blur(12px)
- Border-bottom `--border`
- Nav links : `--text-muted`, hover `--text`
- Logo filter brightness(0) invert(1) (force en blanc)

### Footer
- Fond `--surface` (bleu nuit), border-top
- Headings uppercase, letter-spacing 0.1em, font-size 0.75rem
- Logo filter invert

## Article show (overrides dans theme.css)

### Dark mode complet
- Titre : couleur `--text` (gris clair), letter-spacing -0.02em
- Contenu : couleur `--text`, liens en `--primary` (violet)
- Lead : couleur `--text-muted`, border-bottom couleur `--border`
- Hero image : border 1px `--border`

### Blockquote
- Bordure gauche **gradient** primary→accent (via `border-image`)
- Fond `--surface` (bleu nuit)

### Code
- `pre` : fond `--surface`, border `--border`
- `code` inline : couleur `--primary`

### Images
- Border 1px `--border`, radius `--radius`

### Tags
- Ghost style : fond transparent, border rgba violet 0.3, texte `--primary`
- Hover : fond violet leger (rgba 0.15), border `--primary`

### Share buttons
- Ghost style : fond `--surface`, border `--border`, texte `--text-muted`
- Hover : border violet, texte violet, **glow** box-shadow rgba violet 0.2
- Mobile : fond `--surface`, border-top `--border`

### Author card
- Fond `--surface`, border `--border`
- Placeholder avatar : fond `--border`

### Commentaires
- Form : fond `--surface`, border `--border`
- Inputs : fond `--bg`, border `--border`, focus ring violet (rgba 0.15)
- Comment cards : fond `--surface`, border `--border`

### TOC
- Fond `--surface`, border `--border`
- Titre border-bottom `--border`
- Link hover : fond violet leger (rgba 0.08)
- Link actif : fond violet leger (rgba 0.1)

## Blog listing (overrides dans theme.css)

### Cards dark
- Fond `--surface`, border `--border`
- Hover : border-color → `--primary`, shadow **violet** (rgba 0.15), translateY(-3px)
- Titre : couleur `--text`
- Badge position : right 0.75rem

### Featured
- Border 1px `--border`

### Filtres
- Pills : fond `--surface`, border `--border`, texte `--text-muted`
- Hover : border + texte `--primary`, fond violet leger
- Actif : **gradient** primary→accent, border transparent, texte blanc

### Pagination
- Page link : fond `--surface`, border `--border`, texte `--text-muted`
- Actif : gradient primary→accent, border transparent

### Sidebar
- Widget fond `--surface`, border `--border`

### Empty state
- Texte `--text-muted`

## Page show (overrides dans theme.css)

- Hero : border 1px `--border`, overlay gradient plus fort (→ rgba 0.8)
- Titre : couleur `--text`
- Blockquote : border-image gradient, fond violet leger (rgba 0.06)

## Widgets (overrides dans theme.css)

- Cards : fond `--surface`, border `--border`
- Titles : couleur `--text`, border-bottom `--primary`
- Subscribe : gradient primary→accent, pas de border
- Links : couleur `--text`, hover `--primary`, border-bottom `--border`
- Tag pills : fond transparent, border `--border`, texte `--text-muted`
- Tag hover : border + texte `--primary`, fond violet leger

### Breadcrumbs dark
- Links : `--text-muted`
- Actif : `--text`
- Separateur : `--text-muted`

## Fichiers

- `theme.yaml` — config Space Grotesk, dark mode, buttonStyle gradient
- `theme.css` — ~617 lignes d'overrides (le plus volumineux)
- `_header.html.twig` + `_footer.html.twig`
- `home.html.twig` + `blog.html.twig` + `contact.html.twig`
