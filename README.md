# WhatShop — Modern Cross-Platform E-Commerce Application

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![BLoC](https://img.shields.io/badge/State_Management-BLoC_9.x-blueviolet?style=for-the-badge)](https://bloclibrary.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**A production-ready, feature-first mobile and web e-commerce platform built with Flutter, reactive BLoC state management, Supabase (PostgreSQL & Auth), Firebase Cloud Messaging, and Hive offline-first caching.**

[Features](#-core-features) • [Architecture](#-architecture--design-patterns) • [Tech Stack](#-tech-stack) • [Getting Started](#-getting-started) • [Environment Setup](#-environment-setup) • [Roadmap](#-future-roadmap)

</div>

---

## 📌 Executive Overview

**WhatShop** is a high-performance cross-platform e-commerce application crafted with engineering excellence in mind. It delivers a seamless, responsive shopping experience across iOS, Android, and Web. 

The application utilizes **Clean Architecture with a Feature-First modular approach**, decoupling business logic from presentation using the **BLoC (Business Logic Component)** and **Cubit** patterns. It integrates **Supabase** for relational data persistence, real-time updates, and authentication, alongside **Firebase** for cloud infrastructure and **Hive** for instantaneous offline access.

---

## ✨ Core Features

### 🛍️ Product Catalog & Smart Discovery
- **Dynamic Category Navigation:** Hierarchical product browsing with real-time category filtering.
- **Debounced Instant Search:** Custom search delegate supporting search queries across title, vendor, and tags.
- **Interactive Home Feed:** Auto-scrolling promotion carousels, trending banners, and liquid pull-to-refresh interactions.
- **Adaptive Grid Layout:** Dynamic column recalculation (`crossAxisCount` & aspect ratio) responding seamlessly to screen dimensions across mobile, tablet, and web.

### 🔍 Rich Product Experience
- **Interactive Multi-Angle Gallery:** Deep inspection with pinch-to-zoom, pan, and full-screen view modes.
- **Live Stock & Rating Metrics:** Visual rating breakdowns, verified customer feedback, and real-time availability states.
- **Vendor Storefront:** Dedicated vendor profile pages displaying vendor credibility, ratings, and catalog listings.

### 🛒 Cart & Multi-Step Checkout Pipeline
- **Stateful Cart Synchronization:** Persistent cart state managed via `CartBloc` with optimistic UI updates.
- **Fluid Micro-Interactions:** Swipe-to-delete actions (`flutter_slidable`), instantaneous quantity increments, and price aggregation.
- **2-Step Checkout Funnel:**
  - **Step 1:** Delivery address selection, dynamic shipping calculations, and address book creation.
  - **Step 2:** Payment gateway selection, coupon application, and transactional order confirmation.

### ⚡ Offline-First Resilience & Caching
- **Fast Local Storage:** Critical user data, cached addresses, and wishlist items stored locally via high-speed **Hive key-value boxes**.
- **Dual-State Sync:** Instant client-side state rendering with asynchronous background cloud reconciliation.

### 🔐 Security & Route Guards
- **Declarative Navigation:** Powered by **GoRouter** with centralized route declarations.
- **Session-Aware Route Guards:** Deep-link redirection and automatic redirection between authenticated and unauthenticated states.
- **Environment Isolation:** Zero-hardcoded credentials; API secrets and Supabase keys managed via `.env` configuration.

---

## 🏗️ Architecture & Design Patterns

The project follows a **Feature-First Architecture** combined with the **BLoC pattern**, ensuring strict separation of concerns, testability, and scalability.

### Architectural Diagram

```
┌────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER                            │
│   Widgets • Pages • Bottom Navigation • Custom Search • GoRouter      │
└────────────────────────────────────┬───────────────────────────────────┘
                                     │ Dispatches Events / Listens States
                                     ▼
┌────────────────────────────────────────────────────────────────────────┐
│                        BUSINESS LOGIC (BLoC / CUBIT)                   │
│   CartBloc  •  ProductBloc  •  UserBloc  •  FavoriteBloc  •  Rating    │
│   - Pure Dart state machines handling business rules & transformations │
└───────────────────────┬─────────────────────────┬──────────────────────┘
                        │                         │
            Invokes     │                         │ Reads / Writes
                        ▼                         ▼
┌───────────────────────────────┐     ┌──────────────────────────────────┐
│      REMOTE DATA LAYER        │     │       LOCAL CACHE LAYER          │
│  Supabase Client (PostgreSQL) │     │      Hive Key-Value Boxes        │
│  - Authentication             │     │      - 'userAddresses'           │
│  - Product & Order Queries    │     │      - 'favorites'               │
│  - Real-time Subscriptions    │     │      - Offline fallback          │
│  Firebase Services (FCM/Cloud)│     │                                  │
└───────────────────────────────┘     └──────────────────────────────────┘
```

### Unidirectional Data Flow (UDF)

```
[ User Interaction ] ──▶ [ Add BlocEvent ] ──▶ [ Bloc Event Handler ]
                                                        │
[ UI Rebuilds ] ◀── [ Emit New BlocState ] ◀───────────┴──▶ [ Remote/Local Repository ]
```

---

## 📂 Project Structure

```text
whatshop/
├── .github/
│   └── workflows/
│       └── ci.yml               # Automated static analysis & test runner
├── assets/
│   ├── icons/                  # Scalable SVG vectors
│   └── images/                 # Optimized raster graphics & splash branding
├── lib/
│   ├── core/                   # Core shared components
│   │   ├── constants/          # Dimensions, strings, and asset paths
│   │   ├── env/                # Secure environment variable loader
│   │   ├── router/             # GoRouter setup, guards, and transition builders
│   │   ├── theme/              # Color schemes, typography, and component themes
│   │   └── utils/              # Screen utilities and input formatters
│   ├── features/               # Domain-specific feature modules
│   │   ├── auth/               # Supabase & Google authentication flow
│   │   ├── cart/               # Cart state, item mutations, checkout steps
│   │   ├── catalog/            # Categories, product listings, detail views
│   │   ├── favorites/          # Wishlist management with Hive persistence
│   │   ├── orders/             # Order placement, history, and status
│   │   ├── profile/            # User account settings, addresses, support
│   │   └── reviews/            # Comment threads and rating cubit
│   ├── app.dart                # App configuration & MultiBlocProvider
│   └── main.dart               # Bootstrap & service initialization
├── test/                       # Unit, bloc, and widget test suites
├── .env.example                # Safe environment variable template
├── .gitignore                  # Security-first Git exclusion rules
├── analysis_options.yaml       # Strict static analysis configuration
├── pubspec.yaml                # Package manifest and asset registry
└── README.md                   # Repository documentation
```

---

## 🛠️ Tech Stack

| Category | Technology | Purpose |
| :--- | :--- | :--- |
| **Framework** | [Flutter 3.x](https://flutter.dev) | Cross-platform mobile, web, and desktop UI toolkit |
| **Language** | [Dart 3.x](https://dart.dev) | Strongly-typed, object-oriented language with sound null safety |
| **State Management** | [flutter_bloc 9.x](https://pub.dev/packages/flutter_bloc) / [equatable](https://pub.dev/packages/equatable) | Predictable, event-driven state container |
| **Backend & Database** | [Supabase](https://supabase.com) (PostgreSQL) | Managed PostgreSQL, Row-Level Security, Auth, and Storage |
| **Cloud Services** | [Firebase Core](https://firebase.google.com) | Push notifications (FCM) and cloud infrastructure |
| **Local Persistence** | [Hive](https://pub.dev/packages/hive) / [hive_flutter](https://pub.dev/packages/hive_flutter) | Lightweight, blazing-fast NoSQL key-value database |
| **Routing** | [go_router 14.x](https://pub.dev/packages/go_router) | Declarative routing with deep-linking & redirect guards |
| **UI Components** | [carousel_slider](https://pub.dev/packages/carousel_slider), [flutter_slidable](https://pub.dev/packages/flutter_slidable) | Polished carousels, rating widgets, and list gestures |
| **Image Handling** | [cached_network_image](https://pub.dev/packages/cached_network_image), [photo_view](https://pub.dev/packages/photo_view) | Memory-efficient network image caching and pinch-to-zoom |

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your development machine:
- **Flutter SDK:** `>=3.24.0` ([Installation Guide](https://docs.flutter.dev/get-started/install))
- **Dart SDK:** `>=3.5.0`
- **Xcode** (for iOS simulator/device)
- **Android Studio** (for Android emulator/device)
- **Git**

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/whatshop.git
   cd whatshop
   ```

2. **Set up Environment Variables:**
   Copy `.env.example` to create your local `.env`:
   ```bash
   cp .env.example .env
   ```
   Configure your Supabase project credentials in `.env`:
   ```ini
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=your-supabase-anon-key
   ```

3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run Code Generation (if modifying Hive adapters):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the Application:**
   ```bash
   # Run on connected device or default simulator
   flutter run

   # Target specific platform
   flutter run -d chrome     # Web
   flutter run -d ios        # iOS Simulator
   flutter run -d android    # Android Emulator
   ```

---

## 🧪 Testing & Code Quality

Maintain high code standards using the configured static analysis rules:

```bash
# Run static analysis
flutter analyze

# Verify code formatting
dart format --set-exit-if-changed .

# Execute unit and bloc tests
flutter test --coverage
```

---

## 🗺️ Future Roadmap

- [ ] **Payment Gateway Integration:** Native Apple Pay, Google Pay, and Stripe Elements checkout.
- [ ] **Real-Time Order Tracking:** Live tracking using Supabase Realtime subscriptions and Maps integration.
- [ ] **Dark Mode Theme Engine:** Dynamic theme switching with persistence in local settings.
- [ ] **End-to-End Automation:** Integration testing pipeline using Patrol and Flutter Driver.
- [ ] **Multi-Language Support (i18n):** Localization covering English, Spanish, and Azerbaijani.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <sub>Developed by <b>Nasib Gojayev</b>. Built for high performance and clean code.</sub>
</div>
