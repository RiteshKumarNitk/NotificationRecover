import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text("Clear History"),
            subtitle: const Text("Delete all saved notifications"),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Clear History?"),
                  content: const Text("This action cannot be undone."),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                    TextButton(
                      child: const Text("Clear", style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        context.read<NotificationProvider>().clearHistory();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("History cleared")),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_download, color: Colors.blue),
            title: const Text("Export to Text File"),
            subtitle: const Text("Save history as .txt"),
            onTap: () {
               context.read<NotificationProvider>().exportToFile(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.green),
            title: const Text("Privacy Policy"),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            subtitle: Text("Notification History & Message Viewer\nVersion 1.0.0"),
          ),
        ],
      ),
    );
  }
}
