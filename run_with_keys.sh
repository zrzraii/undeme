#!/bin/bash

# Скрипт для запуска Flutter приложения с API ключами
# Использование: ./run_with_keys.sh

echo "🚀 Запуск Undeme с API ключами..."

# Проверка наличия переменных окружения
if [ -z "$GEMINI_API_KEY" ]; then
    echo "⚠️  GEMINI_API_KEY не установлен"
fi

if [ -z "$GOOGLE_PLACES_API_KEY" ]; then
    echo "⚠️  GOOGLE_PLACES_API_KEY не установлен"
fi

if [ -z "$MONGODB_URI" ]; then
    echo "⚠️  MONGODB_URI не установлен"
fi

# Запуск Flutter с передачей всех ключей
flutter run \
  --dart-define=GEMINI_API_KEY="$GEMINI_API_KEY" \
  --dart-define=GOOGLE_PLACES_API_KEY="$GOOGLE_PLACES_API_KEY" \
  --dart-define=MONGODB_URI="$MONGODB_URI"
