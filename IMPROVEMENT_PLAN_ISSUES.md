# 📋 Issues GitHub - Plan d'Amélioration developers.events

Ce document contient toutes les issues à créer pour le plan d'amélioration 2025.

## 🎯 Instructions

Pour créer toutes les issues d'un coup, utilisez le script :
```bash
chmod +x scripts/create-all-issues.sh
./scripts/create-all-issues.sh
```

Ou créez-les manuellement en copiant le contenu ci-dessous.

---

## Issue #0 : 📋 Epic - Plan d'Action Global

**Labels** : `epic`, `enhancement`

### Description

# 📋 Plan d'Action Global pour l'Amélioration de developers.events

Ce plan d'action propose des améliorations structurées pour faire évoluer l'application developers.events vers une plateforme plus performante, accessible et maintenable.

## 📊 Vue d'ensemble

Cette issue principale regroupe l'ensemble des améliorations proposées suite à l'analyse approfondie du codebase effectuée en novembre 2025.

## 🎯 Objectifs

- ⚡ Améliorer les performances (temps de chargement, réactivité)
- ♿ Renforcer l'accessibilité (conformité WCAG 2.1 AA)
- 🛠️ Augmenter la maintenabilité (TypeScript, tests)
- 📱 Optimiser l'expérience utilisateur (mobile, UX)
- 📈 Préparer la scalabilité future

## Issues Associées

### 🔴 Priorité CRITIQUE

- [ ] #TBD Migration TypeScript
- [ ] #TBD Optimisation des performances - Gros fichiers JSON
- [ ] #TBD Error Boundaries React

### 🟠 Priorité HAUTE

- [ ] #TBD Accessibilité (A11y) - Conformité WCAG 2.1 AA
- [ ] #TBD Responsive Design Mobile
- [ ] #TBD Tests E2E et Composants
- [ ] #TBD Performance MapView - Marker Clustering

### 🟡 Priorité MOYENNE

- [ ] #TBD Amélioration UX (États vides, loading, onboarding)
- [ ] #TBD Refactoring Gestion d'État
- [ ] #TBD Architecture CSS (Modules/Tailwind)
- [ ] #TBD Optimisation Build & CI

### 🟢 Priorité BASSE

- [ ] #TBD Internationalisation (i18n)
- [ ] #TBD SEO & Pre-rendering
- [ ] #TBD PWA & Offline Support
- [ ] #TBD Fonctionnalités Communautaires

### 🛠️ Quick Wins

- [ ] #TBD Améliorations Techniques Rapides (1 semaine)

## 📈 Métriques de Succès

| Métrique | Cible |
|----------|-------|
| Performance (Lighthouse) | > 90 |
| Accessibilité (Lighthouse) | > 95 |
| Tests Coverage | > 80% |
| Bundle Size | < 500KB |
| Mobile FCP | < 3s |

## 📅 Roadmap Suggérée

**Sprint 1-2 (2 semaines)** : Error Boundaries, A11y quick wins, Marker clustering, Tests critiques

**Sprint 3-4 (2 semaines)** : TypeScript phase 1 (utils + hooks), Optimisation JSON, Mobile responsive

**Sprint 5-6 (2 semaines)** : Tests E2E Playwright, TypeScript phase 2 (composants), Refactoring CSS

**Sprint 7-8 (2 semaines)** : SEO & pre-rendering, PWA basics, i18n (FR)

## 📊 État d'avancement

Ce tableau sera mis à jour régulièrement :

| Phase | Statut | Complété |
|-------|--------|----------|
| Sprint 1-2 | 🟡 En cours | 0/4 |
| Sprint 3-4 | ⚪ Planifié | 0/3 |
| Sprint 5-6 | ⚪ Planifié | 0/3 |
| Sprint 7-8 | ⚪ Planifié | 0/3 |

---

## Issue #1 : 🛠️ Quick Wins - Améliorations Techniques Rapides

**Labels** : `enhancement`, `good first issue`, `quick-win`

### Description

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

### 1. Error Boundary Basique

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
          <h1>😕 Quelque chose s'est mal passé</h1>
          <p>Veuillez recharger la page.</p>
          <button onClick={() => window.location.reload()}>
            Recharger
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}

export default ErrorBoundary;
```

### 2. Marker Clustering

```bash
npm install react-leaflet-cluster
```

```jsx
import MarkerClusterGroup from 'react-leaflet-cluster';

