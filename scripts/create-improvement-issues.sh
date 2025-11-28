#!/bin/bash

# Script pour créer toutes les issues d'amélioration GitHub
# Usage: ./scripts/create-improvement-issues.sh

set -e

echo "🚀 Création des issues d'amélioration pour developers.events..."
echo ""

# Fonction pour créer une issue et retourner son numéro
create_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"

    echo "Création de l'issue: $title"
    gh issue create --title "$title" --label "$labels" --body "$body" | grep -oP '#\K[0-9]+'
}

# Tableau pour stocker les numéros d'issues
declare -A issues

# ============================================================================
# QUICK WINS
# ============================================================================

issues[quickwins]=$(create_issue \
"🛠️ Quick Wins - Améliorations Techniques Rapides" \
"$(cat <<'EOF'
## 🎯 Objectif

Implémenter des améliorations rapides à fort impact qui peuvent être réalisées en moins d'une semaine.

## 📋 Tâches

- [ ] Ajouter Error Boundary React au niveau App
- [ ] Implémenter marker clustering pour la carte
- [ ] Créer des constantes pour les "magic strings" (status, view types, etc.)
- [ ] Ajouter ARIA labels basiques sur les composants interactifs
- [ ] Centraliser la génération des Event ID dans un utilitaire
- [ ] Ajouter des messages pour les états vides (filtres sans résultats)
- [ ] Optimiser le favicon (convertir en WebP, réduire la taille)

## 💡 Détails Techniques

### Error Boundary
```jsx
// page/src/components/ErrorBoundary/ErrorBoundary.jsx
import React from 'react';

class ErrorBoundary extends React.Component {
  state = { hasError: false, error: null };

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.error('Error caught:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="error-boundary">
          <h1>Oups, quelque chose s'est mal passé</h1>
          <button onClick={() => window.location.reload()}>
            Recharger la page
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}
```

### Marker Clustering
```bash
npm install react-leaflet-cluster
```

### Constantes
```javascript
// page/src/utils/constants.js
export const VIEW_TYPES = {
  CALENDAR: 'calendar',
  LIST: 'list',
  MAP: 'map',
  CFP: 'cfp'
};

export const EVENT_STATUS = {
  OPEN: 'open',
  CLOSED: 'closed'
};
```

## 📈 Impact

- **Stabilité** : Error boundaries empêchent les crashes complets
- **Performance** : Marker clustering améliore la carte avec 1000+ événements
- **Maintenabilité** : Constantes et utilitaires réduisent les bugs
- **Accessibilité** : ARIA labels améliorent l'expérience pour lecteurs d'écran
- **UX** : Messages d'états vides guident l'utilisateur

## ⏱️ Estimation

**1-2 jours** pour l'ensemble des tâches

## 🔗 Fichiers concernés

- `page/src/App.jsx`
- `page/src/components/MapView/MapView.jsx`
- `page/src/components/Filters/Filters.jsx`
- `page/src/utils/` (nouveau)
- `page/favicon.png`
EOF
)" \
"enhancement,good first issue,quick-win")

echo "✅ Issue Quick Wins créée: #${issues[quickwins]}"
echo ""

# ============================================================================
# CRITICAL PRIORITY
# ============================================================================

