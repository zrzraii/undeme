# Undeme

Prototype Flutter app focusing on rapid emergency assistance.

## Features (Prototype)
- SOS button sends a pre-composed SMS with a Google Maps link to your current location (opens SMS composer).
- Nearby Emergency Services quick links (Hospitals, Police, Fire) open external Maps.
- AI Chat (placeholder) with simple in-memory UI.
- Law Code browsing (placeholder categories and search).
- Profile & Settings for user info and 3 trusted contacts (in-memory only).

## Getting Started
1. Prereqs: Flutter >= 3.35, Dart >= 3.9
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### iOS Notes
- For location permissions, add NSLocationWhenInUseUsageDescription to `ios/Runner/Info.plist`.
- If using Google Maps SDK later, you’ll need API Key setup.

### Android Notes
- For location permissions, ensure the appropriate permissions are declared in `AndroidManifest.xml` (geolocator adds these via manifest placeholders).
- Background SOS and volume-button integration are TBD.

## Roadmap
- Persist contacts securely (encrypted local storage).
- Implement real SMS/phone integrations and background triggers.
- Nearby services with on-map pins (Google Maps SDK) and turn-by-turn navigation.
- AI chat connected to legal knowledge base.
- Law code database with offline search.
