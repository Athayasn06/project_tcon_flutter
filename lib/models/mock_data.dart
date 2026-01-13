// --- DATA MOCK ---
final ARTISTS = [
  {
    'id': '1',
    'name': 'Tulus',
    'genre': 'Pop Jazz',
    'description':
        'Penyanyi dan penulis lagu Indonesia yang dikenal dengan lirik puitis dan suara khas.',
    'image':
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300&h=300&fit=crop',
  },
  {
    'id': '2',
    'name': 'Sheila On 7',
    'genre': 'Pop Rock',
    'description':
        'Grup musik legendaris asal Yogyakarta yang telah melahirkan banyak hits sepanjang masa.',
    'image':
        'https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=300&h=300&fit=crop',
  },
  {
    'id': '3',
    'name': 'Isyana',
    'genre': 'Classical Pop',
    'description':
        'Musisi berbakat dengan latar belakang musik klasik yang kuat.',
    'image':
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300&h=300&fit=crop',
  },
  {
    'id': '4',
    'name': 'Dewa 19',
    'genre': 'Rock',
    'description': 'Band rock ikonik Indonesia yang dipimpin oleh Ahmad Dhani.',
    'image':
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop',
  },
];

final CONCERTS = [
  {
    'id': '1',
    'title': 'Sound of Downtown',
    'date': '20 Nov 2025',
    'location': 'GBK Jakarta',
    'minPrice': 400000,
    'image': 'https://picsum.photos/id/119/800/400',
    'headliner': 'Tulus',
    'description':
        'Festival musik terbesar tahun ini menghadirkan berbagai artis papan atas.',
  },
  {
    'id': '2',
    'title': 'Jazz Goes to Campus',
    'date': '05 Des 2025',
    'location': 'UI Depok',
    'minPrice': 150000,
    'image': 'https://picsum.photos/id/158/800/400',
    'headliner': "Maliq & D'Essentials",
    'description': 'Nikmati alunan jazz di lingkungan kampus yang asri.',
  },
  {
    'id': '3',
    'title': 'Rock In Solo',
    'date': '15 Okt 2025',
    'location': 'Benteng Vastenburg',
    'minPrice': 250000,
    'image': 'https://picsum.photos/id/145/800/400',
    'headliner': 'Burgerkill',
    'description': 'Konser rock paling keras di Jawa Tengah.',
  },
];

final INITIAL_GALLERY = [
  {
    'id': 1,
    'imageUrl': 'https://picsum.photos/id/101/400/400',
    'caption': 'Energi yang luar biasa!',
    'eventName': 'Sound of Downtown',
  },
  {
    'id': 2,
    'imageUrl': 'https://picsum.photos/id/102/400/400',
    'caption': 'Malam yang tak terlupakan.',
    'eventName': 'Jazz Goes to Campus',
  },
  {
    'id': 3,
    'imageUrl': 'https://picsum.photos/id/103/400/400',
    'caption': 'Vibesnya keren!',
    'eventName': 'Rock In Solo',
  },
  {
    'id': 4,
    'imageUrl': 'https://picsum.photos/id/104/400/400',
    'caption': 'Konser terbaik!',
    'eventName': 'Sound of Downtown',
  },
];

String formatRupiah(int n) {
  final s = n.toString();
  return 'Rp ' +
      s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (Match m) => '.');
}
