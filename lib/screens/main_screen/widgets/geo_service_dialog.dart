import 'package:flutter/material.dart';

class GeoServiceDialog extends StatelessWidget {
  const GeoServiceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Geolocation service is disabled\nPlease enable it',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
