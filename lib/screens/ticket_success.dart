import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/mock_data.dart';

class TicketSuccess extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onBack;
  final VoidCallback onViewAllTickets;

  const TicketSuccess({
    super.key,
    required this.order,
    required this.onBack,
    required this.onViewAllTickets,
  });

  @override
  Widget build(BuildContext context) {
    // Parse order data
    final event = order['event'] as Map<String, dynamic>?;
    final eventName = event?['nama_event'] as String? ?? 
                     event?['title'] as String? ?? 
                     order['event_name'] as String? ?? 'Event';
    final eventDate = event?['tanggal'] as String? ?? 
                     event?['date'] as String? ?? 
                     order['event_date'] as String? ?? '';
    final eventLocation = event?['lokasi'] as String? ?? 
                         event?['location'] as String? ?? 
                         order['event_location'] as String? ?? '';
    
    final orderCode = order['order_code'] as String? ?? 'TKT-000000';
    final ticketCategory = order['ticket_category'] as String? ?? 'General';
    
    // Parse quantity and total_amount
    final quantityRaw = order['quantity'];
    final quantity = quantityRaw is int ? quantityRaw : int.tryParse(quantityRaw.toString()) ?? 1;
    
    final totalRaw = order['total_amount'];
    final totalAmount = totalRaw is int ? totalRaw : int.tryParse(totalRaw.toString()) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Ticket', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: onBack,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 80,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pembayaran Berhasil!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tiket Anda telah diterbitkan',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),

            // E-Ticket Card
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade700, Colors.indigo.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ticketCategory,
                            style: TextStyle(
                              color: Colors.indigo.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // QR Code Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // QR Code
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: QrImageView(
                            data: orderCode,
                            version: QrVersions.auto,
                            size: 220,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          orderCode,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tunjukkan QR Code ini saat masuk',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 20),
                        
                        // Event Details
                        _buildDetailRow('Event', eventName, Icons.event),
                        const SizedBox(height: 16),
                        _buildDetailRow('Tanggal', eventDate, Icons.calendar_today),
                        const SizedBox(height: 16),
                        _buildDetailRow('Lokasi', eventLocation, Icons.location_on),
                        const SizedBox(height: 16),
                        _buildDetailRow('Kategori', ticketCategory, Icons.confirmation_num),
                        const SizedBox(height: 16),
                        _buildDetailRow('Jumlah Tiket', '$quantity tiket', Icons.people),
                        const SizedBox(height: 16),
                        _buildDetailRow('Total Bayar', formatRupiah(totalAmount), Icons.payments),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Buttons
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onViewAllTickets,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.confirmation_num, color: Colors.white),
                label: const Text(
                  'Lihat Semua Tiket',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.indigo,
                  side: const BorderSide(color: Colors.indigo, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.home),
                label: const Text(
                  'Kembali ke Beranda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.indigo,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

