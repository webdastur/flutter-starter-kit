# Makefile for common Flutter tasks

.PHONY: help setup get gen watch gen-clean analyze format sort-imports test splash clean run run-ios run-android build-android build-ios build-web

help:
	@echo "Available targets:"
	@echo "  setup          - Install Dart/Flutter deps"
	@echo "  get            - flutter pub get"
	@echo "  gen            - Run build_runner build"
	@echo "  watch          - Run build_runner watch"
	@echo "  gen-clean      - build_runner with --delete-conflicting-outputs"
	@echo "  analyze        - Run flutter analyze"
	@echo "  format         - Format Dart files"
	@echo "  sort-imports   - Sort Dart imports"
	@echo "  test           - Run tests"
	@echo "  splash         - Generate native splash assets"
	@echo "  clean          - flutter clean + delete build artifacts"
	@echo "  run            - Run app (auto device)"
	@echo "  run-ios        - Run app on iOS"
	@echo "  run-android    - Run app on Android"
	@echo "  build-android  - Build Android APK (release)"
	@echo "  build-ios      - Build iOS (release)"
	@echo "  build-web      - Build Web (release)"

setup: get

get:
	flutter pub get

gen:
	flutter packages pub run build_runner build

watch:
	flutter packages pub run build_runner watch

gen-clean:
	flutter packages pub run build_runner build --delete-conflicting-outputs

analyze:
	flutter analyze

format:
	dart format .

sort-imports:
	dart run import_sorter:main --no-comments --no-emojis

test:
	flutter test

splash:
	flutter pub run flutter_native_splash:create

clean:
	flutter clean
	rm -rf build .dart_tool

run:
	flutter run

run-ios:
	flutter run -d ios

run-android:
	flutter run -d android

build-android:
	flutter build apk --release

build-ios:
	flutter build ios --release

build-web:
	flutter build web --release


