// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/client.dart';
import '../services/client_service.dart';
import '../themes/app_colors.dart';
import '../models/contrat_types.dart';
import '../utils/responsive.dart';

class EditClientDialog extends StatefulWidget {
  final Client client;
  const EditClientDialog({super.key, required this.client});

  @override
  State<EditClientDialog> createState() => _EditClientDialogState();
}

class _EditClientDialogState extends State<EditClientDialog> {
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  String? _selectedContratType;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _contactController = TextEditingController(text: widget.client.contact);
    _addressController = TextEditingController(text: widget.client.address);
    _selectedContratType =
        widget.client.contratType.isNotEmpty ? widget.client.contratType : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveAndClose() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      // Validation avant sauvegarde
      if (_nameController.text.trim().isEmpty) {
        throw Exception('Le nom du client est obligatoire');
      }

      final updatedClient = Client(
        id: widget.client.id,
        name: _nameController.text.trim(),
        contact: _contactController.text.trim(),
        address: _addressController.text.trim(),
        contratType: _selectedContratType ?? '',
      );

      // Sauvegarde avec timeout pour éviter les blocages
      await ClientService().updateClient(updatedClient).timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw Exception('Timeout: La sauvegarde a pris trop de temps'),
          );

      // Délai pour éviter les problèmes de synchronisation
      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
        // Fermeture différée pour éviter les conflits
        Future.microtask(() {
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        });
      }
    } catch (e) {
      print('🚨 Erreur dans _saveAndClose: $e');
      if (mounted) {
        String errorMessage = 'Erreur: $e';
        if (e.toString().contains('Timeout')) {
          errorMessage =
              'La sauvegarde prend trop de temps. Vérifiez votre connexion.';
        } else if (e.toString().contains('nom du client')) {
          errorMessage = 'Le nom du client est obligatoire.';
        } else if (e.toString().contains('database')) {
          errorMessage =
              'Erreur de base de données. Redémarrez l\'application.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = AppColors.getNeonColor(isDark);
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: GlassmorphicContainer(
        borderRadius: 16,
        blur: 16,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.18),
            Colors.white.withOpacity(0.09),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.38),
            Colors.white.withOpacity(0.13),
          ],
        ),
        width: MediaQuery.of(context).size.width *
            (Responsive.isMobile(context) ? 0.98 : 0.45),
        height: MediaQuery.of(context).size.height *
            (Responsive.isMobile(context) ? 0.80 : 0.60),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Modifier le client', style: AppTextStyles.title(isDark)),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: AppInputDecorations.neonField('Nom', isDark),
                style: AppTextStyles.body(isDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contactController,
                decoration: AppInputDecorations.neonField('Contact', isDark),
                style: AppTextStyles.body(isDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: AppInputDecorations.neonField('Adresse', isDark),
                style: AppTextStyles.body(isDark),
              ),
              const SizedBox(height: 8),
              // Dropdown pour le type de contrat (utilise uniquement le modèle)
              DropdownButtonFormField<String>(
                value: kContratTypes.contains(_selectedContratType)
                    ? _selectedContratType
                    : null,
                items: kContratTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type,
                              style: TextStyle(
                                  color: AppColors.getNeonColor(isDark),
                                  fontFamily: 'Orbitron')),
                        ))
                    .toList(),
                dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                style: TextStyle(
                    color: AppColors.getNeonColor(isDark),
                    fontFamily: 'Orbitron'),
                icon: Icon(Icons.arrow_drop_down,
                    color: AppColors.getNeonColor(isDark)),
                decoration:
                    AppInputDecorations.dropdown('Type de contrat', isDark),
                onChanged: (val) {
                  setState(() => _selectedContratType = val);
                },
                validator: (_) => null,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Annuler', style: AppTextStyles.body(isDark)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neon,
                      foregroundColor:
                          isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    onPressed: _saveAndClose,
                    child:
                        Text('Enregistrer', style: AppTextStyles.body(isDark)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