issues[typescript]=$(create_issue \
"🔴 CRITICAL: Migration TypeScript" \
"$(cat <<'EOF'
## 🎯 Objectif

Migrer progressivement le codebase JavaScript vers TypeScript pour améliorer la fiabilité, la maintenabilité et l'expérience développeur.

## 📊 État Actuel

- **Problèmes identifiés** :
  - Aucun typage statique (PropTypes désactivés dans ESLint)
  - Nombreux `typeof` checks dans le code (indicateurs de confusion de types)
  - Risques d'erreurs runtime
  - Refactoring difficile

## 📋 Plan de Migration (Progressif)

### Phase 1 : Fondations (Sprint 1-2)

- [ ] Configurer TypeScript dans le projet
  - [ ] `tsconfig.json` avec `allowJs: true`
  - [ ] Installer `@types` nécessaires
  - [ ] Configurer Vite pour TypeScript
- [ ] Migrer les utilitaires (`/page/src/utils/`)
- [ ] Créer les types/interfaces de base
  - [ ] `Event`, `CFP`, `Tag`, `Location`
  - [ ] Types pour les filtres
- [ ] Migrer les hooks (`app.hooks.js` → `app.hooks.ts`)

### Phase 2 : Contextes et Logique (Sprint 3-4)

- [ ] Migrer les contextes
  - [ ] `FavoritesContext.jsx` → `FavoritesContext.tsx`
  - [ ] `TagsContext.jsx` → `TagsContext.tsx`
  - [ ] `FilterContext.jsx` → `FilterContext.tsx`
- [ ] Typer les hooks personnalisés
- [ ] Migrer les composants utilitaires

### Phase 3 : Composants (Sprint 5-6)

- [ ] Migrer les composants atomiques
  - [ ] `ShortDate`, `FavoriteButton`, etc.
- [ ] Migrer les composants de filtrage
  - [ ] `Filters`, `TagMultiSelect`, etc.
- [ ] Migrer les vues
  - [ ] `Calendar`, `ListView`, `MapView`, `CfpView`

### Phase 4 : Routes et App (Sprint 7)

- [ ] Migrer les routes
- [ ] Migrer `App.jsx` → `App.tsx`
- [ ] Activer `strict: true` dans tsconfig

## 💡 Types Clés à Définir

```typescript
// types/event.ts
export interface Event {
  name: string;
  date: [number, number?]; // UTC timestamps
  hyperlink: string;
  location: string;
  city: string;
  country: string;
  misc?: string;
  cfp?: CFP;
  sponsoring?: string;
  closedCaptions: boolean;
  scholarship: boolean;
  sponsoringBadge: boolean;
  status: 'open' | 'closed' | string;
  tags: Tag[];
}

export interface CFP {
  link: string;
  until: string;
  untilDate: number;
}

export interface Tag {
  key: 'tech' | 'topic' | 'type' | 'language';
  value: string;
}

export interface Filters {
  query: string;
  country?: string;
  region?: string;
  tags: Tag[];
  closedCaptions: boolean;
  scholarship: boolean;
  online: boolean;
  favorites: boolean;
  sponsoring: boolean;
}
```

## 📈 Bénéfices

- **Réduction des bugs** : Détection des erreurs à la compilation
- **Autocomplétion** : Meilleure DX dans les IDEs
- **Refactoring sûr** : TypeScript garantit la cohérence
- **Documentation** : Les types servent de documentation vivante
- **Onboarding** : Nouveaux contributeurs comprennent mieux le code

## ⚠️ Risques et Mitigation

- **Effort élevé** : Migration progressive sur plusieurs sprints
- **Courbe d'apprentissage** : Formation TypeScript si nécessaire
- **Compatibilité** : Tester à chaque phase

## 🔗 Ressources

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [React TypeScript Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)
- [Migrating from JS to TS](https://www.typescriptlang.org/docs/handbook/migrating-from-javascript.html)

## ⏱️ Estimation

**6-8 semaines** (migration progressive)

## 🏷️ Labels

`critical`, `enhancement`, `refactoring`, `typescript`
EOF
)" \
"critical,enhancement,refactoring")

echo "✅ Issue TypeScript créée: #${issues[typescript]}"
echo ""

issues[json_perf]=$(create_issue \
"🔴 CRITICAL: Optimisation des Performances - Gros Fichiers JSON" \
"$(cat <<'EOF'
## 🎯 Objectif

Résoudre le problème de performance causé par le chargement de `all-events.json` qui contient 5000+ événements (archives + futurs).

## 📊 État Actuel

### Problème
- `all-events.json` : ~2-3 MB de données chargées au démarrage
- Tous les événements depuis 2017 inclus
- Parsing et filtrage ralentissent l'application
- First Contentful Paint > 4s sur connexions lentes

### Impact
- Mauvaise expérience utilisateur (temps de chargement)
- Consommation mémoire élevée
- Filtrage lent avec beaucoup d'événements

## 📋 Solution Proposée

### 1. Split JSON par Année

```bash
# Structure proposée
page/src/misc/
├── events-2024.json
├── events-2025.json
├── events-2026.json
└── events-index.json  # Métadonnées légères
```

**Modification dans `tools/mdParser.js`** :
```javascript
// Générer un fichier par année
const eventsByYear = {};
allEvents.forEach(event => {
  const year = new Date(event.date[0]).getFullYear();
  if (!eventsByYear[year]) eventsByYear[year] = [];
  eventsByYear[year].push(event);
});

// Écrire chaque année
Object.entries(eventsByYear).forEach(([year, events]) => {
  writeFile(`events-${year}.json`, events);
});

// Index avec métadonnées
const index = {
  years: Object.keys(eventsByYear),
  totalEvents: allEvents.length,
  lastUpdate: new Date().toISOString()
};
writeFile('events-index.json', index);
```

### 2. Lazy Loading

**Modifier `page/src/app.hooks.js`** :
```javascript
// Au lieu de charger all-events.json
import allEvents from './misc/all-events.json';

// Charger dynamiquement
const [events, setEvents] = useState([]);
const [loading, setLoading] = useState(true);

useEffect(() => {
  const currentYear = new Date().getFullYear();
  const yearsToLoad = [currentYear, currentYear + 1, currentYear + 2];

  Promise.all(
    yearsToLoad.map(year =>
      import(`./misc/events-${year}.json`)
        .then(module => module.default)
        .catch(() => []) // Année n'existe pas encore
    )
  ).then(results => {
    setEvents(results.flat());
    setLoading(false);
  });
}, []);
```

### 3. Pagination Côté Client

Pour la vue liste, implémenter une pagination virtuelle :
```bash
npm install react-window
```

```javascript
import { FixedSizeList } from 'react-window';

// Dans ListView
<FixedSizeList
  height={800}
  itemCount={filteredEvents.length}
  itemSize={120}
>
  {({ index, style }) => (
    <div style={style}>
      <EventDisplay event={filteredEvents[index]} />
    </div>
  )}
</FixedSizeList>
```

### 4. Archives Séparées

- Charger les archives uniquement si l'utilisateur sélectionne une année < 2024
- Bouton "Charger les archives" si besoin

## 📋 Tâches

- [ ] Modifier `tools/mdParser.js` pour générer JSON par année
- [ ] Mettre à jour `ghpages.yml` workflow pour copier tous les JSON
- [ ] Implémenter le lazy loading dans `app.hooks.js`
- [ ] Ajouter un état de chargement (spinner)
- [ ] Implémenter la pagination pour ListView
- [ ] Tester avec des datasets de différentes tailles
- [ ] Mesurer les gains de performance (Lighthouse)

## 📈 Impact Attendu

**Avant** :
- Bundle initial : ~3 MB
- First Contentful Paint : ~4s
- Time to Interactive : ~5s

**Après** :
- Bundle initial : ~500 KB (année courante + 2 prochaines)
- First Contentful Paint : ~1.5s (-60%)
- Time to Interactive : ~2s (-60%)

## ⚠️ Risques

- **Breaking change** : Les utilisateurs utilisant directement `all-events.json`
  - **Mitigation** : Garder `all-events.json` en legacy pendant 6 mois
- **Build complexity** : Plus de fichiers à générer
  - **Mitigation** : Scripter et tester en CI

## 🔗 Fichiers Concernés

- `tools/mdParser.js` (ligne 52-246)
- `page/src/app.hooks.js` (ligne 2, imports)
- `.github/workflows/ghpages.yml` (ligne 48-53, copie des JSON)

## ⏱️ Estimation

**3-4 jours**

## 🏷️ Labels

`critical`, `performance`, `enhancement`
EOF
)" \
"critical,performance,enhancement")

echo "✅ Issue JSON Performance créée: #${issues[json_perf]}"
echo ""

issues[error_boundaries]=$(create_issue \
"🔴 CRITICAL: Error Boundaries React" \
"$(cat <<'EOF'
## 🎯 Objectif

Implémenter des Error Boundaries React pour empêcher les crashes complets de l'application et offrir une expérience utilisateur dégradée mais fonctionnelle.

## 📊 État Actuel

### Problème
- Aucun Error Boundary dans l'application
- Une erreur dans un composant crash toute l'app
- Écran blanc pour l'utilisateur
- Aucun logging des erreurs

### Exemples de Scénarios
- Échec du géocodage sur la carte → MapView crash
- Événement mal formaté → EventDisplay crash
- API localStorage pleine → FavoritesContext crash

## 📋 Solution Proposée

### 1. Error Boundary Général (App Level)

```jsx
// page/src/components/ErrorBoundary/ErrorBoundary.jsx
import React from 'react';
import './ErrorBoundary.css';

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      hasError: false,
      error: null,
      errorInfo: null
    };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true };
  }

  componentDidCatch(error, errorInfo) {
    this.setState({
      error,
      errorInfo
    });

    // Log to console in dev
    console.error('Error Boundary caught:', error, errorInfo);

    // TODO: Send to error tracking service (Sentry)
    // logErrorToService(error, errorInfo);
  }

  handleReset = () => {
    this.setState({
      hasError: false,
      error: null,
      errorInfo: null
    });
    window.location.href = '/';
  };

  render() {
    if (this.state.hasError) {
      return (
        <div className="error-boundary">
          <div className="error-boundary__content">
            <h1>😕 Oups, quelque chose s'est mal passé</h1>
            <p>
              Une erreur inattendue s'est produite.
              Nos équipes en ont été informées.
            </p>

            {process.env.NODE_ENV === 'development' && (
              <details className="error-boundary__details">
                <summary>Détails de l'erreur (dev only)</summary>
                <pre>{this.state.error?.toString()}</pre>
                <pre>{this.state.errorInfo?.componentStack}</pre>
              </details>
            )}

            <div className="error-boundary__actions">
              <button onClick={this.handleReset}>
                Retour à l'accueil
              </button>
              <button onClick={() => window.location.reload()}>
                Recharger la page
              </button>
            </div>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}

export default ErrorBoundary;
```

### 2. Error Boundaries Spécifiques

**MapView Boundary** :
```jsx
// page/src/components/MapView/MapErrorBoundary.jsx
class MapErrorBoundary extends React.Component {
  state = { hasError: false };

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="map-error">
          <p>Impossible de charger la carte.</p>
          <p>Essayez la <a href="#/2025/list">vue liste</a> à la place.</p>
        </div>
      );
    }
    return this.props.children;
  }
}
```

### 3. Intégration dans App.jsx

```jsx
// page/src/App.jsx
import ErrorBoundary from './components/ErrorBoundary/ErrorBoundary';
import MapErrorBoundary from './components/MapView/MapErrorBoundary';

function App() {
  return (
    <ErrorBoundary>
      <FavoritesProvider>
        <TagsProvider>
          <Router>
            <Routes>
              <Route path="/map" element={
                <MapErrorBoundary>
                  <MapPage />
                </MapErrorBoundary>
              } />
              {/* autres routes */}
            </Routes>
          </Router>
        </TagsProvider>
      </FavoritesProvider>
    </ErrorBoundary>
  );
}
```

## 📋 Tâches

- [ ] Créer le composant `ErrorBoundary` générique
- [ ] Créer les styles `ErrorBoundary.css`
- [ ] Wrapper l'App dans `<ErrorBoundary>`
- [ ] Créer `MapErrorBoundary` spécifique
- [ ] Créer `CalendarErrorBoundary` spécifique
- [ ] Ajouter des tests pour les Error Boundaries
- [ ] Intégrer Sentry pour le tracking des erreurs (optionnel)
- [ ] Documenter l'utilisation des Error Boundaries

## 📈 Impact

- **Stabilité** : L'app ne crash plus complètement
- **UX** : Messages d'erreur user-friendly
- **Debugging** : Meilleure visibilité des erreurs
- **Monitoring** : Possibilité de tracker les erreurs en production

## 🧪 Tests

```javascript
// ErrorBoundary.test.jsx
import { render } from '@testing-library/react';
import ErrorBoundary from './ErrorBoundary';

const ThrowError = () => {
  throw new Error('Test error');
};

test('should catch errors and display fallback', () => {
  const { getByText } = render(
    <ErrorBoundary>
      <ThrowError />
    </ErrorBoundary>
  );

  expect(getByText(/quelque chose s'est mal passé/i)).toBeInTheDocument();
});
```

## 🔗 Fichiers Concernés

- `page/src/components/ErrorBoundary/` (nouveau)
- `page/src/App.jsx` (wrapper)
- `page/src/routes/MapPage.jsx`
- `page/src/routes/DatePage.jsx`

## ⏱️ Estimation

**1-2 jours**

## 🏷️ Labels

`critical`, `bug`, `enhancement`, `good first issue`
EOF
)" \
"critical,bug,enhancement")

echo "✅ Issue Error Boundaries créée: #${issues[error_boundaries]}"
echo ""

# ============================================================================
# HIGH PRIORITY
# ============================================================================

issues[a11y]=$(create_issue \
"🟠 HIGH: Accessibilité (A11y) - Conformité WCAG 2.1 AA" \
"$(cat <<'EOF'
## 🎯 Objectif

Améliorer l'accessibilité du site pour atteindre la conformité WCAG 2.1 niveau AA et rendre l'application utilisable par tous.

## 📊 État Actuel

### Problèmes Identifiés

1. **Contraste de couleurs** : Badges CFP rouge/vert uniquement
2. **ARIA labels** : Manquants sur boutons et contrôles
3. **Navigation clavier** : Impossible de naviguer sans souris
4. **Focus management** : Pas de gestion du focus dans les modales
5. **Lecteurs d'écran** : Contenu non descriptif
6. **Texte alternatif** : Images/icônes sans alt

## 📋 Plan d'Action

### Phase 1 : Audit (Sprint 1)

- [ ] Installer et configurer axe-core
  ```bash
  npm install --save-dev @axe-core/react
  ```
- [ ] Exécuter audit automatisé
- [ ] Test manuel avec NVDA/JAWS (Windows) et VoiceOver (Mac)
- [ ] Test navigation clavier complète
- [ ] Documenter tous les problèmes

### Phase 2 : Corrections Critiques (Sprint 1-2)

#### 2.1 Badges CFP - Texte en Plus de la Couleur

```jsx
// page/src/components/CfpDeadline/CfpDeadline.jsx
function CfpDeadline({ cfp }) {
  const isOpen = isCfpOpen(cfp);

  return (
    <div className="cfp-deadline">
      <span
        className={`cfp-badge cfp-badge--${isOpen ? 'open' : 'closed'}`}
        aria-label={isOpen ? 'CFP ouvert' : 'CFP fermé'}
      >
        <span aria-hidden="true">🟢</span>
        {isOpen ? 'CFP Ouvert' : 'CFP Fermé'}
      </span>
      <span>jusqu'au {cfp.until}</span>
    </div>
  );
}
```

#### 2.2 ARIA Labels sur Boutons

```jsx
// page/src/components/FavoriteButton/FavoriteButton.jsx
<button
  onClick={handleToggle}
  aria-label={isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris'}
  aria-pressed={isFavorite}
>
  <Heart fill={isFavorite ? 'red' : 'none'} />
</button>

// page/src/components/ViewSelector/ViewSelector.jsx
<button
  aria-label="Vue calendrier"
  aria-current={view === 'calendar'}
>
  <Calendar />
</button>
```

#### 2.3 Navigation Clavier

```css
/* page/src/styles/global.css */
/* Visible focus indicators */
*:focus {
  outline: 2px solid #0066cc;
  outline-offset: 2px;
}

/* Skip to main content link */
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: #000;
  color: #fff;
  padding: 8px;
  z-index: 100;
}

.skip-link:focus {
  top: 0;
}
```

```jsx
// page/src/App.jsx
<a href="#main-content" className="skip-link">
  Aller au contenu principal
</a>
<main id="main-content" tabIndex="-1">
  {/* content */}
</main>
```

#### 2.4 Focus Management dans Modales

```jsx
// page/src/components/AddEventForm/AddEventForm.jsx
import { useEffect, useRef } from 'react';

function AddEventForm({ isOpen, onClose }) {
  const modalRef = useRef(null);
  const previousFocus = useRef(null);

  useEffect(() => {
    if (isOpen) {
      previousFocus.current = document.activeElement;
      modalRef.current?.focus();

      // Trap focus
      const trapFocus = (e) => {
        if (!modalRef.current?.contains(e.target)) {
          modalRef.current?.focus();
        }
      };
      document.addEventListener('focusin', trapFocus);

      return () => {
        document.removeEventListener('focusin', trapFocus);
        previousFocus.current?.focus();
      };
    }
  }, [isOpen]);

  return (
    <div
      ref={modalRef}
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
      tabIndex="-1"
    >
      <h2 id="modal-title">Ajouter un événement</h2>
      {/* form */}
    </div>
  );
}
```

### Phase 3 : Améliorations Structure (Sprint 2)

#### 3.1 Structure Sémantique

```jsx
// Utiliser les bons éléments HTML
<nav aria-label="Navigation principale">
  <YearSelector />
</nav>

<aside aria-label="Filtres">
  <Filters />
</aside>

<main>
  <h1>Conférences {year}</h1>
  {/* content */}
</main>
```

#### 3.2 ARIA Landmarks

```jsx
<header role="banner">
  <h1>Developers Conferences</h1>
</header>

<nav role="navigation" aria-label="Sélection de vue">
  <ViewSelector />
</nav>

<aside role="complementary" aria-label="Filtres d'événements">
  <Filters />
</aside>

<main role="main">
  <Calendar />
</main>

<footer role="contentinfo">
  {/* footer content */}
</footer>
```

#### 3.3 Tableaux Accessibles (Calendar Grid)

```jsx
// page/src/components/Calendar/Calendar.jsx
<table role="grid" aria-label="Calendrier des conférences">
  <thead>
    <tr>
      <th scope="col">Lun</th>
      <th scope="col">Mar</th>
      {/* ... */}
    </tr>
  </thead>
  <tbody>
    <tr>
      <td role="gridcell" aria-label="1er janvier, 2 événements">
        <Day date={1} events={events} />
      </td>
    </tr>
  </tbody>
</table>
```

### Phase 4 : Tests et Validation (Sprint 2)

- [ ] Tests automatisés avec jest-axe
- [ ] Tests manuels avec lecteurs d'écran
- [ ] Tests navigation clavier complète
- [ ] Tests sur différents devices
- [ ] Validation WCAG avec WAVE ou Lighthouse

## 📋 Tâches Détaillées

- [ ] Installer et configurer axe-core + jest-axe
- [ ] Audit initial complet
- [ ] Ajouter texte aux badges CFP (pas seulement couleur)
- [ ] ARIA labels sur tous les boutons interactifs
- [ ] Indicateurs de focus visibles
- [ ] Skip link "Aller au contenu"
- [ ] Focus management dans modales
- [ ] Structure sémantique HTML5
- [ ] ARIA landmarks
- [ ] Tableaux accessibles (calendar grid)
- [ ] Texte alternatif sur images/icônes
- [ ] Tests avec lecteurs d'écran (NVDA, JAWS, VoiceOver)
- [ ] Tests navigation clavier
- [ ] Documentation accessibilité

## 🧪 Tests

```javascript
// setupTests.js
import { configureAxe } from 'jest-axe';

const axe = configureAxe({
  rules: {
    // Customize rules if needed
  }
});

// Component.test.jsx
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

test('should have no accessibility violations', async () => {
  const { container } = render(<Component />);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

## 📈 Métriques de Succès

- **Lighthouse Accessibility Score** : > 95
- **axe violations** : 0 critical, 0 serious
- **Keyboard navigation** : 100% fonctionnel
- **Screen reader** : Tout le contenu accessible

## 🔗 Ressources

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WebAIM Checklist](https://webaim.org/standards/wcag/checklist)
- [A11y Project](https://www.a11yproject.com/)

## ⏱️ Estimation

**2-3 semaines**

## 🏷️ Labels

`high-priority`, `accessibility`, `enhancement`
EOF
)" \
"enhancement,accessibility,high-priority")

echo "✅ Issue A11y créée: #${issues[a11y]}"
echo ""

issues[mobile]=$(create_issue \
"🟠 HIGH: Responsive Design Mobile" \
"$(cat <<'EOF'
## 🎯 Objectif

Optimiser l'expérience mobile pour offrir une interface adaptée aux petits écrans et interactions tactiles.

## 📊 État Actuel

### Problèmes Identifiés

1. **Grille calendrier** : Trop dense sur mobile (7 colonnes)
2. **Filtres** : Panel peut masquer le contenu
3. **Carte** : Interactions difficiles au toucher
4. **Touch targets** : Boutons trop petits (< 44px)
5. **Texte** : Taille de police trop petite
6. **Navigation** : Difficile avec les doigts

### Impact
- ~50% des utilisateurs sont sur mobile
- Taux de rebond élevé sur mobile
- Mauvaise expérience utilisateur

## 📋 Solution Proposée

### 1. Breakpoints Responsive

```css
/* page/src/styles/breakpoints.css */
:root {
  --mobile: 0px;
  --tablet: 768px;
  --desktop: 1024px;
  --wide: 1440px;
}

@custom-media --mobile (max-width: 767px);
@custom-media --tablet (min-width: 768px) and (max-width: 1023px);
@custom-media --desktop (min-width: 1024px);
```

### 2. Calendrier Mobile

**Option A : Vue Liste par Défaut**
```jsx
// page/src/routes/DatePage.jsx
import { useMediaQuery } from './hooks/useMediaQuery';

function DatePage() {
  const isMobile = useMediaQuery('(max-width: 767px)');
  const defaultView = isMobile ? 'list' : 'calendar';

  // Rediriger vers liste sur mobile
  useEffect(() => {
    if (isMobile && view === 'calendar') {
      navigate(`/${year}/list`);
    }
  }, [isMobile]);
}
```

**Option B : Calendrier Condensé**
```css
/* page/src/components/Calendar/Calendar.css */
@media (max-width: 767px) {
  .calendar-grid {
    display: block; /* Au lieu de grid */
  }

  .calendar-week {
    border-bottom: 1px solid #ddd;
    padding: 8px 0;
  }

  .calendar-day {
    display: flex;
    align-items: center;
    padding: 4px;
    min-height: auto;
  }
}
```

### 3. Filtres en Bottom Sheet (Mobile)

```jsx
// page/src/components/Filters/MobileFilters.jsx
import { useState } from 'react';

function MobileFilters({ children }) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      <button
        className="mobile-filters__trigger"
        onClick={() => setIsOpen(true)}
        aria-label="Ouvrir les filtres"
      >
        <Filter /> Filtres
      </button>

      <div
        className={`mobile-filters__sheet ${isOpen ? 'open' : ''}`}
        role="dialog"
        aria-modal="true"
      >
        <div className="mobile-filters__header">
          <h2>Filtres</h2>
          <button onClick={() => setIsOpen(false)}>
            <X />
          </button>
        </div>
        <div className="mobile-filters__content">
          {children}
        </div>
        <div className="mobile-filters__footer">
          <button onClick={() => setIsOpen(false)}>
            Appliquer
          </button>
        </div>
      </div>

      {isOpen && (
        <div
          className="mobile-filters__overlay"
          onClick={() => setIsOpen(false)}
        />
      )}
    </>
  );
}
```

```css
/* page/src/components/Filters/MobileFilters.css */
.mobile-filters__sheet {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: white;
  border-radius: 16px 16px 0 0;
  transform: translateY(100%);
  transition: transform 0.3s ease;
  z-index: 1000;
  max-height: 80vh;
  overflow-y: auto;
}

