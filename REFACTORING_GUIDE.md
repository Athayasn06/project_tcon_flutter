# Refactoring Tcon App - Struktur File

## Struktur Folder Baru

```
lib/
├── main.dart                    # Entry point aplikasi
├── tcon_app.dart               # Widget utama & state management
├── models/
│   └── mock_data.dart          # Data mock (ARTISTS, CONCERTS, dll)
├── widgets/
│   └── concert_card.dart       # Reusable Concert Card widget
└── screens/
    ├── auth_view.dart          # Halaman Login/Register
    ├── home_view.dart          # Halaman Home
    ├── concert_detail.dart     # Detail Konser
    ├── artist_detail.dart      # Detail Artis
    ├── payment_view.dart       # Halaman Pembayaran
    ├── ticket_success.dart     # Halaman Sukses Pembelian
    ├── moment_view.dart        # Halaman Gallery Moment
    ├── profile_view.dart       # Halaman Profil
    ├── edit_profile_view.dart  # Edit Profil
    └── settings/
        ├── account_info_page.dart      # Info Akun
        ├── notifications_page.dart     # Pengaturan Notifikasi
        ├── security_page.dart          # Keamanan & Privasi
        └── help_center_page.dart       # Pusat Bantuan
```

## File yang Sudah Dibuat

✅ `lib/models/mock_data.dart` - Data mock dan helper functions
✅ `lib/widgets/concert_card.dart` - Concert card widget

## Langkah Selanjutnya

Untuk menyelesaikan refactoring, Anda perlu:

1. **Ekstrak semua widget ke file terpisah** di folder `screens/`
2. **Update import statements** di `tcon_app.dart`
3. **Hapus kode yang sudah dipindahkan** dari `tcon_app.dart`

## Keuntungan Refactoring

- ✅ **Kode lebih terorganisir** dan mudah dinavigasi
- ✅ **Easier maintenance** - setiap file fokus pada satu tanggung jawab
- ✅ **Better collaboration** - developer bisa work on different files
- ✅ **Faster compile time** - Flutter hanya recompile file yang berubah
- ✅ **Reusable components** - widget bisa digunakan di tempat lain

## Contoh Import Baru

```dart
// Di tcon_app.dart
import 'models/mock_data.dart';
import 'widgets/concert_card.dart';
import 'screens/auth_view.dart';
import 'screens/home_view.dart';
// dst...
```

## Tips

- Setiap screen/widget harus punya file sendiri
- Gunakan folder untuk mengelompokkan related files
- Keep `tcon_app.dart` hanya untuk state management dan routing
- Test setelah setiap pemindahan file untuk memastikan app masih running
