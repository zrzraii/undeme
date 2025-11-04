# Быстрый старт Undeme

## 🚀 Запуск приложения с API ключами

### Быстрый способ (рекомендуется)

1. **Установите переменные окружения**:
```bash
export GEMINI_API_KEY="ваш_ключ"
export GOOGLE_PLACES_API_KEY="ваш_ключ"
export MONGODB_URI="ваш_uri"
```

2. **Запустите приложение**:
```bash
./run_with_keys.sh
```

### Альтернативный способ

Запуск напрямую с ключами:
```bash
flutter run \
  --dart-define=GEMINI_API_KEY=ваш_ключ \
  --dart-define=GOOGLE_PLACES_API_KEY=ваш_ключ \
  --dart-define=MONGODB_URI=ваш_uri
```

## 📝 Где получить ключи

- **Gemini API**: https://makersuite.google.com/app/apikey
- **Google Places API**: https://console.cloud.google.com/apis/credentials
- **MongoDB**: https://www.mongodb.com/cloud/atlas

## 📚 Полная документация

Подробные инструкции смотрите в [API_SETUP.md](./API_SETUP.md)
