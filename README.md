# 🍴 Saveur — Recipe Mastery App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.19.0-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.3.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![CI](https://img.shields.io/github/actions/workflow/status/Aranya2801/Flutter-RecipeApplication-master/ci.yml?style=for-the-badge&label=CI%2FCD)
![Coverage](https://img.shields.io/codecov/c/github/Aranya2801/Flutter-RecipeApplication-master?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-2.0.0-E8401C?style=for-the-badge)

**A production-grade, MIT-level Flutter recipe application — built for daily use.**

*Master any recipe. Plan your week. Cook like a professional.*

[Download APK](#-download) · [Screenshots](#-screenshots) · [Architecture](#-architecture) · [Setup](#-setup)

</div>

---

## ✨ Features

### 🍽️ Recipe Discovery
- **Curated recipe database** — 10 expert-crafted recipes across 12 cuisines with restaurant-grade techniques
- **Featured & Trending** sections with beautiful card layouts
- **Smart fuzzy search** — search by title, ingredient, cuisine, or tag
- **Advanced filters** — difficulty, cuisine, max time, max calories
- **Recently viewed** history with offline persistence

### 👨‍🍳 Cooking Mode
- **Step-by-step method** with expandable chef's tip cards
- **In-step countdown timers** — tap any timed step to start
- **Live ingredient scaler** — adjust servings from 1–20, quantities update instantly
- **Ingredient checklist** — tap to cross off as you shop/cook
- **Wine pairing** suggestions for gourmet recipes

### 📅 Meal Planner
- **Full weekly calendar** — assign breakfast, lunch, dinner, and snacks
- **Drag-and-replace meals** with a searchable recipe picker
- **Week-level stats** — total calories and meal count at a glance
- **Swipe to clear** individual meal slots
- **Today highlight** indicator on day selector

### 📊 Nutrition Tracking
- **Detailed macro breakdown** — protein, carbs, fat with % of daily value
- **Visual pie chart** for calorie distribution
- **Micronutrients** — fiber, sugar, sodium, cholesterol with % DV
- **Servings-aware** — all values scale when you adjust servings

### 🎨 Design & UX
- **Glassmorphism cards**, animated gradients, and smooth page transitions
- **Dark / Light mode** — persisted across sessions
- **Skeleton shimmer** loading states — zero blank screens
- **Pull-to-refresh**, bounce physics, page indicator
- **Accessibility** — minimum text scale enforced (0.85–1.2)

---

## 🏗️ Architecture

This project follows **Clean Architecture** with **BLoC pattern** for state management:

```
lib/
├── core/
│   ├── constants/          # App-wide constants & config
│   ├── di/                 # Dependency injection (GetIt)
│   ├── router/             # Type-safe navigation (GoRouter)
│   └── theme/              # Material 3 Design System
│
├── data/
│   ├── datasources/
│   │   └── local/          # Hive (favorites, history, meal plan)
│   ├── models/             # Data models with Hive adapters
│   └── repositories/       # Repository implementations
│
├── domain/
│   ├── entities/           # Business logic entities
│   ├── repositories/       # Abstract repository contracts
│   └── usecases/           # Single-responsibility use cases
│
└── presentation/
    ├── blocs/              # BLoC state management (5 blocs)
    ├── screens/            # 8 fully-featured screens
    └── widgets/            # Reusable atomic components
```

### State Management — BLoC
| BLoC | Responsibility |
|------|---------------|
| `RecipeBloc` | Home feed, detail view, category loading |
| `FavoritesBloc` | Save/remove favorites, Hive persistence |
| `SearchBloc` | Real-time search with filter support |
| `MealPlanBloc` | Weekly meal assignment and calorie tracking |
| `ThemeBloc` | Dark/light mode with SharedPreferences persistence |

### Key Technical Decisions
- **GoRouter** — declarative, type-safe routing with shell routes
- **Hive** — lightning-fast local storage (favorites, recently viewed, meal plan)
- **flutter_animate** — declarative, composable animations without boilerplate
- **fl_chart** — pixel-perfect nutrition pie charts
- **GetIt** — service locator for dependency injection

---

## 📱 Screenshots

| Home | Recipe Detail | Meal Plan |
|------|--------------|-----------|
| Beautiful home with featured recipes | Step-by-step cooking with timers | Weekly meal planning calendar |

| Search | Nutrition | Dark Mode |
|--------|-----------|-----------|
| Fuzzy search with filters | Full macro breakdown charts | Complete dark theme support |

---

## 🚀 Setup

### Prerequisites
- Flutter SDK `>=3.19.0`
- Dart SDK `>=3.3.0`
- Android Studio / VS Code with Flutter plugin
- Xcode 15+ (for iOS builds)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Aranya2801/Flutter-RecipeApplication-master.git
cd Flutter-RecipeApplication-master

# 2. Install dependencies
flutter pub get

# 3. Run on device or emulator
flutter run

# 4. Build release APK
flutter build apk --release
```

### Optional: Regenerate Code
```bash
# Regenerate Hive adapters (if you modify models)
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📦 Dataset

The app ships with a curated dataset of **10 professional recipes** in `assets/data/recipes.json`:

| Recipe | Cuisine | Difficulty | Time |
|--------|---------|-----------|------|
| Truffle Mushroom Risotto | Italian | ⭐⭐ Medium | 50 min |
| Japanese Ramen from Scratch | Japanese | ⭐⭐⭐ Advanced | 9 hr |
| Mediterranean Mezze Platter | Mediterranean | ⭐ Easy | 65 min |
| Thai Green Curry | Thai | ⭐⭐ Medium | 50 min |
| Soufflé au Chocolat | French | ⭐⭐⭐ Advanced | 40 min |
| Korean Bibimbap | Korean | ⭐⭐ Medium | 65 min |
| Classic French Croissants | French | ⭐⭐⭐ Advanced | 3 hr |
| Acai Smoothie Bowl | Brazilian | ⭐ Easy | 10 min |
| Beef Wellington | British | ⭐⭐⭐ Advanced | 2 hr |
| Pad Thai Gai | Thai | ⭐⭐ Medium | 35 min |

Each recipe includes **full nutrition facts**, **step-by-step instructions**, **chef's tips**, **ingredients with scaling**, and **wine pairing** suggestions.

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

Test structure:
```
test/
├── unit/
│   ├── blocs/             # BLoC unit tests
│   └── repositories/      # Repository unit tests
├── widget/
│   ├── recipe_card_test.dart
│   └── nutrition_chart_test.dart
└── integration/
    └── home_flow_test.dart
```

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/AmazingFeature`
3. Commit changes: `git commit -m 'feat: Add AmazingFeature'`
4. Push: `git push origin feature/AmazingFeature`
5. Open a Pull Request

Please follow [Conventional Commits](https://conventionalcommits.org/) and ensure tests pass.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for details.

---

## 👩‍💻 Author

**Aranya** — Flutter Developer

[![GitHub](https://img.shields.io/badge/GitHub-Aranya2801-181717?style=flat&logo=github)](https://github.com/Aranya2801)

---

<div align="center">

Made with ❤️ and Flutter

*"The art of cooking is the art of adjustment."*

</div>
