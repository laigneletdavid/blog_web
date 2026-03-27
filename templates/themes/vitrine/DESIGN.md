# Theme Vitrine — Specifications visuelles

## Identite

- **Cible** : Professions liberales, coachs, consultants, freelances
- **Ambiance** : Elegant, epure, premium mais accessible
- **Mot-cle design** : Sophistique, minimaliste-chic, confiance

## Palette

| Variable | Valeur | Usage |
|----------|--------|-------|
| `--primary` | `#4F46E5` (indigo) | Creativite, expertise |
| `--secondary` | `#EC4899` (rose) | Accent feminin/moderne |
| `--accent` | `#06B6D4` (cyan) | Fraicheur, liens |
| `--bg` | `#FFFFFF` | Fond pur |
| `--surface` | `#F9FAFB` | Cards legeres |
| `--border` | `#E5E7EB` | Separateurs discrets |
| `--text` | `#1F2937` | Texte fonce |
| `--text-muted` | `#6B7280` | Texte secondaire |
| `--radius` | `0.625rem` | Arrondis intermediaires |

## Typographie

- **Body + Titres** : DM Sans 400/500/600/700 — geometrique, elegante
- **Pas de police secondaire** — coherence DM Sans partout

## Composants visuels

### Hero (home)
- Split layout : texte gauche + image droite (aspect-ratio 4/3)
- Pas de fond colore — fond blanc, contenu a gauche
- Titre letter-spacing -0.03em, line-height 1.1
- Description max-width 480px
- Placeholder image : gradient primary→accent si pas d'image (opacity 0.15)

### Features
- Bande horizontale, fond `--surface`, border-top/bottom
- 3 ou 4 features en ligne, centrees
- Icone `--primary` + titre + lien

### About
- Photo circulaire (border-radius 50%, max 320px)
- Overtitle uppercase letter-spacing 0.15em, couleur `--primary`
- Texte line-height 1.8

### Temoignages
- Cards individuelles, etoiles `--secondary` (rose)
- Texte en italique, fond `--bg`
- Border + radius

### CTA
- Card a l'interieur d'un container (pas full-width)
- Fond `--surface`, border, radius, padding genereux (3rem)

### Footer
- Border-top 3px `--primary` (indigo)
- Fond `--text` (fonce), logo filter invert

## Article show (overrides dans theme.css)

- Titre : DM Sans bold, letter-spacing -0.02em, line-height 1.15
- Lead : font-size 1.125rem, line-height 1.75, padding-bottom 2rem, margin-bottom 2.5rem
- Contenu : font-size 1.0625rem, line-height 1.8 (espacements genereux)
- Blockquote : bordure gauche `--primary` (indigo)
- Tags : **outline** — fond transparent, border `--primary`, texte `--primary`, hover fond plein
- Share buttons : radius `--radius`
- Author card : radius `--radius`
- Related/comments titles : letter-spacing -0.01em

## Blog listing (overrides dans theme.css)

- Cards body : padding 1.5rem
- Badge dans le body : fond transparent, texte `--primary` uppercase (pas de pill)
- Badge dans l'image : fond `--primary`, texte blanc (pill classique)
- Hover : translateY(-2px), shadow tres douce (rgba 0.06)
- Blog header title : font-weight 700, letter-spacing -0.02em

### Blog custom (blog.html.twig)
- Titre page : 2rem bold
- Cards custom `vit-blog-card` : image 220px, body 1.5rem padding
- Categorie : texte uppercase `--primary`
- Hover : translateY(-2px) + shadow douce

## Page show (overrides dans theme.css)

- Hero : radius `--radius`
- Titre hero/detail : letter-spacing -0.03em, font-weight 700
- Blockquote : border-left 3px `--primary`, fond `--surface`

## Widgets (overrides dans theme.css)

- Cards : radius `--radius`, box-shadow douce (rgba 0.04)
- Titles : font-weight 600, letter-spacing -0.02em, border-bottom 2px `--primary`
- Tag pills : fond transparent, border `--border`, hover border `--primary`

## Fichiers

- `theme.yaml` — config DM Sans, pas de secondary
- `theme.css` — ~343 lignes d'overrides
- `_header.html.twig` + `_footer.html.twig`
- `home.html.twig` + `blog.html.twig` + `contact.html.twig`
