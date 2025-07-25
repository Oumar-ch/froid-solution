// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:froid_solution_service_technique/constants/app_assets.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../themes/app_colors.dart';
import '../constants/intervention_constants.dart';

class NeonInterventionForm extends StatefulWidget {
  final void Function({
    required String client,
    required String type,
    required String description,
    required DateTime installationDate,
  })
  onSubmit;

  final List<String> clients;
  const NeonInterventionForm({
    super.key,
    required this.onSubmit,
    required this.clients,
  });

  @override
  State<NeonInterventionForm> createState() => _NeonInterventionFormState();
}

class _NeonInterventionFormState extends State<NeonInterventionForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClient;
  InterventionType? _selectedType;
  final _descController = TextEditingController();
  DateTime? _installationDate;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      body: Center(
        child: SingleChildScrollView(
          child: GlassmorphicContainer(
            borderRadius: 24,
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
            width: 480,
            height: 700, // Hauteur suffisante pour la plupart des écrans
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.logo, height: 64),
                  const SizedBox(
                    height: 58,
                  ), // espace augmenté pour compenser la suppression du titre
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedClient,
                          items: widget.clients
                              .map(
                                (c) => DropdownMenuItem<String>(
                                  value: c,
                                  child: Text(
                                    c,
                                    style: TextStyle(
                                      color: AppColors.getNeonColor(isDark),
                                      fontFamily: 'Orbitron',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          dropdownColor: isDark
                              ? AppColors.darkSurface
                              : Colors.white,
                          style: TextStyle(
                            color: AppColors.getNeonColor(isDark),
                            fontFamily: 'Orbitron',
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.getNeonColor(isDark),
                          ),
                          decoration: AppInputDecorations.dropdown(
                            'Client (optionnel)',
                            isDark,
                          ),
                          onChanged: (val) =>
                              setState(() => _selectedClient = val),
                          validator: (_) => null,
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<InterventionType>(
                          value: _selectedType == null
                              ? null
                              : InterventionType.values.firstWhere(
                                  (e) => e.label == _selectedType,
                                  orElse: () => InterventionType.autre,
                                ),
                          items: InterventionType.values
                              .map(
                                (t) => DropdownMenuItem<InterventionType>(
                                  value: t,
                                  child: Text(
                                    t.label,
                                    style: TextStyle(
                                      color: AppColors.getNeonColor(isDark),
                                      fontFamily: 'Orbitron',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          dropdownColor: isDark
                              ? AppColors.darkSurface
                              : Colors.white,
                          style: TextStyle(
                            color: AppColors.getNeonColor(isDark),
                            fontFamily: 'Orbitron',
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.getNeonColor(isDark),
                          ),
                          decoration: AppInputDecorations.dropdown(
                            "Type (optionnel)",
                            isDark,
                          ),
                          onChanged: (val) =>
                              setState(() => _selectedType = val),
                          validator: (_) => null,
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _descController,
                          decoration: AppInputDecorations.neonField(
                            'Description (optionnelle)',
                            isDark,
                          ),
                          style: TextStyle(
                            color: AppColors.getNeonColor(isDark),
                          ),
                          maxLines: 2,
                          validator: (_) => null,
                        ),
                        const SizedBox(height: 18),
                        InkWell(
                          onTap: () {
                            WidgetsBinding.instance.addPostFrameCallback((
                              _,
                            ) async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    _installationDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() => _installationDate = picked);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.getNeonColor(isDark),
                                width: 1.3,
                              ),
                              color: isDark
                                  ? Colors.white10
                                  : AppColors.lightSurface,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: AppColors.getNeonColor(isDark),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _installationDate == null
                                      ? "Date d'installation (optionnelle)"
                                      : "${_installationDate!.day}/${_installationDate!.month}/${_installationDate!.year}",
                                  style: TextStyle(
                                    color: AppColors.getNeonColor(isDark),
                                    fontFamily: 'Orbitron',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.getNeonColor(isDark),
                              foregroundColor: isDark
                                  ? Colors.black
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shadowColor: AppColors.getNeonColor(isDark),
                              elevation: 12,
                              textStyle: const TextStyle(
                                fontFamily: 'Orbitron',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () {
                              widget.onSubmit(
                                client:
                                    _selectedClient ?? 'Client non spécifié',
                                type: _selectedType != null
                                    ? _selectedType!.label
                                    : 'Type non spécifié',
                                description:
                                    _descController.text.trim().isNotEmpty
                                    ? _descController.text.trim()
                                    : 'Description non spécifiée',
                                installationDate:
                                    _installationDate ?? DateTime.now(),
                              );
                            },
                            child: const Text(
                              "Enregistrer",
                              style: TextStyle(letterSpacing: 1.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
