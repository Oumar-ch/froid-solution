// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/client.dart';
import '../themes/app_colors.dart';
import 'test_crash_dialog.dart';
import 'no_close_edit_dialog.dart';
import 'simple_edit_dialog.dart';
import 'minimal_test_dialog.dart';

class CrashTestScreen extends StatelessWidget {
  final Client testClient;

  const CrashTestScreen({super.key, required this.testClient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🧪 TESTS DE CRASH - DIAGNOSTICS',
            style: AppTextStyles.title(
                Theme.of(context).brightness == Brightness.dark)),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Client de test: ${testClient.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            const Text(
              'Sélectionnez un test à effectuer:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Test 0: Dialog minimal (fermeture simple)
            ElevatedButton.icon(
              onPressed: () async {
                print('🧪 LANCEMENT TEST 0 - Dialog minimal fermeture');
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const MinimalTestDialog(),
                );
              },
              icon: const Icon(Icons.close),
              label: const Text('TEST 0: Dialog minimal fermeture'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),

            // Test 1: Dialog complètement isolé (pas de base de données)
            ElevatedButton.icon(
              onPressed: () async {
                print('🧪 LANCEMENT TEST 1 - Dialog isolé');
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => TestCrashDialog(client: testClient),
                );
              },
              icon: const Icon(Icons.science),
              label: const Text('TEST 1: Dialog isolé (pas de DB)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),

            // Test 2: Dialog sans fermeture automatique
            ElevatedButton.icon(
              onPressed: () async {
                print('🧪 LANCEMENT TEST 2 - NoCloseEditDialog');
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => NoCloseEditDialog(client: testClient),
                );
              },
              icon: const Icon(Icons.edit_off),
              label: const Text('TEST 2: Édition sans fermeture auto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),

            // Test 3: Dialog avec fermeture automatique (celui qui crash)
            ElevatedButton.icon(
              onPressed: () async {
                print('🧪 LANCEMENT TEST 3 - SimpleEditDialog (CRASH ATTENDU)');
                try {
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => SimpleEditDialog(client: testClient),
                  );
                  print('🧪 TEST 3 - Aucun crash détecté !');
                } catch (e) {
                  print('🚨 TEST 3 - CRASH CONFIRMÉ: $e');
                }
              },
              icon: const Icon(Icons.warning),
              label: const Text('TEST 3: Édition avec fermeture auto (CRASH)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),

            const Divider(),
            const SizedBox(height: 16),

            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Commencer par TEST 1 (isolé) pour voir si le problème vient du dialog lui-même\n'
              '2. Puis TEST 2 (sans fermeture) pour voir si le problème vient de la base de données\n'
              '3. Enfin TEST 3 (avec fermeture) pour confirmer que c\'est la fermeture qui cause le crash',
            ),
          ],
        ),
      ),
    );
  }
}
