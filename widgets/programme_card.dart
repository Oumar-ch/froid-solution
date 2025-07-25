// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/programme_task.dart';
import '../utils/responsive.dart';
// ...existing code...
import 'package:intl/intl.dart';

class ProgrammeCard extends StatelessWidget {
  final ProgrammeTask programme;
  final String? clientName;
  final String? technicienName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onGeneratePdf;

  const ProgrammeCard({
    super.key,
    required this.programme,
    this.clientName,
    this.technicienName,
    required this.onEdit,
    required this.onDelete,
    required this.onGeneratePdf,
  });

  @override
  Widget build(BuildContext context) {
    const blueNeon = Color(0xFF00F0FF);
    // ...existing code...

    return GlassmorphicContainer(
      margin: EdgeInsets.symmetric(
        vertical: Responsive.isMobile(context) ? 8 : 16,
        horizontal: Responsive.isMobile(context) ? 4 : 12,
      ),
      borderRadius: 22,
      blur: 10,
      alignment: Alignment.center,
      border: 1.2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.13),
          Colors.white.withOpacity(0.07),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.35),
          Colors.white.withOpacity(0.10),
        ],
      ),
      height: Responsive.isMobile(context)
          ? 220
          : (Responsive.isTablet(context) ? 320 : 420),
      width: double.infinity,
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(22),
          ),
          padding: EdgeInsets.symmetric(
            vertical: Responsive.isMobile(context) ? 18 : 28,
            horizontal: Responsive.isMobile(context) ? 20 : 36,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.ac_unit_rounded,
                      size: Responsive.isMobile(context) ? 38 : 54,
                      color: Color(0xFF00F0FF).withOpacity(0.7),
                    ),
                    SizedBox(height: Responsive.isMobile(context) ? 4 : 10),
                    Text(
                      'FROID SOLUTIONS',
                      style: TextStyle(
                        fontSize: Responsive.font(context, 20),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00F0FF),
                        fontFamily: 'Orbitron',
                        letterSpacing: 2.2,
                        shadows: [
                          Shadow(
                            blurRadius: 13,
                            color: Color(0xFF00F0FF).withOpacity(0.43),
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.isMobile(context) ? 8 : 16),
                  ],
                ),
              ),
              // Tous les champs un à un, avec style
              _futuristField(
                'Date intervention',
                DateFormat.yMd('fr').format(programme.date),
                blueNeon,
              ),
              _futuristField(
                'Heure',
                programme.heure ?? 'Non renseigné',
                blueNeon,
              ),
              _futuristField(
                "Type d'intervention",
                programme.typeIntervention ?? 'Non renseigné',
                blueNeon,
              ),
              _futuristField(
                'Équipement',
                programme.equipement ?? 'Non renseigné',
                blueNeon,
              ),
              _futuristField('Client', clientName ?? 'Non renseigné', blueNeon),
              _futuristField(
                'Technicien',
                technicienName ?? 'Non assigné',
                blueNeon,
              ),
              _futuristField(
                'Téléphone',
                programme.telephone ?? 'Non renseigné',
                blueNeon,
              ),
              _futuristField(
                'Adresse',
                programme.adresse ?? 'Non renseigné',
                blueNeon,
              ),
              if (programme.commentaire != null &&
                  programme.commentaire!.isNotEmpty)
                _futuristField('Commentaire', programme.commentaire!, blueNeon),
              const SizedBox(height: 18),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: blueNeon, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 13,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: onGeneratePdf,
                  child: Text(
                    'Générer PDF',
                    style: const TextStyle(
                      color: blueNeon,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 2,
                      fontFamily: 'Orbitron',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: blueNeon),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _futuristField(String label, String value, Color neon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: neon.withValues(alpha: 0.8),
              fontWeight: FontWeight.w700,
              fontSize: 13,
              fontFamily: 'Orbitron',
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: neon.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: neon,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Orbitron',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