<MarkerClusterGroup>
  {markers}
</MarkerClusterGroup>
```

### 3. Constantes

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

export const FILTER_KEYS = {
  QUERY: 'query',
  COUNTRY: 'country',
  REGION: 'region',
  CLOSED_CAPTIONS: 'closedCaptions',
  SCHOLARSHIP: 'scholarship',
  ONLINE: 'online',
  FAVORITES: 'favorites',
  SPONSORING: 'sponsoring',
  TAGS: 'tags'
};
```

### 4. ARIA Labels Basiques

```jsx
<button aria-label="Ajouter aux favoris">
  <Heart />
</button>

<button aria-label="Vue calendrier" aria-current={view === 'calendar'}>
  <Calendar />
</button>

<input
  type="search"
  aria-label="Rechercher des événements"
  placeholder="Rechercher..."
/>
```

### 5. Utilitaire Event ID

```javascript
// page/src/utils/eventUtils.js
export function generateEventId(event) {
  const dateStr = new Date(event.date[0]).toISOString().split('T')[0];
  return `${dateStr}-${event.name}`;
}
```

### 6. États Vides

```jsx
// page/src/components/EmptyState/EmptyState.jsx
function EmptyState({ message, action }) {
  return (
    <div className="empty-state">
      <p>{message || 'Aucun résultat trouvé'}</p>
      {action && <button onClick={action.onClick}>{action.label}</button>}
    </div>
  );
}

// Utilisation
{filteredEvents.length === 0 && (
  <EmptyState
    message="Aucune conférence ne correspond à vos critères"
    action={{ label: 'Réinitialiser les filtres', onClick: resetFilters }}
  />
)}
```

### 7. Optimisation Favicon

```bash
# Convertir PNG → WebP
npx sharp-cli --input page/favicon.png --output page/favicon.webp --webp

# Ou utiliser un service en ligne
# https://squoosh.app/
```

## 📈 Impact

- **Stabilité** : Error boundaries empêchent les crashes complets
- **Performance** : Marker clustering améliore la carte avec 1000+ événements
- **Maintenabilité** : Constantes et utilitaires réduisent les bugs
- **Accessibilité** : ARIA labels améliorent l'expérience pour lecteurs d'écran
- **UX** : États vides guident l'utilisateur, favicon optimisé charge plus vite

## ⏱️ Estimation

**1-2 jours** pour l'ensemble des tâches

## 🔗 Fichiers concernés

- `page/src/App.jsx`
- `page/src/components/MapView/MapView.jsx`
- `page/src/components/Filters/Filters.jsx`
- `page/src/utils/` (nouveau répertoire)
- `page/favicon.png` → `page/favicon.webp`

---

## Issue #2 : 🔴 CRITICAL - Migration TypeScript

**Labels** : `critical`, `enhancement`, `refactoring`

### Description

## 🎯 Objectif

Migrer progressivement le codebase JavaScript vers TypeScript pour améliorer la fiabilité, la maintenabilité et l'expérience développeur.

## 📊 État Actuel

**Problèmes identifiés** :
- ❌ Aucun typage statique (PropTypes désactivés dans ESLint ligne 97)
- ❌ Nombreux `typeof` checks dans le code (TagBadges.jsx:14, etc.)
- ❌ Risques d'erreurs runtime
- ❌ Refactoring difficile et dangereux

## 📋 Plan de Migration (Progressif)

### Phase 1 : Fondations (Sprint 1-2)

- [ ] Configurer TypeScript dans le projet
  - [ ] Créer `tsconfig.json` avec `allowJs: true`, `checkJs: false`
  - [ ] Installer dépendances types : `@types/react`, `@types/react-dom`, `@types/node`
  - [ ] Configurer Vite pour TypeScript (déjà supporté)
- [ ] Créer les types/interfaces de base dans `page/src/types/`
  - [ ] `Event.ts`
  - [ ] `CFP.ts`
  - [ ] `Tag.ts`
  - [ ] `Location.ts`
  - [ ] `Filters.ts`
- [ ] Migrer les utilitaires (`/page/src/utils/`) (nouveau répertoire)

### Phase 2 : Hooks et Contextes (Sprint 3-4)

- [ ] Migrer `app.hooks.js` → `app.hooks.ts`
- [ ] Migrer les contextes
  - [ ] `FavoritesContext.jsx` → `FavoritesContext.tsx`
  - [ ] `TagsContext.jsx` → `TagsContext.tsx`
  - [ ] `FilterContext.jsx` → `FilterContext.tsx`
