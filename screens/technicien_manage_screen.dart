// ...existing code...
import 'package:flutter/material.dart';
import '../models/technicien.dart';
import '../services/database_service.dart';
import '../themes/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../widgets/technicien_glass_card.dart';
import '../screens/technicien_form_dialog.dart';

class TechnicienManageScreen extends StatefulWidget {
  const TechnicienManageScreen({super.key});

  @override
  State<TechnicienManageScreen> createState() => _TechnicienManageScreenState();
}

class _TechnicienManageScreenState extends State<TechnicienManageScreen> {
  List<Technicien> _techniciens = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTechniciens();
  }

  Future<void> _loadTechniciens() async {
    setState(() => _loading = true);
    final list = await DataService.getTechniciens();
    if (!mounted) return;
    setState(() {
      _techniciens = list;
      _loading = false;
    });
  }

  Future<void> _addTechnicienDialog() async {
    await showDialog(
      context: context,
      builder: (context) => TechnicienFormDialog(
        onSubmit: (technicien) async {
          await DataService.addTechnicien(technicien);
          if (!mounted) return;
          await _loadTechniciens();
        },
      ),
    );
  }

  Future<void> _deleteTechnicien(String id) async {
    await DataService.deleteTechnicien(id);
    if (!mounted) return;
    await _loadTechniciens();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = AppColors.getNeonColor(isDark);
    // ...existing code...
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add, color: neon),
                    label: Text(
                      'Ajouter un technicien',
                      style: AppTextStyles.body(isDark),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neon,
                      foregroundColor: isDark
                          ? AppColors.darkText
                          : AppColors.lightText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusMedium,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingMedium,
                      ),
                      elevation: 8,
                    ),
                    onPressed: _addTechnicienDialog,
                  ),
                ),
                SizedBox(height: AppDimensions.paddingLarge),
                Expanded(
                  child: _techniciens.isEmpty
                      ? Center(
                          child: Text(
                            'Aucun technicien enregistré',
                            style: AppTextStyles.bodySecondary(isDark),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _techniciens.length,
                          separatorBuilder: (_, _) =>
                              Divider(color: AppColors.getSurfaceColor(isDark)),
                          itemBuilder: (context, i) {
                            final t = _techniciens[i];
                            return TechnicienGlassCard(
                              technicien: t,
                              onDelete: () => _deleteTechnicien(t.id),
                              onEdit: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => TechnicienFormDialog(
                                    onSubmit: (updated) async {
                                      await DataService.updateTechnicien(
                                        Technicien(
                                          id: t.id,
                                          nom: updated.nom,
                                          numero: updated.numero,
                                          adresse: updated.adresse,
                                          habilitation: updated.habilitation,
                                        ),
                                      );
                                      if (!mounted) return;
                                      await _loadTechniciens();
                                    },
                                    initial: t,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
  }
}
