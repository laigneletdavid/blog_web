# Plan : Éditeur de blocs JSON + Améliorations UX

## Résumé

Remplacer le `TextEditorField` (WYSIWYG basique) par un **éditeur de blocs JSON** inspiré d'evohub, avec TipTap pour le texte riche, autosave, et drag & drop. Simple, pas une usine à gaz.

---

## Architecture

### Stockage

On ajoute une colonne `blocks` (JSON) sur `Article` et `Page`. On garde `content` (TEXT) comme **cache HTML** généré à partir des blocs (pour le rendu front rapide et le SEO).

```
Article/Page
├── blocks: JSON       ← source de vérité (tableau de blocs)
├── content: TEXT       ← HTML compilé depuis blocks (cache, pour |raw côté front)
└── draft_blocks: JSON  ← brouillon autosave (nullable)
```

### Types de blocs (6 types, simple)

| Type | Paramètres | Rendu front |
|------|-----------|-------------|
| `text` | `content` (HTML via TipTap) | `<div class="block-text">` + HTML |
| `image` | `media_id`, `caption`, `alt`, `size` (full/medium/small) | `<figure>` + `<img>` + `<figcaption>` |
| `video` | `url`, `provider` (youtube/vimeo) | `<div class="block-video"><iframe>` |
| `quote` | `text`, `author` | `<blockquote>` + `<cite>` |
| `code` | `content`, `language` | `<pre><code class="language-X">` |
| `separator` | `style` (line/dots/space) | `<hr class="separator-X">` |

### Flux de données

```
[Admin] Éditeur blocs JS → JSON → hidden input → formulaire EasyAdmin
                                                          ↓
                                              prePersist/preUpdate
                                                          ↓
                                              BlockRenderer::toHtml()
                                                          ↓
                                              $entity->setContent(html)
                                              $entity->setBlocks(json)
```

---

## Étapes d'implémentation

### Étape 1 — Entités + Migration (~30 min)

**Fichiers modifiés :**
- `src/Entity/Article.php` — ajouter `blocks` (JSON, nullable) + `draft_blocks` (JSON, nullable)
- `src/Entity/Page.php` — idem
- Migration Doctrine

**Détails :**
```php
#[ORM\Column(type: Types::JSON, nullable: true)]
private ?array $blocks = null;

#[ORM\Column(type: Types::JSON, nullable: true)]
private ?array $draftBlocks = null;
```

La colonne `content` (TEXT) reste — elle sert de cache HTML pour le front.

---

### Étape 2 — BlockRenderer service (~30 min)

**Fichiers créés :**
- `src/Service/BlockRenderer.php` — convertit un tableau de blocs JSON en HTML

**Rôle :** Prend `$blocks` (array), retourne du HTML propre. Appelé dans le Doctrine listener avant persist.

```php
class BlockRenderer {
    public function toHtml(array $blocks): string {
        // Pour chaque bloc, génère le HTML correspondant
        // text → HTML brut (déjà HTML via TipTap)
        // image → <figure><img src="..."><figcaption>...</figcaption></figure>
        // video → <div class="block-video"><iframe ...></iframe></div>
        // quote → <blockquote>...<cite>...</cite></blockquote>
        // code → <pre><code>...</code></pre>
        // separator → <hr class="separator-...">
    }
}
```

**Fichier modifié :**
- `src/EventListener/ContentSanitizeListener.php` — en plus de sanitiser, compiler `blocks → content` via `BlockRenderer`

---

### Étape 3 — API Autosave + Media Library (~45 min)

**Fichiers créés :**
- `src/Controller/Admin/Api/BlockApiController.php`

**Endpoints :**

```
POST /admin/api/{entityType}/{id}/autosave
  Body: { blocks: [...] }
  → Sauvegarde dans draft_blocks
  → Retourne { success: true }

GET /admin/api/media/list
  → Retourne la liste des médias avec URL
  → Filtres: ?search=...&type=image
  → Retourne { medias: [{ id, name, fileName, url }] }

POST /admin/api/media/upload
  Body: FormData (file)
  → Upload le fichier, crée l'entité Media
  → Retourne { success: true, media: { id, name, fileName, url } }
```

