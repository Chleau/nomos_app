# Feature Incidents - Documentation

## 📁 Structure

Cette feature gère tous les signalements (incidents) de l'application en suivant l'architecture Clean Architecture.

### 🎯 Domain Layer (Couche métier)

#### Entities
- **signalement.dart** - Entité représentant un signalement
- **type_signalement.dart** - Entité représentant un type de signalement
- **photo_signalement.dart** - Entité représentant une photo de signalement

#### Repositories (Abstraits)
- **signalement_repository.dart** - Interface définissant les opérations sur les signalements

#### Use Cases
- **get_all_signalements_usecase.dart** - Récupère tous les signalements
- **get_signalements_by_commune_usecase.dart** - Récupère les signalements par commune
- **create_signalement_usecase.dart** - Crée un nouveau signalement
- **upload_photo_usecase.dart** - Upload une photo pour un signalement
- **get_types_signalement_usecase.dart** - Récupère les types de signalements disponibles

### 💾 Data Layer (Couche données)

#### Models
- **signalement_model.dart** - Modèle de données pour les signalements
- **type_signalement_model.dart** - Modèle de données pour les types
- **photo_signalement_model.dart** - Modèle de données pour les photos

#### Data Sources
- **signalement_remote_datasource.dart** - Communication avec Supabase pour les signalements

#### Repositories (Implémentations)
- **signalement_repository_impl.dart** - Implémentation concrète du repository

### 🎨 Presentation Layer (Couche présentation)

#### State Management
- **signalements_notifier.dart** - Notifier gérant l'état des signalements
- **signalements_state.dart** - État de l'application pour les signalements

#### Providers
- **signalements_providers.dart** - Providers Riverpod pour l'injection de dépendances

#### Pages
- **signalements_list_page.dart** - Page listant tous les signalements avec filtres
- **signalement_detail_page.dart** - Page de détail d'un signalement
- **create_signalement_page.dart** - Page de création d'un signalement (stepper multi-étapes)

#### Widgets
- **signalement_card.dart** - Carte affichant un signalement dans la liste
- **signalement_thumbnail.dart** - Vignette d'image (base64 ou URL)
- **small_status_badge.dart** - Badge de statut coloré
- **signalement_filter_chip.dart** - Chip de filtre par statut
- **filter_option_tile.dart** - Tuile d'option de filtre dans le dialog

## 🔄 Flux de données

```
UI (Pages/Widgets)
    ↓
State Management (Notifier)
    ↓
Use Cases
    ↓
Repository (Abstract)
    ↓
Repository Implementation
    ↓
Remote Data Source
    ↓
Supabase
```

## 🗄️ Tables Supabase utilisées

- `signalements` - Stocke les signalements
- `types_signalement` - Stocke les types de signalements
- `photos_signalement` - Stocke les photos liées aux signalements
- `habitants` - Référencée pour l'auteur du signalement
- `communes` - Référencée pour la commune du signalement

## ✅ Bonnes pratiques respectées

1. ✅ **Architecture Clean** - Séparation stricte domain/data/presentation
2. ✅ **Injection de dépendances** - Utilisation de GetIt
3. ✅ **State Management** - Riverpod avec StateNotifier
4. ✅ **Widgets réutilisables** - Extraction dans le dossier widgets
5. ✅ **Respect des principes SOLID** - Notamment Single Responsibility et Dependency Inversion
6. ✅ **Pas d'accès direct au datasource** - Tout passe par le repository et les use cases

## 🚀 Utilisation

### Créer un signalement
```dart
await ref.read(signalementsNotifierProvider.notifier).createSignalement(
  habitantId: user.id,
  communeId: user.communeId,
  titre: 'Titre du signalement',
  description: 'Description...',
  typeId: 1,
  photo: imageFile,
);
```

### Charger les signalements d'une commune
```dart
await ref.read(signalementsNotifierProvider.notifier)
  .loadSignalementsByCommune(communeId);
```

### Charger les types de signalement
```dart
await ref.read(signalementsNotifierProvider.notifier)
  .loadTypesSignalement();
```

## 📝 Notes

- Les photos sont stockées en base64 dans Supabase
- Le statut par défaut d'un nouveau signalement est `en_attente`
- Les signalements peuvent être filtrés par statut : tous, en_attente, en_cours, resolu, rejete

