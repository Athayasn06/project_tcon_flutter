import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../services/api_service.dart';

class PaymentView extends StatefulWidget {
  final Map<String, dynamic> concert;
  final VoidCallback onBack;
  final Function(Map<String, dynamic> order) onConfirmPayment;
  final int? userId;

  const PaymentView({
    super.key,
    required this.concert,
    required this.onBack,
    required this.onConfirmPayment,
    this.userId,
  });

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  bool _isLoading = false;
  String _selectedPayment = 'qris';
  int _quantity = 1;
  String _ticketCategory = 'VIP';

  Future<void> _handlePayment() async {
    if (widget.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User tidak ditemukan. Silakan login kembali.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Parse event ID - bisa String atau int dari API
      final eventIdRaw = widget.concert['id'];
      final eventId = eventIdRaw is int ? eventIdRaw : int.tryParse(eventIdRaw.toString()) ?? 0;
      
      if (eventId == 0) {
        throw Exception('Event ID tidak valid');
      }

      // Calculate total amount - handle String/int dari API
      final priceRaw = widget.concert['price'] ?? widget.concert['min_price'];
      final price = priceRaw is int ? priceRaw : int.tryParse(priceRaw.toString()) ?? 0;
      final tax = (price * 0.05).round();
      final totalAmount = (price * _quantity) + tax;

      // Map payment method
      final paymentMethod = _selectedPayment == 'qris' ? 'QRIS' : 'Transfer Bank';

      print('📝 Creating order with:');
      print('   User ID: ${widget.userId}');
      print('   Event ID: $eventId');
      print('   Quantity: $_quantity');
      print('   Category: $_ticketCategory');
      print('   Total: Rp $totalAmount');
      print('   Payment: $paymentMethod');

      final orderData = await ApiService.createOrder(
        userId: widget.userId!,
        eventId: eventId,
        quantity: _quantity,
        ticketCategory: _ticketCategory,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
      );

      if (!mounted) return;

      print('📦 Order data from API: $orderData');

      // Add concert details to order data for e-ticket display
      // Ensure event object exists with all required fields
      final completeOrderData = {
        ...orderData,
        'quantity': _quantity,
        'ticket_category': _ticketCategory,
        'total_amount': totalAmount,
        'payment_method': paymentMethod,
        'status': orderData['status'] ?? 'pending',
        'order_code': orderData['order_code'] ?? 'TKT-${DateTime.now().millisecondsSinceEpoch}',
        // Create complete event object
        'event': {
          'id': eventId,
          'nama_event': widget.concert['nama_event'] ?? widget.concert['name'] ?? widget.concert['title'] ?? 'Event',
          'title': widget.concert['title'] ?? widget.concert['nama_event'] ?? widget.concert['name'] ?? 'Event',
          'tanggal': widget.concert['tanggal'] ?? widget.concert['date'] ?? '',
          'date': widget.concert['date'] ?? widget.concert['tanggal'] ?? '',
          'lokasi': widget.concert['lokasi'] ?? widget.concert['location'] ?? '',
          'location': widget.concert['location'] ?? widget.concert['lokasi'] ?? '',
          'poster': widget.concert['poster'] ?? widget.concert['image'] ?? '',
          'min_price': price,
        },
      };

      print('📦 Complete order data: $completeOrderData');

      setState(() => _isLoading = false);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Order berhasil dibuat!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      widget.onConfirmPayment(completeOrderData);
      
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      print('❌ Payment error: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pembayaran gagal: ${e.toString().replaceAll('Exception: ', '').replaceAll('Error: ', '')}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'TUTUP',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.concert['name'] as String? ?? widget.concert['title'] as String? ?? widget.concert['nama_event'] as String? ?? '';
    
    // Parse price dengan aman - handle String atau int
    final priceRaw = widget.concert['price'] ?? widget.concert['min_price'];
    final price = priceRaw is int ? priceRaw : int.tryParse(priceRaw.toString()) ?? 0;
    final tax = (price * 0.05).round();
    final total = (price * _quantity) + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onBack,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Detail Pesanan
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Pesanan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(name, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      widget.concert['artist'] as String? ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Harga Tiket'),
                        Text(formatRupiah(price)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Biaya Layanan'),
                        Text(formatRupiah(tax)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatRupiah(total),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Metode Pembayaran
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Metode Pembayaran',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.qr_code, color: Colors.indigo),
                      title: const Text('QRIS'),
                      subtitle: const Text('Scan QR untuk membayar'),
                      trailing: Radio<String>(
                        value: 'qris',
                        groupValue: _selectedPayment,
                        onChanged: (val) => setState(() => _selectedPayment = val!),
                        activeColor: Colors.indigo,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.account_balance, color: Colors.indigo),
                      title: const Text('Transfer Bank'),
                      subtitle: const Text('BCA, Mandiri, BNI'),
                      trailing: Radio<String>(
                        value: 'transfer',
                        groupValue: _selectedPayment,
                        onChanged: (val) => setState(() => _selectedPayment = val!),
                        activeColor: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Konfirmasi Pembayaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
