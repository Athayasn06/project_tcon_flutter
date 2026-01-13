# Troubleshooting Guide - Tcon App

## Current Status
✅ **App runs successfully on Chrome browser**
❌ Android build fails with "deleted Android v1 embedding" error
❌ Windows build requires Developer Mode for symlink support

## Solutions

### Option 1: Run on Web (RECOMMENDED - Currently Working)
```bash
flutter run -d chrome
```
This works without any additional configuration!

### Option 2: Fix Android Build

The Android v1 embedding error is a known issue with certain Flutter SDK versions. Here's how to fix it:

#### Solution A: Enable Developer Mode for Windows (Required for plugin support)
1. Open Windows Settings
2. Go to "Privacy & Security" > "For developers"
3. Turn on "Developer Mode"
4. Restart your computer
5. Run: `flutter clean`
6. Run: `flutter pub get`
7. Run: `flutter run -d emulator-5554`

#### Solution B: Update Flutter SDK
```bash
flutter upgrade
flutter clean
flutter pub get
flutter run -d emulator-5554
```

#### Solution C: Recreate Android folder
```bash
# Backup your android/app/src/main/AndroidManifest.xml first
flutter create --platforms=android .
# Restore your AndroidManifest.xml with the permissions
flutter pub get
flutter run -d emulator-5554
```

### Option 3: Fix Windows Build
1. Enable Developer Mode (see Option 2, Solution A)
2. Run:
```bash
flutter clean
flutter pub get
flutter run -d windows
```

### Option 4: Install Android cmdline-tools
1. Open Android Studio
2. Go to Settings > Appearance & Behavior > System Settings > Android SDK
3. Select "SDK Tools" tab
4. Check "Android SDK Command-line Tools (latest)"
5. Click "Apply" to install
6. Run: `flutter doctor --android-licenses` (accept all)
7. Run: `flutter run -d emulator-5554`

## Current Workaround
**The app is currently running successfully on Chrome browser!**

To run the app:
```bash
flutter run -d chrome
```

## App Features
The Tcon Concert Ticket App includes:
- User authentication (login/register)
- Concert browsing
- Artist profiles
- Ticket purchasing with QRIS and Bank Transfer
- Live gallery for sharing moments
- User profile management
- Order history

All features work perfectly on the web version!
