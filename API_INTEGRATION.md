# API Integration Guide

## 📡 Setup API Connection

### 1. Update Base URL

Edit file `lib/services/api_service.dart` dan ganti `baseUrl`:

```dart
// Untuk development local:
static const String baseUrl = 'http://localhost:8000/api';

// Untuk Android Emulator:
static const String baseUrl = 'http://10.0.2.2:8000/api';

// Untuk Device Fisik (ganti YOUR_IP dengan IP komputer Anda):
static const String baseUrl = 'http://192.168.1.100:8000/api';

// Untuk Production:
static const String baseUrl = 'https://your-domain.com/api';
```

### 2. Install Dependencies

```bash
flutter pub get
```

## 🔐 Authentication Flow

### Register
```dart
// Sudah terintegrasi di AuthView
final user = await ApiService.register(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  passwordConfirmation: 'password123',
);
```

**Laravel Endpoint**: `POST /api/register`

**Request Body**:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

**Response Success (201)**:
```json
{
  "message": "Registrasi Berhasil",
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  },
  "access_token": "1|xxxxxxxxxxxxx",
  "token_type": "Bearer"
}
```

**Response Error (422)**:
```json
{
  "errors": {
    "email": ["The email has already been taken."],
    "password": ["The password must be at least 8 characters."]
  }
}
```

### Login
```dart
// Sudah terintegrasi di AuthView
final user = await ApiService.login(
  email: 'john@example.com',
  password: 'password123',
);
```

**Laravel Endpoint**: `POST /api/login`

**Request Body**:
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response Success (200)**:
```json
{
  "access_token": "1|xxxxxxxxxxxxx",
  "token_type": "Bearer"
}
```

**Response Error (401)**:
```json
{
  "message": "Unauthorized"
}
```

### Logout
```dart
final token = await AuthStorage.getToken();
await ApiService.logout(token!);
await AuthStorage.clearUser();
```

**Laravel Endpoint**: `POST /api/logout`

**Headers**:
```
Authorization: Bearer 1|xxxxxxxxxxxxx
```

**Response Success (200)**:
```json
{
  "message": "Token dihapus, Logout berhasil"
}
```

## 💾 Local Storage

Data user dan token disimpan menggunakan `shared_preferences`:

```dart
// Save user
await AuthStorage.saveUser(user);

// Get user
final user = await AuthStorage.getUser();

// Get token
final token = await AuthStorage.getToken();

// Check if logged in
final isLoggedIn = await AuthStorage.isLoggedIn();

// Clear data (logout)
await AuthStorage.clearUser();
```

## 🔧 Laravel Backend Requirements

### 1. Install Laravel Sanctum (jika belum)

```bash
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\\Sanctum\\SanctumServiceProvider"
php artisan migrate
```

### 2. Update `config/cors.php`

```php
'paths' => ['api/*', 'sanctum/csrf-cookie'],

'allowed_methods' => ['*'],

'allowed_origins' => ['*'], // Untuk development, ganti dengan domain spesifik di production

'allowed_headers' => ['*'],

'supports_credentials' => false,
```

### 3. Routes (`routes/api.php`)

```php
Route::post('/register', [ApiAuthController::class, 'register']);
Route::post('/login', [ApiAuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [ApiAuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});
```

### 4. Update Login Response (PENTING!)

Edit `app/Http/Controllers/Api/ApiAuthController.php` method `login`:

```php
public function login(Request $request) {
    $user = User::where('email', $request->email)->first();

    if (!$user || !Hash::check($request->password, $user->password)) {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $token = $user->createToken('auth_token')->plainTextToken;

    return response()->json([
        'access_token' => $token,
        'token_type' => 'Bearer',
        'user' => [  // Tambahkan ini!
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
        ]
    ]);
}
```

## 🧪 Testing

### Test dari Terminal

```bash
# Register
curl -X POST http://localhost:8000/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'

# Login
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'

# Logout (ganti TOKEN dengan token dari response login)
curl -X POST http://localhost:8000/api/logout \
  -H "Authorization: Bearer TOKEN"
```

## 📱 Run Flutter App

```bash
# Run on Chrome
flutter run -d chrome

# Run on Android Emulator
flutter run -d emulator-5554

# Run on Windows
flutter run -d windows
```

## ⚠️ Troubleshooting

### Error: Connection refused
- Pastikan Laravel server berjalan: `php artisan serve`
- Cek base URL sudah benar
- Untuk Android emulator gunakan `10.0.2.2` bukan `localhost`

### Error: CORS
- Pastikan CORS sudah dikonfigurasi di Laravel
- Tambahkan header yang diperlukan

### Error: 401 Unauthorized
- Cek email dan password sudah benar
- Pastikan user sudah terdaftar di database

### Error: 422 Validation Error
- Cek semua field required sudah diisi
- Password minimal 8 karakter
- Email harus valid dan unique

## 🎯 Features

✅ **Register** - Daftar user baru dengan validasi
✅ **Login** - Login dengan email & password
✅ **Logout** - Hapus token dari server & local storage
✅ **Auto Save** - Token disimpan otomatis di device
✅ **Error Handling** - Menampilkan error yang user-friendly
✅ **Loading State** - Loading indicator saat proses API
✅ **Persistent Login** - User tetap login setelah restart app

## 📝 Next Steps

1. ✅ Setup Laravel backend dan jalankan server
2. ✅ Update base URL di `api_service.dart`
3. ✅ Run `flutter pub get`
4. ✅ Test register dan login
5. 🔄 (Optional) Tambahkan fitur Get Profile
6. 🔄 (Optional) Tambahkan fitur Update Profile
7. 🔄 (Optional) Implementasi auto-logout when token expired

---

**Happy Coding! 🚀**
