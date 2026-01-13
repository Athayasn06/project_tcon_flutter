import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/mock_data.dart';
import '../widgets/concert_card.dart';

class ArtistDetail extends StatelessWidget {
  final Map<String, dynamic> artist;
  final VoidCallback onBack;
  final void Function(Map<String, dynamic>) onConcertTap;

  const ArtistDetail({
    super.key,
    required this.artist,
    required this.onBack,
    required this.onConcertTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = artist['name'] as String? ?? '';
    final genre = artist['genre'] as String? ?? '';
    final about =
        artist['about'] as String? ?? artist['description'] as String? ?? '';
    final imagePath =
        artist['image'] as String? ??
        artist['image_path'] as String? ??
        artist['photo'] as String? ??
        '';
    final imageUrl = imagePath.isNotEmpty
        ? 'http://192.168.1.110:8000/storage/$imagePath'
        : '';
    final relatedConcerts = CONCERTS
        .where(
          (c) =>
              (c as Map<String, dynamic>)['artist']
                  ?.toString()
                  .toLowerCase()
                  .contains(name.toLowerCase()) ??
              false,
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.indigo,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade300,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.indigo.shade200,
                  child: const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    genre,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.indigo,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tentang',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    about,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Konser Terkait',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (relatedConcerts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Belum ada konser terkait.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: relatedConcerts
                          .map(
                            (c) => ConcertCard(
                              concert: c as Map<String, dynamic>,
                              onTap: () => onConcertTap(c),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
