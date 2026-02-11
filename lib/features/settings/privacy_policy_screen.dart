import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "1. Data Storage\n"
                "All notification data is stored LOCALLY on your device using an encrypted database (Hive). We do not have any servers, and we do not transmit your messages to any third party.\n\n"
                "2. Notification Access\n"
                "This app requires 'Notification Access' permission to function. This allows the app to read incoming notifications from selected apps (WhatsApp, Telegram, Instagram). We only save the text content and sender name.\n\n"
                "3. Deleted Messages\n"
                "The app detects deleted messages by comparing incoming notifications with saved ones. If a 'This message was deleted' notification arrives, the app matches it with the previous message from that sender.\n\n"
                "4. User Control\n"
                "You can clear all history at any time from the Settings menu. Uninstalling the app will also permanently remove all data.\n\n"
                "5. Compliance\n"
                "This app is not affiliated with WhatsApp, Telegram, or Instagram. It is a standalone utility tool.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
