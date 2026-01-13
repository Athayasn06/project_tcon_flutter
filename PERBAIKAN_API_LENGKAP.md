# 🔧 Panduan Perbaikan API Lengkap

## ⚠️ Masalah Yang Ditemukan:

1. ❌ **Token tidak dikembalikan** - Login berhasil tapi tidak ada token untuk logout
2. ❌ **Orders API 404** - Endpoint `/api/my-orders/{user_id}` tidak ditemukan
3. ⚠️ **Avatar images gagal load** - Pravatar.cc tidak dapat diakses dari web

---

## 📋 PERBAIKAN BACKEND LARAVEL (WAJIB!)

### 1. Tambahkan Routes di `routes/api.php`

Buka file `routes/api.php` di Laravel project Anda dan tambahkan:

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ArtisController;
use App\Http\Controllers\Api\EventController;
use App\Http\Controllers\Api\OrderController;

// ===== AUTHENTICATION ROUTES =====
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected routes (butuh token)
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
});

// ===== PUBLIC ROUTES =====
Route::get('/artis', [ArtisController::class, 'index']);
Route::get('/events', [EventController::class, 'index']);

// ===== ORDERS ROUTES (YANG HILANG!) =====
Route::get('/my-orders/{user_id}', [OrderController::class, 'myOrders']);
Route::post('/orders', [OrderController::class, 'store']);
Route::delete('/orders/{id}', [OrderController::class, 'destroy']);
```

### 2. Perbaiki AuthController - RETURN TOKEN!

Buat atau edit file `app/Http/Controllers/Api/AuthController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Register user baru
     */
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => 'user', // Default role
        ]);

        // CREATE TOKEN!
        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Registrasi berhasil',
            'user' => $user,
            'token' => $token, // ⭐ INI YANG PENTING!
        ], 201);
    }

    /**
     * Login user
     */
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Email atau password salah'],
            ]);
        }

        // CREATE TOKEN!
        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Login Berhasil',
            'role' => $user->role,
            'user' => $user,
            'token' => $token, // ⭐ INI YANG PENTING!
        ]);
    }

    /**
     * Logout user
     */
    public function logout(Request $request)
    {
        // Delete current token
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Logout berhasil',
        ]);
    }

    /**
     * Get authenticated user
     */
    public function user(Request $request)
    {
        return response()->json($request->user());
    }
}
```

### 3. Buat OrderController

Buat file `app/Http/Controllers/Api/OrderController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Get orders by user ID
     */
    public function myOrders($user_id)
    {
        try {
            $orders = Order::where('user_id', $user_id)
                ->with('event') // Eager load event relationship
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'status' => 'success',
                'data' => $orders,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengambil data orders: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Create new order
     */
    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'event_id' => 'required|exists:events,id',
            'quantity' => 'required|integer|min:1',
            'ticket_category' => 'required|string',
        ]);

        try {
            $order = Order::create([
                'order_code' => 'TKT-' . strtoupper(uniqid()),
                'user_id' => $request->user_id,
                'event_id' => $request->event_id,
                'quantity' => $request->quantity,
                'ticket_category' => $request->ticket_category,
                'total_amount' => $request->total_amount ?? 0,
                'status' => 'pending',
                'payment_method' => $request->payment_method ?? 'Transfer',
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Order berhasil dibuat',
                'data' => $order->load('event'),
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal membuat order: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Delete order
     */
    public function destroy($id)
    {
        try {
            $order = Order::findOrFail($id);
            $order->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'Order berhasil dihapus',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal menghapus order: ' . $e->getMessage(),
            ], 500);
        }
    }
}
```

### 4. Pastikan Model Order Sudah Ada

File `app/Models/Order.php`:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'order_code',
        'user_id',
        'event_id',
        'quantity',
        'ticket_category',
        'total_amount',
        'status',
        'payment_method',
    ];

    // Relationship dengan Event
    public function event()
    {
        return $this->belongsTo(Event::class);
    }

    // Relationship dengan User
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
```

### 5. Pastikan Migration Table Orders Ada

```bash
php artisan make:migration create_orders_table
```

File migration:

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string('order_code')->unique();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('event_id')->constrained()->onDelete('cascade');
            $table->integer('quantity')->default(1);
            $table->string('ticket_category');
            $table->decimal('total_amount', 10, 2);
            $table->enum('status', ['pending', 'paid', 'cancelled'])->default('pending');
            $table->string('payment_method')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('orders');
    }
};
```

Jalankan migration:

```bash
php artisan migrate
```

### 6. Install Laravel Sanctum (untuk Token Auth)

```bash
# Install Sanctum
composer require laravel/sanctum

# Publish config
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# Run migrations
php artisan migrate
```

Edit `app/Models/User.php` - tambahkan HasApiTokens:

```php
<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens; // ⭐ TAMBAHKAN INI

class User extends Authenticatable
{
    use HasApiTokens; // ⭐ TAMBAHKAN INI
    
    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];
}
```

### 7. Setup CORS untuk Web

Edit `config/cors.php`:

```php
<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'], // Untuk development, nanti ganti dengan domain spesifik
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

### 8. Test Route Laravel

```bash
# Lihat semua routes
php artisan route:list --path=api

# Restart server
php artisan serve --host=192.168.1.110 --port=8000
```

---

## 📱 PERBAIKAN FLUTTER APP

Saya akan memperbaiki Flutter app untuk:
1. ✅ Handle token dengan benar
2. ✅ Handle error orders lebih baik
3. ✅ Fix avatar image loading

---

## 🧪 CARA TEST API

### 1. Test Login (harus return token!)

```bash
curl -X POST http://192.168.1.110:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"zaharaa@gmail.com","password":"your_password"}'
```

**Expected response:**
```json
{
  "status": "success",
  "message": "Login Berhasil",
  "role": "user",
  "user": {...},
  "token": "1|abc123xyz..." ⭐ HARUS ADA!
}
```

### 2. Test Get Orders

```bash
curl http://192.168.1.110:8000/api/my-orders/11
```

**Expected response:**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "order_code": "TKT-123",
      "user_id": 11,
      "event": {...}
    }
  ]
}
```

### 3. Test Create Order

```bash
curl -X POST http://192.168.1.110:8000/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 11,
    "event_id": 1,
    "quantity": 2,
    "ticket_category": "VIP",
    "total_amount": 1000000
  }'
```

---

## ✅ CHECKLIST PERBAIKAN

### Laravel Backend:
- [ ] Install Laravel Sanctum
- [ ] Tambahkan routes di `routes/api.php`
- [ ] Buat/Edit AuthController dengan token
- [ ] Buat OrderController
- [ ] Buat Model Order
- [ ] Buat migration table orders
- [ ] Setup CORS
- [ ] Test semua endpoint

### Flutter App:
- [x] API service sudah handle token dengan baik
- [ ] Perbaiki error handling untuk orders
- [ ] Fix avatar image loading
- [ ] Update base URL untuk environment berbeda

---

## 🚀 SETELAH SEMUA DIPERBAIKI

Jalankan ulang:

```bash
# Laravel
php artisan serve --host=192.168.1.110 --port=8000

# Flutter
flutter run -d chrome
```

## 📞 JIKA MASIH ERROR

1. Check Laravel logs: `storage/logs/laravel.log`
2. Check Flutter console untuk error details
3. Test API dengan Postman/curl
4. Pastikan database connection OK
5. Pastikan Sanctum sudah terinstall dengan benar
