// ignore_for_file: deprecated_member_use, unnecessary_import

import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';
import '../services/database_service.dart';
import '../themes/app_colors.dart';
import '../themes/dark_theme.dart';
import '../widgets/glass_reminder_card.dart';

class HistoriqueClientScreen extends StatefulWidget {
  final Client client;
  const HistoriqueClientScreen({super.key, required this.client});

  @override
  State<HistoriqueClientScreen> createState() => _HistoriqueClientScreenState();
}

class _HistoriqueClientScreenState extends State<HistoriqueClientScreen>
    with WidgetsBindingObserver {
  List<Intervention> _clientInterventions = [];
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadClientInterventions();
    _loadEvents();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadClientInterventions();
    }
  }

  Future<void> _loadClientInterventions() async {
    final interventions = await DataService.getInterventions();
    setState(() {
      // Pas de champ clientName dans Intervention, filtrage désactivé
      _clientInterventions = interventions;
    });
  }

  Future<void> _loadEvents() async {
    final interventions = await DataService.getInterventions();
    final ids = interventions.map((i) => i.id).toList();
    List<Map<String, dynamic>> allEvents = [];
    for (final id in ids) {
      final events =
          await DataService.getInterventionEvents(int.tryParse(id) ?? 0);
      allEvents.addAll(events);
    }
    allEvents.sort((a, b) => b['eventDate'].compareTo(a['eventDate']));
    setState(() {
      _events = allEvents;
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'validée':
        return Colors.greenAccent.shade400;
      case 'non validée':
        return Colors.redAccent.shade200;
      default:
        return Colors.orangeAccent.shade200;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'validée':
        return Icons.check_circle;
      case 'non validée':
        return Icons.cancel;
      default:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: darkTheme.appBarTheme.backgroundColor,
        foregroundColor: darkTheme.appBarTheme.foregroundColor,
        elevation: darkTheme.appBarTheme.elevation,
        title: Text(
          'HISTORIQUE DE ${widget.client.name.toUpperCase()}',
          style: AppTextStyles.title(
              Theme.of(context).brightness == Brightness.dark),
        ),
      ),
      body: _clientInterventions.isEmpty && _events.isEmpty
          ? Center(
              child: Text(
                'Aucune intervention réalisée pour ce client.',
                style: TextStyle(color: darkTheme.textTheme.bodyMedium?.color),
              ),
            )
          : ListView(
              children: [
                if (_events.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Historique des validations/refus',
                        style: darkTheme.textTheme.titleMedium),
                  ),
                ..._events.map((e) => GlassReminderCard(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16),
                      height: 70,
                      child: ListTile(
                        leading: Icon(
                          e['status'] == 'validée'
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: e['status'] == 'validée'
                              ? Colors.greenAccent.shade400
                              : Colors.redAccent.shade200,
                        ),
                        title: Text('${e['status']?.toUpperCase() ?? ''}'),
                        subtitle: Text(
                            '${e['eventType']} le ${e['eventDate']?.toString().substring(0, 19).replaceAll("T", " à ") ?? ''}'),
                      ),
                    )),
                if (_clientInterventions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Interventions',
                        style: darkTheme.textTheme.titleMedium),
                  ),
                ..._clientInterventions.map((intervention) => GlassReminderCard(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(_statusIcon(intervention.status.label),
                                  color:
                                      _statusColor(intervention.status.label),
                                  size: 28),
                              const SizedBox(width: 10),
                              Text(intervention.type.label,
                                  style: darkTheme.textTheme.titleLarge),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor(intervention.status.label)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                    intervention.status.label.toUpperCase(),
                                    style: TextStyle(
                                        color: _statusColor(
                                            intervention.status.label),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Description : ${intervention.description}',
                              style: darkTheme.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text(
                              'Date : ${intervention.date.toLocal().toString().split(' ')[0]}',
                              style: darkTheme.textTheme.bodyMedium),
                        ],
                      ),
                    )),
              ],
            ),
    );
  }
}
