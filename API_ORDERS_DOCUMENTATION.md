# 📝 API Orders Documentation

## Endpoint untuk Payment/Orders

### 1. Create Order (POST)

**Endpoint:**
```
POST http://192.168.1.110:8000/api/orders
```

**Headers:**
```json
{
  "Content-Type": "application/json",
  "Accept": "application/json"
}
```

**Request Body:**
```json
{
  "user_id": 11,
  "event_id": 1,
  "quantity": 2,
  "ticket_category": "VIP",
  "total_amount": 850000,
  "payment_method": "QRIS"
}
```

**Response Success (201):**
```json
{
  "status": "success",
  "message": "Order berhasil dibuat",
  "data": {
    "id": 1,
    "order_code": "TKT-ABC123DEF",
    "user_id": 11,
    "event_id": 1,
    "quantity": 2,
    "ticket_category": "VIP",
    "total_amount": 850000,
    "status": "pending",
    "payment_method": "QRIS",
    "created_at": "2026-01-06T10:30:00.000000Z",
    "updated_at": "2026-01-06T10:30:00.000000Z",
    "event": {
      "id": 1,
      "nama_event": "GO TULUS",
      "tanggal": "2026-01-14",
      "lokasi": "Jakarta",
      "poster": "1767636111_Konser-Tulus.jpg",
      "min_price": 400000
    }
  }
}
```

**Response Error (400/422):**
```json
{
  "status": "error",
  "message": "Validation failed",
  "errors": {
    "user_id": ["The user_id field is required."],
    "event_id": ["The event_id field is required."]
  }
}
```

---

### 2. Get My Orders (GET)

**Endpoint:**
```
GET http://192.168.1.110:8000/api/my-orders/{user_id}
```

**Example:**
```
GET http://192.168.1.110:8000/api/my-orders/11
```

**Headers:**
```json
{
  "Content-Type": "application/json",
  "Accept": "application/json"
}
```

**Response Success (200):**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "order_code": "TKT-ABC123DEF",
      "user_id": 11,
      "event_id": 1,
      "quantity": 2,
      "ticket_category": "VIP",
      "total_amount": 850000,
      "status": "pending",
      "payment_method": "QRIS",
      "created_at": "2026-01-06T10:30:00.000000Z",
      "updated_at": "2026-01-06T10:30:00.000000Z",
      "event": {
        "id": 1,
        "nama_event": "GO TULUS",
        "tanggal": "2026-01-14",
        "lokasi": "Jakarta",
        "poster": "1767636111_Konser-Tulus.jpg",
        "min_price": 400000
      }
    }
  ]
}
```

**Response Empty (200):**
```json
{
  "status": "success",
  "data": []
}
```

---

### 3. Delete Order (DELETE)

**Endpoint:**
```
DELETE http://192.168.1.110:8000/api/orders/{id}
```

**Example:**
```
DELETE http://192.168.1.110:8000/api/orders/1
```

**Headers:**
```json
{
  "Content-Type": "application/json",
  "Accept": "application/json"
}
```

**Response Success (200):**
```json
{
  "status": "success",
  "message": "Order berhasil dihapus"
}
```

---

## 🔧 Laravel Backend Implementation

### Controller Method untuk Create Order

File: `app/Http/Controllers/Api/OrderController.php`

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'event_id' => 'required|exists:events,id',
            'quantity' => 'required|integer|min:1',
            'ticket_category' => 'required|string',
            'total_amount' => 'required|numeric|min:0',
            'payment_method' => 'required|string',
        ]);

        try {
            $order = Order::create([
                'order_code' => 'TKT-' . strtoupper(uniqid()),
                'user_id' => $validated['user_id'],
                'event_id' => $validated['event_id'],
                'quantity' => $validated['quantity'],
                'ticket_category' => $validated['ticket_category'],
                'total_amount' => $validated['total_amount'],
                'status' => 'pending',
                'payment_method' => $validated['payment_method'],
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

    public function myOrders($user_id)
    {
        try {
            $orders = Order::where('user_id', $user_id)
                ->with('event')
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

### Routes

File: `routes/api.php`

```php
use App\Http\Controllers\Api\OrderController;

Route::post('/orders', [OrderController::class, 'store']);
Route::get('/my-orders/{user_id}', [OrderController::class, 'myOrders']);
Route::delete('/orders/{id}', [OrderController::class, 'destroy']);
```

### Model

File: `app/Models/Order.php`

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
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

    public function event()
    {
        return $this->belongsTo(Event::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
```

### Migration

```bash
php artisan make:migration create_orders_table
```

File: `database/migrations/xxxx_xx_xx_create_orders_table.php`

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

---

## 🧪 Testing dengan cURL

### Test Create Order

```bash
curl -X POST http://192.168.1.110:8000/api/orders \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "user_id": 11,
    "event_id": 1,
    "quantity": 2,
    "ticket_category": "VIP",
    "total_amount": 850000,
    "payment_method": "QRIS"
  }'
```

### Test Get My Orders

```bash
curl http://192.168.1.110:8000/api/my-orders/11 \
  -H "Content-Type: application/json" \
  -H "Accept: application/json"
```

### Test Delete Order

```bash
curl -X DELETE http://192.168.1.110:8000/api/orders/1 \
  -H "Content-Type: application/json" \
  -H "Accept: application/json"
```

---

## 📱 Flutter Implementation

Sudah diimplementasikan di:
- `lib/services/api_service.dart` - Method `createOrder()` dan `getMyOrders()`
- `lib/screens/payment_view.dart` - Method `_handlePayment()` yang memanggil API

### Cara Penggunaan di Flutter

```dart
// Create order
final orderData = await ApiService.createOrder(
  userId: 11,
  eventId: 1,
  quantity: 2,
  ticketCategory: 'VIP',
  totalAmount: 850000,
  paymentMethod: 'QRIS',
);

// Get user orders
final orders = await ApiService.getMyOrders(11);
```

---

## ✅ Checklist Setup

- [ ] Buat migration `orders` table
- [ ] Jalankan `php artisan migrate`
- [ ] Buat Model `Order.php`
- [ ] Buat Controller `OrderController.php`
- [ ] Tambahkan routes di `api.php`
- [ ] Test dengan cURL/Postman
- [ ] Test di Flutter app

---

## 🚀 Jalankan Laravel Server

```bash
php artisan serve --host=192.168.1.110 --port=8000
```

Setelah setup selesai, jalankan Flutter app:

```bash
flutter run -d chrome
```
