import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/mock_data.dart';

class MyTicketsView extends StatelessWidget {
  final VoidCallback onBack;
  final List<Map<String, dynamic>> orders;
  final bool isLoading;
  final void Function(Map<String, dynamic>)? onViewTicket;

  const MyTicketsView({
    super.key,
    required this.onBack,
    this.orders = const [],
    this.isLoading = false,
    this.onViewTicket,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
              ),
              const Text(
                'Tiket Saya',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // E-Ticket List
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : orders.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada tiket',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final event = order['event'] as Map<String, dynamic>?;
                        
                        // Parse data dari API Laravel
                        final eventTitle = event?['nama_event'] as String? ?? 
                                          event?['title'] as String? ?? 'Event';
                        final eventDate = event?['tanggal'] as String? ?? 
                                         event?['date'] as String? ?? '-';
                        final eventLocation = event?['lokasi'] as String? ?? 
                                             event?['location'] as String? ?? '-';
                        
                        // Parse quantity dan total_amount
                        final quantityRaw = order['quantity'];
                        final quantity = quantityRaw is int ? quantityRaw : int.tryParse(quantityRaw.toString()) ?? 1;
                        
                        final totalRaw = order['total_amount'];
                        final totalAmount = totalRaw is int ? totalRaw : int.tryParse(totalRaw.toString()) ?? 0;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildTicketCard(
                            context,
                            title: eventTitle,
                            date: eventDate,
                            time: '19:00', // Default time karena API tidak return time
                            venue: eventLocation,
                            ticketType: order['ticket_category'] as String? ?? 'General',
                            price: formatRupiah(totalAmount),
                            seat: 'A-${index + 1}', // Generate seat number
                            qrData: order['order_code'] as String? ?? 'NO-CODE',
                            quantity: quantity,
                            orderCode: order['order_code'] as String? ?? 'NO-CODE',
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildTicketCard(
    BuildContext context, {
    required String title,
    required String date,
    required String time,
    required String venue,
    required String ticketType,
    required String price,
    required String seat,
    required String qrData,
    int quantity = 1,
    String? orderCode,
  }) {
    return GestureDetector(
      onTap: () {
        // If onViewTicket callback is provided, use it
        // Otherwise fallback to showing ticket detail dialog
        if (onViewTicket != null) {
          // Find the order from orders list by orderCode
          final order = orders.firstWhere(
            (o) => o['order_code'] == (orderCode ?? qrData),
            orElse: () => {},
          );
          if (order.isNotEmpty) {
            onViewTicket!(order);
          } else {
            _showTicketDetail(
              context,
              title: title,
              date: date,
              time: time,
              venue: venue,
              ticketType: ticketType,
              price: price,
              seat: seat,
              qrData: qrData,
              quantity: quantity,
              orderCode: orderCode ?? qrData,
            );
          }
        } else {
          _showTicketDetail(
            context,
            title: title,
            date: date,
            time: time,
            venue: venue,
            ticketType: ticketType,
            price: price,
            seat: seat,
            qrData: qrData,
            quantity: quantity,
            orderCode: orderCode ?? qrData,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade700, Colors.indigo.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ticketType,
                          style: TextStyle(
                            color: Colors.indigo.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.confirmation_num,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        date,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        venue,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kursi',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            seat,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Harga',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            price,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Tap untuk lihat e-ticket',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
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

  void _showTicketDetail(
    BuildContext context, {
    required String title,
    required String date,
    required String time,
    required String venue,
    required String ticketType,
    required String price,
    required String seat,
    required String qrData,
    int quantity = 1,
    String? orderCode,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade700, Colors.indigo.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.confirmation_num,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'E-TICKET',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                // QR Code
                Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                        ),
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 200,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        qrData,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                // Ticket Details
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      _buildDetailRow('Kode Order', orderCode ?? qrData),
                      _buildDetailRow('Tanggal', date),
                      _buildDetailRow('Waktu', time),
                      _buildDetailRow('Lokasi', venue),
                      _buildDetailRow('Tipe Tiket', ticketType),
                      _buildDetailRow('Jumlah', quantity.toString()),
                      _buildDetailRow('Kursi', seat),
                      _buildDetailRow('Harga Total', price),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Tutup',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
