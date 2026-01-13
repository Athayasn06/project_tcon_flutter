import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class MomentView extends StatefulWidget {
  final List<Map<String, dynamic>> moments;
  final Function(List<Map<String, dynamic>>)? onMomentsUpdated;

  const MomentView({
    super.key,
    this.moments = const [],
    this.onMomentsUpdated,
  });

  @override
  State<MomentView> createState() => _MomentViewState();
}

class _MomentViewState extends State<MomentView> {
  late List<Map<String, dynamic>> _moments;

  @override
  void initState() {
    super.initState();
    _moments = List.from(widget.moments);
    if (_moments.isEmpty) {
      // Add default moments if empty
      _moments = [
        {
          'user': 'Andi Saputra',
          'avatar': 'https://i.pravatar.cc/150?img=12',
          'image': 'https://picsum.photos/id/453/600/600',
          'caption': 'Konser kemarin seru banget! 🎉',
          'likes': 42,
          'event': 'Jass',
        },
        {
          'user': 'Budi Santoso',
          'avatar': 'https://i.pravatar.cc/150?img=13',
          'image': 'https://picsum.photos/id/454/600/600',
          'caption': 'Momen terbaik tahun ini! 🔥',
          'likes': 38,
          'event': 'Rox',
        },
      ];
    }
  }

  final List<String> _events = [
    'Jass',
    'Rox',
    'Sund',
  ];

  final TextEditingController _captionController = TextEditingController();
  XFile? _pickedImage;
  Uint8List? _webImage;
  String? _selectedEvent;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      }
    }
  }

  void _uploadMoment() {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar terlebih dahulu')),
      );
      return;
    }
    setState(() {
      _moments.insert(0, {
        'user': 'Saya',
        'avatar': 'https://i.pravatar.cc/150?img=68',
        'imagePath': _pickedImage!.path,
        'imageBytes': _webImage,
        'caption': _captionController.text.isEmpty
            ? 'Moment saya di konser!'
            : _captionController.text,
        'likes': 0,
        'event': _selectedEvent ?? 'Event',
      });
      // Notify parent about the update
      widget.onMomentsUpdated?.call(List.from(_moments));
      _pickedImage = null;
      _webImage = null;
      _captionController.clear();
      _selectedEvent = null;
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Moment berhasil dibagikan! 🎉')),
    );
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bagikan Momen'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _pickedImage == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Pilih Gambar', style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: kIsWeb
                              ? (_webImage != null
                                  ? Image.memory(_webImage!, fit: BoxFit.cover)
                                  : const SizedBox())
                              : Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedEvent,
                decoration: InputDecoration(
                  labelText: 'Pilih Event',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.event),
                ),
                items: _events.map((event) {
                  return DropdownMenuItem(
                    value: event,
                    child: Text(event),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEvent = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _captionController,
                decoration: InputDecoration(
                  labelText: 'Caption',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _pickedImage = null;
                _webImage = null;
                _captionController.clear();
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: _uploadMoment,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text('Upload', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _moments.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Belum ada momen. Mulai bagikan momen Anda!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: _moments.length,
                itemBuilder: (context, index) {
                  final moment = _moments[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(moment['avatar'] as String),
                          ),
                          title: Text(
                            moment['user'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text('Baru saja'),
                        ),
                        // Display uploaded image or network image
                        moment['imageBytes'] != null
                            ? Image.memory(
                                moment['imageBytes'] as Uint8List,
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.cover,
                              )
                            : moment['imagePath'] != null && !kIsWeb
                                ? Image.file(
                                    File(moment['imagePath'] as String),
                                    width: double.infinity,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: moment['image'] as String,
                                    width: double.infinity,
                                    height: 300,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => Container(
                                      height: 300,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.error, size: 48),
                                    ),
                                  ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border),
                                    onPressed: () {},
                                  ),
                                  Text('${moment['likes']} suka'),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    icon: const Icon(Icons.chat_bubble_outline),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                moment['caption'] as String,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: _showUploadDialog,
            backgroundColor: Colors.indigo,
            icon: const Icon(Icons.add_a_photo, color: Colors.white),
            label: const Text('Upload', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