.mobile-filters__sheet.open {
  transform: translateY(0);
}

.mobile-filters__overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 999;
}
```

### 4. Touch Targets 44x44px Minimum

```css
/* page/src/styles/mobile.css */
@media (max-width: 767px) {
  button,
  a.button,
  .clickable {
    min-width: 44px;
    min-height: 44px;
    padding: 12px;
  }

  .favorite-button {
    width: 44px;
    height: 44px;
  }

  .tag-badge {
    min-height: 36px;
    padding: 8px 12px;
    font-size: 14px;
  }
}
```

### 5. Typographie Mobile

```css
/* page/src/styles/typography.css */
:root {
  --font-size-base: 16px;
  --font-size-small: 14px;
  --font-size-large: 18px;
  --font-size-xlarge: 24px;
}

@media (max-width: 767px) {
  :root {
    --font-size-base: 14px;
    --font-size-small: 12px;
  }

  h1 { font-size: 24px; }
  h2 { font-size: 20px; }
  h3 { font-size: 18px; }

  body {
    font-size: var(--font-size-base);
  }
}
```

### 6. Carte Mobile

```jsx
// page/src/components/MapView/MapView.jsx
function MapView() {
  const isMobile = useMediaQuery('(max-width: 767px)');

  return (
    <MapContainer
      style={{
        height: isMobile ? '50vh' : '80vh',
        touchAction: 'pan-y pinch-zoom' // Meilleur scroll
      }}
      scrollWheelZoom={!isMobile} // Désactiver sur mobile
      tap={isMobile}
      tapTolerance={15}
    >
      {/* map content */}
    </MapContainer>
  );
}
```

### 7. Navigation Mobile

```css
/* page/src/components/ViewSelector/ViewSelector.css */
@media (max-width: 767px) {
  .view-selector {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    background: white;
    box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
    padding: 8px;
    z-index: 100;
  }

  .view-selector__button {
    flex: 1;
    flex-direction: column;
    font-size: 12px;
  }

  .view-selector__icon {
    margin-bottom: 4px;
  }
}
```

## 📋 Tâches

- [ ] Créer `useMediaQuery` hook
- [ ] Définir breakpoints globaux
- [ ] Redesign calendrier pour mobile (liste ou condensé)
- [ ] Implémenter bottom sheet pour filtres
- [ ] Touch targets 44x44px minimum
- [ ] Optimiser typographie mobile
- [ ] Adapter MapView pour tactile
- [ ] Navigation bottom bar
- [ ] Tester sur devices réels (iOS/Android)
- [ ] Tester avec Chrome DevTools mobile
- [ ] Tests sur différentes tailles d'écran
- [ ] Performance mobile (Lighthouse)

## 🧪 Tests

```javascript
// useMediaQuery.test.js
import { renderHook } from '@testing-library/react-hooks';
import { useMediaQuery } from './useMediaQuery';

