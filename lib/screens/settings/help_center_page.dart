import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  final VoidCallback onBack;

  const HelpCenterPage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade400, Colors.indigo.shade600],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.support_agent, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Ada yang bisa kami bantu?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tim support kami siap membantu Anda 24/7',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menghubungkan ke customer support...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Chat dengan CS'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Topik Populer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildHelpCard([
            _buildHelpTile(
              Icons.confirmation_num_outlined,
              'Cara Membeli Tiket',
              'Panduan lengkap pembelian tiket konser',
              () => _showHelpDetail(
                context,
                'Cara Membeli Tiket',
                '1. Pilih konser yang ingin Anda tonton\n'
                    '2. Klik tombol "Pesan Sekarang"\n'
                    '3. Pilih jumlah tiket yang diinginkan\n'
                    '4. Pilih metode pembayaran (QRIS atau Transfer)\n'
                    '5. Lakukan pembayaran sesuai instruksi\n'
                    '6. Konfirmasi pembayaran\n'
                    '7. Tiket akan tersimpan di Profil > Tiket Saya',
              ),
            ),
            _buildHelpTile(
              Icons.payment,
              'Metode Pembayaran',
              'Informasi pembayaran yang tersedia',
              () => _showHelpDetail(
                context,
                'Metode Pembayaran',
                'Tcon menerima pembayaran melalui:\n\n'
                    '• QRIS - Scan QR code dengan aplikasi e-wallet\n'
                    '• Transfer Bank - Transfer ke rekening BNI Tcon Events\n\n'
                    'Semua transaksi aman dan terenkripsi.',
              ),
            ),
            _buildHelpTile(
              Icons.refresh,
              'Kebijakan Refund',
              'Syarat dan ketentuan pengembalian dana',
              () => _showHelpDetail(
                context,
                'Kebijakan Refund',
                'Pengembalian dana dapat dilakukan jika:\n\n'
                    '• Konser dibatalkan oleh penyelenggara\n'
                    '• Pengajuan refund maksimal 7 hari sebelum event\n'
                    '• Tiket belum digunakan untuk check-in\n\n'
                    'Proses refund memakan waktu 5-7 hari kerja.',
              ),
            ),
            _buildHelpTile(
              Icons.qr_code_scanner,
              'Cara Menggunakan Tiket',
              'Panduan check-in di lokasi event',
              () => _showHelpDetail(
                context,
                'Cara Menggunakan Tiket',
                '1. Buka aplikasi Tcon\n'
                    '2. Masuk ke Profil > Tiket Saya\n'
                    '3. Pilih tiket yang akan digunakan\n'
                    '4. Tunjukkan QR code ke petugas di pintu masuk\n'
                    '5. Tunggu validasi dari petugas\n'
                    '6. Selamat menikmati konser!',
              ),
            ),
          ]),
          const SizedBox(height: 24),
          const Text(
            'Hubungi Kami',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildHelpCard([
            _buildContactTile(
              Icons.email_outlined,
              'Email',
              'support@tcon.id',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka email client...')),
                );
              },
            ),
            _buildContactTile(
              Icons.phone_outlined,
              'Telepon',
              '021-1234-5678',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Memanggil nomor telepon...')),
                );
              },
            ),
            _buildContactTile(
              Icons.chat_outlined,
              'WhatsApp',
              '+62 812-3456-7890',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka WhatsApp...')),
                );
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildHelpCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children
            .asMap()
            .entries
            .map(
              (entry) => Column(
                children: [
                  if (entry.key > 0) const Divider(height: 1),
                  entry.value,
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildHelpTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.indigo, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
    );
  }

  Widget _buildContactTile(
    IconData icon,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.green, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 13, color: Colors.indigo),
      ),
      trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
    );
  }

  void _showHelpDetail(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}
