// ignore_for_file: deprecated_member_use

// ...existing code...
import 'settings_screen.dart';
import 'statistics_screen.dart';
import 'package:flutter/material.dart';

// Suppression de l'import glassmorphism
import '../constants/app_dimensions.dart';

// App colors and text styles
import '../themes/app_colors.dart';
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';
import '../widgets/charts/intervention_type_pie_chart.dart';
import '../widgets/charts/monthly_intervention_chart.dart';
import '../widgets/charts/intervention_heatmap_calendar.dart';
import '../widgets/lists/recent_interventions_list.dart';

// Responsive utility

/// Écran principal de l'application affichant le tableau de bord.

final List<Intervention> recentInterventions = [
  Intervention(
    id: '1',
    date: DateTime.now().subtract(const Duration(days: 1)),
    type: InterventionType.autre,
    description: 'Client A - Remplacement du compresseur',
    status: InterventionStatus.terminee,
    clientName: 'Client A',
    installationDate: DateTime.now().subtract(const Duration(days: 30)),
  ),
  Intervention(
    id: '2',
    date: DateTime.now().subtract(const Duration(days: 2)),
    type: InterventionType.maintenance,
    description: 'Site B - Contrôle général des unités',
    status: InterventionStatus.enCours,
    clientName: 'Site B',
    installationDate: DateTime.now().subtract(const Duration(days: 60)),
  ),
  Intervention(
    id: '3',
    date: DateTime.now().subtract(const Duration(days: 4)),
    type: InterventionType.installation,
    description: 'Nouveau client - Unité Murale',
    status: InterventionStatus.reporte,
    clientName: 'Nouveau client',
    installationDate: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Intervention(
    id: '4',
    date: DateTime.now().subtract(const Duration(days: 5)),
    type: InterventionType.autre,
    description: 'Fuite détectée sur le circuit de refroidissement',
    status: InterventionStatus.terminee,
    clientName: 'Client C',
    installationDate: DateTime.now().subtract(const Duration(days: 90)),
  ),
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final int _selectedIndex = 0;
  InterventionType? _selectedTypeFilter;
  InterventionStatus? _selectedStatusFilter;

  static const Map<String, double> pieChartData = {
    'Maintenance': 45,
    'Réparation': 28,
    'Installation': 15,
    'Urgence': 12,
  };
  static const Map<String, int> monthlyChartData = {
    'Jan': 12,
    'Fév': 18,
    'Mar': 15,
    'Avr': 22,
    'Mai': 19,
    'Juin': 25,
  };
  final List<Intervention> recentInterventions = [
    Intervention(
      id: '1',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: InterventionType.autre,
      description: 'Client A - Remplacement du compresseur',
      status: InterventionStatus.terminee,
      clientName: 'Client A',
      installationDate: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Intervention(
      id: '2',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: InterventionType.maintenance,
      description: 'Site B - Contrôle général des unités',
      status: InterventionStatus.enCours,
      clientName: 'Site B',
      installationDate: DateTime.now().subtract(const Duration(days: 60)),
    ),
    Intervention(
      id: '3',
      date: DateTime.now().subtract(const Duration(days: 4)),
      type: InterventionType.installation,
      description: 'Nouveau client - Unité Murale',
      status: InterventionStatus.reporte,
      clientName: 'Nouveau client',
      installationDate: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Intervention(
      id: '4',
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: InterventionType.autre,
      description: 'Fuite détectée sur le circuit de refroidissement',
      status: InterventionStatus.terminee,
      clientName: 'Client C',
      installationDate: DateTime.now().subtract(const Duration(days: 90)),
    ),
  ];
  final Map<DateTime, int> heatmapData = {
    DateTime.now().subtract(const Duration(days: 3)): 2,
    DateTime.now().subtract(const Duration(days: 4)): 1,
    DateTime.now().subtract(const Duration(days: 5)): 3,
    DateTime.now().subtract(const Duration(days: 10)): 1,
    DateTime.now().subtract(const Duration(days: 15)): 2,
    DateTime.now().subtract(const Duration(days: 28)): 1,
  };

  Widget _buildDashboard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // ...existing code...
    const double breakpoint = 600.0;
    final bool isWideScreen = MediaQuery.of(context).size.width >= breakpoint;
    final double horizontalPadding = isWideScreen
        ? AppDimensions.paddingLarge
        : AppDimensions.paddingMedium;
    final Widget chartsSection = isWideScreen
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: InterventionTypePieChart(data: pieChartData)),
              SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: MonthlyInterventionChart(monthlyData: monthlyChartData),
              ),
            ],
          )
        : Column(
            children: [
              InterventionTypePieChart(data: pieChartData),
              MonthlyInterventionChart(monthlyData: monthlyChartData),
            ],
          );
    List<Intervention> filteredInterventions = recentInterventions;
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: AppDimensions.paddingSmall,
                bottom: AppDimensions.paddingMedium,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bonjour !', style: textTheme.headlineMedium),
                      Text(
                        'Comment vous sentez-vous aujourd’hui ?',
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // Filtres en haut du dashboard
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
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
                        setState(() {
                          _selectedTypeFilter = val;
                        });
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
                        setState(() {
                          _selectedStatusFilter = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            chartsSection,
            RecentInterventionsList(interventions: filteredInterventions),
            InterventionHeatMapCalendar(
              interventionData: heatmapData,
              startDate: DateTime.now().subtract(const Duration(days: 90)),
              endDate: DateTime.now(),
            ),
            SizedBox(height: AppDimensions.paddingLarge),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_selectedIndex) {
      case 0:
        content = _buildDashboard(context);
        break;
      case 1:
        content = const StatisticsScreen();
        break;
      case 2:
        content = const SettingsScreen();
        break;
      default:
        content = _buildDashboard(context);
    }
    return Scaffold(
      body: content,
      // BottomNavigationBar supprimée pour éviter la double navigation
    );
  }
}
// ...existing code...