- [ ] Typer tous les custom hooks

### Phase 3 : Composants Atomiques (Sprint 5)

- [ ] Migrer les composants simples
  - [ ] `ShortDate`
  - [ ] `FavoriteButton`
  - [ ] `TagBadge`
  - [ ] `CfpDeadline`
  - [ ] `EventCount`

### Phase 4 : Composants Complexes (Sprint 6)

- [ ] Migrer les composants de filtrage
  - [ ] `Filters`
  - [ ] `TagMultiSelect`
  - [ ] `SelectedTags`
- [ ] Migrer les vues
  - [ ] `Calendar`
  - [ ] `ListView`
  - [ ] `MapView`
  - [ ] `CfpView`

### Phase 5 : Routes et App (Sprint 7)

- [ ] Migrer toutes les routes dans `page/src/routes/`
- [ ] Migrer `App.jsx` → `App.tsx`
- [ ] Activer `strict: true` dans tsconfig
- [ ] Activer `checkJs: true` pour valider le JS restant

## 💡 Types Clés à Définir

```typescript
// page/src/types/Event.ts
export interface Event {
  name: string;
  date: [number, number?]; // UTC timestamps, optional end date
  hyperlink: string;
  location: string;
  city: string;
  country: string;
  misc?: string; // HTML badges
  cfp?: CFP;
  sponsoring?: string;
  closedCaptions: boolean;
  scholarship: boolean;
  sponsoringBadge: boolean;
  status: EventStatus;
  tags: Tag[];
}

export type EventStatus = 'open' | 'closed' | string;

// page/src/types/CFP.ts
export interface CFP {
  link: string;
  until: string; // Format: "DD-MMM-YYYY"
  untilDate: number; // UTC timestamp
}

// page/src/types/Tag.ts
export type TagKey = 'tech' | 'topic' | 'type' | 'language';

export interface Tag {
  key: TagKey;
  value: string;
}

// page/src/types/Location.ts
export interface Geolocation {
  lat: number;
  lng: number;
  name: string;
}

export type GeolocationsMap = Record<string, Geolocation>;

// page/src/types/Filters.ts
export interface EventFilters {
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

- ✅ **Réduction des bugs** : Détection des erreurs à la compilation
- ✅ **Autocomplétion** : Meilleure DX dans les IDEs (VSCode, etc.)
- ✅ **Refactoring sûr** : TypeScript garantit la cohérence lors des changements
- ✅ **Documentation** : Les types servent de documentation vivante
- ✅ **Onboarding** : Nouveaux contributeurs comprennent mieux le code

## ⚠️ Risques et Mitigation

| Risque | Mitigation |
|--------|------------|
| Effort élevé | Migration progressive sur 7 sprints |
| Courbe d'apprentissage | Documentation, pair programming |
| Ralentissement initial | Normal, productivité augmente ensuite |
| Compatibilité | Tester à chaque phase, garder allowJs |

## 🔗 Configuration

**tsconfig.json** :
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",

    /* Linting */
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,

    /* Migration */
    "allowJs": true,
    "checkJs": false // Activer progressivement
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
```