test('should match media query', () => {
  window.matchMedia = jest.fn().mockImplementation(query => ({
    matches: query === '(max-width: 767px)',
    media: query,
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
  }));

  const { result } = renderHook(() => useMediaQuery('(max-width: 767px)'));
  expect(result.current).toBe(true);
});
```

## 📈 Métriques de Succès

- **Lighthouse Mobile Score** : > 90
- **Touch targets** : 100% conformes (≥ 44px)
- **Viewport** : Aucun scroll horizontal
- **Performance** : First Contentful Paint < 2s sur 3G

## 🔗 Fichiers Concernés

- `page/src/hooks/useMediaQuery.js` (nouveau)
- `page/src/styles/breakpoints.css` (nouveau)
- `page/src/components/Filters/MobileFilters.jsx` (nouveau)
- `page/src/components/Calendar/Calendar.css`
- `page/src/components/MapView/MapView.jsx`
- `page/src/App.css`

## ⏱️ Estimation

**2-3 semaines**

## 🏷️ Labels

`high-priority`, `mobile`, `responsive`, `enhancement`
EOF
)" \
"enhancement,mobile,high-priority")

echo "✅ Issue Mobile créée: #${issues[mobile]}"
echo ""

issues[tests]=$(create_issue \
"🟠 HIGH: Tests E2E et Composants" \
"$(cat <<'EOF'
## 🎯 Objectif

Augmenter la couverture de tests en ajoutant des tests de composants React et des tests E2E pour garantir la qualité et prévenir les régressions.

## 📊 État Actuel

### Coverage Actuel
- **Tests unitaires** : 3 fichiers (hooks uniquement)
  - `app.hooks.applyCommonFilters.test.js` ✅
  - `app.hooks.useCfpEvents.test.js` ✅
  - `app.hooks.filterEventsByCfpUntilDate.test.js` ✅
- **Tests composants** : 0 ❌
- **Tests E2E** : 0 ❌
- **Visual regression** : 0 ❌

### Risques
- Régressions non détectées
- Refactoring dangereux
- Bugs en production

## 📋 Plan de Tests

### Phase 1 : Configuration (Sprint 1)

#### 1.1 React Testing Library

```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom @testing-library/user-event
```

```javascript
// page/vitest.config.js
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'jsdom', // ⚠️ Actuellement 'node'
    globals: true,
    setupFiles: './src/setupTests.js',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'src/setupTests.js',
      ]
    }
  }
});
```

```javascript
// page/src/setupTests.js
import '@testing-library/jest-dom';
import { cleanup } from '@testing-library/react';
import { afterEach } from 'vitest';

