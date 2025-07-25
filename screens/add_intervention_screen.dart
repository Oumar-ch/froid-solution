// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../screens/intervention_form.dart';
import '../services/database_service.dart';
import '../services/client_service.dart';
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';
import '../services/notification_service.dart';

class AddInterventionScreen extends StatefulWidget {
  const AddInterventionScreen({super.key});

  @override
  State<AddInterventionScreen> createState() => _AddInterventionScreenState();
}

class _AddInterventionScreenState extends State<AddInterventionScreen> {
  List<String> _clients = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    final clients = await ClientService().getClients();
    setState(() {
      _clients = clients.map((c) => c.name).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      appBar: AppBar(
        title:
            Text('NOUVELLE INTERVENTION', style: AppTextStyles.title(isDark)),
        backgroundColor: AppColors.getSurfaceColor(isDark),
        iconTheme: IconThemeData(color: AppColors.getNeonColor(isDark)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : NeonInterventionForm(
              clients: _clients,
              onSubmit: (
                  {required String client,
                  required String type,
                  required String description,
                  required DateTime installationDate}) async {
                // Conversion des String en enums
                final typeEnum = InterventionType.values.firstWhere(
                  (e) => e.label == type,
                  orElse: () => InterventionType.autre,
                );
                final statusEnum = InterventionStatus.values.firstWhere(
                  (e) => e.label == 'À faire',
                  orElse: () => InterventionStatus.aFaire,
                );
                // Enregistrement réel dans la base
                final intervention = Intervention(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  date: installationDate,
                  type: typeEnum,
                  description: description,
                  status: statusEnum,
                  clientName: client,
                  installationDate: installationDate,
                );
                await DataService.addIntervention(intervention);
                // Planification notifications (id unique basé sur le timestamp)
                await NotificationService.scheduleInterventionNotifications(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: 'Intervention à venir',
                  body:
                      'Chez $client le ${installationDate.day}/${installationDate.month}/${installationDate.year}',
                  interventionDate: installationDate,
                );
                if (mounted) Navigator.pop(context, true);
              },
            ),
    );
  }
}
