# Theme Artisan — Specifications visuelles

## Identite

- **Cible** : Commerces locaux, restaurants, boulangers, artisans
- **Ambiance** : Chaleureux, authentique, terroir
- **Mot-cle design** : Humain, organique, accueillant

## Palette

| Variable | Valeur | Usage |
|----------|--------|-------|
| `--primary` | `#8B4513` (brun selle) | Terre, authenticite |
| `--secondary` | `#D4A574` (sable) | Chaleur, douceur |
| `--accent` | `#2E7D32` (vert foret) | Nature, fraicheur |
| `--bg` | `#FFFBF0` (creme) | Fond chaud (PAS blanc pur) |
| `--surface` | `#FFF8E7` (ivoire) | Cards chaudes |
| `--border` | `#E8DCC8` (beige) | Separateurs doux |
| `--text` | `#2D1B00` (brun fonce) | Texte chocolat |
| `--text-muted` | `#7A6B5A` (taupe) | Texte secondaire |
| `--radius` | `1rem` | Arrondis genereux (organique) |

## Typographie

- **Body** : Lato 400/700 — humaniste, lisible, chaleureuse
- **Titres** : Playfair Display 400/700 — serif classique, artisanale
- Tous les titres de section et hero en `font-family-secondary`

## Composants visuels

### Hero (home)
- Image de fond plein ecran (70vh), overlay sombre 45%
- Titre Playfair Display serif, tres grand (clamp 2.5→4.5rem)
- Sous-titre poetique/descriptif
- CTA simple

### Galerie
- Grille masonry 3 colonnes, items arrondis (1rem)
- Hover : zoom image scale(1.05), caption apparait en gradient
- Item large : grid-row span 2
- Responsive : 2 colonnes mobile

### Cards services
- Fond `--surface`, numero circulaire fond `--primary`
- Titres en Playfair Display
- Hover : translateY(-3px), pas de changement de border

### Temoignages
- Border-left 3px `--primary`, fond `--bg`
- Texte en italique, auteur en couleur `--primary`
- Pas de cards individuelles — style citation longue
- Radius : 0 en haut-gauche/bas-gauche, `--radius` en haut-droite/bas-droite

### Header
- Border-bottom 2px (plus epaisse)
- Navigation centree sous le logo, uppercase, letter-spacing 0.08em
- Style "bistrot" / menu de restaurant

### Footer
- Fond `--text` (brun fonce), headings en Playfair Display
- Tagline chaleureuse
- Logo filter brightness(0) invert(1)

## Article show (overrides dans theme.css)

- Fond page : `--bg` creme (PAS blanc pur) — donne une chaleur (via variable)
- Titre : **Playfair Display**, letter-spacing -0.01em
- Contenu H2/H3 : Playfair Display
- Lead text : font-size 1.1875rem, line-height 1.8
- Contenu : line-height 1.85 (plus aere que default)
- Blockquote : bordure gauche `--primary` (brun), radius droite `--radius`
- Images : radius genereux (1rem), pas de border
- Cards commentaires : fond `--surface`, radius 1rem
- Tags : pills fond `--secondary` (sable), texte `--text`, border `--secondary`
- Share buttons : tons terres (brun) — hover couleur `--primary` (pas de couleurs reseaux sociaux pures)
- Author card : fond `--surface`, nom en Playfair Display
- TOC title : Playfair Display, pas d'uppercase, font-size 0.9375rem
- Related & comments titles : Playfair Display

## Blog listing (overrides dans theme.css)

- Cards : radius genereux (`--radius` = 1rem), fond `--surface`
- Badge : radius genereux (`--radius`)
- Titre cards : Playfair Display bold
- Featured card : radius `--radius`, titre Playfair Display
- Blog header title : Playfair Display
- Filter pills : radius `--radius`

### Blog custom (blog.html.twig)
- Header fond `--surface` (ivoire), titre Playfair Display 2.25rem
- Sidebar sticky top 1rem

## Page show (overrides dans theme.css)

- Hero : radius `--radius`
- Titre : Playfair Display
- Blockquote : bordure gauche `--secondary`, fond brun leger (rgba 0.06)

## Widgets (overrides dans theme.css)

- Cards : radius `--radius`, fond `--surface`
- Titles : Playfair Display, border-bottom couleur `--secondary`
- Subscribe : gradient `--primary` → `--secondary`
- Tag pills : radius `--radius`, fond `--surface`, border `--border`

## Fichiers

- `theme.yaml` — config Lato + Playfair Display, fond creme
- `theme.css` — ~454 lignes d'overrides
- `_header.html.twig` + `_footer.html.twig`
- `home.html.twig` + `blog.html.twig` + `contact.html.twig`
