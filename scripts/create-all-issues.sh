#!/bin/bash

# Script pour créer toutes les issues GitHub du plan d'amélioration
# Usage: ./scripts/create-all-issues.sh

set -e

echo "🚀 Création de toutes les issues GitHub pour le plan d'amélioration..."
echo ""
echo "⚠️  Ce script va créer 16 issues GitHub."
echo ""
read -p "Continuer? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Annulé."
    exit 1
fi

# Fonction helper pour créer une issue
create_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"

    echo "📝 Création: $title"
    issue_url=$(gh issue create --title "$title" --label "$labels" --body "$body")
    echo "✅ Créée: $issue_url"
    echo ""
}

echo ""
echo "=========================================="
echo "🛠️  QUICK WINS"
echo "=========================================="

create_issue \
"🛠️ Quick Wins - Améliorations Techniques Rapides" \
"Implémenter des améliorations rapides à fort impact en moins d'une semaine.

## Tâches
- [ ] Error Boundary React au niveau App
- [ ] Marker clustering pour la carte
- [ ] Constantes pour magic strings
- [ ] ARIA labels basiques
- [ ] Centraliser génération Event ID
- [ ] Messages états vides
- [ ] Optimiser favicon (WebP)

## Impact
- Stabilité, performance, accessibilité, maintenabilité

## Estimation
**1-2 jours**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,good first issue,quick-win"

echo ""
echo "=========================================="
echo "🔴 PRIORITÉ CRITIQUE"
echo "=========================================="

create_issue \
"🔴 CRITICAL: Migration TypeScript" \
"Migrer progressivement le codebase vers TypeScript.

## Problèmes
- Aucun typage statique
- PropTypes désactivés
- Nombreux typeof checks
- Risques erreurs runtime

## Plan
- Phase 1: Config + types de base + utils
- Phase 2: Hooks + contextes
- Phase 3: Composants atomiques
- Phase 4: Composants complexes
- Phase 5: Routes + App + strict mode

## Bénéfices
- Réduction bugs
- Autocomplétion IDE
- Refactoring sûr
- Documentation vivante

## Estimation
**6-8 semaines** (progressif)

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"critical,enhancement,refactoring"

create_issue \
"🔴 CRITICAL: Optimisation Performances - Gros Fichiers JSON" \
"Résoudre le problème de all-events.json (5000+ événements, 2-3 MB).

## Problème
- Chargement complet au démarrage
- FCP > 4s sur 3G
- 150 MB mémoire

## Solution
- Split JSON par année
- Lazy loading dynamique
- Charger seulement année courante + 2 suivantes
- États de chargement

## Impact Attendu
- Bundle: 3 MB → 500 KB (-83%)
- FCP: 4s → 1.5s (-62%)
- Mémoire: 150 MB → 50 MB (-67%)

## Estimation
**3-4 jours**

Fichiers: tools/mdParser.js, page/src/app.hooks.js

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"critical,performance,enhancement"

create_issue \
"🔴 CRITICAL: Error Boundaries React" \
"Empêcher les crashes complets de l'application.

## Problème
- Aucun Error Boundary
- Erreur → écran blanc complet

## Solution
- Error Boundary général (App-level)
- Boundaries spécifiques (Map, Calendar)
- Messages user-friendly
- Logging erreurs

## Impact
- Stabilité: app ne crash plus
- UX: messages d'erreur clairs
- Monitoring possible

## Estimation
**1-2 jours**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"critical,bug,enhancement"

echo ""
echo "=========================================="
echo "🟠 PRIORITÉ HAUTE"
echo "=========================================="

create_issue \
"🟠 HIGH: Accessibilité (A11y) - Conformité WCAG 2.1 AA" \
"Améliorer l'accessibilité pour conformité WCAG 2.1 AA.

## Problèmes
- Badges CFP couleur uniquement
- ARIA labels manquants
- Navigation clavier impossible
- Focus management manquant
- Lecteurs d'écran non supportés

