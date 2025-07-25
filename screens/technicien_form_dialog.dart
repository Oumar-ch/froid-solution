// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:uuid/uuid.dart';
import '../models/technicien.dart';
import '../themes/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../utils/responsive.dart';

class TechnicienFormDialog extends StatefulWidget {
  final void Function(Technicien technicien) onSubmit;
  final Technicien? initial;
  const TechnicienFormDialog({super.key, required this.onSubmit, this.initial});

  @override
  State<TechnicienFormDialog> createState() => _TechnicienFormDialogState();
}

class _TechnicienFormDialogState extends State<TechnicienFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _numeroController;
  late TextEditingController _adresseController;
  late String _habilitation;

  final List<String> _habilitations = [
    'novice',
    'intermédiaire',
    'avancé',
    'expert',
  ];

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.initial?.nom ?? '');
    _numeroController =
        TextEditingController(text: widget.initial?.numero ?? '');
    _adresseController =
        TextEditingController(text: widget.initial?.adresse ?? '');
    _habilitation = widget.initial?.habilitation ?? 'novice';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassmorphicContainer(
        borderRadius: AppDimensions.borderRadiusLarge,
        blur: AppDimensions.paddingLarge,
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
            (Responsive.isMobile(context) ? 0.98 : 0.40),
        height: MediaQuery.of(context).size.height *
            (Responsive.isMobile(context) ? 0.85 : 0.60),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLarge,
              vertical: AppDimensions.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Ajouter un technicien',
                    style: TextStyle(
                      color: AppColors.getNeonColor(isDark),
                      fontFamily: 'Orbitron',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    )),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Nom requis' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _numeroController,
                  decoration: InputDecoration(
                    labelText: 'Numéro',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Numéro requis' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _adresseController,
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Adresse requise' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _habilitation,
                  items: _habilitations
                      .map((h) => DropdownMenuItem(
                            value: h,
                            child: Text(h[0].toUpperCase() + h.substring(1)),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Niveau d\'habilitation',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (v) =>
                      setState(() => _habilitation = v ?? 'novice'),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final technicien = Technicien(
                          id: widget.initial?.id ?? const Uuid().v4(),
                          nom: _nomController.text.trim(),
                          numero: _numeroController.text.trim(),
                          adresse: _adresseController.text.trim(),
                          habilitation: _habilitation,
                        );
                        widget.onSubmit(technicien);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Enregistrer',
                        style: TextStyle(fontSize: 18, fontFamily: 'Orbitron')),
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
