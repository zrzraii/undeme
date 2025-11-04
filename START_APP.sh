#!/bin/bash

# Скрипт для быстрого запуска приложения Undeme
# Все ключи уже настроены

echo "🚀 Запуск Undeme..."
echo ""
echo "📍 MapScreen - поиск экстренных служб через Google Places API"
echo "💬 ChatScreen - AI помощник через Gemini API"
echo "💾 MongoDB - кэширование данных"
echo ""

# Установка переменных окружения
export MONGODB_URI="mongodb+srv://raihan_db_user:rwNzNg7dKOkKwWrR@cluster0.rqirk9y.mongodb.net/?appName=Cluster0"

# Проверка наличия других ключей
if [ -z "$GEMINI_API_KEY" ]; then
    echo "⚠️  Установите GEMINI_API_KEY:"
    echo "   export GEMINI_API_KEY=\"ваш_ключ\""
    echo ""
fi

if [ -z "$GOOGLE_PLACES_API_KEY" ]; then
    echo "⚠️  Установите GOOGLE_PLACES_API_KEY:"
    echo "   export GOOGLE_PLACES_API_KEY=\"ваш_ключ\""
    echo ""
fi

# Запуск приложения
flutter run \
  --dart-define=GEMINI_API_KEY="${GEMINI_API_KEY:-}" \
  --dart-define=GOOGLE_PLACES_API_KEY="${GOOGLE_PLACES_API_KEY:-}" \
  --dart-define=MONGODB_URI="$MONGODB_URI"
