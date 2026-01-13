import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  final VoidCallback onBack;

  const SecurityPage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Keamanan & Privasi'),
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_user, color: Colors.green.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Akun Anda Aman',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dilindungi dengan enkripsi end-to-end',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Keamanan Akun',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSecurityCard([
            _buildSecurityTile(
              Icons.lock_outline,
              'Ubah Password',
              'Terakhir diubah 30 hari lalu',
              () {
                _showChangePasswordDialog(context);
              },
            ),
            _buildSecurityTile(
              Icons.phonelink_lock,
              'Verifikasi Dua Langkah',
              'Tambahan keamanan untuk akun',
              () {
                _showInfoDialog(
                  context,
                  'Verifikasi Dua Langkah',
                  'Fitur ini akan segera tersedia untuk meningkatkan keamanan akun Anda.',
                );
              },
            ),
            _buildSecurityTile(
              Icons.devices,
              'Perangkat Terhubung',
              'Kelola perangkat yang terhubung',
              () {
                _showDevicesDialog(context);
              },
            ),
          ]),
          const SizedBox(height: 24),
          const Text(
            'Privasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSecurityCard([
            _buildSecurityTile(
              Icons.visibility_off_outlined,
              'Privasi Profil',
              'Atur siapa yang bisa melihat profil',
              () {
                _showInfoDialog(
                  context,
                  'Privasi Profil',
                  'Saat ini profil Anda terlihat oleh semua pengguna Tcon.',
                );
              },
            ),
            _buildSecurityTile(
              Icons.history,
              'Riwayat Aktivitas',
              'Lihat aktivitas akun Anda',
              () {
                _showActivityDialog(context);
              },
            ),
            _buildSecurityTile(
              Icons.delete_outline,
              'Hapus Data',
              'Hapus riwayat dan data pribadi',
              () {
                _showDeleteDataDialog(context);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSecurityCard(List<Widget> children) {
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

  Widget _buildSecurityTile(
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

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Ubah Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Lama',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(c).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password berhasil diubah!')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDevicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Perangkat Terhubung'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.computer, color: Colors.indigo),
              title: const Text('Windows PC'),
              subtitle: const Text('Aktif sekarang'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone_android, color: Colors.grey),
              title: const Text('Android Phone'),
              subtitle: const Text('Terakhir aktif 2 hari lalu'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showActivityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Riwayat Aktivitas'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildActivityItem('Login ke aplikasi', '5 Jan 2026, 10:30'),
              _buildActivityItem('Membeli tiket konser', '3 Jan 2026, 15:20'),
              _buildActivityItem('Mengubah profil', '1 Jan 2026, 09:15'),
              _buildActivityItem('Login ke aplikasi', '30 Des 2025, 18:45'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String action, String time) {
    return ListTile(
      leading: const Icon(Icons.history, size: 20),
      title: Text(action, style: const TextStyle(fontSize: 14)),
      subtitle: Text(time, style: const TextStyle(fontSize: 12)),
      dense: true,
    );
  }

  void _showDeleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus semua data dan riwayat? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(c).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data berhasil dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(message),
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
