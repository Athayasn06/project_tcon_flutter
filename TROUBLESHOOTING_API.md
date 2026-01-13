# 🔧 Troubleshooting API Connection

## ❌ Masalah: API Tidak Nyambung

### Langkah 1: Pastikan Laravel Server Running

Buka terminal/CMD baru dan jalankan:

```bash
cd /path/to/laravel-project
php artisan serve
```

Harusnya muncul:
```
Starting Laravel development server: http://127.0.0.1:8000
```

**JANGAN TUTUP** terminal ini, biarkan terus running.

### Langkah 2: Test API dengan Browser

Buka browser dan akses:
```
http://127.0.0.1:8000
```

Harusnya muncul halaman Laravel.

### Langkah 3: Test API Endpoint

Klik 2x file `test_api.bat` yang sudah saya buat, atau jalankan di CMD:

```bash
test_api.bat
```

Ini akan test endpoint `/api/login` dan `/api/register`.

**Hasilnya:**
- ✅ Jika berhasil: Akan muncul response JSON
- ❌ Jika gagal: Akan muncul "Connection refused"

### Langkah 4: Cek CORS Laravel

Edit file `config/cors.php` di Laravel project:

```php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'],  // DEVELOPMENT ONLY!
    'allowed_headers' => ['*'],
    'supports_credentials' => false,
];
```

Lalu jalankan:
```bash
php artisan config:clear
php artisan config:cache
```

### Langkah 5: Restart Flutter App

1. Di terminal Flutter yang running, tekan `R` (Hot Restart)
2. Atau stop (Ctrl+C) dan jalankan lagi:
   ```bash
   flutter run -d chrome
   ```

### Langkah 6: Lihat Debug Log di Console

Setelah restart, coba register atau login. Di terminal Flutter akan muncul log:

```
[API SERVICE] 📤 POST http://127.0.0.1:8000/api/register
[API SERVICE] 📦 Body: {name: Test, email: test@example.com}
[API SERVICE] 📥 Response: 201
[API SERVICE] 📄 Body: {"message":"Registrasi Berhasil",...}
```

**Jika tidak muncul response atau muncul error:**
- Cek Laravel server masih running
- Cek IP address sudah benar

### Jika Masih Tidak Bisa - Gunakan IP Komputer

1. **Cek IP Komputer:**
   ```bash
   ipconfig
   ```
   Cari bagian "IPv4 Address", contoh: `192.168.1.100`

2. **Update api_service.dart:**
   
   Edit `lib/services/api_service.dart` line 8:
   ```dart
   static const String baseUrl = 'http://192.168.1.100:8000/api';
   ```
   Ganti `192.168.1.100` dengan IP komputer Anda

3. **Jalankan Laravel dengan bind ke semua IP:**
   ```bash
   php artisan serve --host=0.0.0.0
   ```

4. **Restart Flutter app**

### ⚠️ Common Issues

1. **Port 8000 sudah dipakai:**
   ```bash
   php artisan serve --port=8001
   ```
   Lalu update baseUrl jadi `http://127.0.0.1:8001/api`

2. **Firewall blocking:**
   - Windows Defender Firewall mungkin block koneksi
   - Allow PHP/Laravel di firewall settings

3. **Antivirus blocking:**
   - Disable sementara antivirus
   - Atau tambahkan exception untuk Laravel folder

### 🧪 Quick Test dari Browser

Paste ini di browser (ganti email jika sudah ada):

```
http://127.0.0.1:8000/api/register?name=Test&email=test3@example.com&password=password123&password_confirmation=password123
```

Jika muncul error "Method not allowed", berarti Laravel server **RUNNING** tapi endpoint **salah**.
Jika muncul "Connection refused", berarti Laravel server **TIDAK RUNNING**.

### 📞 Masih Tidak Bisa?

Screenshot error yang muncul di:
1. Terminal Flutter (yang running `flutter run`)
2. Terminal Laravel (yang running `php artisan serve`)
3. Console browser (F12 → Console tab)

Dan kirim ke saya untuk analisa lebih lanjut.

---

**Checklist Debug:**
- [ ] Laravel server running di http://127.0.0.1:8000
- [ ] Browser bisa akses http://127.0.0.1:8000
- [ ] File `test_api.bat` berhasil test API
- [ ] CORS sudah dikonfigurasi
- [ ] Flutter app sudah restart
- [ ] Debug log muncul di terminal Flutter
