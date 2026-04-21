# WHO Health Facilities Assessment Tool

## 🌍 Project Overview
The WHO Health Facilities Assessment Tool is an enterprise-grade, **offline-first** mobile application built with Flutter. It provides rapid structural assessment capabilities for health facilities during infectious disease outbreaks (e.g., Mpox, Ebola, SARI/COVID-19), strictly adhering to official WHO clinical pathways and spatial guidelines.

## 🏗 Architecture & Tech Stack
* **Framework:** Flutter / Dart
* **UI/UX:** Material 3 Design Guidelines, custom enterprise UI components.
* **Database:** **Isar (NoSQL Object Database)**. Fully implemented for robust offline-first capabilities, complex nested data handling (Facility -> Zones -> Questions), and zero-latency UI performance.
* **State Management:** **Riverpod (v2)**. Fully integrated for predictable, robust state management and seamless UI updates.
* **Hardware Sensors:** Camera integration via `image_picker` for capturing field evidence during assessments.
* **Export Engine:** `pdf` and `printing` modules integrated, paving the way for native PDF report generation fueled by Isar's object-oriented structure.

## 🚀 Key Features & Implementation Status
* [x] **Secure SSO Interface & Registration:** Pre-provisioned login architecture and dynamic registration form for WHO authorized personnel and external staff.
* [x] **Emergency Context Selection:** Modular pathways for specific outbreaks (Mpox active; Ebola/SARI upcoming).
* [x] **Mpox Assessment Modules:** Fully implemented blueprints and checklists for:
  * Existing Facility with Dedicated Ward (Fig. 4)
  * Stand-Alone Treatment Centre (Fig. 5)
  * Congregate Settings / Camps (Fig. 6)
* [x] **Pre-Assessment Wizard:** Form for facility metadata and services based on WHO standards.
* [x] **Glove-Friendly Interactive Map:** Dynamic layout evaluation using scalable, gesture-enabled maps with expanded, opaque hit-test areas (80x80px) designed for operators wearing heavy PPE.
* [x] **Offline Data Entry & Database:** Real-time persistence of zone evaluations (Green/Yellow/Red indicators) via Isar NoSQL, surviving app restarts and crashes.
* [x] **Photo Evidence Collection:** Ability to attach photos directly to assessment criteria.
* [x] **Offline Data Analytics:** Advanced local dashboard (`analytics_screen`) calculating global readiness scores, compliance breakdown, critical failures, and geographical rankings.
* [ ] **PDF Report Generation:** Automated, offline generation of printable structural reports and mitigation plans directly from the Isar local storage (Dependencies installed, logic in progress).

## 📂 Project Architecture

The application is built using a modern, scalable, and modular **Offline-First** architecture. The `lib/` directory is structured as follows:

```text
lib/
├── data/                           # Data Layer & Factory
│   ├── facility_data_factory.dart  # Centralized factory routing data based on Disease & Facility Type
│   ├── general_facility_data.dart  # Shared questions/data across facilities
│   └── mpox/                       # Disease-specific data modules (Mpox)
│       ├── mpox_existing_ward_data.dart      # Blueprint & Checklist for Mpox Fig. 4 Ward
│       ├── mpox_treatment_center_data.dart   # Blueprint & Checklist for Stand-Alone Centre
│       └── mpox_congregate_setting_data.dart # Blueprint & Checklist for Congregate Settings
├── models/                         # Data Models & Schemas
│   ├── assessment_models.dart      # Core classes (AssessmentQuestion, SpatialZone, FacilityLayout)
│   └── assessment_models.g.dart    # Auto-generated Isar Database bindings
├── screens/                        # UI Layer
│   ├── analytics_screen.dart       # Dashboard with KPIs, charts, and Geo-readiness rankings
│   ├── assessment_screen.dart      # Interactive checklist for health facility zones
│   ├── assessments_list_screen.dart# Dashboard displaying all saved local assessments
│   ├── interactive_map_screen.dart # Spatial assessment map with dynamic tappable pins
│   ├── login_screen.dart           # App entry point & Authentication
│   ├── pre_assessment_screen.dart  # Wizard form for facility metadata and services (WHO Standards)
│   ├── register_screen.dart        # WHO & External staff registration with dynamic validation
│   └── settings_screen.dart        # Application settings and preferences
├── services/                       # Core Services
│   └── database_service.dart       # Local NoSQL Database Engine (Isar CRUD operations)
└── main.dart                       # App entry point, Riverpod Scope, DB init, and Bottom NavBar
```

### 🧠 Key Architectural Choices
- **Offline-First (Isar Database):** All assessments are saved locally on the device using Isar, allowing operators to perform assessments in deep-field areas without internet connectivity.
- **ProviderScope / Riverpod:** State management handles data sharing across the application with zero boilerplate.
- **Data Factory Pattern:** Hardcoded data is modularized. The `FacilityDataFactory` dynamically loads the correct spatial layout and checklist based on the user's selection (e.g., Mpox vs. Ebola, Tents vs. Hospitals).

### 🗄 Data Flow (Offline-First Strategy)
1) **Input:** Field inspectors evaluate zones using the interactive map. The UI provides large, invisible touch-targets for ease of use in protective gear. Images can be added using the device camera.
2) **Local Persistence:** Data is immediately serialized and stored in the Isar Database.
3) **Analytics:** A dedicated local dashboard aggregates Isar offline data into metrics and geographical rankings.
4) **Output (Reporting):** The stored `FacilityLayout` object (containing all nested zones, checklists, and images) will be injected directly into a PDF generator to create official reports locally.

## 🛠 Getting Started (How to Run)

### Prerequisites
* Flutter SDK (>= 3.1.0)
* Dart SDK

### Installation
1. Clone the repository:
   ```bash
   git clone [your-repo-url]
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate Isar Database Files & Riverpod Code: (Crucial step: The app uses Isar, which requires generated code for the models)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## ⚠️ Known Issues & Technical Workarounds

### Isar Database & Android AGP 8.0+ Namespace Issue
**Issue:** The official `isar_flutter_libs` (v3.1.0) package currently lacks a defined namespace, which causes build failures on newer Android Gradle Plugins (AGP 8.0+).
**Solution Applied:** A `dependency_overrides` has been added to the `pubspec.yaml` to fetch a patched version of the library from a community fork that includes the correct namespace. 

```yaml
dependency_overrides:
  isar_flutter_libs:
    git:
      url: https://github.com/MrLittleWhite/isar_flutter_libs.git
```
Note: This override can be safely removed once the official Isar package releases a patch for AGP 8.0+ compliance.

---

## © Copyright & Legal
**© 2026 World Health Organization (WHO). All rights reserved.**

The **WHO Health Facilities Assessment Tool** and its underlying data structures, spatial guidelines, and clinical pathways are proprietary to the World Health Organization. Unauthorized distribution, modification, or commercial use of this software and its source code is strictly prohibited.
