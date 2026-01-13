import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  // GANTI URL INI dengan URL Laravel backend Anda
  static const String baseUrl = 'http://192.168.1.110:8000/api';
  // Untuk Android Emulator gunakan: http://10.0.2.2:8000/api
  // Untuk device fisik gunakan: http://YOUR_IP:8000/api
  // Untuk Web/Chrome gunakan: http://YOUR_IP:8000/api
  
  // 💡 TIP: Untuk development yang lebih mudah:
  // - iOS Simulator: http://localhost:8000/api
  // - Android Emulator: http://10.0.2.2:8000/api  
  // - Physical Device: http://192.168.1.110:8000/api (IP komputer di jaringan yang sama)
  // - Web/Chrome: http://192.168.1.110:8000/api (IP komputer)

  static void _log(String message) {
    print('[🔌 API] $message');
  }

  /// Register user baru
  static Future<User> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final url = '$baseUrl/register';
      _log('📤 POST $url');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Connection timeout! Pastikan Laravel server running'),
      );

      _log('📥 Status: ${response.statusCode}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _log('📦 Response data: $data');
        
        // Handle different response structures
        // Format 1: {user: {...}, token: "..."}
        if (data['user'] != null && data['token'] != null) {
          return User(
            id: data['user']['id'],
            name: data['user']['name'],
            email: data['user']['email'],
            token: data['token'],
          );
        }
        // Format 2: {data: {...}, access_token: "..."}
        else if (data['data'] != null && data['access_token'] != null) {
          return User(
            id: data['data']['id'],
            name: data['data']['name'],
            email: data['data']['email'],
            token: data['access_token'],
          );
        }
        // Format 3: {token: "...", id: ..., name: "...", email: "..."}
        else if (data['token'] != null) {
          return User(
            id: data['id'],
            name: data['name'],
            email: data['email'],
            token: data['token'],
          );
        }
        // Format 4: {status: "success", data: {...}} - NO TOKEN (your current Laravel)
        else if (data['status'] == 'success' && data['data'] != null) {
          _log('⚠️ WARNING: Laravel tidak mengembalikan token! Registrasi akan berhasil tapi logout tidak akan bekerja.');
          return User(
            id: data['data']['id'],
            name: data['data']['name'],
            email: data['data']['email'],
            token: '', // Empty token - Laravel needs to be fixed to return token
          );
        }
        else {
          _log('❌ Unknown response structure: $data');
          throw Exception('Format response tidak dikenali. Cek Laravel API response format.');
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      _log('❌ Error: $e');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      if (e.toString().contains('SocketException') || 
          e.toString().contains('Failed host lookup')) {
        throw Exception('Tidak dapat terhubung ke server $baseUrl\nPastikan Laravel server running!');
      }
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Login user
  static Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = '$baseUrl/login';
      _log('📤 POST $url');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Connection timeout! Pastikan Laravel server running'),
      );

      _log('📥 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _log('📦 Response data: $data');
        
        // Handle different response structures
        // Format 1: {user: {...}, token: "..."}
        if (data['user'] != null && data['token'] != null) {
          return User(
            id: data['user']['id'],
            name: data['user']['name'],
            email: data['user']['email'],
            token: data['token'],
          );
        }
        // Format 2: {data: {...}, access_token: "..."}
        else if (data['data'] != null && data['access_token'] != null) {
          return User(
            id: data['data']['id'],
            name: data['data']['name'],
            email: data['data']['email'],
            token: data['access_token'],
          );
        }
        // Format 3: {token: "...", id: ..., name: "...", email: "..."}
        else if (data['token'] != null) {
          return User(
            id: data['id'],
            name: data['name'],
            email: data['email'],
            token: data['token'],
          );
        }
        // Format 4: {status: "success", data: {...}} - NO TOKEN (register)
        else if (data['status'] == 'success' && data['data'] != null) {
          _log('⚠️ WARNING: Laravel tidak mengembalikan token! Login akan berhasil tapi logout tidak akan bekerja.');
          return User(
            id: data['data']['id'],
            name: data['data']['name'],
            email: data['data']['email'],
            token: '', // Empty token - Laravel needs to be fixed
          );
        }
        // Format 5: {status: "success", user: {...}, token: "..."} - CORRECT FORMAT!
        else if (data['status'] == 'success' && data['user'] != null) {
          if (data['token'] != null && data['token'].toString().isNotEmpty) {
            _log('✅ Token received successfully!');
            return User(
              id: data['user']['id'],
              name: data['user']['name'],
              email: data['user']['email'],
              token: data['token'],
            );
          } else {
            _log('! WARNING: Laravel tidak mengembalikan token! Login akan berhasil tapi logout tidak akan bekerja.');
            _log('! SOLUSI: Lihat file PERBAIKAN_API_LENGKAP.md untuk fix Laravel backend');
            return User(
              id: data['user']['id'],
              name: data['user']['name'],
              email: data['user']['email'],
              token: '', // Empty token - Laravel needs to be fixed
            );
          }
        }
        else {
          _log('❌ Unknown response structure: $data');
          throw Exception('Format response tidak dikenali. Cek Laravel API response format.');
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Login gagal');
      }
    } catch (e) {
      _log('❌ Error: $e');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      if (e.toString().contains('SocketException') || 
          e.toString().contains('Failed host lookup')) {
        throw Exception('Tidak dapat terhubung ke server $baseUrl\nPastikan Laravel server running!');
      }
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Logout user (hapus token dari server)
  static Future<bool> logout(String token) async {
    try {
      _log('📤 POST $baseUrl/logout');
      
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      _log('📥 Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Logout gagal');
      }
    } catch (e) {
      _log('❌ Error: $e');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Get data profile user yang sedang login
  static Future<User> getUserProfile(String token) async {
    try {
      _log('📤 GET $baseUrl/user');
      
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      _log('📥 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          token: token,
        );
      } else {
        throw Exception('Gagal mengambil data user');
      }
    } catch (e) {
      _log('❌ Error: $e');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Get all artists
  static Future<List<Map<String, dynamic>>> getArtists() async {
    try {
      final url = '$baseUrl/artis';
      _log('📤 GET $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      _log('📥 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _log('📦 Artists data received');
        
        // Response format: {data: [...]}
        if (data['data'] != null && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        
        return [];
      } else {
        throw Exception('Gagal mengambil data artis');
      }
    } catch (e) {
      _log('❌ Error: $e');
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Get all events/concerts
  static Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      final url = '$baseUrl/events';
      _log('📤 GET $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      _log('📥 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _log('📦 Events data received');
        
        // Response format: {data: [...]}
        if (data['data'] != null && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        
        return [];
      } else {
        throw Exception('Gagal mengambil data events');
      }
    } catch (e) {
      _log('❌ Error: $e');
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Get user's orders
  static Future<List<Map<String, dynamic>>> getMyOrders(int userId) async {
    try {
      final url = '$baseUrl/my-orders/$userId';
      _log('📤 GET $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      _log('📥 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _log('📦 Orders data received');
        
        // Response format: {status: "success", data: [...]}
        if (data['data'] != null && data['data'] is List) {
          final orders = List<Map<String, dynamic>>.from(data['data']);
          _log('✅ Found ${orders.length} orders for user $userId');
          return orders;
        }
        
        _log('ℹ️ No orders found for user $userId');
        return [];
      } else if (response.statusCode == 404) {
        _log('⚠️ Orders endpoint not found (404)');
        _log('! SOLUSI: Tambahkan route di Laravel - lihat PERBAIKAN_API_LENGKAP.md');
        _log('! Route yang diperlukan: GET /api/my-orders/{user_id}');
        // Return empty list instead of throwing
        return [];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengambil data orders');
      }
    } catch (e) {
      _log('❌ Error: $e');
      if (e.toString().contains('404')) {
        _log('💡 TIP: Orders API belum tersedia. User bisa tetap menggunakan app.');
        return []; // Return empty list untuk graceful degradation
      }
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Create new order
  static Future<Map<String, dynamic>> createOrder({
    required int userId,
    required int eventId,
    required int quantity,
    required String ticketCategory,
    required int totalAmount,
    required String paymentMethod,
  }) async {
    try {
      final url = '$baseUrl/orders';
      _log('📤 POST $url');
      
      final requestBody = {
        'user_id': userId,
        'event_id': eventId,
        'quantity': quantity,
        'ticket_category': ticketCategory,
        'total_amount': totalAmount,
        'payment_method': paymentMethod,
      };
      
      _log('📦 Request: $requestBody');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      _log('📥 Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _log('✅ Order created successfully');
        _log('📦 Response: $data');
        
        // Response format: {status: "success", message: "...", data: {...}}
        if (data['data'] != null) {
          return Map<String, dynamic>.from(data['data']);
        }
        // Fallback if data is at root level
        else if (data['id'] != null) {
          return Map<String, dynamic>.from(data);
        }
        
        return data;
      } else if (response.statusCode == 404) {
        _log('⚠️ Orders endpoint not found (404)');
        _log('! SOLUSI: Tambahkan route POST /api/orders di Laravel');
        _log('! Lihat file PERBAIKAN_API_LENGKAP.md untuk setup lengkap');
        throw Exception('Orders API belum tersedia. Silakan setup Laravel backend terlebih dahulu.');
      } else {
        final errorData = jsonDecode(response.body);
        _log('❌ Error response: $errorData');
        throw Exception(errorData['message'] ?? 'Gagal membuat order');
      }
    } catch (e) {
      _log('❌ Error: $e');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      if (e.toString().contains('SocketException') || 
          e.toString().contains('Failed host lookup')) {
        throw Exception('Tidak dapat terhubung ke server. Pastikan Laravel server running di $baseUrl');
      }
      throw Exception('Error: ${e.toString()}');
    }
  }
}
