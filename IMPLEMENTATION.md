# Undeme - Emergency Safety App Implementation

## Overview
Undeme is a Flutter-based emergency safety application with AI-powered assistance using Google's Gemini AI. The app features SOS functionality, nearby emergency services, AI chat assistant, legal information, and user profile management.

## Features Implemented

### 1. **Home Screen (SOS)**
- Large circular red SOS button with emoji indicator
- Emergency contacts display
- Location sharing information
- Clean, modern UI matching Figma design

### 2. **Services/Map Screen**
- Filter chips for different emergency services (Hospitals, Police, Fire)
- Interactive map placeholder
- Service cards with:
  - Service name, emoji, and status (Open/Closed)
  - Distance and estimated time
  - Address information
  - Navigate and Call action buttons
- Real-time navigation to Google Maps

### 3. **AI Chat Screen**
- Google Gemini AI integration for emergency assistance
- Suggested questions for quick access
- Clean chat interface with AI avatar
- Helpful responses about:
  - Legal rights and procedures
  - Safety tips
  - Emergency protocols
- Fallback mode when API key is not configured

### 4. **Profile & Settings Screen**
- Personal information management (Name, Email, Phone)
- Emergency contacts management (up to 3 contacts)
  - Edit and remove functionality
  - Contact details (phone, relationship)
- App settings with toggles:
  - SOS Button Vibration
  - Auto Location Sharing
  - Emergency Notifications
  - Sound Alerts
- Privacy & Security section

### 5. **Bottom Navigation**
- 5 tabs: SOS, Services, AI Chat, Legal, Profile
- Active state indication
- Smooth navigation between screens

## Design System
All screens follow the Figma design specifications:
- **Primary Color**: `#D4183D` (Red for SOS)
- **Text Primary**: `#030213`
- **Text Secondary**: `#717182`
- **Background**: White (`#FFFFFF`)
- **Surface**: `#F3F3F5`
- **Border**: `rgba(0, 0, 0, 0.1)`

## Setup Instructions

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- iOS Simulator or Android Emulator
- Google Gemini API Key (optional, for AI features)

### Installation Steps

1. **Install Dependencies**
   ```bash
   cd /Users/zharkyn/Projects/undeme
   flutter pub get
   ```

2. **Configure Gemini API Key (Optional)**
   
   To enable AI chat functionality, you need a Gemini API key:
   
   a. Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
   
   b. Run the app with the API key:
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
   ```
   
   **Without API key**: The app will still work but AI chat will show a fallback message.

3. **Run the App**
   ```bash
   flutter run
   ```

### Build for Production

**iOS:**
```bash
flutter build ios --release --dart-define=GEMINI_API_KEY=your_key
```

**Android:**
```bash
flutter build apk --release --dart-define=GEMINI_API_KEY=your_key
```

## Project Structure

```
lib/
├── main.dart                 # App entry point and routing
├── screens/
│   ├── home_screen.dart      # SOS screen
│   ├── map_screen.dart       # Emergency services list
│   ├── chat_screen.dart      # AI chat assistant
│   ├── profile_screen.dart   # User profile & settings
│   └── law_code_screen.dart  # Legal information (placeholder)
└── widgets/
    └── bottom_nav.dart       # Bottom navigation bar
```

## Dependencies

### Main Dependencies
- `flutter` - Flutter SDK
- `google_generative_ai: ^0.4.7` - Gemini AI integration
- `geolocator: ^14.0.2` - Location services
- `permission_handler: ^12.0.1` - Permission management
- `url_launcher: ^6.3.2` - External URL/phone launching
- `google_maps_flutter: ^2.13.1` - Maps integration
- `flutter_riverpod: ^3.0.3` - State management
- `http: ^1.5.0` - HTTP requests
- `intl: ^0.20.2` - Internationalization

## Key Features & Functionality

### SOS Functionality
- Press the SOS button to trigger emergency alert
- Automatically fetches user's location
- Sends SMS with location to emergency contacts
- Visual feedback during sending

### Emergency Services
- Lists nearby hospitals, police stations, and fire departments
- Real-time filtering by service type
- One-tap navigation to Google Maps
- Direct call functionality (dial 911)

### AI Assistant
- Powered by Google's Gemini Pro model
- Provides advice on:
  - Legal rights during police stops
  - Safety tips for various situations
  - Emergency procedures
  - Filing police reports
- Context-aware responses
- Suggested questions for quick access

### Location Services
- Requests location permissions
- Fetches current GPS coordinates
- Shares location via SMS during SOS
- Auto location sharing setting

## Security & Privacy

✅ **Privacy-First Design**:
- Location only shared during SOS activation
- Emergency contacts stored locally on device
- No data shared with third parties
- User can delete data anytime

✅ **Permissions Required**:
- Location (for SOS and nearby services)
- SMS (for emergency messaging)
- Phone (for emergency calls)

## Testing

Run tests:
```bash
flutter test
```

## Troubleshooting

### Common Issues

1. **Gemini API Key Not Working**
   - Verify API key is correct
   - Check API is enabled in Google Cloud Console
   - Ensure you're passing it via `--dart-define`

2. **Location Not Working**
   - Grant location permissions in device settings
   - Enable location services on device
   - For iOS: Add location usage descriptions in Info.plist

3. **Build Errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Update Flutter: `flutter upgrade`

## Future Enhancements

- [ ] Real-time location tracking
- [ ] Volume button SOS trigger (Android)
- [ ] Background location monitoring
- [ ] Push notifications for emergency alerts
- [ ] Offline mode for basic features
- [ ] Multi-language support
- [ ] Dark mode support
- [ ] Legal code database integration

## Credits

- **Design**: Figma design provided by user
- **AI**: Powered by Google Gemini
- **Framework**: Flutter
- **Maps**: Google Maps Platform

## License

This is a prototype/educational project. Ensure proper licensing and permissions before deploying to production.

## Support

For issues or questions, please refer to:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Gemini AI Documentation](https://ai.google.dev/docs)

---

**Note**: This app is designed for emergency assistance. Always call local emergency services (911 in the US) for immediate help.
