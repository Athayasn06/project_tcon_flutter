import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'screens/auth_view.dart';
import 'screens/home_view.dart';
import 'screens/concert_detail.dart';
import 'screens/artist_detail.dart';
import 'screens/payment_view.dart';
import 'screens/ticket_success.dart';
import 'screens/moment_view.dart';
import 'screens/profile_view.dart';
import 'screens/edit_profile_view.dart';
import 'screens/my_tickets_view.dart';
import 'screens/settings/account_info_page.dart';
import 'screens/settings/notifications_page.dart';
import 'screens/settings/security_page.dart';
import 'screens/settings/help_center_page.dart';
import 'models/mock_data.dart';
import 'widgets/concert_card.dart';
import 'package:project_tcon_flutter/services/auth_storage.dart';
import 'package:project_tcon_flutter/services/api_service.dart';
import 'package:project_tcon_flutter/models/user_model.dart';

class TconApp extends StatelessWidget {
  const TconApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tcon',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TconHome(),
    );
  }
}

class TconHome extends StatefulWidget {
  const TconHome({super.key});

  @override
  State<TconHome> createState() => _TconHomeState();
}

class _TconHomeState extends State<TconHome> {
  int currentIndex = 0;
  bool isLoggedIn = false;
  String subPage = 'main';
  Map<String, dynamic>? selectedItem;
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> gallery = [];
  String? showToast;
  String authMode = 'login';
  Map<String, dynamic>? selectedOrder;
  Map<String, dynamic>? alert;
  dynamic currentUser;

  // API Data
  List<Map<String, dynamic>> apiArtists = [];
  List<Map<String, dynamic>> apiConcerts = [];
  List<Map<String, dynamic>> apiOrders = [];
  List<Map<String, dynamic>> moments = [];
  bool isLoadingArtists = false;
  bool isLoadingConcerts = false;
  bool isLoadingOrders = false;

  Map<String, dynamic> userProfile = {
    'name': 'User Tcon',
    'email': 'user@example.com',
    'image': null,
  };

