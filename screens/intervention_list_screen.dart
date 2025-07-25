// ignore_for_file: use_build_context_synchronously, sort_child_properties_last

import 'package:flutter/material.dart';
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';
import '../services/database_service.dart';
import '../services/client_service.dart';
import '../widgets/intervention_card.dart';
import '../themes/app_colors.dart';
import 'edit_intervention_dialog.dart';
import '../utils/responsive.dart';

class InterventionListScreen extends StatefulWidget {
  const InterventionListScreen({super.key});

  @override
  State<InterventionListScreen> createState() => _InterventionListScreenState();
}

class _InterventionListScreenState extends State<InterventionListScreen> {
  List<Intervention> _interventions = [];
  InterventionType? _selectedTypeFilter;
  InterventionStatus? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    _loadInterventions();
  }

  Future<void> _loadInterventions() async {
    final interventions = await DataService.getInterventions();
    debugPrint(
      '[InterventionListScreen] Interventions récupérées: \\${interventions.length}',
    );
    if (!mounted) return;
    setState(() {
      _interventions = interventions;
    });
  }

  Future<void> _deleteIntervention(String id) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        title: Text('Confirmation', style: AppTextStyles.title(isDark)),
        content: Text(
          'Voulez-vous vraiment supprimer cette intervention ?',
          style: AppTextStyles.body(isDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Annuler', style: AppTextStyles.body(isDark)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Supprimer',
              style: AppTextStyles.body(
                isDark,
              ).copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await DataService.deleteIntervention(int.parse(id));
      await _loadInterventions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(
              'Intervention supprimée',
              style: AppTextStyles.body(isDark).copyWith(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = AppColors.getNeonColor(isDark);

    List<Intervention> filteredInterventions = _interventions;
    if (_selectedTypeFilter != null) {
      filteredInterventions = filteredInterventions
          .where((i) => i.type == _selectedTypeFilter)
          .toList();
    }
    if (_selectedStatusFilter != null) {
      filteredInterventions = filteredInterventions
          .where((i) => i.status == _selectedStatusFilter)
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(height: Responsive.isMobile(context) ? 8 : 16),
          // Filtres en-tête
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<InterventionType>(
                    value: _selectedTypeFilter,
                    decoration: InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: InterventionType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.label),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedTypeFilter = val);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<InterventionStatus>(
                    value: _selectedStatusFilter,
                    decoration: InputDecoration(
                      labelText: 'Statut',
                      border: OutlineInputBorder(),
                    ),
                    items: InterventionStatus.values
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.label),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedStatusFilter = val);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 22 : 36),
          Expanded(
            child: filteredInterventions.isEmpty
                ? Center(
                    child: Text(
                      "Aucune intervention enregistrée.",
                      style: AppTextStyles.bodySecondary(
                        isDark,
                      ).copyWith(fontSize: Responsive.font(context, 14)),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.padding(context),
                    ),
                    itemCount: filteredInterventions.length,
                    itemBuilder: (ctx, i) {
                      final intervention = filteredInterventions[i];
                      return InterventionCard(
                        intervention: intervention,
                        onEdit: () async {
                          final clients = await ClientService().getClients();
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) => EditInterventionDialog(
                              intervention: intervention,
                              clients: clients,
                            ),
                          );
                          if (result == true) {
                            _loadInterventions();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: neon,
                                  content: Text(
                                    'Intervention modifiée avec succès !',
                                    style: AppTextStyles.body(
                                      isDark,
                                    ).copyWith(color: Colors.black),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        onDelete: () =>
                            _deleteIntervention(intervention.id.toString()),
                      );
                    },
                  ),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 16 : 28),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: neon,
        foregroundColor: isDark ? Colors.black : Colors.white,
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/add_intervention',
          );
          if (result == true) {
            _loadInterventions();
          }
        },
        tooltip: 'Ajouter une intervention',
        child: const Icon(Icons.add, size: 32),
        elevation: 8,
      ),
    );
  }
}
