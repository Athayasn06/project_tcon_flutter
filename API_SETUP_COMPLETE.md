# 🎯 API Authentication - Tcon Flutter App

## ✅ Yang Sudah Dibuat

### 📦 Packages Installed
- `http: ^1.2.0` - Untuk HTTP requests ke Laravel API
- `shared_preferences: ^2.2.2` - Untuk menyimpan token & user data locally

### 📁 Files Created

1. **lib/models/user_model.dart**
   - Model untuk User data
   - Method `fromJson()` dan `toJson()`

2. **lib/services/api_service.dart**
   - Service untuk API calls:
     - `register()` - Register user baru
     - `login()` - Login user
     - `logout()` - Logout & hapus token
     - `getUserProfile()` - Get user profile (optional)

3. **lib/services/auth_storage.dart**
   - Service untuk local storage:
     - `saveUser()` - Simpan user & token
     - `getUser()` - Ambil user data
     - `getToken()` - Ambil auth token
     - `clearUser()` - Hapus data (logout)
     - `isLoggedIn()` - Check login status

4. **lib/screens/auth_view.dart (Updated)**
   - Sudah terintegrasi dengan API
   - Loading indicator saat proses
   - Error handling yang user-friendly
   - Auto save token setelah login/register

5. **API_INTEGRATION.md**
   - Dokumentasi lengkap cara setup & testing

## 🚀 Cara Penggunaan

### 1. Setup Laravel Backend

Pastikan Laravel API Anda sudah running:

```bash
cd /path/to/laravel-project
php artisan serve
```

Laravel akan berjalan di `http://localhost:8000`

### 2. Update Base URL di Flutter

Edit `lib/services/api_service.dart` line 6:

```dart
// Pilih salah satu sesuai kebutuhan:

// Untuk Chrome/Web development:
static const String baseUrl = 'http://localhost:8000/api';

// Untuk Android Emulator:
static const String baseUrl = 'http://10.0.2.2:8000/api';

// Untuk Android Device Fisik (ganti dengan IP komputer Anda):
static const String baseUrl = 'http://192.168.1.100:8000/api';

// Untuk Production:
static const String baseUrl = 'https://your-domain.com/api';
```

**Cara cek IP komputer:**
- Windows: `ipconfig` di cmd, cari "IPv4 Address"
- Mac/Linux: `ifconfig` di terminal, cari "inet"

### 3. Run Flutter App

```bash
flutter run -d chrome
```

## 📱 Test Authentication

### Test Register
1. Buka app di browser
2. Klik tab "DAFTAR"
3. Isi form:
   - Nama: Test User
   - Email: test@example.com
   - Password: password123
   - Konfirmasi: password123
4. Klik "Buat Akun Baru"
5. Jika berhasil akan muncul snackbar hijau dan masuk ke home

### Test Login
1. Buka app di browser
2. Klik tab "MASUK"
3. Isi form:
   - Email: test@example.com
   - Password: password123
4. Klik "Masuk Sekarang"
5. Jika berhasil akan muncul snackbar hijau dan masuk ke home

## 🔍 Troubleshooting

### ❌ "Tidak dapat terhubung ke server"

**Solusi:**
1. Pastikan Laravel server running (`php artisan serve`)
2. Cek base URL sudah benar
3. Untuk Android emulator, gunakan `10.0.2.2` bukan `localhost`
4. Pastikan CORS sudah dikonfigurasi di Laravel

### ❌ "CORS Error" di Browser

**Solusi Laravel** - Edit `config/cors.php`:

```php
return [
    'paths' => ['api/*'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'], // Development only!
    'allowed_headers' => ['*'],
    'supports_credentials' => false,
];
```

**Jalankan:**
```bash
php artisan config:clear
```

### ❌ "The email has already been taken"

**Solusi:**
- Email sudah terdaftar, gunakan email lain
- Atau hapus dari database Laravel:
```sql
DELETE FROM users WHERE email = 'test@example.com';
```

### ❌ "Unauthorized" saat login

**Solusi:**
- Cek email & password benar
- Pastikan user sudah register
- Cek database Laravel ada user tersebut

## 🎨 Features

✅ **Real API Integration** - Connect ke Laravel backend
✅ **Auto Token Storage** - Token disimpan otomatis
✅ **Loading Indicator** - UI feedback saat proses
✅ **Error Handling** - Error messages yang jelas
✅ **Validation** - Validasi form sebelum kirim
✅ **Persistent Login** - Tetap login setelah restart app

## 📝 Laravel Backend Checklist

### Pastikan sudah ada:

1. ✅ Laravel Sanctum installed
2. ✅ Route `/api/register` - POST
3. ✅ Route `/api/login` - POST
4. ✅ Route `/api/logout` - POST (protected)
5. ✅ Controller `ApiAuthController` dengan method:
   - `register()`
   - `login()`
   - `logout()`
6. ✅ CORS configured untuk allow requests dari Flutter

### Testing Laravel API

Gunakan Postman atau curl:

```bash
# Register
curl -X POST http://localhost:8000/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test2@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'

# Login
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test2@example.com",
    "password": "password123"
  }'
```

## 🔐 Security Notes

### Development (Sekarang)
- CORS allow all origins (`*`)
- HTTP tanpa SSL
- Token disimpan di shared_preferences

### Production (Nanti)
- CORS hanya allow domain specific
- HTTPS wajib
- Tambahkan token refresh mechanism
- Tambahkan token expiry handling
- Consider using secure storage

## 📚 Next Steps

Setelah auth berfungsi, Anda bisa:

1. **Auto Login Check** - Check token saat app start
2. **Profile Integration** - Load user profile setelah login
3. **Protected API Calls** - Tambahkan token di semua API calls
4. **Token Refresh** - Implement refresh token mechanism
5. **Logout Everywhere** - Revoke all tokens

## 🎉 Summary

Sekarang Flutter app Anda sudah bisa:
- ✅ Register user baru ke Laravel backend
- ✅ Login dengan email & password
- ✅ Simpan token di device
- ✅ Logout dan hapus token

**App siap untuk testing! Pastikan Laravel server running, lalu coba register dan login.**

---

**Need Help?**
- Cek `API_INTEGRATION.md` untuk dokumentasi detail
- Test endpoint Laravel dengan Postman dulu
- Cek console/terminal untuk error messages
