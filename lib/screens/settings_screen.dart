import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildSectionHeader("ACCOUNT & SYNC"),
          _buildSettingsTile(icon: Icons.person_outline, title: "User Profile", subtitle: "Logistics Officer"),
          _buildSettingsTile(icon: Icons.cloud_sync_outlined, title: "Offline Sync", subtitle: "Last synced: 2 hours ago", trailing: const Icon(Icons.sync, color: Colors.blue)),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader("PREFERENCES"),
          _buildSettingsTile(icon: Icons.language, title: "Language", subtitle: "English (UK)"),
          _buildSettingsTile(icon: Icons.dark_mode_outlined, title: "Dark Mode", trailing: Switch(value: false, onChanged: (val) {})),
          _buildSettingsTile(icon: Icons.notifications_outlined, title: "Notifications", trailing: Switch(value: true, activeThumbColor: const Color(0xFF005DA8), onChanged: (val) {})),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader("ABOUT"),
          _buildSettingsTile(icon: Icons.menu_book, title: "WHO Guidelines"),
          _buildSettingsTile(icon: Icons.privacy_tip_outlined, title: "Privacy Policy"),
          _buildSettingsTile(icon: Icons.info_outline, title: "App Version", subtitle: "1.0.0-beta", isLink: false),
          
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 8, top: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon, required String title, 
    String? subtitle, Widget? trailing, bool isLink = true
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF005DA8).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: const Color(0xFF005DA8), size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)) : null,
        trailing: trailing ?? (isLink ? Icon(Icons.chevron_right, color: Colors.grey.shade400) : null),
        onTap: isLink ? () {} : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}