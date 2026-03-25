# Audit CMS existant — Questions pour Claude Code

> Objectif : transformer un CMS maison (~90% terminé) en plateforme multi-site avec abonnement client.

---

## 1. Architecture générale

- Quelle est la structure de dossiers du projet ? Génère un arbre complet.
- Quel stack technique est utilisé (PHP version, framework, BDD, front) ?
- Y a-t-il un fichier de configuration central ? Montre-le.
- Comment sont gérées les dépendances (Composer, npm, autre) ?
- Y a-t-il déjà une notion de "site" ou "tenant" dans le code ? Si oui, comment est-elle implémentée ?

---

## 2. Base de données

- Montre le schéma complet de la BDD (tables, colonnes, relations).
- Y a-t-il déjà un champ `site_id` ou équivalent dans les tables principales ?
- Comment sont gérés les utilisateurs : un seul espace ou déjà cloisonné par site ?
- Quelle stratégie de multi-tenancy serait la plus adaptée à l'architecture actuelle ?
  - Base unique avec `site_id` sur chaque table
  - Une base par client
  - Schéma séparé par client
- Y a-t-il des données "globales" (partagées entre sites) et des données "locales" (par site) ? Identifie-les.

---

## 3. Système de thèmes

- Comment est actuellement géré le rendu front (templates, moteur de template) ?
- Est-il possible d'associer un thème différent par site sans tout refactoriser ?
- Où sont stockés les assets (CSS, JS, images) ? Sont-ils mutualisés ou par site ?
- Quelle structure de dossier proposes-tu pour un système multi-thème propre ?

---

## 4. Authentification & rôles

- Comment fonctionne le système d'authentification actuel ?
- Quels rôles existent (admin, éditeur, lecteur…) ?
- Est-il possible d'avoir un super-admin (moi) qui gère tous les sites, et des admins clients limités à leur site ?
- Y a-t-il une gestion de session qui pourrait poser problème en multi-site ?

---

## 5. Back-office client

- Quelles fonctionnalités d'édition sont déjà disponibles pour l'utilisateur final ?
- Qu'est-ce qui manque pour qu'un client non-technique puisse éditer son site seul ?
- Y a-t-il une prévisualisation des modifications avant publication ?
- Comment sont gérés les médias (upload, stockage, organisation) ?

---

## 6. Ce qui reste à faire (les 10%)

- Analyse le code et identifie les fonctionnalités incomplètes (TODO, fonctions vides, routes manquantes).
- Y a-t-il des zones avec du code commenté ou des placeholders ?
- Quels sont les points bloquants pour une mise en production ?
- Génère une liste priorisée des tâches restantes.

---

## 7. Qualité du code & sécurité

- Y a-t-il des failles évidentes (injections SQL, XSS, CSRF non protégé) ?
- Les mots de passe sont-ils hashés correctement ?
- Y a-t-il une gestion des erreurs et des logs ?
- Le code est-il cohérent en termes de style et de structure, ou y a-t-il des parties hétérogènes ?

---

## 8. Performance & scalabilité

- Y a-t-il un système de cache ? Si non, où en aurait-on le plus besoin ?
- Les requêtes BDD sont-elles optimisées (index, N+1 problèmes) ?
- L'architecture actuelle peut-elle tenir 20-30 sites simultanément sans refonte majeure ?

---

## 9. Hébergement & déploiement

- Y a-t-il un système de déploiement automatisé ou tout est manuel ?
- Comment envisager l'isolation entre les sites clients (sous-domaines, dossiers, vhosts) ?
- Quelle stratégie pour les sauvegardes par client ?
- Est-ce que le code est versionné (Git) ? Y a-t-il des branches de travail propres ?

---

## 10. Système d'abonnement (à construire)

- Quelle table / module faudrait-il ajouter pour gérer les abonnements (date début, statut, tarif) ?
- Comment désactiver automatiquement un site si l'abonnement expire ?
- Faut-il intégrer un outil de paiement (Stripe) ou gérer la facturation manuellement pour commencer ?
- Propose un schéma de données minimal pour gérer : client → site → abonnement → statut.

---

## Commandes utiles à donner à Claude Code

```bash
# Lire la structure du projet
find . -type f -name "*.php" | head -50

# Voir le schéma BDD si dump disponible
cat database.sql | grep "CREATE TABLE"

# Chercher les TODO et FIXME
grep -r "TODO\|FIXME\|HACK\|XXX" --include="*.php" .

# Chercher les requêtes SQL brutes (potentiel risque sécurité)
grep -r "mysql_query\|mysqli_query\|\$_GET\|\$_POST" --include="*.php" .
```

---

*Utilise ces questions dans l'ordre lors de ta session Claude Code. Commence par l'architecture générale avant de plonger dans les détails.*