  Uint8List? profileImageBytes;
  String? profileImagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final user = null; // await AuthStorage.getUser();
    if (user != null) {
      setState(() {
        currentUser = user;
        isLoggedIn = true;
        userProfile = {'name': user.name, 'email': user.email};
      });
      // Fetch API data after login
      _fetchArtists();
      _fetchConcerts();
      _fetchOrders();
    }
  }

  Future<void> _fetchArtists() async {
    setState(() => isLoadingArtists = true);
    try {
      final artists =
          <Map<String, dynamic>>[]; // await ApiService.getArtists();
      print('✅ Fetched ${artists.length} artists from API');
      if (artists.isNotEmpty) {
        print('📝 First artist: ${artists[0]}');
      }
      setState(() {
        apiArtists = artists;
        isLoadingArtists = false;
      });
    } catch (e) {
      setState(() => isLoadingArtists = false);
      print('Error fetching artists: $e');
    }
  }

  Future<void> _fetchConcerts() async {
    setState(() => isLoadingConcerts = true);
    try {
      final concerts =
          <Map<String, dynamic>>[]; // await ApiService.getEvents();
      print('✅ Fetched ${concerts.length} concerts from API');
      if (concerts.isNotEmpty) {
        print('📝 First concert: ${concerts[0]}');
      }
      setState(() {
        apiConcerts = concerts;
        isLoadingConcerts = false;
      });
    } catch (e) {
      setState(() => isLoadingConcerts = false);
      print('Error fetching concerts: $e');
    }
  }

  Future<void> _fetchOrders() async {
    if (currentUser?.id == null) {
      print('⚠️ Cannot fetch orders: User ID is null');
      return;
    }

    print('📥 Fetching orders for user ID: ${currentUser!.id}');
    setState(() => isLoadingOrders = true);

    try {
      final orders =
          <
            Map<String, dynamic>
          >[]; // await ApiService.getMyOrders(currentUser!.id!);
      print('✅ Orders fetched successfully: ${orders.length} orders');

      setState(() {
        // Only update apiOrders if API returns data, otherwise keep local orders
        if (orders.isNotEmpty) {
          apiOrders = orders;
          print('📦 Updated apiOrders from API with ${orders.length} orders');
        } else {
          print(
            '⚠️ API returned empty orders, keeping local ${apiOrders.length} orders',
          );
        }
        isLoadingOrders = false;
      });
    } catch (e) {
      print('❌ Error fetching orders: $e');
      setState(() {
        isLoadingOrders = false;
        // Don't clear apiOrders if fetch fails - keep existing orders
        // apiOrders = []; // ❌ REMOVED: This was clearing local orders
      });
      print('⚠️ Keeping existing ${apiOrders.length} orders in local state');
      // Don't show error to user, just use existing list
      // Error 404 means route belum di-setup di Laravel
    }
  }

  void triggerToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> handleLogin() async {
    final user = null; // await AuthStorage.getUser();
    setState(() {
      currentUser = user;
      isLoggedIn = true;
      subPage = 'main';
      currentIndex = 0;
      if (user != null) {
        userProfile = {'name': user.name, 'email': user.email};
      }
    });
    // Fetch API data after login
    _fetchArtists();
    _fetchConcerts();
    _fetchOrders();
  }

  Future<void> handleRegister(String name, String email) async {
    final user = null; // await AuthStorage.getUser();
    setState(() {
      currentUser = user;
      isLoggedIn = true;
      subPage = 'main';
      currentIndex = 0;
      if (user != null) {
        userProfile = {'name': user.name, 'email': user.email};
      }
    });
  }

  Future<void> _handleLogout() async {
    try {
      // Panggil API logout jika ada token
      if (currentUser?.token != null && currentUser!.token!.isNotEmpty) {
        // await ApiService.logout(currentUser!.token!);
      }

      // Hapus data user dari local storage
      // await AuthStorage.clearUser();

      // Reset state
      setState(() {
        currentUser = null;
        isLoggedIn = false;
        userProfile = {'name': 'User Tcon', 'email': 'user@example.com'};
        currentIndex = 0;
        subPage = 'main';
      });

      triggerToast('Anda telah keluar dari aplikasi.');
    } catch (e) {
      // Tetap logout meskipun API gagal
      // await AuthStorage.clearUser();
      setState(() {
        currentUser = null;
        isLoggedIn = false;
        userProfile = {'name': 'User Tcon', 'email': 'user@example.com'};
        currentIndex = 0;
        subPage = 'main';
      });
      triggerToast('Logout berhasil (offline mode)');
    }
  }

  void navigateTo(String page, [Map<String, dynamic>? item]) {
    setState(() {
      subPage = page;
      selectedItem = item;
    });
    // scroll to top not needed in Flutter
  }

  void showSettingsPage(String page) {
    setState(() {
      subPage = page;
    });
  }

  void updateProfile(Map<String, dynamic> newData) {
    setState(() {
      userProfile = {...userProfile, ...newData};
      subPage = 'main';
    });
    triggerToast('Profil berhasil diperbarui!');
  }

  Future<void> updateProfileImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (file == null) return;

    Uint8List? bytes;
    try {
      bytes = await file.readAsBytes();
    } catch (_) {}

    setState(() {
      profileImageBytes = bytes;
      profileImagePath = file.path;
    });

    triggerToast('Foto profil berhasil diperbarui!');
  }

  Future<void> addMoment(Map<String, dynamic> newMoment) async {
    // Ensure we attach bytes for local files so MemoryImage can render reliably
    if (newMoment['imageBytes'] == null && newMoment['imageUrl'] != null) {
      if (!kIsWeb) {
        try {
          final f = File(newMoment['imageUrl'] as String);
          if (await f.exists()) {
            newMoment['imageBytes'] = await f.readAsBytes();
          }
        } catch (_) {
          // ignore read errors
        }
      }
    }

    setState(() {
      gallery.insert(0, newMoment);
      alert = {
        'title': 'Momen Berhasil Diunggah!',
        'message': 'Foto kamu kini tersedia di Live Gallery event ini.',
        'type': 'success',
      };
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(alert!['title']),
          content: Text(alert!['message']),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Oke, Mengerti'),
            ),
          ],
        ),
      );
    });
  }

  Future<void> pickImageAndAdd(String eventName, String caption) async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
    );
    if (file == null) return;
    Uint8List? bytes;
    try {
      bytes = await file.readAsBytes();
    } catch (_) {}
    final newMoment = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'imageUrl': file.path,
      'imageBytes': bytes,
      'caption': caption,
      'eventName': eventName,
    };
    addMoment(newMoment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !isLoggedIn
            ? AuthView(
                onLogin: handleLogin,
                onRegister: handleRegister,
                authMode: authMode,
                setAuthMode: (m) => setState(() => authMode = m),
              )
            : _buildMain(),
      ),
      bottomNavigationBar: isLoggedIn && subPage == 'main'
          ? _buildBottomNav()
          : null,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, 'Beranda', 0),
          _navItem(FontAwesomeIcons.ticket, 'Konser', 1),
          _navItem(Icons.mic, 'Artis', 2),
          _navItem(Icons.camera_alt_outlined, 'Moment', 3),
          _navItem(Icons.person, 'Akun', 4),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int idx) {
    final active = currentIndex == idx;
    final color = active ? Colors.indigo : Colors.grey;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = idx;
          subPage = 'main';
        });
        // Refresh orders when navigating to Profile tab (index 4)
        if (idx == 4) {
          print('🔄 Navigating to Profile tab, refreshing orders...');
          print('📊 Current apiOrders count: ${apiOrders.length}');
          _fetchOrders();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMain() {
    if (subPage != 'main') return _buildSubPage();

    // MomentView needs full screen (Stack with Positioned)
    if (currentIndex == 3) {
      return MomentView(
        moments: moments,
        onMomentsUpdated: (updatedMoments) {
          setState(() {
            moments = updatedMoments;
          });
        },
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (currentIndex == 0)
            HomeView(
              onViewConcerts: () => setState(() => currentIndex = 1),
              onArtistTap: (a) => navigateTo('artist_detail', a),
              onGoConcert: (c) => navigateTo('concert_detail', c),
            ),
          if (currentIndex == 1)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Daftar Konser',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (isLoadingConcerts)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (apiConcerts.isEmpty)
                    Column(
                      children: CONCERTS
                          .map(
                            (c) => ConcertCard(
                              concert: c as Map<String, dynamic>,
                              onTap: () => navigateTo('concert_detail', c),
                            ),
                          )
                          .toList(),
                    )
                  else
                    Column(
                      children: apiConcerts
                          .map(
                            (c) => ConcertCard(
                              concert: c,
                              onTap: () => navigateTo('concert_detail', c),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          if (currentIndex == 2)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Semua Artis',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (isLoadingArtists)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: (apiArtists.isEmpty ? ARTISTS : apiArtists).map(
                        (a) {
                          final artist = a;
                          return GestureDetector(
                            onTap: () => navigateTo('artist_detail', artist),
                            child: Container(
                              width:
                                  (MediaQuery.of(context).size.width - 64) / 2,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFF3F4F6),
                                ),
                              ),
                              child: Column(
                                children: [
                                  _buildArtistAvatar(artist),
                                  const SizedBox(height: 8),
                                  Text(
                                    artist['name'] as String? ?? 'Unknown',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    artist['genre'] as String? ?? '',
                                    style: const TextStyle(
                                      color: Colors.indigo,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                ],
              ),
            ),
          if (currentIndex == 4)
            ProfileView(
              userName: userProfile['name'] as String,
              userEmail: userProfile['email'] as String,
              profileImageBytes: profileImageBytes,
              profileImagePath: profileImagePath,
              onEditProfile: () => navigateTo('edit_profile'),
              onUpdateProfileImage: updateProfileImage,
              onGoSettings: () {},
              onSettingTap: (page) => showSettingsPage(page),
              onGoToTickets: () => navigateTo('my_tickets'),
              onLogout: _handleLogout,
              orders: () {
                print(
                  '🎨 Building ProfileView with ${apiOrders.length} orders from apiOrders',
                );
                return apiOrders;
              }(),
              isLoadingOrders: isLoadingOrders,
              onViewTicket: (order) {
                setState(() {
                  selectedOrder = order;
                  subPage = 'ticket_success';
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSubPage() {
    switch (subPage) {
      case 'artist_detail':
        return ArtistDetail(
          artist: selectedItem!,
          onBack: () => setState(() => subPage = 'main'),
          onConcertTap: (c) => navigateTo('concert_detail', c),
        );
      case 'concert_detail':
        return ConcertDetail(
          concert: selectedItem!,
          onBack: () => setState(() => subPage = 'main'),
          onGoPayment: () => navigateTo('payment', selectedItem),
          onGoToMoment: () => setState(() {
            subPage = 'main';
            currentIndex = 3;
          }),
          moments: moments,
        );
      case 'payment':
        return PaymentView(
          concert: selectedItem!,
          userId: currentUser?.id,
          onBack: () => setState(() => subPage = 'main'),
          onConfirmPayment: (orderData) async {
            print('🎉 Payment confirmed! Order data: $orderData');

            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );

            // Add order to local state immediately
            setState(() {
              apiOrders.insert(0, orderData);
              print(
                '✅ Order added to apiOrders. Total orders now: ${apiOrders.length}',
              );
              print('📦 apiOrders content: $apiOrders');
              selectedOrder = orderData; // Store the order for display
            });

            // Try to refresh orders from API
            if (currentUser != null) {
              try {
                await _fetchOrders();
                print('✅ Orders refreshed from API');
              } catch (e) {
                print(
                  '⚠️ Failed to fetch from API, using local order data: $e',
                );
              }
              await Future.delayed(const Duration(milliseconds: 300));
            }

            // Close loading dialog
            if (mounted) Navigator.of(context).pop();

            // Navigate to ticket success page with e-ticket
            setState(() {
              subPage = 'ticket_success';
            });
          },
        );
      case 'ticket_success':
        return TicketSuccess(
          order: selectedOrder ?? {},
          onBack: () => setState(() {
            subPage = 'main';
            currentIndex = 0;
          }),
          onViewAllTickets: () => setState(() => subPage = 'my_tickets'),
        );
      case 'edit_profile':
        return EditProfileView(
          userName: userProfile['name'] as String,
          userEmail: userProfile['email'] as String,
          onSave: (name, email) {
            setState(() {
              userProfile['name'] = name;
              userProfile['email'] = email;
              subPage = 'main';
            });
            triggerToast('Profil berhasil diperbarui!');
          },
          onBack: () => setState(() => subPage = 'main'),
        );
      case 'notifications':
        return NotificationsPage(
          onBack: () => setState(() => subPage = 'main'),
        );
      case 'security':
        return SecurityPage(onBack: () => setState(() => subPage = 'main'));
      case 'help':
        return HelpCenterPage(onBack: () => setState(() => subPage = 'main'));
      case 'account_info':
        return AccountInfoPage(
          userProfile: userProfile,
          onBack: () => setState(() => subPage = 'main'),
        );
      case 'my_tickets':
        return MyTicketsView(
          onBack: () => setState(() => subPage = 'main'),
          orders: apiOrders,
          isLoading: isLoadingOrders,
          onViewTicket: (order) {
            setState(() {
              selectedOrder = order;
              subPage = 'ticket_success';
            });
          },
        );
      default:
        return Container();
    }
  }

  Widget _buildArtistAvatar(Map<String, dynamic> artist) {
    // Try multiple possible image field names from Laravel
    String imageUrl =
        artist['image'] as String? ??
        artist['image_path'] as String? ??
        artist['photo'] as String? ??
        artist['avatar'] as String? ??
        artist['picture'] as String? ??
        '';

    // Add base URL if image path exists
    if (imageUrl.isNotEmpty) {
      imageUrl = 'http://192.168.1.110:8000/storage/$imageUrl';
    }

    // If no image, generate avatar from name
    if (imageUrl.isEmpty) {
      final name = artist['name'] as String? ?? 'Artist';
      final encodedName = Uri.encodeComponent(name);
      // Use UI Avatars service to generate colored avatar with initials
      imageUrl =
          'https://ui-avatars.com/api/?name=$encodedName&size=200&background=6366f1&color=fff&bold=true';
    }

    return CircleAvatar(
      radius: 34,
      backgroundColor: Colors.grey.shade300,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 68,
          height: 68,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: 68,
            height: 68,
            color: Colors.indigo.shade100,
            child: const Icon(Icons.person, size: 40, color: Colors.indigo),
          ),
        ),
      ),
    );
  }
}
