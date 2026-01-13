# Field Mapping - Laravel API to Flutter

## 📊 Artists (Artis)

### Laravel Database Fields:
```php
// Table: artists
- id (int)
- name (string)
- genre (string)
- image (string) // atau photo/avatar/picture
- bio (text)
- created_at
- updated_at
```

### Flutter Expected Fields:
```dart
{
  'id': 1,
  'name': 'HITAM PUTIH',
  'genre': 'Pop Rock',
  'image': 'https://example.com/artist.jpg',  // URL gambar
}
```

### Image Field Alternatives (Flutter auto-detect):
- `image` (primary)
- `photo` (fallback 1)
- `avatar` (fallback 2)
- `picture` (fallback 3)

---

## 🎸 Events/Concerts

### Laravel Database Fields:
```php
// Table: events
- id (int)
- title (string) // atau name
- date (date)
- time (time)
- location (string)
- poster (string) // atau image
- min_price (int) // atau minPrice
- description (text)
- created_at
- updated_at
```

### Flutter Expected Fields:
```dart
{
  'id': 1,
  'title': 'HITAM PUTIH Live in JKT',  // atau 'name'
  'date': '2025-02-20',
  'time': '19:00',
  'location': 'Istora Senayan',
  'poster': 'https://example.com/poster.jpg',  // atau 'image'
  'min_price': 500000,  // atau 'minPrice'
}
```

### Field Alternatives (Flutter auto-detect):
- Title: `title` or `name`
- Image: `poster` or `image`
- Price: `min_price` or `minPrice`

---

## 🎫 Orders (Tiket)

### Laravel Database Fields:
```php
// Table: orders
- id (int)
- order_code (string)
- user_id (int)
- event_id (int)
- quantity (int)
- ticket_category (string)
- total_amount (int)
- status (string)
- payment_method (string)
- created_at
- updated_at
```

### Flutter Expected Fields:
```dart
{
  'id': 1,
  'order_code': 'API-ABC123',
  'user_id': 11,
  'event_id': 1,
  'quantity': 2,
  'ticket_category': 'VIP',
  'total_amount': 1000000,
  'status': 'paid',
  'payment_method': 'API Transfer',
  'event': {  // Relation data
    'id': 1,
    'title': 'HITAM PUTIH Live in JKT',
    'date': '2025-02-20',
    'time': '19:00',
    'location': 'Istora Senayan'
  }
}
```

---

## ⚠️ IMPORTANT: Image URLs

### Absolute URLs (Recommended):
```php
'image' => 'https://example.com/storage/artists/image.jpg'
```

### Relative URLs (Need base URL):
```php
'image' => '/storage/artists/image.jpg'  // ❌ Will fail in Flutter
```

### Fix in Laravel Controller:
```php
public function listArtis() {
    $artists = Artist::all()->map(function($artist) {
        return [
            'id' => $artist->id,
            'name' => $artist->name,
            'genre' => $artist->genre,
            'image' => $artist->image 
                ? url('storage/' . $artist->image)  // Convert to full URL
                : null,
        ];
    });
    
    return response()->json(['data' => $artists]);
}
```

---

## 🧪 Testing Data

### Sample Artist Data (untuk testing):
```sql
INSERT INTO artists (name, genre, image) VALUES
('HITAM PUTIH', 'Pop Rock', 'https://i.pravatar.cc/150?img=1'),
('Sheila on 7', 'Pop', 'https://i.pravatar.cc/150?img=2'),
('Noah', 'Pop Rock', 'https://i.pravatar.cc/150?img=3'),
('Tulus', 'Jazz Pop', 'https://i.pravatar.cc/150?img=4');
```

### Sample Event Data:
```sql
INSERT INTO events (title, date, time, location, poster, min_price) VALUES
('HITAM PUTIH Live', '2025-02-20', '19:00', 'Istora Senayan', 
 'https://picsum.photos/400/300?random=1', 500000),
('Sheila on 7 Concert', '2025-03-15', '20:00', 'GBK Stadium',
 'https://picsum.photos/400/300?random=2', 350000);
```

---

## 🔍 Debug Checklist

When images don't show:

1. ✅ **Check API Response Format**
   ```bash
   curl http://192.168.1.110:8000/api/artis | jq
   ```

2. ✅ **Verify Image URLs are absolute**
   - Should start with `http://` or `https://`
   - NOT relative like `/storage/...`

3. ✅ **Check Flutter Console for:**
   - `✅ Fetched X artists from API`
   - `📝 First artist: {...}`
   - Image load errors

4. ✅ **Test Image URL in Browser**
   - Copy URL from API response
   - Open in browser - should show image

5. ✅ **CORS Headers (for web)**
   - Laravel should allow requests from `localhost:57772`
