# STATE.md — BlogWeb CMS

> Etat vivant du projet. Mis a jour a chaque session de travail.

## En cours
_(rien)_

## A faire
_(a definir)_

## Bloqueurs
_(aucun)_

## Derniere session
- **Date** : 2026-06-15
- **Quoi** : Module Marketing — landing pages
  - Nouveau module `marketing` dans `ModuleEnum`
  - 4 champs landing sur `Page` (cta_text, cta_url, show_form, form_title) + migration
  - `LandingCrudController` separe de `PageCrudController` (filtrage par template)
  - `LandingContactType` (nom, email, activite, UTM caches, honeypot)
  - `PageController::showLanding()` — soumission form, reCAPTCHA, rate limit, StatConversion
  - `base_landing.html.twig` — layout epure (mini-header logo, footer minimal, noindex)
  - `page/show_landing.html.twig` — hero, CTA, contenu Tiptap, formulaire
  - `landing.scss` — styles hero, CTA, form, responsive
  - Section Marketing dans le dashboard admin (conditionnel `hasModule('marketing')`)
  - Aide contextuelle (AdminHelpTrait) + section Landing dans le guide
  - Action "Copier l'URL" dans le CRUD Landing

## Historique
- **2026-06-15** : Ajout CLAUDE.md + STATE.md pour structurer les echanges Claude Code
