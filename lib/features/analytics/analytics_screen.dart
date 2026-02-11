import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    final provider = context.watch<NotificationProvider>();
    final notifications = provider.notifications;
    
    if (notifications.isEmpty) {
      return const Scaffold(body: Center(child: Text("Not enough data for analytics")));
    }

    // Messages per App
    int waCount = notifications.where((n) => n.package == 'com.whatsapp').length;
    int tgCount = notifications.where((n) => n.package == 'org.telegram.messenger').length;
    int igCount = notifications.where((n) => n.package == 'com.instagram.android').length;
    int otherCount = notifications.length - waCount - tgCount - igCount;

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Messages Distribution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    if (waCount > 0)
                      PieChartSectionData(
                        value: waCount.toDouble(),
                        title: "WA",
                        color: Colors.green,
                        radius: 50,
                      ),
                    if (tgCount > 0)
                      PieChartSectionData(
                        value: tgCount.toDouble(),
                        title: "TG",
                        color: Colors.blue,
                        radius: 50,
                      ),
                    if (igCount > 0)
                      PieChartSectionData(
                        value: igCount.toDouble(),
                        title: "IG",
                        color: Colors.purple,
                        radius: 50,
                      ),
                    if (otherCount > 0)
                       PieChartSectionData(
                        value: otherCount.toDouble(),
                        title: "Other",
                        color: Colors.grey,
                        radius: 50,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text("Statistics", style: TextStyle(fontWeight: FontWeight.bold)),
                    const Divider(),
                    _StatRow("Total Messages", notifications.length.toString()),
                    _StatRow("WhatsApp", waCount.toString()),
                    _StatRow("Telegram", tgCount.toString()),
                    _StatRow("Instagram", igCount.toString()),
                    _StatRow("Deleted Messages", notifications.where((n) => n.isDeleted).length.toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
