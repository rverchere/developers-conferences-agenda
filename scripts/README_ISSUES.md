# 📝 Scripts de Création d'Issues GitHub

Ce répertoire contient les scripts pour créer automatiquement toutes les issues GitHub du plan d'amélioration 2025.

## 📋 Fichiers

- **`create-all-issues.sh`** : Script principal pour créer les 16 issues
- **`create-improvement-issues.sh`** : Script détaillé avec contenu complet des issues (référence)

## 🚀 Utilisation

### Option 1 : Script Automatique (Recommandé)

Créer toutes les 16 issues d'un coup :

```bash
# Rendre le script exécutable (si nécessaire)
chmod +x scripts/create-all-issues.sh

# Exécuter
./scripts/create-all-issues.sh
```

Le script va :
1. Demander confirmation avant de créer les issues
2. Créer 16 issues dans l'ordre :
   - 1 Quick Wins
   - 3 Critiques
   - 4 Hautes priorités
   - 4 Moyennes priorités
   - 4 Basses priorités
   - 1 Epic principale (récapitulative)
3. Afficher l'URL de chaque issue créée

### Option 2 : Création Manuelle

Si vous préférez créer les issues manuellement :

1. Consultez le fichier **`../IMPROVEMENT_PLAN_ISSUES.md`**
2. Copiez le contenu de chaque issue
3. Créez les issues via l'interface GitHub

## 📦 Prérequis

- **GitHub CLI** installé et configuré
  ```bash
  # Installer gh (si nécessaire)
  # macOS
  brew install gh

  # Linux
  sudo apt install gh

  # Windows
  winget install GitHub.cli

  # Authentifier
  gh auth login
  ```

- **Permissions** : Vous devez avoir les droits de création d'issues sur le repository

## 📚 Documentation

Pour voir les détails complets de chaque amélioration, consultez :

- **`../IMPROVEMENT_PLAN_ISSUES.md`** : Documentation complète de toutes les issues (recommandations, code, estimations)

## 🔍 Vérifier les Issues Créées

Après avoir exécuté le script :

```bash
# Lister toutes les issues d'amélioration
gh issue list --label enhancement

# Lister par priorité
gh issue list --label critical
gh issue list --label high-priority

# Voir les quick wins
gh issue list --label quick-win

# Voir l'epic
gh issue list --label epic
```

## 🏷️ Labels Utilisés

Les issues sont automatiquement taguées avec :

- **Priorité** : `critical`, `high-priority`
- **Type** : `enhancement`, `bug`, `refactoring`, `feature`
- **Domaine** : `performance`, `accessibility`, `mobile`, `testing`, `css`, `i18n`, `seo`, `pwa`
- **Statut** : `quick-win`, `good first issue`
- **Structure** : `epic`

## ⚠️ Notes Importantes

1. **Ne pas exécuter deux fois** : Le script créera des doublons si exécuté plusieurs fois
2. **Ordre de création** : Les issues sont créées dans un ordre logique (Quick Wins → Critical → High → Medium → Low → Epic)
3. **Epic en dernier** : L'issue Epic est créée en dernier pour pouvoir référencer les autres issues

## 🎯 Prochaines Étapes

Après avoir créé les issues :

1. **Prioriser** : Organiser les issues dans un project board
2. **Assigner** : Attribuer les issues aux développeurs
3. **Milestones** : Créer des milestones pour les sprints
4. **Commencer** : Démarrer par les Quick Wins !

## 📞 Support

Si vous rencontrez des problèmes :

1. Vérifiez que `gh` est bien installé : `gh --version`
2. Vérifiez l'authentification : `gh auth status`
3. Vérifiez les permissions : `gh repo view`

Pour plus d'aide : https://cli.github.com/manual/
