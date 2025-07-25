// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';
import '../models/client.dart';

import '../services/database_service.dart';
import '../themes/app_colors.dart';
import '../utils/responsive.dart';

class EditInterventionDialog extends StatefulWidget {
  final Intervention intervention;
  final List<Client> clients;
  const EditInterventionDialog(
      {super.key, required this.intervention, required this.clients});

  @override
  State<EditInterventionDialog> createState() => _EditInterventionDialogState();
}

class _EditInterventionDialogState extends State<EditInterventionDialog> {
  InterventionType? _selectedType;
  late TextEditingController _descriptionController;
  DateTime? _installationDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // No clientName in Intervention model, fallback à premier client (désactivé, champ supprimé)
    _selectedType = widget.intervention.type;
    _descriptionController =
        TextEditingController(text: widget.intervention.description);
    _installationDate = widget.intervention.date;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveAndClose() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      debugPrint('[EditInterventionDialog] Début sauvegarde...');
      final intervention = Intervention(
        id: widget.intervention.id,
        date: _installationDate ?? DateTime.now(),
        type: _selectedType ?? InterventionType.autre,
        description: _descriptionController.text.trim(),
        status: widget.intervention.status,
        clientName: widget.intervention.clientName,
        installationDate: _installationDate ?? DateTime.now(),
      );
      debugPrint('[EditInterventionDialog] Intervention à sauvegarder: '
          'id=${intervention.id}, type=${_selectedType ?? ''}, '
          'description=${_descriptionController.text.trim()}, date=${_installationDate ?? DateTime.now()}');
      await DataService.updateIntervention(intervention).timeout(
        const Duration(seconds: 10),
        onTimeout: () =>
            throw Exception('Timeout: La sauvegarde a pris trop de temps'),
      );
      debugPrint('[EditInterventionDialog] Sauvegarde réussie.');
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        Future.microtask(() {
          if (mounted) {
            debugPrint(
                '[EditInterventionDialog] Fermeture du dialog après sauvegarde.');
            Navigator.of(context).pop(true);
          }
        });
      }
    } catch (e, stack) {
      debugPrint('[EditInterventionDialog] Erreur lors de la sauvegarde: $e');
      debugPrint(stack.toString());
      if (mounted) {
        String errorMessage = 'Erreur: $e';
        if (e.toString().contains('Timeout')) {
          errorMessage =
              'La sauvegarde prend trop de temps. Vérifiez votre connexion.';
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
      if (mounted) setState(() => _isSaving = false);
      debugPrint('[EditInterventionDialog] Fin de _saveAndClose.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            (Responsive.isMobile(context) ? 0.98 : 0.50),
        height: MediaQuery.of(context).size.height *
            (Responsive.isMobile(context) ? 0.85 : 0.65),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Modifier intervention', style: AppTextStyles.title(isDark)),
              const SizedBox(height: 16),
              // Dropdown client
              DropdownButtonFormField<InterventionType>(
                value: _selectedType,
                items: InterventionType.values
                    .map((type) => DropdownMenuItem<InterventionType>(
                          value: type,
                          child: Text(type.label,
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
                decoration: AppInputDecorations.dropdown(
                    'Type d\'intervention', isDark),
                onChanged: (val) => setState(() => _selectedType = val),
                validator: (_) => null,
                // Fin du DropdownButtonFormField
              ),
              const SizedBox(height: 8),
              // Dropdown type intervention centralisé avec enum
              DropdownButtonFormField<InterventionType>(
                value: _selectedType,
                items: InterventionType.values
                    .map((type) => DropdownMenuItem<InterventionType>(
                          value: type,
                          child: Text(type.label,
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
                  setState(() => _selectedType = val);
                },
                validator: (_) => null,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration:
                    AppInputDecorations.neonField('Description', isDark),
                style: AppTextStyles.body(isDark),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.calendar_today,
                    color: AppColors.getNeonColor(isDark), size: 20),
                title: Text(
                  _installationDate == null
                      ? 'Sélectionnez la date'
                      : '${_installationDate!.day}/${_installationDate!.month}/${_installationDate!.year}',
                  style: AppTextStyles.body(isDark).copyWith(
                    color: _installationDate == null
                        ? AppColors.getNeonColor(isDark).withOpacity(0.6)
                        : AppColors.getNeonColor(isDark),
                  ),
                ),
                trailing: Icon(Icons.arrow_drop_down,
                    color: AppColors.getNeonColor(isDark)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _installationDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _installationDate = picked);
                  }
                },
              ),
              const SizedBox(height: 16),
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
                      backgroundColor: AppColors.getNeonColor(isDark),
                      foregroundColor:
                          isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    onPressed: _isSaving ? null : _saveAndClose,
                    child: _isSaving
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText),
                            ),
                          )
                        : Text('Enregistrer',
                            style: AppTextStyles.body(isDark)),
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
