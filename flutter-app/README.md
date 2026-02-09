# Blood Near Me - Flutter

Blood bank finder app for India.

## Setup

1. Install Flutter: https://flutter.dev/docs/get-started/install

2. Install dependencies:
```bash
cd flutter-app
flutter pub get
```

3. Run app:
```bash
flutter run
```

## Build APK

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

## Project Structure

```
flutter-app/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── search_screen.dart
│   │   ├── sos_screen.dart
│   │   ├── sos_alert_screen.dart
│   │   └── registration_screen.dart
│   └── components/
│       ├── location_header.dart
│       └── blood_type_selector.dart
├── pubspec.yaml
└── README.md
```

## Run on Phone

### Android
1. Enable USB debugging on phone
2. Connect phone via USB
3. Run: `flutter run`

### iOS (Mac only)
1. Connect iPhone
2. Run: `flutter run`

## Build for Release

### Android APK
```bash
flutter build apk --release --split-per-abi
```

### iOS
```bash
flutter build ios --release
```

## Features

- Find blood banks by distance
- Call blood banks directly
- Get directions via Google Maps
- Send emergency SOS
- Register as donor
- Offline data persistence

## Dependencies

- shared_preferences: Local storage
- url_launcher: Phone calls & maps

## Size

- APK: ~15MB
- Installed: ~25MB
