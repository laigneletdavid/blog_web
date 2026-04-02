# CLAUDE4 — Backlog technique

## A faire

### Favicon auto-generation depuis le logo (CRUD Site)
**Priorite** : Haute
**Contexte** : Quand l'admin uploade un logo dans le CRUD Site (EasyAdmin), generer automatiquement tous les favicons et icones.

**Implementation** :
- EventSubscriber sur l'entite Site (post-persist/post-update)
- Quand `Site.logo` change, generer via `intervention/image` :
  - favicon.ico (16x16, 32x32, 48x48 multi-size)
  - apple-touch-icon.png (180x180)
  - favicon-96x96.png
  - web-app-manifest-192x192.png (192x192)
  - web-app-manifest-512x512.png (512x512)
- Stocker dans `public/documents/medias/`
- Mettre a jour `Site.favicon` automatiquement
- Generer/maj `public/site.webmanifest` avec les bons chemins

**Champ logoDark** :
- Ajouter `Site.logoDark` (relation Media, nullable)
- Ajouter dans le CRUD Site (EasyAdmin)
- Utiliser dans les templates footer (fond sombre) : `site.logoDark ?? site.logo`

**Dependances** : `intervention/image` (deja installe)

### Systeme d'override client templates/client/
**Statut** : FAIT
- Priorite : client/ > themes/{theme}/ > themes/default/
- 5 includes mis a jour (header, footer, home, contact, blog)
- ThemeService.hasClientTemplate() ajoute
- .gitignore sur main, trackable sur branches bw_* via `git add -f`
