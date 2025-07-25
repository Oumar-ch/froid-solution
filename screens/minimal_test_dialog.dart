// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class MinimalTestDialog extends StatelessWidget {
  const MinimalTestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🧪 Test Minimal'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Test de fermeture immédiate'),
          SizedBox(height: 16),
          Text('Ce dialogue va se fermer automatiquement dans 2 secondes'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Fermer manuellement'),
        ),
        ElevatedButton(
          onPressed: () async {
            print('🧪 MinimalTestDialog - TEST FERMETURE IMMÉDIATE');

            // Attente courte puis fermeture
            await Future.delayed(const Duration(milliseconds: 100));

            print('🧪 MinimalTestDialog - FERMETURE MAINTENANT');

            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('TEST FERMETURE'),
        ),
      ],
    );
  }
}
