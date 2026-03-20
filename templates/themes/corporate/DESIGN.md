# Theme Corporate — Specifications visuelles

## Identite

- **Cible** : PME, services B2B, cabinets conseil
- **Ambiance** : Professionnel, sobre, inspire confiance
- **Mot-cle design** : Serieux, structure, credible

## Palette

| Variable | Valeur | Usage |
|----------|--------|-------|
| `--primary` | `#1E3A5F` (bleu marine) | Autorite, confiance |
| `--secondary` | `#C49A6C` (or/bronze) | Premium, accents |
| `--accent` | `#2E86AB` (bleu clair) | Liens, CTAs |
| `--bg` | `#FFFFFF` | Fond principal |
| `--surface` | `#F8F9FA` | Cards, zones secondaires |
| `--border` | `#DEE2E6` | Separateurs nets |
| `--text` | `#212529` | Texte dense |
| `--text-muted` | `#6C757D` | Texte secondaire |
| `--radius` | `0.375rem` | Arrondis discrets |

## Typographie

- **Body** : Montserrat 400/500/600/700 — geometrique, moderne, pro
- **Titres** : Playfair Display 400/700 — serif elegante pour credibilite
- Tous les titres de section utilisent `font-family-secondary`

## Composants visuels

### Hero (home)
- Image de fond plein ecran (75vh), overlay gradient sombre
- Tagline uppercase en petites majuscules, letter-spacing 0.15em
- Titre en Playfair Display serif, clamp 2.5rem→4rem
- 2 CTA : btn-light + btn-outline-light

### Cards services
- Background `--surface`, border, petit radius (0.375rem)
- Icone en carre colore `--primary` (48x48px)
- Hover : border-color → primary, translateY(-3px)
- Lien "En savoir plus" couleur primary, sousligne au hover

### Stats
- Fond `--primary` plein, texte blanc
- Chiffres en Playfair Display 2.5rem bold
- Labels uppercase, letter-spacing

### Boutons
- Style : `filled`, radius petit
- Font-weight 600, pas de gradient
- Hover : pas de glow, juste assombrissement

### Header
- Sticky blanc, border-bottom (pas de shadow)
- CTA header "Nous contacter" btn-primary font-weight 600

### Footer
- Fond `--text` (quasi noir), texte blanc/opaque
- Section titles : UPPERCASE, letter-spacing 0.1em, font-size 0.75rem
- Logo en filter brightness(0) invert(1)

## Article show (overrides dans theme.css)

- Titres article/page : **Playfair Display serif** (difference cle avec default)
- Contenu H2/H3 : egalement Playfair Display
- Blockquote : bordure gauche `--secondary` (or/bronze), fond `--surface`
- Badge categorie : rectangle peu arrondi (0.25rem), fond `--primary`
- Commentaires : style formel — auteur en Montserrat bold UPPERCASE, letter-spacing 0.02em
- Share buttons : radius `--radius` (petit)
- TOC : titre UPPERCASE, letter-spacing 0.1em, font-size 0.75rem
- Author card : radius `--radius`
- Related articles title : Playfair Display

## Blog listing (overrides dans theme.css)

- Blog header title : Playfair Display
- Cards : radius `--radius` (petit), titre Playfair Display bold
- Badge categorie : rectangle peu arrondi (0.25rem)
- Filter pills : UPPERCASE, letter-spacing 0.05em, font-weight 600
- Featured card : radius `--radius`, titre Playfair Display

### Blog custom (blog.html.twig)
- Featured : card horizontale image gauche / contenu droite, fond `--surface`
- Grille articles : cards corp-blog-card, image 180px fixe
- Categorie : texte colore uppercase (pas de pill en blog custom)
- Sidebar : fond blanc, border, sticky top 1rem

## Page show (overrides dans theme.css)

- Hero title : Playfair Display
- Page detail title : Playfair Display, letter-spacing -0.02em
- Blockquote : bordure gauche `--secondary`, fond bronze leger (rgba 0.05)

## Widgets (overrides dans theme.css)

- Cards : radius `--radius`
- Titles : Playfair Display, UPPERCASE, font-size 0.8rem, letter-spacing 0.05em
- Border-bottom couleur `--secondary`
- Subscribe : fond `--primary`
- Tag pills : radius 0.25rem

## Fichiers

- `theme.yaml` — config Montserrat + Playfair Display
- `theme.css` — ~608 lignes d'overrides
- `_header.html.twig` + `_footer.html.twig`
- `home.html.twig` + `blog.html.twig` + `contact.html.twig`