Sécurisé par `#[IsGranted('ROLE_AUTHOR')]`.

---

### Étape 4 — Entry Webpack admin + dépendances (~20 min)

**Fichiers modifiés :**
- `webpack.config.js` — ajouter entry `admin_blocks` : `./assets/admin/blocks-editor.js`
- `package.json` — ajouter `@tiptap/core`, `@tiptap/starter-kit`, `@tiptap/extension-image`, `sortablejs`

**Fichiers créés :**
- `assets/admin/blocks-editor.js` — point d'entrée JS de l'éditeur
- `assets/admin/blocks-editor.scss` — styles de l'éditeur

**Note :** Entry séparée = le JS de l'éditeur ne charge QUE sur les pages Article/Page admin, pas sur le front.

---

### Étape 5 — Éditeur de blocs JS (~2h)

**Fichier créé :**
- `assets/admin/blocks-editor.js` — classe `BlocksEditor` (adapté d'evohub)

**Simplifications vs evohub :**
- Pas de `courseId` → utilise l'`entityId` d'EasyAdmin depuis l'URL
- Pas de quiz/tool/interactive_content/audio/document → 6 types seulement
- TipTap intégré dans le bloc `text` (remplace le simple textarea)
- Même pattern : hidden input JSON + rendu dynamique + modals Bootstrap
- Drag & drop via SortableJS (comme evohub)
- Autosave via fetch POST toutes les 30s

**Structure de la classe :**
```javascript
class BlocksEditor {
    // Identique au pattern evohub mais simplifié :
    constructor()
    init()

    // Types de blocs (6 au lieu de 8)
    loadBlockTypes()

    // Rendu
    injectEditorHTML()        // Toolbar + liste + modals
    renderBlock(block, index) // Card avec drag handle + preview
    renderBlockEditForm(block) // Formulaire d'édition par type

    // TipTap pour bloc texte
    initTipTap(element)       // Initialise l'éditeur WYSIWYG

    // Média (simplifié : utilise l'entity Media existante)
    openMediaLibrary()
    renderMediaLibrary()

    // CRUD blocs
    addBlock(type)
    editBlock(index)
    saveBlockEdit()
    removeBlock(index)

    // Persistance
    updateDisplay()           // Met à jour le hidden input + rendu
    setupDragDrop()           // SortableJS
    autosave()                // POST /admin/api/.../autosave
}
```

---

### Étape 6 — Intégration EasyAdmin (~30 min)

**Fichiers modifiés :**
- `src/Controller/Admin/ArticleCrudController.php`
  - Remplacer `TextEditorField::new('content')` par un champ custom
  - Utiliser `Field::new('blocks')` avec template custom qui charge l'éditeur
- `src/Controller/Admin/PageCrudController.php` — idem
- `src/Controller/Admin/DashboardController.php`
  - Ajouter le JS/CSS admin dans `configureAssets()` (conditionnellement)

**Fichier créé :**
- `templates/admin/field/blocks_editor.html.twig` — template du champ custom EasyAdmin
  - Contient le `<div id="blocks-editor-container">` + hidden input
  - Charge les blocs existants via `<script>window.existingBlocks = {{ entity.blocks|json_encode|raw }};</script>`

---

### Étape 7 — Rendu front des blocs (~30 min)

**Fichiers modifiés :**
- `templates/article/show.html.twig`
  - Remplacer `{{ article.content|raw }}` par le rendu des blocs
  - Si `blocks` est null/vide, fallback sur `content|raw` (rétrocompatibilité)
- `templates/page/show.html.twig` — idem

**Fichier créé :**
- `templates/_partials/blocks_render.html.twig` — macro Twig qui rend les blocs

```twig
{% for block in blocks %}
    {% if block.type == 'text' %}
        <div class="block-text">{{ block.parameters.content|raw }}</div>
    {% elseif block.type == 'image' %}
        <figure class="block-image block-image--{{ block.parameters.size|default('full') }}">
            <img src="{{ asset('documents/medias/' ~ mediaFileName) }}" alt="{{ block.parameters.alt }}">
            {% if block.parameters.caption %}
                <figcaption>{{ block.parameters.caption }}</figcaption>
            {% endif %}
        </figure>
    {% elseif block.type == 'video' %}
        ...
    {% endif %}
{% endfor %}
```

**Fichier créé :**
- `assets/css/base/blocks.scss` — styles pour les blocs côté front

---

### Étape 8 — CSS front des blocs (~20 min)

**Fichier créé :**
- `assets/css/base/blocks.scss` — styles responsives pour les blocs rendus

```scss
.block-text { /* typographie de contenu */ }
.block-image { margin: 2rem 0; }
.block-image--small { max-width: 50%; margin: 1rem auto; }
.block-image--medium { max-width: 75%; margin: 1.5rem auto; }
.block-image--full { width: 100%; }
.block-video { position: relative; padding-bottom: 56.25%; /* 16:9 */ }
.block-quote { border-left: 4px solid var(--primary); padding-left: 1.5rem; }
.block-code { background: #1e1e1e; color: #d4d4d4; border-radius: 0.5rem; }
.separator-line { border-top: 2px solid var(--secondary); }
```

---

## Résumé des fichiers

### Créés (9 fichiers)
| Fichier | Rôle |
|---------|------|
| `src/Service/BlockRenderer.php` | JSON → HTML |
| `src/Controller/Admin/Api/BlockApiController.php` | API autosave + médias |
| `assets/admin/blocks-editor.js` | Éditeur de blocs (JS) |
| `assets/admin/blocks-editor.scss` | Styles éditeur admin |
| `assets/css/base/blocks.scss` | Styles blocs front |
| `templates/admin/field/blocks_editor.html.twig` | Champ custom EasyAdmin |
| `templates/_partials/blocks_render.html.twig` | Rendu Twig des blocs |
| Migration Doctrine | `blocks` + `draft_blocks` sur Article/Page |

### Modifiés (7 fichiers)
| Fichier | Changement |
|---------|-----------|
| `src/Entity/Article.php` | +blocks, +draftBlocks |
| `src/Entity/Page.php` | +blocks, +draftBlocks |
| `src/EventListener/ContentSanitizeListener.php` | +compilation blocks→content |
| `src/Controller/Admin/ArticleCrudController.php` | TextEditorField → blocks field |
| `src/Controller/Admin/PageCrudController.php` | idem |
| `src/Controller/Admin/DashboardController.php` | +assets JS/CSS admin |
| `webpack.config.js` | +entry admin_blocks |
| `package.json` | +tiptap, +sortablejs |
| `templates/article/show.html.twig` | rendu blocs |
| `templates/page/show.html.twig` | rendu blocs |

---

## Ce qu'on ne fait PAS (pour rester simple)

- Pas de preview live côté admin (le rendu bloc est déjà visuel dans l'éditeur)
- Pas de versionning/historique des blocs
- Pas de blocs imbriqués (colonnes, grilles) — trop complexe
- Pas de marketplace de blocs — les 6 types sont hardcodés
- Pas de drag & drop d'images depuis le desktop (upload via modal seulement)
- Pas de collaboration temps réel

## Rétrocompatibilité

Les articles/pages existants gardent leur `content` HTML. Le front fait un fallback :
```twig
{% if article.blocks is not empty %}
    {% include '_partials/blocks_render.html.twig' %}
{% else %}
    {{ article.content|raw }}
{% endif %}
```

On ne migre PAS l'ancien contenu — les anciens articles restent en HTML pur.