// ────────────── Widget 1 : Interventions en cours ──────────────
class _InterventionsEnCoursCard extends StatefulWidget {
  final int count;
  const _InterventionsEnCoursCard({required this.count});
  @override
  State<_InterventionsEnCoursCard> createState() =>
      _InterventionsEnCoursCardState();
}

class _InterventionsEnCoursCardState extends State<_InterventionsEnCoursCard>
    with SingleTickerProviderStateMixin {
  // Animation supprimée

  @override
  Widget build(BuildContext context) {
    final interventionsEnCours =
        (ModalRoute.of(context)?.settings.arguments
            as Map?)?['interventionsEnCours'] ??
        widget.count;
    return Container(
      height: AppDimensions.alertCardHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightAccentGlow.withOpacity(0.18),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
          vertical: AppDimensions.paddingMedium,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.autorenew,
              color: AppColors.lightAccentGlow,
              size: AppDimensions.iconSizeLarge,
            ),
            SizedBox(height: AppDimensions.paddingSmall),
            Text(
              '$interventionsEnCours',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 12,
                    color: AppColors.lightAccentGlow.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.paddingSmall),
            Text(
              'Interventions en cours',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: AppDimensions.fontSizeMedium,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────── Widget 2 : Interventions terminées ──────────────
class _InterventionsTermineesCard extends StatefulWidget {
  final int count;
  const _InterventionsTermineesCard({required this.count});
  @override
  State<_InterventionsTermineesCard> createState() =>
      _InterventionsTermineesCardState();
}

class _InterventionsTermineesCardState
    extends State<_InterventionsTermineesCard>
    with SingleTickerProviderStateMixin {
  // Animation supprimée

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.alertCardHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
          vertical: AppDimensions.paddingMedium,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.verified,
              color: AppColors.success,
              size: AppDimensions.iconSizeLarge,
            ),
            SizedBox(height: AppDimensions.paddingSmall),
            Text(
              '${widget.count}',
              style: TextStyle(
                fontSize: AppDimensions.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 12,
                    color: AppColors.success.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.paddingSmall),
            Text(
              'Interventions terminées',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: AppDimensions.fontSizeMedium,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// End of file
