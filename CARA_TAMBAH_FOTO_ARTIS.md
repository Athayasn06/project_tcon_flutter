# 📸 CARA MENAMBAHKAN FOTO ARTIS

Ada 3 cara untuk menambahkan foto artis di database Laravel:

---

## ✅ CARA 1: Gunakan File SQL (PALING MUDAH)

1. **Buka phpMyAdmin** atau MySQL Workbench
2. **Pilih database** Anda
3. **Copy & Paste** query dari file `INSERT_ARTISTS_WITH_PHOTOS.sql`
4. **Klik Execute** atau Run

File: `INSERT_ARTISTS_WITH_PHOTOS.sql`

---

## ✅ CARA 2: Gunakan Laravel Seeder

1. **Copy file** `ArtistSeeder.php` ke folder Laravel:
   ```
   laravel-project/database/seeders/ArtistSeeder.php
   ```

2. **Jalankan seeder:**
   ```bash
   php artisan db:seed --class=ArtistSeeder
   ```

3. **Atau jalankan semua seeders:**
   ```bash
   php artisan db:seed
   ```

---

## ✅ CARA 3: Update Manual via URL Generator

Jalankan query ini di phpMyAdmin untuk auto-generate foto:

### Opsi A: Unsplash (Foto Orang Nyata)
```sql
UPDATE artists 
SET image = CONCAT('https://source.unsplash.com/400x400/?musician,portrait,', id)
WHERE image IS NULL OR image = '';
```

### Opsi B: Lorem Picsum (Foto Random)
```sql
UPDATE artists 
SET image = CONCAT('https://picsum.photos/400/400?random=', id)
WHERE image IS NULL OR image = '';
```

### Opsi C: UI Avatars (Avatar dengan Nama)
```sql
UPDATE artists 
SET image = CONCAT('https://ui-avatars.com/api/?name=', REPLACE(name, ' ', '+'), '&size=400&background=6366f1&color=fff&bold=true')
WHERE image IS NULL OR image = '';
```

### Opsi D: DiceBear (Avatar Cartoon)
```sql
UPDATE artists 
SET image = CONCAT('https://api.dicebear.com/7.x/avataaars/svg?seed=', name)
WHERE image IS NULL OR image = '';
```

---

## 🔍 CEK HASIL

Setelah insert, cek dengan query:

```sql
-- Lihat semua artis dengan foto
SELECT id, name, genre, image FROM artists;

-- Hitung artis yang punya foto
SELECT COUNT(*) as total FROM artists WHERE image IS NOT NULL AND image != '';

-- Test URL foto (copy & paste ke browser)
SELECT image FROM artists LIMIT 1;
```

---

## 🚀 TEST DI FLUTTER

1. **Restart Laravel server:**
   ```bash
   php artisan serve --host=192.168.1.110 --port=8000
   ```

2. **Test API endpoint:**
   ```bash
   curl http://192.168.1.110:8000/api/artis
   ```

3. **Hot reload Flutter app:**
   - Tekan `R` di terminal Flutter
   - Atau tekan tombol restart di browser

4. **Lihat hasil:**
   - Buka tab "Artis"
   - Semua artis seharusnya punya foto sekarang!

---

## 📝 CONTOH DATA ARTIS

```sql
INSERT INTO artists (name, genre, image, created_at, updated_at) VALUES
('NOAH', 'Pop Rock', 'https://source.unsplash.com/400x400/?musician,band,1', NOW(), NOW()),
('Tulus', 'Jazz Pop', 'https://source.unsplash.com/400x400/?musician,singer,2', NOW(), NOW()),
('Raisa', 'R&B Pop', 'https://source.unsplash.com/400x400/?musician,woman,3', NOW(), NOW()),
('Sheila on 7', 'Pop Rock', 'https://source.unsplash.com/400x400/?musician,band,4', NOW(), NOW()),
('Isyana Sarasvati', 'Classical Pop', 'https://source.unsplash.com/400x400/?musician,piano,5', NOW(), NOW());
```

---

## ⚠️ TROUBLESHOOTING

### Foto tidak muncul di Flutter?

1. **Cek URL di browser:**
   - Copy URL foto dari database
   - Paste di browser
   - Apakah foto muncul?

2. **Cek format response API:**
   ```bash
   curl http://192.168.1.110:8000/api/artis | jq .data[0]
   ```
   
   Harus ada field `image` dengan URL lengkap:
   ```json
   {
     "id": 1,
     "name": "NOAH",
     "genre": "Pop Rock",
     "image": "https://source.unsplash.com/400x400/?musician,1"
   }
   ```

3. **Pastikan URL absolute:**
   - ✅ BENAR: `https://example.com/image.jpg`
   - ❌ SALAH: `/storage/image.jpg`
   - ❌ SALAH: `storage/image.jpg`

4. **Clear cache Flutter:**
   ```bash
   flutter clean
   flutter pub get
   flutter run -d chrome
   ```

---

## 🎨 REKOMENDASI FOTO

Gunakan **Unsplash** untuk foto berkualitas tinggi:

```sql
-- Musician portraits
https://source.unsplash.com/400x400/?musician,portrait

-- Band photos
https://source.unsplash.com/400x400/?band,music

-- Singer
https://source.unsplash.com/400x400/?singer,performer

-- Specific genre
https://source.unsplash.com/400x400/?jazz,musician
https://source.unsplash.com/400x400/?rock,band
https://source.unsplash.com/400x400/?pop,singer
```

Tambahkan number di akhir untuk foto yang berbeda:
```
https://source.unsplash.com/400x400/?musician,1
https://source.unsplash.com/400x400/?musician,2
https://source.unsplash.com/400x400/?musician,3
```

---

## ✨ BONUS: Upload Foto Sendiri

Jika ingin upload foto artis sendiri:

1. **Simpan foto** di folder `public/storage/artists/`
2. **Update database:**
   ```sql
   UPDATE artists 
   SET image = 'http://192.168.1.110:8000/storage/artists/nama-artis.jpg'
   WHERE id = 1;
   ```

3. **Pastikan symbolic link:**
   ```bash
   php artisan storage:link
   ```
