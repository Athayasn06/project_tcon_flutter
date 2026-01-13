import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/mock_data.dart';
import '../widgets/concert_card.dart';

class HomeView extends StatelessWidget {
  final VoidCallback onViewConcerts;
  final void Function(Map<String, dynamic>) onArtistTap;
  final void Function(Map<String, dynamic>) onGoConcert;

  const HomeView({
    super.key,
    required this.onViewConcerts,
    required this.onArtistTap,
    required this.onGoConcert,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero
        Stack(
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: 'https://picsum.photos/id/452/800/600',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 18,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Temukan & Beli\nTiket Konser',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: onViewConcerts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Lihat Konser',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Artis Populer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Artis Populer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 86,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ARTISTS.map((artist) {
                    final a = artist as Map<String, dynamic>;
                    String imageUrl =
                        a['image'] as String? ??
                        a['image_path'] as String? ??
                        a['photo'] as String? ??
                        a['avatar'] as String? ??
                        '';

                    // Add base URL if image path exists
                    if (imageUrl.isNotEmpty) {
                      imageUrl = 'http://192.168.1.110:8000/storage/$imageUrl';
                    }

                    // Generate avatar from name if no image
                    if (imageUrl.isEmpty) {
                      final name = a['name'] as String? ?? 'Artist';
                      final encodedName = Uri.encodeComponent(name);
                      imageUrl =
                          'https://ui-avatars.com/api/?name=$encodedName&size=120&background=6366f1&color=fff&bold=true';
                    }

                    return GestureDetector(
                      onTap: () => onArtistTap(a),
                      child: SizedBox(
                        width: 72,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade300,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.indigo.shade100,
                                        child: const Icon(
                                          Icons.person,
                                          size: 30,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              a['name'] as String? ?? 'Unknown',
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Konser Unggulan
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              const Text(
                'Konser Unggulan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: CONCERTS
                    .map(
                      (c) => ConcertCard(
                        concert: c as Map<String, dynamic>,
                        onTap: () => onGoConcert(c),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