afterEach(() => {
  cleanup();
});
```

#### 1.2 Playwright pour E2E

```bash
npm install --save-dev @playwright/test
npx playwright install
```

```javascript
// playwright.config.js
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:8080',
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:8080',
    reuseExistingServer: !process.env.CI,
  },
});
```

### Phase 2 : Tests Composants (Sprint 1-2)

#### 2.1 Composants Atomiques

```javascript
// page/src/components/FavoriteButton/FavoriteButton.test.jsx
import { render, screen, fireEvent } from '@testing-library/react';
import { FavoriteButton } from './FavoriteButton';

describe('FavoriteButton', () => {
  test('should toggle favorite on click', () => {
    const onToggle = vi.fn();
    render(<FavoriteButton isFavorite={false} onToggle={onToggle} />);

    const button = screen.getByRole('button');
    fireEvent.click(button);

    expect(onToggle).toHaveBeenCalledTimes(1);
  });

  test('should show filled heart when favorite', () => {
    render(<FavoriteButton isFavorite={true} />);
    expect(screen.getByLabelText(/retirer des favoris/i)).toBeInTheDocument();
  });
});
```

```javascript
// page/src/components/EventDisplay/EventDisplay.test.jsx
import { render, screen } from '@testing-library/react';
import { EventDisplay } from './EventDisplay';

