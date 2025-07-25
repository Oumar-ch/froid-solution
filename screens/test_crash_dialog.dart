import 'package:flutter/material.dart';
import '../models/client.dart';
import '../constants/app_dimensions.dart';
import '../themes/app_colors.dart';

class TestCrashDialog extends StatefulWidget {
  final Client client;
  const TestCrashDialog({super.key, required this.client});

  @override
  State<TestCrashDialog> createState() => _TestCrashDialogState();
}

class _TestCrashDialogState extends State<TestCrashDialog> {
  late TextEditingController _nameController;
  bool _isSaving = false;
  String _status = 'Prêt';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _testSave() async {
    print('🧪 TestCrashDialog - DÉBUT TEST SAUVEGARDE');

    setState(() {
      _isSaving = true;
      _status = 'Simulation sauvegarde...';
    });

    try {
      // SIMULATION D'UNE SAUVEGARDE SANS BASE DE DONNÉES
      print('🧪 TestCrashDialog - Simulation attente 1 seconde');
      await Future.delayed(const Duration(milliseconds: 1000));

      setState(() {
        _status = 'Sauvegarde simulée avec succès !';
        _isSaving = false;
      });

      print('🧪 TestCrashDialog - SUCCÈS - Pas de crash jusqu\'ici');

      // Test fermeture automatique après délai
      print('🧪 TestCrashDialog - Test fermeture automatique dans 2 secondes');
      await Future.delayed(const Duration(milliseconds: 2000));

      if (mounted) {
        print('🧪 TestCrashDialog - FERMETURE DIALOG MAINTENANT');
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _status = 'Erreur lors de la simulation: $e';
        _isSaving = false;
      });
      print('🧪 TestCrashDialog - ERREUR: $e');
    }
  }

  void _testManualClose() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🧪 TEST CRASH - Dialog Isolé'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Test pour isoler la cause du crash VSync'),
          SizedBox(height: AppDimensions.paddingSmall),
          Text('Client:  24{widget.client.name}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: AppDimensions.paddingMedium),
          TextField(
            controller: _nameController,
            enabled: !_isSaving,
            decoration: const InputDecoration(
              labelText: 'Nom du client (test)',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          if (_isSaving) const LinearProgressIndicator(),
          if (!_isSaving)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _testSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  child: const Text('Tester Sauvegarde'),
                ),
                ElevatedButton(
                  onPressed: _testManualClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                  ),
                  child: const Text('Fermer'),
                ),
              ],
            ),
          SizedBox(height: AppDimensions.paddingMedium),
          Text(
            _status,
            style: TextStyle(
              color: _status.contains('succès')
                  ? AppColors.success
                  : _status.contains('Erreur')
                      ? AppColors.error
                      : AppColors.lightAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
