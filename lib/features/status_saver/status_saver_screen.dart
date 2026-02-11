// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/status_provider.dart';
import 'package:share_plus/share_plus.dart';

class StatusSaverScreen extends StatefulWidget {
  const StatusSaverScreen({super.key});

  @override
  State<StatusSaverScreen> createState() => _StatusSaverScreenState();
}

class _StatusSaverScreenState extends State<StatusSaverScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatusProvider>().getStatuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Status Saver")),
      body: Consumer<StatusProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!provider.isPermissionGranted) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Storage permission needed to save statuses."),
                  ElevatedButton(
                    onPressed: () => provider.getStatuses(),
                    child: const Text("Grant Permission"),
                  ),
                ],
              ),
            );
          }

          if (provider.statuses.isEmpty) {
            return const Center(child: Text("No statuses found or access restricted."));
          }

          /*
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: provider.statuses.length,
            itemBuilder: (context, index) {
              final dynamic file = provider.statuses[index];
              final String path = file.path;
              final isVideo = path.endsWith('.mp4');
              return Stack(
                children: [
                   Container(
                     decoration: BoxDecoration(
                       color: Colors.black,
                       // image: isVideo ? null : DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover),
                     ),
                     child: isVideo ? const Center(child: Icon(Icons.play_circle, color: Colors.white, size: 48)) : null,
                   ),
                   Positioned(
                     bottom: 4,
                     right: 4,
                     child: IconButton(
                       icon: const Icon(Icons.share, color: Colors.white),
                       onPressed: () {
                         // Share.shareXFiles([XFile(path)]);
                       },
                     ),
                   ),
                ],
              );
            },
          );
          */
          return const Center(child: Text("Status Saver not supported on this platform."));
        },
      ),
    );
  }
}
