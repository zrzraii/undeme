/// Конфигурация API ключей для приложения
/// 
/// Ключи передаются через --dart-define при запуске приложения
class ApiConfig {
  /// Ключ API Gemini для AI помощника
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Ключ API Google Places для поиска экстренных служб
  static const String googlePlacesApiKey = String.fromEnvironment(
    'GOOGLE_PLACES_API_KEY',
    defaultValue: '',
  );

  /// URI подключения к MongoDB
  static const String mongodbUri = String.fromEnvironment(
    'MONGODB_URI',
    defaultValue: '',
  );

  /// Проверка наличия всех необходимых ключей
  static bool get hasAllKeys {
    return geminiApiKey.isNotEmpty &&
        googlePlacesApiKey.isNotEmpty &&
        mongodbUri.isNotEmpty;
  }

  /// Проверка наличия ключа Gemini
  static bool get hasGeminiKey => geminiApiKey.isNotEmpty;

  /// Проверка наличия ключа Google Places
  static bool get hasGooglePlacesKey => googlePlacesApiKey.isNotEmpty;

  /// Проверка наличия URI MongoDB
  static bool get hasMongodbUri => mongodbUri.isNotEmpty;
}
