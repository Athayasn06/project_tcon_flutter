import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/mock_data.dart';

class ConcertCard extends StatelessWidget {
  final Map<String, dynamic> concert;
  final VoidCallback onTap;

  const ConcertCard({super.key, required this.concert, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Get image from API (poster field)
    final posterPath = concert['poster'] as String? ?? concert['image'] as String? ?? '';
    final imageUrl = posterPath.isNotEmpty 
        ? 'http://192.168.1.110:8000/storage/$posterPath'
        : '';
    
    // Get title from API (nama_event or title)
    final title = concert['nama_event'] as String? ?? 
                 concert['title'] as String? ?? 
                 concert['name'] as String? ?? 'Konser';
    
    // Get location from API (lokasi or location)
    final location = concert['lokasi'] as String? ?? 
                    concert['location'] as String? ?? 
                    concert['venue'] as String? ?? '';
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.music_note, size: 50, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai ${formatRupiah(concert['minPrice'] as int? ?? concert['min_price'] as int? ?? 0)}',
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
