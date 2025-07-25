import 'package:flutter/material.dart';
import '../models/client.dart';
import '../services/client_service.dart';

class NoCloseEditDialog extends StatefulWidget {
  final Client client;
  const NoCloseEditDialog({super.key, required this.client});

  @override
  State<NoCloseEditDialog> createState() => _NoCloseEditDialogState();
}

class _NoCloseEditDialogState extends State<NoCloseEditDialog> {
  late TextEditingController _nameController;
  bool _isSaving = false;
  bool _saved = false;

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

  Future<void> _save() async {
    print('🔧 NoCloseEditDialog - Début sauvegarde');
    setState(() => _isSaving = true);

    try {
      final updatedClient = Client(
        id: widget.client.id,
        name: _nameController.text.trim(),
        contact: widget.client.contact,
        address: widget.client.address,
        contratType: widget.client.contratType,
      );

      print('🔧 NoCloseEditDialog - Avant ClientService.updateClient');
      await ClientService().updateClient(updatedClient);
      print('🔧 NoCloseEditDialog - Après ClientService.updateClient - SUCCÈS');

      // NE FERME PAS LE DIALOG - juste marque comme sauvé
      setState(() {
        _saved = true;
        _isSaving = false;
      });

      print('🔧 NoCloseEditDialog - Dialog reste ouvert, sauvegarde terminée');
    } catch (e) {
      print('🚨 NoCloseEditDialog - ERREUR: $e');
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('TEST - Dialog sans fermeture automatique'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Ce dialog ne se ferme pas automatiquement'),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            enabled: !_isSaving && !_saved,
            decoration: const InputDecoration(
              labelText: 'Nom du client',
              border: OutlineInputBorder(),
            ),
          ),
          if (_saved) ...[
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Sauvegardé avec succès !',
                    style: TextStyle(color: Colors.green)),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Fermer manuellement'),
        ),
        if (_saved)
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Fermer après succès'),
          )
        else
          ElevatedButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Sauvegarder'),
          ),
      ],
    );
  }
}