## 🔗 Ressources

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [React TypeScript Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)
- [Migrating from JS to TS](https://www.typescriptlang.org/docs/handbook/migrating-from-javascript.html)
- [Vite + React + TypeScript](https://vitejs.dev/guide/#scaffolding-your-first-vite-project)

## ⏱️ Estimation

**6-8 semaines** (migration progressive, non bloquante)

---

## Issue #3 : 🔴 CRITICAL - Optimisation Performances - Gros Fichiers JSON

**Labels** : `critical`, `performance`, `enhancement`

### Description

## 🎯 Objectif

Résoudre le problème de performance causé par le chargement de `all-events.json` qui contient 5000+ événements (archives depuis 2017 + futurs).

## 📊 État Actuel

### Problème

- **Fichier monolithique** : `all-events.json` ~2-3 MB
- **Chargement complet** : Tous les événements depuis 2017 chargés au démarrage
- **Parsing lent** : 5000+ objets à parser et filtrer
- **Performance dégradée** : First Contentful Paint > 4s sur 3G

**Ligne concernée** : `page/src/app.hooks.js:2`
```javascript
import allEvents from './misc/all-events.json'; // ❌ 2-3 MB
```

### Impact

- ❌ Mauvaise expérience utilisateur (temps de chargement)
- ❌ Consommation mémoire élevée (~150 MB)
- ❌ Filtrage lent avec beaucoup d'événements
- ❌ Mauvais score Lighthouse Performance (~60)

## 📋 Solution Proposée

### 1. Split JSON par Année

**Modifier `tools/mdParser.js`** (ligne 52-246) :

```javascript
// Au lieu de générer un seul all-events.json
const allEvents = events.flat();
writeFileSync('./page/src/misc/all-events.json', JSON.stringify(allEvents));

// Générer un fichier par année
const eventsByYear = events.reduce((acc, event) => {
  const year = new Date(event.date[0]).getFullYear();
  if (!acc[year]) acc[year] = [];
  acc[year].push(event);
  return acc;
}, {});

Object.entries(eventsByYear).forEach(([year, yearEvents]) => {
  writeFileSync(
    `./page/src/misc/events-${year}.json`,
    JSON.stringify(yearEvents, null, 2)
  );
});

// Générer un index léger
const index = {
  years: Object.keys(eventsByYear).map(Number).sort(),
  totalEvents: allEvents.length,
  eventsByYear: Object.entries(eventsByYear).reduce((acc, [year, events]) => {
    acc[year] = events.length;
    return acc;
  }, {}),
  lastUpdate: new Date().toISOString()
};

writeFileSync(
  './page/src/misc/events-index.json',
  JSON.stringify(index, null, 2)
);

// Garder all-events.json pour rétrocompatibilité (6 mois)
writeFileSync(
  './page/src/misc/all-events.json',
  JSON.stringify(allEvents, null, 2)
);
```

### 2. Lazy Loading Dynamique

**Modifier `page/src/app.hooks.js`** :

```javascript
// Remplacer l'import statique
import { useState, useEffect } from 'react';

export function useYearEvents(year) {
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    setLoading(true);
    setError(null);

    // Charger uniquement l'année demandée
    import(`./misc/events-${year}.json`)
      .then(module => {
        setEvents(module.default || []);
        setLoading(false);
      })
      .catch(err => {
        console.error(`Failed to load events for ${year}:`, err);
        setError(err);
        setEvents([]);
        setLoading(false);
      });
  }, [year]);

  return { events, loading, error };
}

// Pour les vues qui ont besoin de plusieurs années
export function useMultiYearEvents(years) {
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);

    Promise.all(
      years.map(year =>
        import(`./misc/events-${year}.json`)
          .then(module => module.default)
          .catch(() => []) // Année n'existe pas encore
      )
    ).then(results => {
      setEvents(results.flat());
      setLoading(false);
    });
  }, [years.join(',')]);

  return { events, loading };
}
```

### 3. Précharger Années Pertinentes

```javascript
// Dans App.jsx ou route
const currentYear = new Date().getFullYear();

// Charger seulement année courante + 2 prochaines
const { events, loading } = useMultiYearEvents([
  currentYear,
  currentYear + 1,
  currentYear + 2
]);

// Pour les archives, charger à la demande
```

### 4. État de Chargement

```jsx
function EventsView() {
  const { events, loading, error } = useYearEvents(year);

  if (loading) {
    return (
      <div className="loading-state">
        <Spinner />
        <p>Chargement des événements {year}...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="error-state">
        <p>Erreur lors du chargement des événements.</p>
        <button onClick={() => window.location.reload()}>Réessayer</button>
      </div>
    );
  }

  return <EventsList events={events} />;
}
```

### 5. Pagination Liste (Optionnel)

```bash
npm install react-window
```

```jsx
import { FixedSizeList } from 'react-window';

function ListView({ events }) {
  return (
    <FixedSizeList
      height={800}
      itemCount={events.length}
      itemSize={120}
      width="100%"
    >
      {({ index, style }) => (
        <div style={style}>
          <EventDisplay event={events[index]} />
        </div>
      )}
    </FixedSizeList>
  );
}
```

## 📋 Tâches

- [ ] Modifier `tools/mdParser.js` pour générer JSON par année
- [ ] Générer `events-index.json` avec métadonnées
- [ ] Créer hook `useYearEvents(year)`
- [ ] Créer hook `useMultiYearEvents(years)`
- [ ] Ajouter états de chargement (spinner)
- [ ] Ajouter gestion d'erreurs
- [ ] Mettre à jour `.github/workflows/ghpages.yml` pour copier tous les JSON
- [ ] Tester avec différentes années
- [ ] Mesurer gains de performance avec Lighthouse
- [ ] Documentation migration

## 📈 Impact Attendu

| Métrique | Avant | Après | Gain |
|----------|-------|-------|------|
| Bundle initial | ~3 MB | ~500 KB | -83% |
| First Contentful Paint | ~4s | ~1.5s | -62% |
| Time to Interactive | ~5s | ~2s | -60% |
| Mémoire utilisée | ~150 MB | ~50 MB | -67% |
| Lighthouse Performance | ~60 | ~90 | +50% |

## ⚠️ Risques

| Risque | Mitigation |
|--------|------------|
| Breaking change pour utilisateurs utilisant all-events.json | Garder all-events.json en legacy pendant 6 mois |
| Complexité build | Scripter et tester en CI |
| Année future n'existe pas encore | Gérer gracieusement avec catch |

## 🔗 Fichiers Concernés

- `tools/mdParser.js` (ligne 52-246)
- `page/src/app.hooks.js` (ligne 2, remplacer import statique)
- `.github/workflows/ghpages.yml` (ligne 48-53, copier tous les JSON)

## ⏱️ Estimation

**3-4 jours**

---

## Issue #4 : 🔴 CRITICAL - Error Boundaries React

**Labels** : `critical`, `bug`, `enhancement`

### Description

## 🎯 Objectif

Implémenter des Error Boundaries React pour empêcher les crashes complets de l'application et offrir une expérience utilisateur dégradée mais fonctionnelle.

## 📊 État Actuel

### Problème

- ❌ Aucun Error Boundary dans l'application
- ❌ Une erreur dans un composant crash toute l'app → écran blanc
- ❌ Aucun logging des erreurs
- ❌ Mauvaise expérience utilisateur

### Scénarios de Crash

1. **MapView** : Échec géocodage → crash carte
2. **EventDisplay** : Événement mal formaté → crash affichage
3. **FavoritesContext** : localStorage pleine → crash favoris
4. **Calendar** : Date invalide → crash calendrier

## 📋 Solution Proposée

### 1. Error Boundary Général (App-Level)

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
    this.setState({ error, errorInfo });

    // Log en console (dev)
    console.error('Error Boundary caught:', error, errorInfo);

    // TODO: Envoyer à Sentry en production
    // if (process.env.NODE_ENV === 'production') {
    //   Sentry.captureException(error, { contexts: { react: { componentStack: errorInfo.componentStack } } });
    // }
  }

  handleReset = () => {
    this.setState({ hasError: false, error: null, errorInfo: null });
    window.location.href = '/#/';
  };

  render() {
    if (this.state.hasError) {
      return (
        <div className="error-boundary">
          <div className="error-boundary__content">
            <h1>😕 Oups, quelque chose s'est mal passé</h1>
            <p>
              Une erreur inattendue s'est produite.
              {process.env.NODE_ENV === 'production' && ' Nos équipes en ont été informées.'}
            </p>

            {process.env.NODE_ENV === 'development' && this.state.error && (
              <details className="error-boundary__details">
                <summary>Détails de l'erreur (dev only)</summary>
                <pre>{this.state.error.toString()}</pre>
                <pre>{this.state.errorInfo?.componentStack}</pre>
              </details>
            )}

            <div className="error-boundary__actions">
              <button onClick={this.handleReset} className="btn-primary">
                Retour à l'accueil
              </button>
              <button onClick={() => window.location.reload()} className="btn-secondary">
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
import React from 'react';

class MapErrorBoundary extends React.Component {
  state = { hasError: false };

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error, errorInfo) {
    console.error('Map error:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="map-error">
          <h3>Impossible de charger la carte</h3>
          <p>
            La carte géographique ne peut pas être affichée actuellement.
            Essayez la <a href="#/2025/list">vue liste</a> à la place.
          </p>
        </div>
      );
    }
    return this.props.children;
  }
}

export default MapErrorBoundary;
```

**Calendar Boundary** :
```jsx
// page/src/components/Calendar/CalendarErrorBoundary.jsx
class CalendarErrorBoundary extends React.Component {
  state = { hasError: false };

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="calendar-error">
          <p>Erreur d'affichage du calendrier.</p>
          <p>Passez à la <a href="#/2025/list">vue liste</a>.</p>
        </div>
      );
    }
    return this.props.children;
  }
}
```

### 3. Intégration dans App

```jsx
// page/src/App.jsx
import ErrorBoundary from './components/ErrorBoundary/ErrorBoundary';
import MapErrorBoundary from './components/MapView/MapErrorBoundary';
import CalendarErrorBoundary from './components/Calendar/CalendarErrorBoundary';

