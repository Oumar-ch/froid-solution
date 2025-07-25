// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/intervention_model.dart';
import '../models/client.dart';
import '../constants/intervention_constants.dart';
import '../services/client_service.dart';
import '../services/database_service.dart';
import '../themes/app_colors.dart';

class EditInterventionScreen extends StatefulWidget {
  final Intervention intervention;
  const EditInterventionScreen({super.key, required this.intervention});

  @override
  State<EditInterventionScreen> createState() => _EditInterventionScreenState();
}

class _EditInterventionScreenState extends State<EditInterventionScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Client> _clients = [];
  String? _selectedClientId;
  InterventionType? _selectedType;
  late TextEditingController _descriptionController;
  DateTime? _installationDate;
  bool _isModified = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.intervention.type;
    _descriptionController =
        TextEditingController(text: widget.intervention.description);
    _installationDate = widget.intervention.date;
    _descriptionController.addListener(_onChanged);
    _loadClients();
  }

  void _onChanged() {
    setState(() {
      _isModified = _selectedType != widget.intervention.type ||
          _descriptionController.text.trim() !=
              widget.intervention.description.trim() ||
          _installationDate != widget.intervention.date;
    });
  }

  Future<void> _loadClients() async {
    final clients = await ClientService().getClients();
    setState(() {
      _clients = clients;
      _selectedClientId = clients.isNotEmpty ? clients.first.id : null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _installationDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _installationDate = picked;
      });
    }
  }

  Future<void> _updateIntervention() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      // Pas de champ obligatoire
      final intervention = Intervention(
        id: widget.intervention.id,
        date: _installationDate ?? DateTime.now(),
        type: _selectedType ?? InterventionType.autre,
        description: _descriptionController.text.trim(),
        status: widget.intervention.status,
        clientName: widget.intervention.clientName,
        installationDate: _installationDate ?? DateTime.now(),
      );
      await DataService.updateIntervention(intervention).timeout(
        const Duration(seconds: 10),
        onTimeout: () =>
            throw Exception('Timeout: La sauvegarde a pris trop de temps'),
      );
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        Future.microtask(() {
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        });
      }
    } catch (e) {
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
    }
  }

  // Méthode helper pour créer des champs de saisie stylisés
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    String? hintText,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = AppColors.getNeonColor(isDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: AppTextStyles.label(isDark),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: AppTextStyles.body(isDark).copyWith(color: neon),
          decoration: AppInputDecorations.neonField(label, isDark).copyWith(
            prefixIcon: Icon(icon, color: neon, size: 20),
            hintText: hintText,
            hintStyle: AppTextStyles.body(isDark)
                .copyWith(color: neon.withValues(alpha: 0.6)),
          ),
        ),
      ],
    );
  }

  Future<bool> _onWillPop() async {
    if (!_isModified) return true;
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter sans enregistrer ?'),
        content:
            const Text('Des modifications non enregistrées seront perdues.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
    if (shouldLeave ?? false) {
      Future.microtask(() {
        if (mounted) Navigator.of(context).pop(false);
      });
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.getBackgroundColor(isDark),
        appBar: AppBar(
          title: Text(
            'MODIFIER INTERVENTION',
            style: AppTextStyles.title(isDark),
          ),
          backgroundColor: AppColors.getSurfaceColor(isDark),
          iconTheme: IconThemeData(color: AppColors.getNeonColor(isDark)),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.darkBackground,
                      AppColors.darkSurface.withValues(alpha: 0.8),
                    ],
                  )
                : null,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Titre de section
                Text(
                  'Informations intervention',
                  style: AppTextStyles.title(isDark),
                ),
                const SizedBox(height: 24),

                // Dropdown Client stylisé
                Text(
                  'Client',
                  style: AppTextStyles.label(isDark),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.getNeonColor(isDark).withOpacity(0.5),
                      width: 1.5,
                    ),
                    color: AppColors.getSurfaceColor(isDark),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedClientId,
                    items: _clients
                        .map((client) => DropdownMenuItem<String>(
                              value: client.id,
                              child: Text(
                                client.name,
                                style: TextStyle(
                                  color: AppColors.getNeonColor(isDark),
                                  fontFamily: 'Orbitron',
                                ),
                              ),
                            ))
                        .toList(),
                    dropdownColor:
                        isDark ? AppColors.darkSurface : Colors.white,
                    style: TextStyle(
                        color: AppColors.getNeonColor(isDark),
                        fontFamily: 'Orbitron'),
                    icon: Icon(Icons.arrow_drop_down,
                        color: AppColors.getNeonColor(isDark)),
                    decoration: AppInputDecorations.dropdown(
                        'Client (optionnel)', isDark),
                    onChanged: (val) {
                      setState(() => _selectedClientId = val);
                      _onChanged();
                    },
                    validator: (_) => null,
                  ),
                ),
                const SizedBox(height: 20),

                // Type d'intervention (DROPDOWN MODERNE harmonisé avec liste centralisée)
                Text(
                  "Type d'intervention",
                  style: AppTextStyles.label(isDark),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.getNeonColor(isDark).withOpacity(0.5),
                      width: 1.5,
                    ),
                    color: AppColors.getSurfaceColor(isDark),
                  ),
                  child: Builder(
                    builder: (context) {
                      // Liste centralisée + ajout dynamique si valeur inconnue
                      return DropdownButtonFormField<InterventionType>(
                        value: _selectedType,
                        items: InterventionType.values
                            .map((type) => DropdownMenuItem<InterventionType>(
                                  value: type,
                                  child: Text(
                                    type.label,
                                    style: TextStyle(
                                        color: AppColors.getNeonColor(isDark),
                                        fontFamily: 'Orbitron'),
                                  ),
                                ))
                            .toList(),
                        dropdownColor:
                            isDark ? AppColors.darkSurface : Colors.white,
                        style: TextStyle(
                            color: AppColors.getNeonColor(isDark),
                            fontFamily: 'Orbitron'),
                        icon: Icon(Icons.arrow_drop_down,
                            color: AppColors.getNeonColor(isDark)),
                        decoration: AppInputDecorations.dropdown(
                            "Type d'intervention", isDark),
                        onChanged: (val) {
                          setState(() => _selectedType = val);
                          _onChanged();
                        },
                        validator: (_) => null,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                _buildStyledTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.description,
                  isRequired: false,
                  hintText: 'Détails de l\'intervention...',
                  maxLines: 3,
                  validator: null, // Champ optionnel
                ),
                const SizedBox(height: 20),

                // Date d'installation
                Text(
                  'Date d\'installation',
                  style: AppTextStyles.label(isDark),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.getNeonColor(isDark).withOpacity(0.5),
                      width: 1.5,
                    ),
                    color: AppColors.getSurfaceColor(isDark),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.calendar_today,
                        color: AppColors.getNeonColor(isDark), size: 20),
                    title: Text(
                      _installationDate == null
                          ? 'Sélectionnez la date'
                          : '${_installationDate!.day}/${_installationDate!.month}/${_installationDate!.year}',
                      style: AppTextStyles.body(isDark).copyWith(
                        color: _installationDate == null
                            ? AppColors.getNeonColor(isDark)
                                .withValues(alpha: 0.6)
                            : AppColors.getNeonColor(isDark),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_drop_down,
                        color: AppColors.getNeonColor(isDark)),
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await _selectDate(context);
                        _onChanged();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Bouton de sauvegarde stylisé
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.getNeonColor(isDark),
                        AppColors.getNeonColor(isDark).withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.getNeonColor(isDark)
                            .withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _updateIntervention,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.save,
                          color:
                              isDark ? AppColors.darkText : AppColors.lightText,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Enregistrer les modifications',
                          style: AppTextStyles.label(isDark).copyWith(
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
