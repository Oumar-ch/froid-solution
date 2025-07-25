import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/programme_task.dart';
import '../models/client.dart';
import '../models/technicien.dart';
import '../themes/app_colors.dart';
import '../services/database_service.dart';

class ProgrammeForm extends StatefulWidget {
  final ProgrammeTask? initial;
  final void Function(ProgrammeTask) onSubmit;

  const ProgrammeForm({super.key, this.initial, required this.onSubmit});

  @override
  State<ProgrammeForm> createState() => _ProgrammeFormState();
}

class _ProgrammeFormState extends State<ProgrammeForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titreController;
  late TextEditingController _telephoneController;
  late TextEditingController _adresseController;
  late TextEditingController _commentaireController;
  late TextEditingController _heureController;
  late TextEditingController _typeController;
  late TextEditingController _equipementController;
  DateTime? _selectedDate;

  final List<Client> _clients = [];
  final List<Technicien> _techniciens = [];
  String? _selectedClient;
  String? _selectedTechnicienId;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.initial?.titre ?? '');
    _selectedClient = widget.initial?.client;
    _selectedTechnicienId = widget.initial?.technicienId;
    _telephoneController = TextEditingController(
      text: widget.initial?.telephone ?? '',
    );
    _adresseController = TextEditingController(
      text: widget.initial?.adresse ?? '',
    );
    _commentaireController = TextEditingController(
      text: widget.initial?.commentaire ?? '',
    );
    _heureController = TextEditingController(text: widget.initial?.heure ?? '');
    _typeController = TextEditingController(
      text: widget.initial?.typeIntervention ?? '',
    );
    _equipementController = TextEditingController(
      text: widget.initial?.equipement ?? '',
    );
    _selectedDate = widget.initial?.date;
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    // Charger les clients et techniciens depuis la base
    final clients = await DataService.getClients();
    final techniciens = await DataService.getTechniciens();
    if (mounted) {
      setState(() {
        _clients.clear();
        _clients.addAll(clients);
        _techniciens.clear();
        _techniciens.addAll(techniciens);
      });
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _telephoneController.dispose();
    _adresseController.dispose();
    _commentaireController.dispose();
    _heureController.dispose();
    _typeController.dispose();
    _equipementController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final task = ProgrammeTask(
      id: widget.initial?.id ?? const Uuid().v4(),
      titre: _titreController.text.trim(),
      date: _selectedDate!,
      client: _selectedClient,
      technicienId: _selectedTechnicienId,
      telephone: _telephoneController.text.trim().isNotEmpty
          ? _telephoneController.text.trim()
          : null,
      adresse: _adresseController.text.trim().isNotEmpty
          ? _adresseController.text.trim()
          : null,
      commentaire: _commentaireController.text.trim().isNotEmpty
          ? _commentaireController.text.trim()
          : null,
      heure: _heureController.text.trim().isNotEmpty
          ? _heureController.text.trim()
          : null,
      typeIntervention: _typeController.text.trim().isNotEmpty
          ? _typeController.text.trim()
          : null,
      equipement: _equipementController.text.trim().isNotEmpty
          ? _equipementController.text.trim()
          : null,
    );
    try {
      widget.onSubmit(task);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = AppColors.getNeonColor(isDark);
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titreController,
                  decoration: AppInputDecorations.neonField('Titre', isDark),
                  style: AppTextStyles.body(isDark),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Titre requis' : null,
                ),
                const SizedBox(height: 12),
                // Client Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedClient,
                  decoration: AppInputDecorations.neonField('Client', isDark),
                  items: _clients
                      .map(
                        (client) => DropdownMenuItem(
                          value: client.name,
                          child: Text(
                            client.name,
                            style: AppTextStyles.body(isDark),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedClient = val),
                ),
                const SizedBox(height: 12),
                // Technicien Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedTechnicienId,
                  decoration: AppInputDecorations.neonField(
                    'Technicien',
                    isDark,
                  ),
                  items: _techniciens
                      .map(
                        (tech) => DropdownMenuItem(
                          value: tech.id,
                          child: Text(
                            tech.nom,
                            style: AppTextStyles.body(isDark),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selectedTechnicienId = val),
                ),
                const SizedBox(height: 12),
                // Téléphone
                TextFormField(
                  controller: _telephoneController,
                  keyboardType: TextInputType.phone,
                  decoration: AppInputDecorations.neonField(
                    'Téléphone',
                    isDark,
                  ),
                  style: AppTextStyles.body(isDark),
                ),
                const SizedBox(height: 12),
                // Adresse
                TextFormField(
                  controller: _adresseController,
                  decoration: AppInputDecorations.neonField('Adresse', isDark),
                  style: AppTextStyles.body(isDark),
                ),
                const SizedBox(height: 12),
                // Commentaire
                TextFormField(
                  controller: _commentaireController,
                  maxLines: 2,
                  decoration: AppInputDecorations.neonField(
                    'Commentaire',
                    isDark,
                  ),
                  style: AppTextStyles.body(isDark),
                ),
                const SizedBox(height: 12),
                // Heure intervention
                TextFormField(
                  controller: _heureController,
                  decoration: AppInputDecorations.neonField(
                    "Heure d'intervention",
                    isDark,
                  ),
                  style: AppTextStyles.body(isDark),
                ),
                const SizedBox(height: 12),
                // Type intervention
                TextFormField(
                  controller: _typeController,
                  decoration: AppInputDecorations.neonField(
                    "Type d'intervention",
                    isDark,
                  ),
                  style: AppTextStyles.body(isDark),
                ),
                const SizedBox(height: 12),
                // Equipement
                TextFormField(
                  controller: _equipementController,
                  decoration: AppInputDecorations.neonField(
                    "Équipement concerné",
                    isDark,
                  ),
                  style: AppTextStyles.body(isDark),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neon,
                    foregroundColor: isDark
                        ? AppColors.darkText
                        : AppColors.lightText,
                  ),
                  onPressed: _submit,
                  child: Text('Enregistrer', style: AppTextStyles.body(isDark)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