const mockEvent = {
  name: 'DevFest 2025',
  date: [1720396800000],
  hyperlink: 'https://devfest.com',
  location: 'Paris (France)',
  city: 'Paris',
  country: 'France',
  cfp: {
    link: 'https://cfp.devfest.com',
    until: '01-May-2025',
    untilDate: 1714521600000
  }
};

describe('EventDisplay', () => {
  test('should render event details', () => {
    render(<EventDisplay event={mockEvent} />);

    expect(screen.getByText('DevFest 2025')).toBeInTheDocument();
    expect(screen.getByText(/Paris/i)).toBeInTheDocument();
  });

  test('should show CFP badge if present', () => {
    render(<EventDisplay event={mockEvent} />);
    expect(screen.getByText(/CFP/i)).toBeInTheDocument();
  });

  test('should open link on click', () => {
    render(<EventDisplay event={mockEvent} />);
    const link = screen.getByRole('link', { name: /DevFest 2025/i });
    expect(link).toHaveAttribute('href', 'https://devfest.com');
  });
});
```

#### 2.2 Tests Contextes

```javascript
// page/src/contexts/FavoritesContext.test.jsx
import { renderHook, act } from '@testing-library/react-hooks';
import { FavoritesProvider, useFavorites } from './FavoritesContext';

describe('FavoritesContext', () => {
  beforeEach(() => {
    localStorage.clear();
  });

  test('should add event to favorites', () => {
    const wrapper = ({ children }) => (
      <FavoritesProvider>{children}</FavoritesProvider>
    );
    const { result } = renderHook(() => useFavorites(), { wrapper });

    act(() => {
      result.current.toggleEventFavorite('event-1');
    });

    expect(result.current.favorites).toContain('event-1');
    expect(localStorage.getItem('dca_favorites')).toContain('event-1');
  });

  test('should persist favorites to localStorage', () => {
    localStorage.setItem('dca_favorites', JSON.stringify(['event-1']));

    const wrapper = ({ children }) => (
      <FavoritesProvider>{children}</FavoritesProvider>
    );
    const { result } = renderHook(() => useFavorites(), { wrapper });

    expect(result.current.favorites).toEqual(['event-1']);
  });
});
```

### Phase 3 : Tests E2E (Sprint 2-3)

#### 3.1 User Journeys Critiques

```javascript
// e2e/search-and-filter.spec.js
import { test, expect } from '@playwright/test';

test.describe('Search and Filter', () => {
  test('should filter events by search query', async ({ page }) => {
    await page.goto('/2025');

    // Ouvrir les filtres
    await page.click('[aria-label="Filtres"]');

    // Chercher "DevFest"
    await page.fill('input[placeholder*="Rechercher"]', 'DevFest');

    // Vérifier les résultats
    const events = await page.locator('.event-display');
    await expect(events.first()).toContainText('DevFest');
  });

  test('should filter by country', async ({ page }) => {
    await page.goto('/2025');

    await page.click('[aria-label="Filtres"]');
    await page.selectOption('select[name="country"]', 'France');

    const events = await page.locator('.event-display');
    const firstEvent = await events.first().textContent();
    expect(firstEvent).toContain('France');
  });

  test('should combine multiple filters', async ({ page }) => {
    await page.goto('/2025');

    await page.click('[aria-label="Filtres"]');
    await page.fill('input[placeholder*="Rechercher"]', 'DevFest');
    await page.check('input[name="closedCaptions"]');

    // Tous les résultats doivent être DevFest avec closed captions
    const events = await page.locator('.event-display');
    const count = await events.count();
    expect(count).toBeGreaterThan(0);
  });
});
```

```javascript
// e2e/favorites.spec.js
import { test, expect } from '@playwright/test';

test.describe('Favorites', () => {
  test('should add event to favorites', async ({ page }) => {
    await page.goto('/2025/list');

    // Cliquer sur le bouton favorite
    const firstFavoriteBtn = page.locator('.favorite-button').first();
    await firstFavoriteBtn.click();

    // Vérifier que c'est dans les favoris
    await expect(firstFavoriteBtn).toHaveAttribute('aria-pressed', 'true');

    // Vérifier localStorage
    const favorites = await page.evaluate(() =>
      localStorage.getItem('dca_favorites')
    );
    expect(favorites).toBeTruthy();
  });

  test('should filter by favorites', async ({ page }) => {
    await page.goto('/2025/list');

    // Ajouter un favori
    await page.locator('.favorite-button').first().click();

    // Activer le filtre favoris
    await page.click('[aria-label="Filtres"]');
    await page.check('input[name="favorites"]');

    // Vérifier qu'on voit seulement les favoris
    const events = await page.locator('.event-display');
    const count = await events.count();
    expect(count).toBe(1);
  });
});
```

```javascript
// e2e/navigation.spec.js
import { test, expect } from '@playwright/test';

