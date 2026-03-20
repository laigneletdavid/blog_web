# Theme Starter — Specifications visuelles

## Identite

- **Cible** : Blog personnel, developpeur, ecrivain, minimaliste
- **Ambiance** : Brut, sans fioritures, contenu avant tout
- **Mot-cle design** : Typographie, noir/blanc, editorial

## Palette

| Variable | Valeur | Usage |
|----------|--------|-------|
| `--primary` | `#171717` (noir quasi-pur) | Tout en noir |
| `--secondary` | `#525252` (gris) | Accents |
| `--accent` | `#2563EB` (bleu) | Seule couleur : liens |
| `--bg` | `#FFFFFF` | Fond blanc pur |
| `--surface` | `#FAFAFA` | A peine visible |
| `--border` | `#E5E5E5` | Separateurs fins |
| `--text` | `#171717` | Noir |
| `--text-muted` | `#737373` | Gris moyen |
| `--radius` | `0.375rem` | Minimal |

## Typographie

- **Body + Titres** : Inter 400/500/600/700 — neutre, systemique
- **Pas de serif** — tout en Inter

## Composants visuels

### Hero (home)
- **AUCUNE image** — texte centre sur fond blanc
- Titre enorme (clamp 2.5→4rem), letter-spacing -0.04em
- Description centree max 500px
- Padding vertical enorme (8rem top, 5rem bottom)

### Articles (home)
- **PAS de grille cards** — liste lineaire, max-width 700px
- Chaque article = ligne horizontale : titre + date a droite
- Separateur border-bottom + border-top premier item
- Hover : opacity 0.7 (pas de translateY)
- Style "table des matieres" / index

### About
- Photo ronde petite (200px)
- Texte sobre, pas d'overtitle
- Border-top separateur

### Header
- **Static** (pas sticky) — `headerStyle: static`
- Border-bottom 1px, pas de shadow
- Logo en texte (strong) si pas d'image, max-height 36px
- Nav links : gris muted, hover noir, font-size 0.9rem

### Footer
- Meme fond que la page (blanc), border-top simple
- Minimaliste : copyright + quelques liens
- Pas de colonnes, pas de social

## Article show (overrides dans theme.css)

### Layout radical
- **Pas de sidebar** — `blog-sidebar`, `col-lg-4`, `col-lg-1` masques (`display: none`)
- **Colonne principale pleine largeur** — `col-lg-7` passe a `flex: 0 0 100%`
- **Max-width contenu** : `640px` (tres etroit, style Medium/Substack)

### Typographie
- Titre : Inter bold, tres grand (clamp 2→3rem), letter-spacing -0.04em, line-height 1.1
- Contenu : font-size 1.0625rem, line-height **1.9** (tres aere)
- **Pas de badge categorie** : `article-detail__badge { display: none }`

### Elements
- Blockquote : border-left noir (`--text`), fond **transparent**, style italique
- Images : radius `--radius`
- Tags : **texte bleu accent** (`--accent`), pas de pill, pas de border, hover underline
- **PAS de boutons de partage** : `share-sticky` et `share-mobile` masques
- Author card : fond transparent, pas de border, juste border-top, radius 0
- Commentaires : fond transparent, border-bottom, radius 0, padding 1rem 0
- Comment form : fond transparent, border `--border`
- Related articles title : 0.8rem, UPPERCASE, letter-spacing 0.1em, gris muted

## Blog listing (overrides dans theme.css)

### Layout liste (pas de grille)
- Cards : **pas de border visible** — fond transparent, border-bottom seulement
- Hover : pas de translateY ni shadow, juste opacity 0.75
- Card link : **flex-direction row** (image a gauche, texte a droite)
- Image : 160x110px, radius `--radius`
- Badge : **masque** (`display: none`)
- Body : padding 0.5rem 0
- Tags : masques

### Responsive mobile
- Card link passe en colonne (image au-dessus, pleine largeur 16/9)

### Blog custom (blog.html.twig)
- Titre 2rem bold
- Liste lineaire `start-blog-list`, max-width 800px
- Items : thumbnail 160x110 a gauche, texte a droite
- Categorie : texte uppercase `--accent`
- Hover : opacity 0.75
- Mobile : thumbnail au-dessus, pleine largeur

## Page show (overrides dans theme.css)

- Hero overlay : fond transparent (pas de gradient sombre)
- Hero title : couleur `--text`, pas de text-shadow, clamp 1.5→2.25rem
- Detail : max-width 640px
- Detail title : letter-spacing -0.04em
- Blockquote : border-left noir, fond transparent, italique

## Widgets (overrides dans theme.css)

- Cards : fond transparent, pas de border ni shadow, border-bottom seulement, radius 0
- Titles : 0.8rem, UPPERCASE, letter-spacing 0.1em, gris muted, pas de border-bottom
- Subscribe : fond transparent, texte `--text`, border `--border`, bouton noir inverse

## Fichiers

- `theme.yaml` — config Inter, headerStyle static
- `theme.css` — ~417 lignes d'overrides
- `_header.html.twig` + `_footer.html.twig`
- `home.html.twig` + `blog.html.twig` + `contact.html.twig`
