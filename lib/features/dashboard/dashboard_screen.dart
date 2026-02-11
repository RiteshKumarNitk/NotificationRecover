import 'package:flutter/material.dart';
import '../../features/home/home_screen.dart';
import '../../features/settings/settings_screen.dart';
import 'package:local_auth/local_auth.dart';
import '../status_saver/status_saver_screen.dart';
import '../analytics/analytics_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("NotifyLog", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const SettingsScreen())
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Messages"),
              const SizedBox(height: 12),
              _buildGrid(context, [
                _DashboardItem(
                  icon: Icons.history, 
                  color: Colors.blue, 
                  label: "Logs", 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
                ),
                _DashboardItem(
                  icon: Icons.delete_sweep, 
                  color: Colors.red, 
                  label: "Deleted", 
                  onTap: () {
                     // Filter for deleted messages
                     // For now just open Home, ideally pass filter
                     Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                  },
                ),
              ]),
              
              const SizedBox(height: 24),
              _buildSectionTitle("Media Tools"),
              const SizedBox(height: 12),
              _buildGrid(context, [
                _DashboardItem(
                  icon: Icons.camera_alt, 
                  color: Colors.purple, 
                  label: "Status Saver", 
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const StatusSaverScreen()));
                  },
                ),
                _DashboardItem(
                  icon: Icons.photo_library, 
                  color: Colors.orange, 
                  label: "Saved Media", 
                  onTap: () {
                     // Re-use StatusSaver or separate gallery
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Use Status Saver to view")));
                  },
                ),
              ]),

              const SizedBox(height: 24),
              _buildSectionTitle("Insights"),
              const SizedBox(height: 12),
              _buildGrid(context, [
                _DashboardItem(
                  icon: Icons.bar_chart, 
                  color: Colors.teal, 
                  label: "Analytics", 
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.bold, 
        color: Colors.grey.shade600,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Widget> items) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: items,
    );
  }
}

class _DashboardItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _DashboardItem({
    required this.icon, 
    required this.color, 
    required this.label, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