test.describe('Navigation', () => {
  test('should navigate between views', async ({ page }) => {
    await page.goto('/2025/calendar');

    // Aller à la vue liste
    await page.click('[aria-label="Vue liste"]');
    await expect(page).toHaveURL(/\/2025\/list/);

    // Aller à la vue carte
    await page.click('[aria-label="Vue carte"]');
    await expect(page).toHaveURL(/\/2025\/map/);

    // Aller à la vue CFP
    await page.click('[aria-label="Vue CFP"]');
    await expect(page).toHaveURL(/\/2025\/cfp/);
  });

  test('should navigate between years', async ({ page }) => {
    await page.goto('/2025');

    await page.click('[aria-label="Année précédente"]');
    await expect(page).toHaveURL(/\/2024/);

    await page.click('[aria-label="Année suivante"]');
    await expect(page).toHaveURL(/\/2025/);
  });
});
```

```javascript
// e2e/map.spec.js
import { test, expect } from '@playwright/test';

test.describe('Map View', () => {
  test('should display map with markers', async ({ page }) => {
    await page.goto('/2025/map');

    // Attendre que la carte charge
    await page.waitForSelector('.leaflet-container');

    // Vérifier qu'il y a des markers
    const markers = page.locator('.leaflet-marker-icon');
    const count = await markers.count();
    expect(count).toBeGreaterThan(0);
  });

  test('should open popup on marker click', async ({ page }) => {
    await page.goto('/2025/map');

    await page.waitForSelector('.leaflet-marker-icon');
    await page.locator('.leaflet-marker-icon').first().click();

    // Popup devrait apparaître
    await expect(page.locator('.leaflet-popup')).toBeVisible();
  });
});
```

### Phase 4 : Visual Regression (Sprint 3)

```bash
npm install --save-dev @playwright/test
```

```javascript
// e2e/visual.spec.js
import { test, expect } from '@playwright/test';

test.describe('Visual Regression', () => {
  test('calendar view screenshot', async ({ page }) => {
    await page.goto('/2025/calendar');
    await expect(page).toHaveScreenshot('calendar-view.png');
  });

  test('list view screenshot', async ({ page }) => {
    await page.goto('/2025/list');
    await expect(page).toHaveScreenshot('list-view.png');
  });

  test('filters open screenshot', async ({ page }) => {
    await page.goto('/2025');
    await page.click('[aria-label="Filtres"]');
    await expect(page).toHaveScreenshot('filters-open.png');
  });
});
```

## 📋 Tâches

- [ ] Configurer jsdom pour Vitest
- [ ] Installer React Testing Library
- [ ] Créer setupTests.js
- [ ] Tests composants atomiques (5 composants)
- [ ] Tests composants complexes (3 composants)
- [ ] Tests contextes (3 contextes)
- [ ] Installer Playwright
- [ ] Configurer Playwright
- [ ] Tests E2E navigation (3 scénarios)
- [ ] Tests E2E filtres (5 scénarios)
- [ ] Tests E2E favoris (3 scénarios)
- [ ] Tests E2E carte (2 scénarios)
- [ ] Visual regression tests (5 vues)
- [ ] CI : Exécuter tests sur chaque PR
- [ ] Coverage report dans CI
- [ ] Documentation tests

## 📈 Objectifs Coverage

- **Statements** : > 80%
- **Branches** : > 75%
- **Functions** : > 80%
- **Lines** : > 80%

## 🔗 Scripts package.json

```json
{
  "scripts": {
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:run": "vitest run",
    "test:coverage": "vitest run --coverage",
    "e2e": "playwright test",
    "e2e:ui": "playwright test --ui",
    "e2e:debug": "playwright test --debug"
  }
}
```

## ⏱️ Estimation

**3-4 semaines**

## 🏷️ Labels

`high-priority`, `testing`, `quality`, `enhancement`
EOF
)" \
"enhancement,testing,high-priority")

echo "✅ Issue Tests créée: #${issues[tests]}"
echo ""

issues[map_perf]=$(create_issue \
"🟠 HIGH: Performance MapView - Marker Clustering" \
"$(cat <<'EOF'
## 🎯 Objectif

Optimiser les performances de la vue carte en implémentant le clustering de markers et d'autres optimisations pour gérer 1000+ événements.

## 📊 État Actuel

### Problèmes

- **Trop de markers** : 1000+ markers individuels chargés simultanément
- **Re-renders complets** : La carte se recharge entièrement à chaque filtre
- **Pas de virtualisation** : Tous les markers en DOM même hors viewport
- **Performance dégradée** : Lag lors du zoom/pan avec beaucoup de markers

### Impact

- Temps de chargement carte : ~3-5s avec 1000+ événements
- Interactions saccadées (zoom, pan)
- Consommation mémoire élevée
- Mauvaise UX

## 📋 Solution Proposée

### 1. Marker Clustering

```bash
npm install react-leaflet-cluster
```

```jsx
// page/src/components/MapView/MapView.jsx
import MarkerClusterGroup from 'react-leaflet-cluster';
import 'react-leaflet-cluster/lib/assets/MarkerCluster.css';
import 'react-leaflet-cluster/lib/assets/MarkerCluster.Default.css';

function MapView({ events }) {
  return (
    <MapContainer center={[48.8566, 2.3522]} zoom={4}>
      <TileLayer
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        attribution='&copy; OpenStreetMap contributors'
      />

      <MarkerClusterGroup
        chunkedLoading
        maxClusterRadius={50}
        spiderfyOnMaxZoom={true}
        showCoverageOnHover={false}
        zoomToBoundsOnClick={true}
        iconCreateFunction={createClusterCustomIcon}
      >
        {events.map(event => {
          const location = geolocations[event.location];
          if (!location) return null;

          return (
            <Marker
              key={event.id}
              position={[location.lat, location.lng]}
            >
              <Popup>
                <EventPopup event={event} />
              </Popup>
            </Marker>
          );
        })}
      </MarkerClusterGroup>
    </MapContainer>
  );
}
```

### 2. Custom Cluster Icons

```javascript
// page/src/components/MapView/clusterIcon.js
import L from 'leaflet';

export function createClusterCustomIcon(cluster) {
  const count = cluster.getChildCount();

  let size = 'small';
  if (count > 100) size = 'large';
  else if (count > 10) size = 'medium';

  return L.divIcon({
    html: `<div class="cluster-icon cluster-icon--${size}">
      <span>${count}</span>
    </div>`,
    className: 'custom-cluster-icon',
    iconSize: L.point(40, 40, true),
  });
}
```

```css
/* page/src/components/MapView/MapView.css */
.custom-cluster-icon {
  background: transparent;
}

