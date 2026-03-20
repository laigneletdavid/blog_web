# Theme Default — Specifications visuelles

## Identite

- **Cible** : Blog/vitrine polyvalent, CMS de demonstration
- **Ambiance** : Moderne, aerien, SaaS-like
- **Mot-cle design** : Clean, colore, confiant
- **Usage** : Template de base pour construire des designs a la demande. Le `theme.css` est volontairement vide (squelette commente) pour etre personnalise projet par projet.

## Palette

| Variable | Valeur | Usage |
|----------|--------|-------|
| `--primary` | `#2563EB` (bleu vif) | Boutons, liens, accents |
| `--secondary` | `#F59E0B` (ambre) | Badges, highlights |
| `--accent` | `#8B5CF6` (violet) | Gradients, decorations |
| `--bg` | `#FFFFFF` | Fond principal |
| `--surface` | `#F8FAFC` | Cards, sidebar |
| `--border` | `#E2E8F0` | Separateurs |
| `--text` | `#0F172A` | Texte principal |
| `--text-muted` | `#64748B` | Texte secondaire |
| `--radius` | `0.75rem` | Arrondis moyens |

## Typographie

- **Body** : Inter 400/500/600/700/800
- **Code** : JetBrains Mono
- **Pas de police secondaire** (titres = Inter bold)

## Composants visuels

### Hero (home)
- Gradient bleu→violet, cercles decoratifs CSS
- Badge "CMS professionnel" pill
- 2 CTA : btn-light (blanc) + btn-outline-light
- 3 badges de confiance en bas

### Cards article
- Background blanc, border `--border`, radius `0.75rem`
- Image en haut, badge categorie superpose (coin haut droit)
- Hover : `translateY(-4px)` + shadow elevation
- Meta : date + temps lecture avec dot separator

### Boutons
- Style : `filled` (fond plein)
- Primary : fond `--primary`, texte blanc
- Hover : translateY(-1px) + shadow

### Header
- Sticky blanc, backdrop-filter blur(12px)
- Nav links font-weight 600, hover couleur primary-light
- Logo max 42px

### Footer
- 3 colonnes, fond sombre
- Gradient accent line en haut
- Icones sociales en carres arrondis

## Article show

Le theme Default utilise les styles globaux (`article.scss`) sans overrides.
Le `theme.css` est un squelette commente pret a etre personnalise :

- Layout epure, colonne contenu standard
- Titres H2/H3 : Inter bold, pas de serif
- Blockquote : bordure gauche `--primary`, fond `--surface`
- Cards commentaires : border subtile, hover shadow legere
- Share sticky : boutons ronds outline, hover couleur reseau social
- TOC sidebar : trait actif `--primary`

## Blog listing

Utilise les styles globaux (`article_list.scss`) sans overrides :

- Grille 2 colonnes (1 mobile)
- Cards blanches avec image, badge et ombre au hover
- Pagination Bootstrap customisee `--primary`
- Featured article : card large pleine largeur en haut

## Fichiers

- `theme.yaml` — config + defaults
- `theme.css` — squelette commente (a personnaliser par projet)
- `_header.html.twig` + `_footer.html.twig`
- `home.html.twig` + `blog.html.twig` + `contact.html.twig`
