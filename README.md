# google_map

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 🔑 Google Maps API key

The key is **not** stored in the repo. Add it to `android/local.properties` (this file is git-ignored):

```properties
MAPS_API_KEY=your_google_maps_api_key
```

It is injected into `AndroidManifest.xml` at build time through `manifestPlaceholders`.
