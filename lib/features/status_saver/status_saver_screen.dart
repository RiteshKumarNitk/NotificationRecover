import 'dart:io';
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
                  const Text("Storage permission needed to load statuses."),
                  ElevatedButton(
                    onPressed: () => provider.getStatuses(),
                    child: const Text("Grant Permission"),
                  ),
                ],
              ),
            );
          }

          if (provider.statuses.isEmpty) {
            return const Center(
              child: Text("No statuses found."),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: provider.statuses.length,
            itemBuilder: (context, index) {
              final File file = provider.statuses[index];
              final isVideo = file.path.endsWith('.mp4');

              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black,
                    child: isVideo
                        ? const Center(
                            child: Icon(Icons.play_circle,
                                color: Colors.white, size: 48),
                          )
                        : Image.file(
                            file,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.white),
                            ),
                          ),
                  ),

                  /// SHARE BUTTON
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () async {
                        try {
                          await Share.shareXFiles([XFile(file.path)]);
                        } catch (e) {
                          debugPrint("Share error: $e");
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}