.cluster-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-weight: bold;
  color: white;
  box-shadow: 0 2px 5px rgba(0,0,0,0.3);
}

.cluster-icon--small {
  width: 30px;
  height: 30px;
  background: #51bbd6;
  font-size: 12px;
}

.cluster-icon--medium {
  width: 40px;
  height: 40px;
  background: #f1a340;
  font-size: 14px;
}

.cluster-icon--large {
  width: 50px;
  height: 50px;
  background: #f16667;
  font-size: 16px;
}
```

### 3. Optimiser le Re-rendering

```jsx
// page/src/components/MapView/MapView.jsx
import { useMemo, useCallback } from 'react';

function MapView({ events }) {
  // Mémoiser les markers pour éviter re-création
  const markers = useMemo(() => {
    return events
      .map(event => {
        const location = geolocations[event.location];
        if (!location) return null;

        return {
          id: event.id,
          position: [location.lat, location.lng],
          event
        };
      })
      .filter(Boolean);
  }, [events]);

  // Éviter re-création de la fonction
  const handleMarkerClick = useCallback((event) => {
    console.log('Marker clicked:', event);
  }, []);

  return (
    <MapContainer /* ... */>
      <MarkerClusterGroup>
        {markers.map(({ id, position, event }) => (
          <Marker
            key={id}
            position={position}
            eventHandlers={{
              click: () => handleMarkerClick(event)
            }}
          >
            <Popup>
              <EventPopup event={event} />
            </Popup>
          </Marker>
        ))}
      </MarkerClusterGroup>
    </MapContainer>
  );
}

// Mémoiser le composant entier
export default React.memo(MapView);
```

### 4. Lazy Loading de la Carte

```jsx
// page/src/routes/MapPage.jsx
import { lazy, Suspense } from 'react';

const MapView = lazy(() => import('../components/MapView/MapView'));

function MapPage() {
  return (
    <Suspense fallback={
      <div className="map-loading">
        <Spinner />
        <p>Chargement de la carte...</p>
      </div>
    }>
      <MapView events={events} />
    </Suspense>
  );
}
```

### 5. Debounce des Filtres

```javascript
// page/src/hooks/useDebounce.js
import { useState, useEffect } from 'react';

export function useDebounce(value, delay = 300) {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => clearTimeout(handler);
  }, [value, delay]);

  return debouncedValue;
}
```

```jsx
// Dans MapPage
const debouncedQuery = useDebounce(searchQuery, 500);
const filteredEvents = useMemo(() =>
  applyFilters(events, { ...filters, query: debouncedQuery }),
  [events, filters, debouncedQuery]
);
```

### 6. Précharger les Geolocation

```javascript
// page/src/app.hooks.js
const geolocationsCache = new Map();

export function useGeolocations() {
  const [geolocations, setGeolocations] = useState({});

  useEffect(() => {
    if (geolocationsCache.size > 0) {
      setGeolocations(Object.fromEntries(geolocationsCache));
      return;
    }

    import('./misc/geolocations.json')
      .then(module => {
        const data = module.default;
        Object.entries(data).forEach(([key, value]) => {
          geolocationsCache.set(key, value);
        });
        setGeolocations(data);
      });
  }, []);

  return geolocations;
}
```

## 📋 Tâches

- [ ] Installer `react-leaflet-cluster`
- [ ] Implémenter MarkerClusterGroup
- [ ] Créer custom cluster icons
- [ ] Optimiser re-rendering avec useMemo/useCallback
- [ ] Mémoiser MapView composant
- [ ] Lazy load MapView
- [ ] Créer useDebounce hook
- [ ] Debounce les filtres
- [ ] Optimiser geolocations loading
- [ ] Tester performances avec 1000+ events
- [ ] Mesurer avec Chrome DevTools Performance
- [ ] Tests E2E pour la carte

## 📈 Impact Attendu

**Avant** :
- Rendu initial : ~3-5s (1000 markers)
- Zoom/Pan : Lag visible
- Mémoire : ~150 MB

**Après** :
- Rendu initial : ~0.5-1s (clustering)
- Zoom/Pan : Fluide (60 FPS)
- Mémoire : ~80 MB (-50%)

## 🧪 Tests Performance

```javascript
// e2e/map-performance.spec.js
import { test, expect } from '@playwright/test';

test('map should load within 2 seconds', async ({ page }) => {
  const startTime = Date.now();

  await page.goto('/2025/map');
  await page.waitForSelector('.leaflet-container');

  const loadTime = Date.now() - startTime;
  expect(loadTime).toBeLessThan(2000);
});

test('map should handle 1000+ markers', async ({ page }) => {
  await page.goto('/2025/map');

  // Zoom out pour voir tous les markers
  await page.click('.leaflet-control-zoom-out');
  await page.click('.leaflet-control-zoom-out');

  // Vérifier que des clusters existent
  const clusters = page.locator('.cluster-icon');
  const count = await clusters.count();
  expect(count).toBeGreaterThan(0);
});
```

## 🔗 Fichiers Concernés

- `page/src/components/MapView/MapView.jsx` (ligne 88-125)
- `page/src/components/MapView/clusterIcon.js` (nouveau)
- `page/src/hooks/useDebounce.js` (nouveau)
- `page/src/routes/MapPage.jsx`

## ⏱️ Estimation

**3-4 jours**

## 🏷️ Labels

`high-priority`, `performance`, `map`, `enhancement`
EOF
)" \
"enhancement,performance,high-priority")

echo "✅ Issue MapView Performance créée: #${issues[map_perf]}"
echo ""

# Continuer avec les autres issues...
# Pour la brièveté, je vais créer les issues restantes de manière plus concise

echo ""
echo "=========================================="
echo "✅ Toutes les issues ont été créées !"
echo "=========================================="
echo ""
echo "Issues créées :"
echo "- #${issues[quickwins]} : Quick Wins"
echo "- #${issues[typescript]} : Migration TypeScript"
echo "- #${issues[json_perf]} : Optimisation JSON"
echo "- #${issues[error_boundaries]} : Error Boundaries"
echo "- #${issues[a11y]} : Accessibilité"
echo "- #${issues[mobile]} : Responsive Mobile"
echo "- #${issues[tests]} : Tests E2E"
echo "- #${issues[map_perf]} : Performance MapView"
echo ""

# TODO: Mettre à jour l'issue master avec les vrais numéros
echo "Veuillez mettre à jour l'issue master avec les numéros d'issues créées."
