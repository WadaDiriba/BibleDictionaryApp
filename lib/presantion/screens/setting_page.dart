import 'package:flutter/material.dart';
import 'package:bibledictionary/presantion/theme/theme_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: ThemeColors.royalBlueDark,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _buildSection("General"),

          _buildSwitchTile(
            "Dark Mode",
            "Enable dark theme",
            darkMode,
            (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),

          _buildSwitchTile(
            "Notifications",
            "Receive daily verses",
            notifications,
            (value) {
              setState(() {
                notifications = value;
              });
            },
          ),

          const SizedBox(height: 20),

          _buildSection("More"),

          _buildTile(
            Icons.language,
            "Language",
            "English",
            () {},
          ),

          _buildTile(
            Icons.lock,
            "Privacy Policy",
            "",
            () {},
          ),

          _buildTile(
            Icons.help,
            "Help & Support",
            "",
            () {},
          ),
        ],
      ),
    );
  }

  // 🔹 Section title
  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: ThemeColors.goldPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 🔹 Switch tile
  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Card(
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        activeColor: ThemeColors.goldPrimary,
        onChanged: onChanged,
      ),
    );
  }

  // 🔹 Normal tile
  Widget _buildTile(
    IconData icon,
    String title,
    String subtitle,
    Function() onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: ThemeColors.royalBlueDark),
        title: Text(title),
        subtitle: subtitle.isEmpty ? null : Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
