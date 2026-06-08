# WHO Health Facilities Assessment Tool

## 👥 Development Team
* **Gabriele Francesco Zazzetta**
* **Antonio Parente**

> **Note**: A comprehensive **Design Document** is delivered alongside this repository. It provides an in-depth look at architectural decisions, design patterns, and the underlying domain model.

## 🌍 Project Overview
The WHO Health Facilities Assessment Tool is an enterprise-grade, **offline-first** mobile application built with Flutter. It provides rapid structural assessment capabilities for health facilities during infectious disease outbreaks (e.g., Mpox, Ebola, SARI/COVID-19), strictly adhering to official WHO clinical pathways and spatial guidelines.

## 🏗 Architecture & Tech Stack
* **Framework:** Flutter / Dart
* **UI/UX:** Material 3 Design Guidelines, "Dark Matter" Cartography, custom enterprise UI components.
* **Database:** **Isar (NoSQL Object Database)**. Fully implemented for robust offline-first capabilities, complex nested data handling (Facility -> Zones -> Questions), and zero-latency UI performance.
* **Geospatial & Mapping:**
  * **3D Engine:** Mapbox Maps SDK for high-performance vector tiles and 3D globe visualization.
  * **2D Mapping:** Leaflet-based `flutter_map` with advanced Marker Clustering for high-density data management.
  * **Cartography:** High-end "Dark Matter" styling for professional analytical dashboards.
* **State Management:** **Riverpod (v2)**. Fully integrated for predictable, robust state management and seamless UI updates.
* **External Services:**
  * **Geocoding:** Integration with OpenStreetMap (Nominatim) and regex-based coordinate parsing.
  * **Hardware Sensors:** Camera integration via `image_picker` for field evidence.
* **Export Engine:** `pdf`, `printing` and `share_plus` modules integrated for native offline PDF generation and **editable Microsoft Word (.doc)** reporting.

## 🚀 Key Features
* **Advanced Global Visualization (2D/3D):**
  * **2D Clusters:** Optimized Leaflet view with marker clustering to manage hundreds of global assessments without UI lag.
  * **3D Globe:** Immersive Mapbox 3D view with custom teardrop pins and detached base graphics.
  * **Readiness Heatmaps:** Color-coded markers (Red, Amber, Green) driven by `globalReadinessScore`.
* **Automated Geocoding Engine:** Intelligent translation of facility addresses into GPS coordinates using Nominatim API and local storage.
* **Intelligent Navigation:** "Fit to Extent" and "FlyTo" animations for seamless transition between global overview and facility-specific details.
* **Mpox Assessment Modules:** Blueprints and checklists for:
  * Existing Facility with Dedicated Ward (Fig. 4)
  * Stand-Alone Treatment Centre (Fig. 5)
  * Congregate Settings / Camps (Fig. 6)
* **Glove-Friendly Interactive Map:** Spatial assessment map with expanded hit-test areas (80x80px) designed for PPE-clad operators.
* **Offline Data Entry & Persistence:** Real-time storage of evaluations via Isar NoSQL, surviving app restarts and connectivity loss.
* **Offline Data Analytics:** Advanced dashboard calculating global readiness scores, compliance breakdown, and critical failures.
* **Advanced Reporting (PDF & Word):** Automated, offline generation of printable structural reports and **fully editable Microsoft Word documents** via HTML-to-Office serialization, facilitating immediate field refinement.

## 📂 Project Architecture

The application is built using a modern, scalable, and modular **Offline-First** architecture.

```text
lib/
├── data/                           # Data Layer & Factory
│   ├── facility_data_factory.dart  # Centralized factory routing data
│   └── mpox/                       # Disease-specific data modules
├── helpers/                        # Utility functions and extensions
├── l10n/                           # Localization & Translations
├── models/                         # Data Models & Schemas
│   ├── assessment_models.dart      # Core classes (Isar Collections)
│   └── assessment_models.g.dart    # Auto-generated Isar bindings
├── providers/                      # Riverpod State Management
├── repositories/                   # Abstracted Data Access Layer
├── screens/                        # UI Layer
│   ├── analytics_screen.dart       # Dashboard with KPIs and charts
│   ├── assessment_screen.dart      # Interactive zone checklist
│   ├── assessments_list_screen.dart# List of all saved assessments
│   ├── global_map_screen_2d.dart   # 2D Map with clustering (Leaflet)
│   ├── global_map_screen_3d.dart   # 3D Globe View (Mapbox)
│   ├── interactive_map_screen.dart # Spatial assessment (Zone mapping)
│   ├── login_screen.dart           # App entry point
│   └── pre_assessment_screen.dart  # WHO Standard metadata form
├── services/                       # Core Services
│   ├── database_service.dart       # Local NoSQL Database Engine
│   └── report_export_service.dart  # Multi-format report generation (PDF/Word)
├── widgets/                        # Reusable Enterprise UI Components
└── main.dart                       # App entry point & DB init
```

## 🛠 Getting Started (How to Run)

### Prerequisites
* Flutter SDK (>= 3.1.0)
* Mapbox Access Token (already configured in `global_map_screen_3d.dart`)

### Installation & Configuration
1. Clone the repository and install dependencies:
   ```bash
   flutter pub get
   ```

2. **Mapbox Setup (Required for 3D Globe):**
   * **Android:** Provide a `MAPBOX_DOWNLOADS_TOKEN` in `~/.gradle/gradle.properties` or `android/gradle.properties`:
     ```properties
     MAPBOX_DOWNLOADS_TOKEN=YOUR_SECRET_MAPBOX_TOKEN
     ```
   * **iOS:** Create or edit the `~/.netrc` file in your home directory and add:
     ```text
     machine api.mapbox.com
     login mapbox
     password YOUR_SECRET_MAPBOX_TOKEN
     ```
     Then, run `pod install` inside the `ios` directory.
   * **Runtime:** A public token is already provided in `lib/screens/global_map_screen_3d.dart` for UI initialization.

3. Generate Isar Database & Serialization Code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the application:
   ```bash
   flutter run
   ```

### 🧪 Running Tests
To ensure the robustness of the application, comprehensive test suites have been developed. 

**Unit & Widget Tests**
These test individual components and logic without requiring an emulator.
```bash
flutter test
```

**E2E Integration Tests**
These simulate a real user navigating through the complete application on a running emulator, interacting with the Isar database and offline workflows.
*(Ensure an emulator or physical device is connected before running)*
```bash
flutter test integration_test/
```

## ⚠️ Known Issues & Technical Workarounds

### Isar Database & Android AGP 8.0+
**Issue:** `isar_flutter_libs` (v3.1.0) lacks a defined namespace for newer AGP versions.
**Solution:** Overridden in `pubspec.yaml` to use a community-patched version:
```yaml
dependency_overrides:
  isar_flutter_libs:
    git:
      url: https://github.com/MrLittleWhite/isar_flutter_libs.git
```

---

## © Copyright & Legal
**© 2026 World Health Organization (WHO). All rights reserved.**

Proprietary clinical pathways and spatial guidelines owned by the World Health Organization. Unauthorized distribution or commercial use is strictly prohibited.
