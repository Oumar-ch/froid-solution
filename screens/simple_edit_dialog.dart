import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/client.dart';
import '../services/client_service.dart';

class SimpleEditDialog extends StatefulWidget {
  final Client client;
  const SimpleEditDialog({super.key, required this.client});

  @override
  State<SimpleEditDialog> createState() => _SimpleEditDialogState();
}

class _SimpleEditDialogState extends State<SimpleEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  late TextEditingController _contratTypeController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _contactController = TextEditingController(text: widget.client.contact);
    _addressController = TextEditingController(text: widget.client.address);
    _contratTypeController =
        TextEditingController(text: widget.client.contratType);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _contratTypeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      _showError('Le nom du client est obligatoire');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updatedClient = Client(
        id: widget.client.id,
        name: _nameController.text.trim(),
        contact: _contactController.text.trim(),
        address: _addressController.text.trim(),
        contratType: _contratTypeController.text.trim(),
      );

      await ClientService().updateClient(updatedClient);

      // Fermeture avec microtask pour éviter VSync
      if (mounted) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showError('Erreur lors de la sauvegarde: $e');
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier Client'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              enabled: !_isSaving,
              decoration: const InputDecoration(
                labelText: 'Nom du client *',
                border: OutlineInputBorder(),
                hintText: 'Nom obligatoire',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contactController,
              enabled: !_isSaving,
              decoration: const InputDecoration(
                labelText: 'Contact',
                border: OutlineInputBorder(),
                hintText: 'Téléphone, email...',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              enabled: !_isSaving,
              decoration: const InputDecoration(
                labelText: 'Adresse',
                border: OutlineInputBorder(),
                hintText: 'Adresse complète',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contratTypeController,
              enabled: !_isSaving,
              decoration: const InputDecoration(
                labelText: 'Type de contrat',
                border: OutlineInputBorder(),
                hintText: 'Maintenance, dépannage...',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
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
