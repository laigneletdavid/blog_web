# Fiche de reference client — BlogWeb CMS

> Remplir cette fiche pour chaque nouveau client. Elle sera utilisee par Claude Code pour executer le setup complet du site.

---

## 1. Identite du site

| Champ | Valeur |
|-------|--------|
| **Nom du site** | |
| **Email de contact** | |
| **Telephone** | _(optionnel)_ |

## 2. Compte administrateur

| Champ | Valeur |
|-------|--------|
| **Email admin** | |
| **Mot de passe** | _(min 12 caracteres)_ |
| **Prenom** | |
| **Nom** | |

## 3. Environnement

| Champ | Valeur |
|-------|--------|
| **Nom de BDD** | _(ex: blog_client_x)_ |
| **MAILER_DSN Brevo** | _(login + cle SMTP)_ |
| **Domaine** | _(ex: client-x.fr)_ |

## 4. Modules a activer

Cocher les modules souhaites :

- [ ] `blog` — Articles, categories, tags
- [ ] `services` — Pages de services
- [ ] `catalogue` — Catalogue produits
- [ ] `ecommerce` — Boutique en ligne (+ CGV auto)
- [ ] `events` — Evenements
- [ ] `directory` — Annuaire

## 5. reCAPTCHA v3

_(Optionnel mais recommande en production)_

| Champ | Valeur |
|-------|--------|
| **Site key** | |
| **Secret key** | |

> Creer les cles sur https://www.google.com/recaptcha/admin (type v3, ajouter le domaine client + localhost)

## 6. Apparence

| Champ | Valeur |
|-------|--------|
| **Theme** | _(default / corporate / artisan / ...)_ |
| **Couleur primaire** | _(hex, ex: #2563eb)_ |
| **Couleur secondaire** | _(hex, ex: #1e40af)_ |
| **Couleur accent** | _(hex, ex: #f59e0b)_ |
| **Police principale** | _(ex: Inter)_ |
| **Police secondaire** | _(ex: Merriweather)_ |

## 7. Coordonnees completes

| Champ | Valeur |
|-------|--------|
| **Adresse ligne 1** | |
| **Adresse ligne 2** | _(optionnel)_ |
| **Code postal** | |
| **Ville** | |
| **Lien Google Maps** | _(optionnel)_ |

## 8. SEO

| Champ | Valeur |
|-------|--------|
| **Titre SEO par defaut** | _(le title Google, ex: "Boulangerie Martin - Pain artisanal a Lyon")_ |
| **Description SEO par defaut** | _(meta description, ~155 caracteres)_ |
| **Google Analytics ID** | _(optionnel, ex: G-XXXXXXXXXX)_ |
| **Google Search Console** | _(optionnel, code de verification)_ |

## 9. Medias

Fournir les fichiers suivants (formats acceptes : PNG, JPG, WebP) :

- [ ] **Logo** — _(fichier: )_
- [ ] **Favicon** — _(fichier: )_
- [ ] **Image hero** (page d'accueil) — _(fichier: )_
- [ ] **Image a propos** _(optionnel)_ — _(fichier: )_

---

## Notes / demandes particulieres

_(Contenu specifique, pages supplementaires, integrations, remarques...)_