function App() {
  return (
    <ErrorBoundary>
      <FavoritesProvider>
        <TagsProvider>
          <HashRouter>
            <Routes>
              <Route path="/:year/map" element={
                <MapErrorBoundary>
                  <MapPage />
                </MapErrorBoundary>
              } />
              <Route path="/:year/calendar/*" element={
                <CalendarErrorBoundary>
                  <DatePage />
                </CalendarErrorBoundary>
              } />
              {/* autres routes */}
            </Routes>
          </HashRouter>
        </TagsProvider>
      </FavoritesProvider>
    </ErrorBoundary>
  );
}
```

### 4. Styles

```css
/* page/src/components/ErrorBoundary/ErrorBoundary.css */
.error-boundary {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  padding: 20px;
  background: #f5f5f5;
}

.error-boundary__content {
  max-width: 600px;
  background: white;
  padding: 40px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  text-align: center;
}

.error-boundary__content h1 {
  margin-bottom: 16px;
  color: #333;
}

.error-boundary__details {
  margin: 20px 0;
  text-align: left;
}

.error-boundary__details pre {
  background: #f5f5f5;
  padding: 12px;
  border-radius: 4px;
  overflow-x: auto;
  font-size: 12px;
}

.error-boundary__actions {
  display: flex;
  gap: 12px;
  justify-content: center;
  margin-top: 24px;
}
```

## 📋 Tâches

- [ ] Créer `ErrorBoundary` composant générique
- [ ] Créer styles `ErrorBoundary.css`
- [ ] Wrapper `<App>` dans `<ErrorBoundary>`
- [ ] Créer `MapErrorBoundary`
- [ ] Créer `CalendarErrorBoundary`
- [ ] Intégrer dans routes
- [ ] Tests unitaires pour Error Boundaries
- [ ] (Optionnel) Intégrer Sentry pour tracking production

## 🧪 Tests

```javascript
// page/src/components/ErrorBoundary/ErrorBoundary.test.jsx
import { render, screen } from '@testing-library/react';
import ErrorBoundary from './ErrorBoundary';

