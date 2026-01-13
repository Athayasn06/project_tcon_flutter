# tcon_aca

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Tcon (converted UI)

I added a Flutter implementation of the provided React UI (`lib/tcon_app.dart`) with these notes:

- Run `flutter pub get` to fetch new dependencies (`image_picker`, `cached_network_image`, `font_awesome_flutter`).
- The Live Gallery supports uploading images from device gallery (mobile). The app uses `image_picker`.
- Android: permissions for CAMERA and READ/WRITE external storage were added in `android/app/src/main/AndroidManifest.xml`.
- iOS: `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` were added in `ios/Runner/Info.plist`.

If you want, I can also add platform-specific setup steps (e.g., Android 13 scoped storage notes).
