// ...existing code...
import 'dashboard_screen.dart';
import 'client_screen.dart';
import 'clientele_screen.dart';
import 'intervention_list_screen.dart';
import 'technicien_manage_screen.dart';
import 'programme_screen.dart';
import 'reminder_screen.dart';
import 'history_screen.dart';
import 'package:flutter/material.dart';

class NavigationItem {
  final String label;
  final IconData icon;
  final Widget page;
  NavigationItem({required this.label, required this.icon, required this.page});
}

// Centralisation de la configuration de navigation
List<NavigationItem> navigationItems(BuildContext context) {
  return [
    NavigationItem(
      label: 'Tableau de bord',
      icon: Icons.dashboard,
      page: const DashboardScreen(),
    ),
    NavigationItem(
      label: 'Nouveau client',
      icon: Icons.person_add,
      page: const ClientsScreen(),
    ),
    NavigationItem(
      label: 'Clientèle',
      icon: Icons.people,
      page: const ClienteleScreen(),
    ),
    NavigationItem(
      label: 'Interventions',
      icon: Icons.build,
      page: const InterventionListScreen(),
    ),
    NavigationItem(
      label: 'Techniciens',
      icon: Icons.engineering,
      page: const TechnicienManageScreen(),
    ),
    NavigationItem(
      label: 'Programme',
      icon: Icons.calendar_month,
      page: const ProgrammeScreen(),
    ),
    NavigationItem(
      label: 'Rappels',
      icon: Icons.notifications_active,
      page: const ReminderScreen(),
    ),
    NavigationItem(
      label: 'Historique',
      icon: Icons.history,
      page: const HistoryScreen(),
    ),
  ];
}
