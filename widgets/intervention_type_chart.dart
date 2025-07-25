import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glassmorphism/glassmorphism.dart';
// ignore: unused_import
import '../services/database_service.dart';
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';

class _TypeMeta {
  final String label;
  final Color color;
  final IconData icon;
  const _TypeMeta(this.label, this.color, this.icon);
}

class _TypeData {
  final String name;
  final int percent;
  final Color color;
  final IconData icon;
  final int count;
  _TypeData(this.name, this.percent, this.color, this.icon, this.count);
}

class InterventionTypeChart extends StatefulWidget {
  final List<Intervention> interventions;
  const InterventionTypeChart(
      {super.key, required List<Intervention>? interventions})
      : interventions = interventions ?? const [];

  @override
  State<InterventionTypeChart> createState() => _InterventionTypeChartState();
}

class _InterventionTypeChartState extends State<InterventionTypeChart> {
  static final List<_TypeMeta> typeMetas = [
    _TypeMeta('Maintenance', Colors.cyanAccent.withAlpha(204), Icons.build),
    _TypeMeta(
        'Dépannage', Colors.deepPurpleAccent.withAlpha(204), Icons.flash_on),
    _TypeMeta('Installation', Colors.greenAccent.withAlpha(204),
        Icons.settings_input_component),
    _TypeMeta('Autres', Colors.orangeAccent.withAlpha(204), Icons.more_horiz),
  ];

  static _TypeMeta getTypeMeta(String type) {
    for (final meta in typeMetas) {
      if (type.toLowerCase().contains(meta.label.toLowerCase())) {
        return meta;
      }
    }
    return typeMetas.last; // Autres
  }

  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final chartHeight = isMobile ? 180.0 : 260.0;
    final interventions = widget.interventions;
    final Map<String, int> typeCounts = {
      for (final meta in typeMetas) meta.label: 0
    };
    for (final intervention in interventions) {
      final meta = getTypeMeta(intervention.type.label);
      typeCounts[meta.label] = (typeCounts[meta.label] ?? 0) + 1;
    }
    final total = typeCounts.values.fold(0, (a, b) => a + b);
    if (total == 0) {
      return GlassmorphicContainer(
        width: double.infinity,
        height: chartHeight + 80,
        borderRadius: 24,
        blur: 18,
        border: 1.8,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withAlpha((0.18 * 255).round()),
            Colors.white.withAlpha((0.07 * 255).round())
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.cyanAccent.withAlpha((0.7 * 255).round()),
            Colors.transparent
          ],
        ),
        child: const Center(
          child: Text(
            'Aucune intervention enregistrée',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ),
      );
    }
    final List<_TypeData> types = typeMetas.map((meta) {
      final count = typeCounts[meta.label] ?? 0;
      double percent = total > 0 ? (count * 100) / total : 0;
      if (!percent.isFinite || percent.isNaN) percent = 0;
      return _TypeData(
          meta.label, percent.round(), meta.color, meta.icon, count);
    }).toList();
    return GlassmorphicContainer(
      width: double.infinity,
      height: chartHeight + 80,
      borderRadius: 24,
      blur: 18,
      border: 1.8,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withAlpha((0.18 * 255).round()),
          Colors.white.withAlpha((0.07 * 255).round())
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.cyanAccent.withAlpha((0.7 * 255).round()),
          Colors.transparent
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: chartHeight,
              child: _InterventionTypeChartAnimated(
                types: types,
                chartHeight: chartHeight,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                for (final type in types)
                  if (type.count > 0)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: type.color.withAlpha((0.3 * 255).round()),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(100),
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            type.icon,
                            color: type.color,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${type.name} (${type.count})',
                            style: TextStyle(
                              color: type.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InterventionTypeChartAnimated extends StatefulWidget {
  final List<_TypeData> types;
  final double chartHeight;
  const _InterventionTypeChartAnimated(
      {required this.types, required this.chartHeight});
  @override
  State<_InterventionTypeChartAnimated> createState() =>
      _InterventionTypeChartAnimatedState();
}

class _InterventionTypeChartAnimatedState
    extends State<_InterventionTypeChartAnimated>
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = -90 + (_controller.value * 360) % 360;
        return PieChart(
          PieChartData(
            sections: [
              for (int i = 0; i < widget.types.length; i++)
                if (widget.types[i].count > 0)
                  PieChartSectionData(
                    color: widget.types[i].color,
                    value: widget.types[i].count.isFinite &&
                            !widget.types[i].count.isNaN
                        ? widget.types[i].count.toDouble()
                        : 0,
                    title: '${widget.types[i].percent}%',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    radius: 60,
                    badgeWidget: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(100),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        widget.types[i].icon,
                        color: widget.types[i].color,
                        size: 18,
                      ),
                    ),
                    badgePositionPercentageOffset: 1.18,
                  ),
            ],
            sectionsSpace: 4,
            centerSpaceRadius: widget.chartHeight * 0.22,
            startDegreeOffset: angle,
            pieTouchData: PieTouchData(enabled: false),
          ),
        );
      },
    );
  }
}
