// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';

class InterventionStatusChart extends StatefulWidget {
  final List<Intervention> interventions;
  const InterventionStatusChart(
      {super.key, required List<Intervention>? interventions})
      : interventions = interventions ?? const [];

  @override
  State<InterventionStatusChart> createState() =>
      _InterventionStatusChartState();
}

class _InterventionStatusChartState extends State<InterventionStatusChart> {
  double realisee = 0;
  double attente = 0;
  double retard = 0;

  @override
  void initState() {
    super.initState();
    _computeStats();
  }

  @override
  void didUpdateWidget(covariant InterventionStatusChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.interventions != widget.interventions) {
      _computeStats();
    }
  }

  void _computeStats() {
    final interventions = widget.interventions;
    if (interventions.isEmpty) {
      setState(() {
        realisee = attente = retard = 0;
      });
      return;
    }
    final now = DateTime.now();
    int nbRealisee = 0;
    int nbAttente = 0;
    int nbRetard = 0;
    for (final i in interventions) {
      if (i.status.label.toLowerCase() == 'terminé' ||
          i.status.label.toLowerCase() == 'terminée') {
        nbRealisee++;
      } else if (i.installationDate.isBefore(now)) {
        nbRetard++;
      } else {
        nbAttente++;
      }
    }
    final total = interventions.length;
    double safePercent(int n) {
      if (total == 0) return 0;
      final v = (n / total) * 100;
      return (v.isFinite && !v.isNaN) ? v : 0;
    }

    setState(() {
      realisee = safePercent(nbRealisee);
      attente = safePercent(nbAttente);
      retard = safePercent(nbRetard);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final chartSize = isMobile ? 160.0 : 220.0;
    final data = [
      _PieSectionData('Réalisée', realisee, Colors.greenAccent.shade400,
          Icons.check_circle),
      _PieSectionData('En attente', attente, Colors.orangeAccent.shade200,
          Icons.hourglass_top),
      _PieSectionData('En retard', retard, Colors.redAccent.shade200,
          Icons.warning_amber_rounded),
    ]
        .where((d) => d.percent > 0 && d.percent.isFinite && !d.percent.isNaN)
        .toList();
    // Sécurité supplémentaire : log si données invalides détectées
    if ([realisee, attente, retard]
        .any((v) => !v.isFinite || v.isNaN || v < 0)) {
      debugPrint(
          '[PieChart] Données invalides détectées : realisee=$realisee, attente=$attente, retard=$retard');
    }
    if (data.isEmpty) {
      return GlassmorphicContainer(
        borderRadius: 24,
        blur: 18,
        border: 1.8,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.18),
            Colors.white.withOpacity(0.07)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [Colors.cyanAccent.withOpacity(0.7), Colors.transparent],
        ),
        height: chartSize + 110,
        width: double.infinity,
        child: const Center(
          child: Text(
            'Aucune donnée à afficher',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      );
    }
    // Sécurité : si une section a une valeur non-finite, fallback sur le message
    if (data
        .any((d) => !d.percent.isFinite || d.percent.isNaN || d.percent < 0)) {
      debugPrint('[PieChart] Section non-finite détectée dans data, fallback.');
      return GlassmorphicContainer(
        borderRadius: 24,
        blur: 18,
        border: 1.8,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.18),
            Colors.white.withOpacity(0.07)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [Colors.cyanAccent.withOpacity(0.7), Colors.transparent],
        ),
        height: chartSize + 110,
        width: double.infinity,
        child: const Center(
          child: Text(
            'Aucune donnée à afficher',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      );
    }
    return GlassmorphicContainer(
      borderRadius: 24,
      blur: 18,
      border: 1.8,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.18),
          Colors.white.withOpacity(0.07)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [Colors.cyanAccent.withOpacity(0.7), Colors.transparent],
      ),
      height: chartSize + 110,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: chartSize,
              width: chartSize,
              child: _InterventionStatusChartAnimated(
                data: data,
                chartSize: chartSize,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: data
                  .map((d) => _LegendItem(
                        color: d.color,
                        label: d.label,
                        percent: d.percent,
                        icon: d.icon,
                        isMobile: isMobile,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PieSectionData {
  final String label;
  final double percent;
  final Color color;
  final IconData icon;
  _PieSectionData(this.label, this.percent, this.color, this.icon);
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final double percent;
  final IconData icon;
  final bool isMobile;
  const _LegendItem({
    required this.color,
    required this.label,
    required this.percent,
    required this.icon,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: isMobile ? 18 : 22),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: isMobile ? 13 : 15,
            shadows: [
              Shadow(blurRadius: 6, color: color.withOpacity(0.5)),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(${percent.toInt()}%)',
          style: TextStyle(
            color: Colors.white70,
            fontSize: isMobile ? 12 : 14,
          ),
        ),
      ],
    );
  }
}

class _InterventionStatusChartAnimated extends StatefulWidget {
  final List<_PieSectionData> data;
  final double chartSize;
  const _InterventionStatusChartAnimated(
      {required this.data, required this.chartSize});
  @override
  State<_InterventionStatusChartAnimated> createState() =>
      _InterventionStatusChartAnimatedState();
}

class _InterventionStatusChartAnimatedState
    extends State<_InterventionStatusChartAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
    _controller.repeat(
      min: 0,
      max: 1.0, // Limite finie pour éviter les valeurs infinies
      period: const Duration(seconds: 12), // Animation plus lente
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filtrage strict : aucune section non-finite ou négative ne doit passer
    final validSections = widget.data
        .where((d) => d.percent > 0 && d.percent.isFinite && !d.percent.isNaN)
        .toList();
    if (widget.data
        .any((d) => !d.percent.isFinite || d.percent.isNaN || d.percent < 0)) {
      debugPrint(
          '[PieChart/Animated] Section non-finite ou négative détectée dans widget.data : '
          '${widget.data.map((d) => '${d.label}:${d.percent}').join(', ')}');
    }
    if (validSections.isEmpty) {
      return const Center(
        child: Text(
          'Aucune donnée à afficher',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    }
    // Sécurité : ne jamais passer de valeur non-finite à PieChartSectionData, même dans l'AnimatedBuilder
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!mounted) {
          return const SizedBox.shrink();
        }
        final filteredSections = validSections
            .where(
                (d) => d.percent > 0 && d.percent.isFinite && !d.percent.isNaN)
            .toList();
        // Deep copy et filtrage strict juste avant PieChart
        final safeSections = List<_PieSectionData>.from(filteredSections)
            .where(
                (d) => d.percent > 0 && d.percent.isFinite && !d.percent.isNaN)
            .toList();
        final safeTotal =
            safeSections.fold<double>(0, (sum, d) => sum + d.percent);
        if (safeSections.isEmpty || !safeTotal.isFinite || safeTotal <= 0) {
          debugPrint(
              '[PieChart/Animated] Fallback : aucune section safe ou somme nulle/non-finie.');
          return const Center(
            child: Text(
              'Aucune donnée à afficher',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          );
        }
        var angle = -90 + (_controller.value * 360) % 360;
        if (!angle.isFinite || angle.isNaN) {
          debugPrint(
              '[PieChart/Animated] Angle non-fini ou NaN, fallback -90.');
          angle = -90;
        }
        return PieChart(
          PieChartData(
            sectionsSpace: 4,
            centerSpaceRadius: widget.chartSize * 0.22,
            startDegreeOffset: angle,
            sections: safeSections
                .map((d) => PieChartSectionData(
                      color: d.color,
                      value: d.percent,
                      title: (d.percent > 0 &&
                              d.percent.isFinite &&
                              !d.percent.isNaN)
                          ? '${d.percent.toStringAsFixed(0)}%'
                          : '',
                      radius: widget.chartSize < 200
                          ? widget.chartSize * 0.36
                          : widget.chartSize * 0.38,
                      titleStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.chartSize < 200 ? 16 : 20,
                        shadows: [
                          Shadow(blurRadius: 8, color: d.color.withOpacity(0.7))
                        ],
                      ),
                    ))
                .toList(),
            pieTouchData: PieTouchData(enabled: false),
          ),
        );
      },
    );
  }
}
