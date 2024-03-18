# RNS App

## Перед запуском дебага

1. spider build (Spider желательно установить глобально, чтобы не таскать его из проекта в проект как зависимость)
2. get generate locales assets/locales

## Используемые команды

1. генерация частичных файлов моделей и других классов (с очистой созданных ранее файлов)
   - dart run build_runner build --delete-conflicting-outputs
2. Создание splash-экранов из файла с настройками (flutter_native_splash.yaml)
   - dart run flutter_native_splash:create
3. Для генерации getX locales
   - get generate locales assets/locales
4. Для обновления конфигурации Firebase (https://firebase.google.com/docs/flutter/setup?hl=ru&platform=ios)
   - flutterfire configure
5. Для генерации файлов (hive и другие)

- dart run build_runner build --delete-conflicting-outputs

## Сквозные виджеты

## Bundle apk

1. Для более сжатой сборки

- flutter build apk --target-platform android-arm,android-arm64

2. Для сборки + анализа размера компонентов

- flutter build apk --target-platform android-arm --analyze-size
- flutter build apk --target-platform android-arm64 --analyze-size
- flutter build apk --target-platform android-x64 --analyze-size

- dart devtools --appSizeBase=apk-code-size-analysis_01.json
