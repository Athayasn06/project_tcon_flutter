import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  final VoidCallback onBack;

  const NotificationsPage({super.key, required this.onBack});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool promotionNotifications = false;
  bool eventReminders = true;
  bool newArtistNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Kelola notifikasi untuk tetap update dengan konser favorit Anda',
                    style: TextStyle(fontSize: 13, color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Notifikasi Push',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildNotificationCard([
            _buildSwitchTile(
              'Notifikasi Push',
              'Terima notifikasi dari aplikasi',
              pushNotifications,
              (v) => setState(() => pushNotifications = v),
              Icons.notifications_active,
            ),
            _buildSwitchTile(
              'Pengingat Event',
              'Ingatkan saya sebelum konser dimulai',
              eventReminders,
              (v) => setState(() => eventReminders = v),
              Icons.alarm,
            ),
            _buildSwitchTile(
              'Artis Baru',
              'Notifikasi saat ada artis baru',
              newArtistNotifications,
              (v) => setState(() => newArtistNotifications = v),
              Icons.person_add,
            ),
          ]),
          const SizedBox(height: 24),
          const Text(
            'Notifikasi Email',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildNotificationCard([
            _buildSwitchTile(
              'Email Newsletter',
              'Terima newsletter mingguan',
              emailNotifications,
              (v) => setState(() => emailNotifications = v),
              Icons.email,
            ),
            _buildSwitchTile(
              'Promosi & Diskon',
              'Info promo dan penawaran khusus',
              promotionNotifications,
              (v) => setState(() => promotionNotifications = v),
              Icons.local_offer,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(List<Widget> children) {
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
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return ListTile(
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
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.indigo,
      ),
    );
  }
}
