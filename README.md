# Dhaka Bus Finder 🚌

A fully-offline **Flutter Android** app that helps you find local buses between any two stops in Dhaka city, complete with the official fare and full stop list for every matching route.

> Data sources: route list curated from [dhakabusservice.com](https://dhakabusservice.com), fares from the official Dhaka Metro Passenger & Goods Transport Committee fare chart (2.53 BDT/km, minimum ৳10).

---

## Features

- **Searchable From / To pickers** with bilingual (English + Bangla) stop names
- **Results screen** with the headline fare and every bus that connects the two stops
- **Bus detail screen** with the full ordered stop list, the user's segment highlighted, operating hours, and service type (Seating / Semi-Seating)
- **Offline-first** — all 200+ routes and the fare chart are bundled at compile time
- **Bidirectional & fuzzy search** (e.g. *Jashimuddin* matches *Jashimuddin (Uttara)*)
- **Recent searches** persisted via `shared_preferences`
- **Material 3** themed in the brand green `#1B8A4A` with the **Hind Siliguri** Bangla-friendly font

---

## Project layout

```
lib/
  main.dart                  # App entry, theme, routing root
  models/
    bus_route.dart           # BusRoute & FareEntry data classes
  data/
    bus_data.dart            # `allRoutes` — every Dhaka route
    fare_data.dart           # Official fare chart + per-km constants
  services/
    bus_service.dart         # Search + fare resolution
    recent_searches.dart     # SharedPreferences-backed recents
  widgets/
    stop_picker.dart         # Reusable searchable stop field
  screens/
    home_screen.dart         # Screen 1 — From/To pickers
    results_screen.dart      # Screen 2 — Matching buses + fare
    detail_screen.dart       # Screen 3 — Stops & segment view
test/
  widget_test.dart           # Smoke + service unit tests
```

---

## Running locally

```bash
# 1. Install Flutter (>= 3.27, Dart 3.6) — https://docs.flutter.dev/get-started/install
flutter --version

# 2. Resolve dependencies
flutter pub get

# 3. Run tests + static analysis
flutter analyze
flutter test

# 4. Launch on a connected Android device / emulator
flutter run

# 5. Build a release APK
flutter build apk --release
# -> build/app/outputs/flutter-apk/app-release.apk
```

Minimum supported Android version: **5.0 (API 21)**.

---

## How fares are calculated

1. **Exact lookup** in `fareChart` (key: `"FromStop|ToStop"`, bidirectional).
2. **Per-km fallback** — sum of adjacent-leg distances from `stopDistanceKm` × `2.53 BDT/km`, rounded.
3. **Floor** at the official minimum fare of `৳10`.

The headline fare on the results screen is the **cheapest** fare across all matching buses.

---

## Roadmap (Phase 2+)

- Google Maps integration for live route visualisation
- Multi-leg journeys with transfers
- Crowd-sourced live updates (delays, diversions)
- iOS build & web preview
