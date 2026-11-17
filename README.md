<h1 align="center">🗺️ Tanta Guide</h1>

<p align="center">
  A Flutter app to explore places in Tanta on <b>Google Maps</b> — custom markers, light / dark map styles,
  a synced places carousel and <b>live trip tracking</b> with distance, time and speed.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Google%20Maps-4285F4?style=flat-square&logo=googlemaps&logoColor=white" alt="Google Maps"/>
  <img src="https://img.shields.io/badge/Location-live%20tracking-0F766E?style=flat-square" alt="Live location"/>
  <img src="https://img.shields.io/badge/UI-Arabic%20RTL-FF7A45?style=flat-square" alt="Arabic"/>
</p>

## ✨ Features

- 📍 **Custom map markers** drawn in code per category (landmarks, fun, education, services) — the selected place gets a bigger pin.
- 🎠 **Places carousel** synced with the map: swipe a card and the camera flies to the place (with tilt); tap a marker and the card follows.
- 🔎 **Search & category filters** — the map zooms to fit whatever matches.
- 🌗 **Light / dark map styles** (custom JSON styles) with one tap.
- 📄 **Place details sheet** — description, address, distance from you, coordinates and a **Directions** button that opens Google Maps.
- 🧭 **My location** — asks for GPS & permission, shows the blue dot and distance to every place.
- 🛣️ **Live trip tracking** — draws your route as you move, with distance (km), time and average speed, and fits the whole trip when you stop.
- ⭕ **Service area** circle around the city center.

## 🏗️ How it's built

```
lib/
├── core/        # colors
├── data/        # places (real Tanta coordinates)
├── models/      # PlaceModel + PlaceCategory (label, icon, color)
├── services/    # LocationService — GPS, permission, live location stream
├── helpers/     # MarkerBuilder (canvas pins), geo (haversine distance)
└── views/       # ExploreView, TripTrackerView + widgets
```

- **Maps:** `google_maps_flutter` — markers, circles, polylines, camera animations, custom styles.
- **Location:** `location` — service / permission checks and a filtered location stream.
- **Directions:** `url_launcher` opens the Google Maps app.
- Unit tests for the distance helpers in `test/`.

## 🔑 Google Maps API key

The key is **not** stored in the repo. Add it to `android/local.properties` (this file is git-ignored):

```properties
MAPS_API_KEY=your_google_maps_api_key
```

It is injected into `AndroidManifest.xml` at build time through `manifestPlaceholders`.

## 🚀 Run it

```bash
flutter pub get
flutter run
```

---

<p align="center">Made with ❤️ by <a href="https://github.com/youssef-hossam">Youssef Hadwa</a></p>
