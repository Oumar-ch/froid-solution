// ignore_for_file: unnecessary_import, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../models/client.dart';
import '../services/client_service.dart';
import '../services/database_service.dart';
import '../widgets/glass_reminder_card.dart';
import 'historique_client_screen.dart';
import '../themes/app_colors.dart';
import '../utils/responsive.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Client> _clientsWithHistory = [];

  @override
  void initState() {
    super.initState();
    _loadClientsWithHistory();
  }

  Future<void> _loadClientsWithHistory() async {
    final interventions = await DataService.getInterventions();
    final clients = await ClientService().getClients();
    // On ne garde que les clients qui ont au moins une intervention validée, non validée, ou terminée
    // completedDates et clientName n'existent pas dans Intervention, on filtre seulement sur le status
    final Set<String> clientNamesWithHistory = interventions
        .where((i) => i.status != 'à faire')
        .map((i) => '') // Impossible d'associer à un client sans champ dédié
        .toSet();

    setState(() {
      _clientsWithHistory = clients
          .where((c) => clientNamesWithHistory.contains(c.name))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neon = AppColors.getNeonColor(isDark);
    return _clientsWithHistory.isEmpty
        ? Center(
            child: Text(
              'Aucun historique disponible.',
              style: AppTextStyles.bodySecondary(isDark),
            ),
          )
        : ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.padding(context),
              vertical: Responsive.padding(context) / 2,
            ),
            itemCount: _clientsWithHistory.length,
            separatorBuilder: (_, _) =>
                Divider(color: AppColors.getSurfaceColor(isDark)),
            itemBuilder: (context, index) {
              final client = _clientsWithHistory[index];
              return OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedElevation: 4,
                closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                closedColor: Colors.transparent,
                openColor: AppColors.getBackgroundColor(isDark),
                closedBuilder: (context, action) => GlassReminderCard(
                  margin: EdgeInsets.symmetric(
                    vertical: Responsive.isMobile(context) ? 8 : 16,
                    horizontal: Responsive.isMobile(context) ? 12 : 24,
                  ),
                  height: Responsive.isMobile(context)
                      ? 90
                      : (Responsive.isTablet(context) ? 110 : 130),
                  child: ListTile(
                    title: Text(
                      client.name,
                      style: AppTextStyles.label(
                        isDark,
                      ).copyWith(fontSize: Responsive.font(context, 15)),
                    ),
                    subtitle: Text(
                      '${client.contact}\n${client.address}',
                      style: AppTextStyles.body(
                        isDark,
                      ).copyWith(fontSize: Responsive.font(context, 13)),
                    ),
                    isThreeLine: true,
                    trailing: Icon(
                      Icons.chevron_right,
                      color: neon,
                      size: Responsive.isMobile(context) ? 22 : 30,
                    ),
                    onTap: action,
                  ),
                ),
                openBuilder: (context, action) =>
                    HistoriqueClientScreen(client: client),
              );
            },
          );
  }
}
