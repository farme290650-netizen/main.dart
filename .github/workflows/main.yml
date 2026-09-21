name: Build Android APK

on:
  push:
    branches:
      - main
      - master
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Java
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
          
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.x'
          
      - name: Create basic Flutter structure
        run: |
          flutter create temp_app
          mv temp_app/android ./
          mv temp_app/pubspec.yaml ./
          mkdir -p lib
          mv main.dart lib/ || mv เมน.ดาร์ท lib/main.dart

      - name: Add flutter_openvpn dependency
        run: |
          flutter pub add flutter_openvpn
          flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: esan-vpn-app
          path: build/app/outputs/flutter-apk/app-release.apk
