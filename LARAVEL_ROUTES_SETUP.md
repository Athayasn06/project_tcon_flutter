# Setup Laravel Routes untuk Tcon API

## ⚠️ PENTING: Tambahkan Route Berikut di Laravel

Buka file `routes/api.php` di project Laravel Anda dan tambahkan:

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\TconApiController;

// Authentication
Route::post('/login', [TconApiController::class, 'login']);
Route::post('/register', [TconApiController::class, 'register']);
Route::post('/logout', [TconApiController::class, 'logout']);

// Profile
Route::put('/profile/{id}', [TconApiController::class, 'updateProfile']);

// Events (Konser)
Route::get('/events', [TconApiController::class, 'listEvents']);
Route::post('/events', [TconApiController::class, 'storeEvent']);
Route::put('/events/{id}', [TconApiController::class, 'updateEvent']);
Route::delete('/events/{id}', [TconApiController::class, 'deleteEvent']);

// Artists
Route::get('/artis', [TconApiController::class, 'listArtis']);
Route::post('/artis', [TconApiController::class, 'storeArtis']);
Route::put('/artis/{id}', [TconApiController::class, 'updateArtis']);
Route::delete('/artis/{id}', [TconApiController::class, 'deleteArtis']);

// Gallery
Route::get('/gallery', [TconApiController::class, 'listGallery']);
Route::post('/gallery', [TconApiController::class, 'storeGallery']);
Route::delete('/gallery/{id}', [TconApiController::class, 'deleteGallery']);

// Contact
Route::post('/contact', [TconApiController::class, 'sendContact']);
Route::get('/messages', [TconApiController::class, 'listMessages']);
Route::delete('/messages/{id}', [TconApiController::class, 'deleteMessage']);

// Orders ⭐ ROUTE YANG HILANG INI YANG MENYEBABKAN ERROR 405
Route::post('/orders', [TconApiController::class, 'storeOrder']);
Route::get('/my-orders/{user_id}', [TconApiController::class, 'myOrders']);
Route::delete('/orders/{id}', [TconApiController::class, 'deleteOrder']);
```

## 🔧 Cara Test Route

Jalankan command ini di terminal Laravel untuk melihat semua route:

```bash
php artisan route:list --path=api
```

## 📝 Penjelasan Error 405

**Error yang terjadi:**
```
[🔌 API] 📥 Status: 405
[🔌 API] ❌ Error: Exception: Gagal mengambil data orders
```

**Penyebab:**
- Status 405 = Method Not Allowed
- Endpoint `/api/my-orders/{user_id}` belum didefinisikan di Laravel routes
- Flutter app mencoba GET tapi route tidak ada

**Solusi:**
Tambahkan route di atas ke file `routes/api.php` Laravel Anda

## ✅ Testing Endpoint

Setelah menambahkan routes, test dengan:

```bash
# Test get artists
curl http://192.168.1.110:8000/api/artis

# Test get events
curl http://192.168.1.110:8000/api/events

# Test get user orders (ganti 11 dengan user_id Anda)
curl http://192.168.1.110:8000/api/my-orders/11
```

## 🎯 Expected Response Format

### Artists Response:
```json
{
  "data": [
    {
      "id": 1,
      "name": "HITAM PUTIH",
      "genre": "Pop Rock",
      "image": "https://example.com/image.jpg"
    }
  ]
}
```

### Events Response:
```json
{
  "data": [
    {
      "id": 1,
      "title": "HITAM PUTIH Live in JKT",
      "date": "2025-02-20",
      "time": "19:00",
      "location": "Istora Senayan",
      "poster": "https://example.com/poster.jpg",
      "min_price": 500000
    }
  ]
}
```

### Orders Response:
```json
{
  "data": [
    {
      "id": 1,
      "order_code": "API-ABC123",
      "user_id": 11,
      "event_id": 1,
      "quantity": 2,
      "ticket_category": "VIP",
      "total_amount": 1000000,
      "status": "paid",
      "payment_method": "API Transfer",
      "event": {
        "id": 1,
        "title": "HITAM PUTIH Live in JKT",
        "date": "2025-02-20",
        "time": "19:00",
        "location": "Istora Senayan"
      }
    }
  ]
}
```

## 🚀 Restart Laravel Server

Setelah menambahkan routes:

```bash
# Hentikan server
Ctrl + C

# Jalankan ulang
php artisan serve --host=192.168.1.110 --port=8000
```

## 🔍 Debug Tips

Jika masih error:

1. **Check route exists:**
   ```bash
   php artisan route:list | grep my-orders
   ```

2. **Check controller method exists:**
   - Pastikan function `myOrders($user_id)` ada di TconApiController

3. **Test direct:**
   Buka browser: `http://192.168.1.110:8000/api/my-orders/11`

4. **Check CORS:**
   Pastikan CORS sudah di-setup untuk menerima request dari Flutter web