## Plan
- Phase 1: Audit (axe-core)
- Phase 2: Corrections critiques (badges, ARIA, keyboard)
- Phase 3: Structure sémantique
- Phase 4: Tests validation

## Objectifs
- Lighthouse A11y: > 95
- axe violations: 0
- Navigation clavier: 100%

## Estimation
**2-3 semaines**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,accessibility,high-priority"

create_issue \
"🟠 HIGH: Responsive Design Mobile" \
"Optimiser l'expérience mobile (50%+ des users).

## Problèmes
- Calendrier trop dense sur mobile
- Filtres masquent contenu
- Carte difficile au toucher
- Touch targets < 44px
- Texte trop petit

## Solutions
- Breakpoints responsive
- Calendrier mobile (liste par défaut)
- Filtres en bottom sheet
- Touch targets 44x44px min
- Typographie adaptée
- Navigation bottom bar

## Objectifs
- Lighthouse Mobile: > 90
- Touch targets: 100% ≥ 44px
- FCP mobile: < 2s sur 3G

## Estimation
**2-3 semaines**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,mobile,high-priority"

create_issue \
"🟠 HIGH: Tests E2E et Composants" \
"Augmenter la couverture de tests.

## État Actuel
- Tests unitaires: 3 fichiers (hooks seulement)
- Tests composants: 0 ❌
- Tests E2E: 0 ❌

## Plan
- Phase 1: Config (RTL + Playwright)
- Phase 2: Tests composants (atomiques, complexes, contextes)
- Phase 3: Tests E2E (navigation, filtres, favoris, carte)
- Phase 4: Visual regression

## Objectifs Coverage
- Statements: > 80%
- Branches: > 75%
- Functions: > 80%

## Estimation
**3-4 semaines**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,testing,high-priority"

create_issue \
"🟠 HIGH: Performance MapView - Marker Clustering" \
"Optimiser la carte pour 1000+ événements.

## Problèmes
- 1000+ markers individuels
- Re-renders complets
- Pas de virtualisation
- Lag zoom/pan

## Solutions
- react-leaflet-cluster
- Custom cluster icons
- Optimiser re-rendering (useMemo)
- Lazy loading carte
- Debounce filtres
- Cache geolocations

## Impact Attendu
- Rendu: 3-5s → 0.5-1s
- Zoom/Pan: fluide 60 FPS
- Mémoire: 150 MB → 80 MB (-50%)

## Estimation
**3-4 jours**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,performance,high-priority"

echo ""
echo "=========================================="
echo "🟡 PRIORITÉ MOYENNE"
echo "=========================================="

create_issue \
"🟡 MEDIUM: Amélioration UX" \
"Améliorer l'expérience utilisateur globale.

## Améliorations
- États vides (messages filtres 0 résultats)
- États de chargement (spinners)
- Onboarding (tour guidé nouveaux users)
- Badge filtres actifs
- Raccourcis clavier (/, f, etc.)
- Scroll to top amélioré

## Impact
- Expérience plus intuitive et professionnelle

## Estimation
**1-2 semaines**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,ux"

create_issue \
"🟡 MEDIUM: Refactoring Gestion d'État" \
"Standardiser et simplifier la gestion d'état.

## Problèmes
- Mix Context + URL params + hooks locaux
- FilterContext sous-utilisé
- Prop drilling

## Solutions
- Auditer contexts
- Considérer Zustand
- Standardiser URL params
- Supprimer FilterContext si inutile

## Impact
- Code plus maintenable
- Moins de prop drilling

## Estimation
**1-2 semaines**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,refactoring"

create_issue \
"🟡 MEDIUM: Architecture CSS" \
"Moderniser et organiser les styles.

## Problèmes
- 24 fichiers CSS séparés
- Risque collisions
- Styles dupliqués

## Solutions
- Migrer vers CSS Modules ou Tailwind
- Design tokens (couleurs, spacings)
- Audit duplications
- Mobile-first approach

## Impact
- Cohérence visuelle
- Moins de code
- Maintenabilité