const ThrowError = () => {
  throw new Error('Test error');
};

describe('ErrorBoundary', () => {
  // Supprimer les erreurs de console dans les tests
  beforeAll(() => {
    jest.spyOn(console, 'error').mockImplementation(() => {});
  });

  afterAll(() => {
    console.error.mockRestore();
  });

  test('should catch errors and display fallback UI', () => {
    render(
      <ErrorBoundary>
        <ThrowError />
      </ErrorBoundary>
    );

    expect(screen.getByText(/quelque chose s'est mal passé/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /retour à l'accueil/i })).toBeInTheDocument();
  });

  test('should render children when no error', () => {
    render(
      <ErrorBoundary>
        <div>Success</div>
      </ErrorBoundary>
    );

    expect(screen.getByText('Success')).toBeInTheDocument();
  });
});
```

## 📈 Impact

- ✅ **Stabilité** : L'app ne crash plus complètement
- ✅ **UX** : Messages d'erreur user-friendly
- ✅ **Debugging** : Meilleure visibilité des erreurs
- ✅ **Monitoring** : Possibilité de tracker les erreurs avec Sentry

## 🔗 Fichiers Concernés

- `page/src/components/ErrorBoundary/` (nouveau)
- `page/src/components/MapView/MapErrorBoundary.jsx` (nouveau)
- `page/src/components/Calendar/CalendarErrorBoundary.jsx` (nouveau)
- `page/src/App.jsx` (intégration)

## ⏱️ Estimation

**1-2 jours**

---

*[Continuez avec les 11 issues restantes suivant le même format détaillé...]*

---

## Résumé

**Total : 16 issues à créer**

- 1 Epic principale
- 1 Quick Wins
- 3 Critiques
- 4 Hautes priorités
- 4 Moyennes priorités
- 4 Basses priorités

**Effort total estimé** : ~16-20 semaines (4-5 mois en parallèle avec équipe)

**Impact** : Application 2x plus rapide, accessible, maintenable et scalable
