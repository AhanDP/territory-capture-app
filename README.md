# Territory Capture App (Flutter) — Machine Test

## Features
- Google Sign-In (Firebase Auth)
- Google Maps live capture with polyline and polygon conversion
- Location sampling every 1–2s or 3–5m (Geolocator)
- Save territory (points + metadata) to Firestore
- List & detail views
- GetX for state management/routing/DI
- Clean Architecture (Presentation / Domain / Data)

## Setup
1. Clone repo
2. Create Firebase project; enable Firestore and Authentication (Google)
3. Add Android / iOS apps in Firebase console; download `google-services.json` / `GoogleService-Info.plist`
4. Configure OAuth consent and SHA-1 for Android if needed
5. Add files to `android/app` and `ios/Runner` per Firebase docs
6. Update `lib/main.dart` with your Firebase options (if not using default config)
7. `flutter pub get`
8. Run: `flutter run` or build an APK: `flutter build apk --release`

## Build
- APK: `flutter build apk --release`
- iOS: follow code signing profiles

## Architecture notes
- GetX controllers in `features/.../presentation/controllers`
- Domain entities & usecases in `domain/`
- Data layer with DTOs and Firebase datasource in `data/`
- Repositories implement data logic and map DTO ↔ Entity

## Firestore rules
(see `firestore.rules` in repo)

## Submission
- Source code in this repo
- APK in `releases/territory_capture.apk`
- README with above instructions