## Estimation
**1-2 semaines**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,css"

create_issue \
"🟡 MEDIUM: Optimisation Build & CI" \
"Améliorer le processus de build et CI.

## Améliorations
- Error checking dans run.sh
- Validation schema JSON
- Cache npm dans GitHub Actions
- Optimiser images (WebP)
- Bundle analysis
- Pre-commit hooks

## Impact
- Builds plus rapides
- Moins d'erreurs
- Meilleure DX

## Estimation
**3-5 jours**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,ci-cd"

echo ""
echo "=========================================="
echo "🟢 PRIORITÉ BASSE"
echo "=========================================="

create_issue \
"🟢 LOW: Internationalisation (i18n)" \
"Supporter plusieurs langues.

## Langues
- FR (priorité)
- EN
- ES, DE

## Solution
- react-i18next
- Traductions
- Format dates/nombres localisés

## Impact
- Audience internationale élargie

## Estimation
**2-3 semaines**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,i18n"

create_issue \
"🟢 LOW: SEO & Pre-rendering" \
"Améliorer le référencement Google.

## Problèmes
- HashRouter (pas de SSR)
- Pas de meta tags dynamiques
- Pas de sitemap

## Solutions
- Migrer vers BrowserRouter
- Pre-rendering statique (Vite SSG)
- Meta tags dynamiques
- Sitemap.xml
- Structured data (JSON-LD)

## Impact
- Meilleur référencement
- Plus de trafic organique

## Estimation
**2-3 semaines**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,seo"

create_issue \
"🟢 LOW: PWA & Offline Support" \
"Rendre l'app utilisable hors ligne.

## Fonctionnalités
- Service worker (Workbox)
- Cache events offline
- Background sync favoris
- Installation app native

## Impact
- Utilisable hors ligne
- App-like experience

## Estimation
**1-2 semaines**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,pwa"

create_issue \
"🟢 LOW: Fonctionnalités Communautaires" \
"Enrichir l'engagement communauté.

## Fonctionnalités
- Comptes utilisateurs (OAuth optionnel)
- Profils speakers
- Reviews/ratings événements
- Notifications CFP (push/email)
- Export calendriers (Google, Outlook)

## Impact
- Engagement communauté
- Valeur ajoutée

## Estimation
**4-6 semaines**

Voir IMPROVEMENT_PLAN_ISSUES.md pour tous les détails." \
"enhancement,feature"

echo ""
echo "=========================================="
echo "📋 EPIC PRINCIPALE"
echo "=========================================="

create_issue \
"📋 Epic - Plan d'Action Global Améliorations 2025" \
"Plan d'action complet pour améliorer developers.events.

## Objectifs
- ⚡ Performances (Lighthouse > 90)
- ♿ Accessibilité (Score > 95)
- 🛠️ Maintenabilité (TypeScript, tests > 80%)
- 📱 Mobile (FCP < 3s)
- 📈 Scalabilité

## Roadmap
**Sprint 1-2**: Error Boundaries, A11y, Clustering, Tests
**Sprint 3-4**: TypeScript phase 1, JSON split, Mobile
**Sprint 5-6**: Tests E2E, TypeScript phase 2, CSS
**Sprint 7-8**: SEO, PWA, i18n

## Métriques
- Performance: > 90
- A11y: > 95
- Tests: > 80%
- Bundle: < 500KB
- Mobile FCP: < 3s

Voir toutes les issues associées ci-dessus.
Détails complets dans IMPROVEMENT_PLAN_ISSUES.md" \
"epic,enhancement"

echo ""
echo "=========================================="
echo "✅ TERMINÉ !"
echo "=========================================="
echo ""
echo "🎉 Toutes les 16 issues ont été créées avec succès !"
echo ""
echo "📝 Pour voir les détails complets, consultez:"
echo "   IMPROVEMENT_PLAN_ISSUES.md"
echo ""
echo "🔗 Pour voir les issues créées:"
echo "   gh issue list --label enhancement"
echo ""
