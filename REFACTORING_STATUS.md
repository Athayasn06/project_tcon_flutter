# Update untuk tcon_app.dart

## File-File Baru yang Sudah Dibuat

### 📁 Models
- `lib/models/mock_data.dart` - Data constants (ARTISTS, CONCERTS, INITIAL_GALLERY, formatRupiah)

### 📁 Widgets
- `lib/widgets/concert_card.dart` - Reusable ConcertCard widget

### 📁 Screens
- `lib/screens/auth_view.dart` - Login & Register page
- `lib/screens/home_view.dart` - Home dengan hero, artist carousel, dan concert list
- `lib/screens/concert_detail.dart` - Detail konser dengan gallery dan "Bagikan Momen"
- `lib/screens/artist_detail.dart` - Detail artis dengan konser terkait
- `lib/screens/payment_view.dart` - Halaman pembayaran QRIS/Transfer
- `lib/screens/ticket_success.dart` - Success page dengan QR code
- `lib/screens/moment_view.dart` - Upload dan lihat moments
- `lib/screens/profile_view.dart` - Profile dengan tiket dan settings menu
- `lib/screens/edit_profile_view.dart` - Edit profile dengan image picker

### 📁 Settings
- `lib/screens/settings/account_info_page.dart` - Informasi akun & statistik
- `lib/screens/settings/notifications_page.dart` - Pengaturan notifikasi
- `lib/screens/settings/security_page.dart` - Keamanan & privasi
- `lib/screens/settings/help_center_page.dart` - FAQ dan contact support

## Langkah Selanjutnya

### 1. Tambahkan Import di tcon_app.dart (bagian atas file)

```dart
// Models
import 'models/mock_data.dart';

// Widgets
import 'widgets/concert_card.dart';

// Screens
import 'screens/auth_view.dart';
import 'screens/home_view.dart';
import 'screens/concert_detail.dart';
import 'screens/artist_detail.dart';
import 'screens/payment_view.dart';
import 'screens/ticket_success.dart';
import 'screens/moment_view.dart';
import 'screens/profile_view.dart';
import 'screens/edit_profile_view.dart';

// Settings
import 'screens/settings/account_info_page.dart';
import 'screens/settings/notifications_page.dart';
import 'screens/settings/security_page.dart';
import 'screens/settings/help_center_page.dart';
```

### 2. Hapus Kode yang Sudah Diekstrak

Dari tcon_app.dart, hapus:
- ✅ Semua data constants (ARTISTS, CONCERTS, INITIAL_GALLERY, formatRupiah) - sudah di mock_data.dart
- ✅ Class ConcertCard - sudah di concert_card.dart
- ✅ Class AuthView - sudah di auth_view.dart
- ✅ Class HomeView - sudah di home_view.dart
- ✅ Class ConcertDetail - sudah di concert_detail.dart
- ✅ Class ArtistDetail - sudah di artist_detail.dart
- ✅ Class PaymentView - sudah di payment_view.dart
- ✅ Class TicketSuccess - sudah di ticket_success.dart
- ✅ Class MomentView - sudah di moment_view.dart
- ✅ Class ProfileView - sudah di profile_view.dart (yang lama, bukan ProfileViewEnhanced)
- ✅ Class EditProfileView - sudah di edit_profile_view.dart
- ✅ Class AccountInfoPage - sudah di account_info_page.dart
- ✅ Class NotificationsPage - sudah di notifications_page.dart
- ✅ Class SecurityPage - sudah di security_page.dart
- ✅ Class HelpCenterPage - sudah di help_center_page.dart
- ✅ Class _MenuItemData - tidak perlu lagi

### 3. Yang Tetap di tcon_app.dart

Hanya simpan:
- ✅ Class `TconApp` (MaterialApp root)
- ✅ Class `TconHome` dan `_TconHomeState` (state management & navigation)
- ✅ Class `ProfileViewEnhanced` (versi profile yang lebih lengkap dengan tiket management)

### 4. Struktur Folder Akhir

```
lib/
├── main.dart
├── tcon_app.dart (simplified)
├── models/
│   └── mock_data.dart
├── widgets/
│   └── concert_card.dart
└── screens/
    ├── auth_view.dart
    ├── home_view.dart
    ├── concert_detail.dart
    ├── artist_detail.dart
    ├── payment_view.dart
    ├── ticket_success.dart
    ├── moment_view.dart
    ├── profile_view.dart
    ├── edit_profile_view.dart
    └── settings/
        ├── account_info_page.dart
        ├── notifications_page.dart
        ├── security_page.dart
        └── help_center_page.dart
```

## Manfaat Refactoring

✅ **Lebih Mudah Dipelihara** - Setiap screen di file terpisah
✅ **Compile Lebih Cepat** - Flutter hanya compile file yang berubah
✅ **Tim Bisa Kolaborasi** - Tidak ada konflik di satu file besar
✅ **Lebih Mudah Debug** - Fokus pada satu file saat debugging
✅ **Reusable Code** - Widgets bisa dipakai di mana saja
✅ **Testing Lebih Mudah** - Test setiap komponen secara terpisah

## Status

🟢 **SELESAI**: Semua file screen dan settings sudah dibuat!
🟡 **NEXT**: Update tcon_app.dart dengan menambah imports dan menghapus kode yang sudah diekstrak
🔴 **TODO**: Test app setelah refactoring untuk memastikan semua masih berfungsi

---

**Note**: Semua file sudah dibuat dengan kode lengkap dan siap digunakan. Tinggal update tcon_app.dart saja! 🎉
