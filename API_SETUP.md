# Настройка API ключей для Undeme

## Необходимые API ключи

Приложение использует следующие API:

1. **Google Gemini API** - для AI помощника
2. **Google Places API** - для поиска экстренных служб
3. **MongoDB** - для базы данных

## Способы настройки

### Вариант 1: Прямой запуск с ключами

```bash
flutter run \
  --dart-define=GEMINI_API_KEY=ваш_gemini_ключ \
  --dart-define=GOOGLE_PLACES_API_KEY=ваш_google_places_ключ \
  --dart-define=MONGODB_URI=ваш_mongodb_uri
```

### Вариант 2: Использование скрипта с переменными окружения

1. Создайте файл `.env` на основе `.env.example`:
```bash
cp .env.example .env
```

2. Отредактируйте `.env` и добавьте свои ключи:
```bash
nano .env
```

3. Загрузите переменные окружения:
```bash
export $(cat .env | xargs)
```

4. Запустите приложение через скрипт:
```bash
chmod +x run_with_keys.sh
./run_with_keys.sh
```

### Вариант 3: Установка переменных окружения в shell

Добавьте в `~/.zshrc` (для macOS/Linux с zsh) или `~/.bashrc`:

```bash
export GEMINI_API_KEY="ваш_gemini_ключ"
export GOOGLE_PLACES_API_KEY="ваш_google_places_ключ"
export MONGODB_URI="ваш_mongodb_uri"
```

Затем:
```bash
source ~/.zshrc  # или source ~/.bashrc
./run_with_keys.sh
```

## Получение API ключей

### Google Gemini API
1. Перейдите на https://makersuite.google.com/app/apikey
2. Войдите с Google аккаунтом
3. Создайте новый API ключ
4. Скопируйте ключ

### Google Places API
1. Перейдите в Google Cloud Console: https://console.cloud.google.com/
2. Создайте новый проект или выберите существующий
3. Включите Places API: https://console.cloud.google.com/apis/library/places-backend.googleapis.com
4. Перейдите в "Credentials": https://console.cloud.google.com/apis/credentials
5. Создайте API ключ
6. (Опционально) Ограничьте ключ только для Places API

### MongoDB
1. Создайте аккаунт на https://www.mongodb.com/cloud/atlas
2. Создайте новый кластер (можно бесплатный)
3. Создайте пользователя базы данных
4. Получите connection string в формате:
   ```
   mongodb+srv://username:password@cluster.mongodb.net/database
   ```

## Использование в коде

После настройки ключи доступны через класс `ApiConfig`:

```dart
import 'package:undeme/config/api_config.dart';

// Проверка наличия ключей
if (ApiConfig.hasGeminiKey) {
  // Использовать Gemini
  final apiKey = ApiConfig.geminiApiKey;
}

if (ApiConfig.hasGooglePlacesKey) {
  // Использовать Places
  final apiKey = ApiConfig.googlePlacesApiKey;
}

if (ApiConfig.hasMongodbUri) {
  // Подключиться к MongoDB
  final uri = ApiConfig.mongodbUri;
}
```

## Безопасность

⚠️ **ВАЖНО**: 
- Никогда не коммитьте файл `.env` в git
- Файл `.env` уже добавлен в `.gitignore`
- Не храните ключи в исходном коде
- Используйте переменные окружения или --dart-define

## Troubleshooting

### Приложение не видит API ключи
- Убедитесь, что вы запускаете через `flutter run --dart-define=...`
- Проверьте, что переменные окружения установлены: `echo $GEMINI_API_KEY`
- Перезапустите приложение после установки переменных

### Ошибки API
- Проверьте правильность ключей
- Убедитесь, что API включены в Google Cloud Console
- Проверьте квоты и лимиты использования
