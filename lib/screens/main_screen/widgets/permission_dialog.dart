import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({super.key, required this.deteriminePosition});
  final VoidCallback deteriminePosition;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("App doesn't have geolocation permission"),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      await Geolocator.openAppSettings();
                      deteriminePosition.call();
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Go to app settings'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
