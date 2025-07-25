import 'package:flutter/material.dart';
// ...existing code...
// Centralisation des statuts, types d'intervention, rôles, etc.

enum InterventionStatus {
  aFaire,
  validee,
  enRetard,
  urgent,
  terminee,
  enCours,
  reporte,
}

extension InterventionStatusExt on InterventionStatus {
  String getLocalizedLabel(BuildContext context) {
    switch (this) {
      case InterventionStatus.aFaire:
        return 'À faire';
      case InterventionStatus.validee:
        return 'Validée';
      case InterventionStatus.enRetard:
        return 'En retard';
      case InterventionStatus.urgent:
        return 'Urgent';
      case InterventionStatus.terminee:
        return 'Terminé';
      case InterventionStatus.enCours:
        return 'En cours';
      case InterventionStatus.reporte:
        return 'Reporté';
    }
  }

  String get label {
    switch (this) {
      case InterventionStatus.aFaire:
        return 'À faire';
      case InterventionStatus.validee:
        return 'Validée';
      case InterventionStatus.enRetard:
        return 'En retard';
      case InterventionStatus.urgent:
        return 'Urgent';
      case InterventionStatus.terminee:
        return 'Terminé';
      case InterventionStatus.enCours:
        return 'En cours';
      case InterventionStatus.reporte:
        return 'Reporté';
    }
  }
}

enum InterventionType {
  installation,
  depannage,
  entretien,
  dimensionnement,
  maintenance,
  autre,
}

extension InterventionTypeExt on InterventionType {
  String getLocalizedLabel(BuildContext context) {
    switch (this) {
      case InterventionType.installation:
        return 'Installation';
      case InterventionType.depannage:
        return 'Dépannage';
      case InterventionType.entretien:
        return 'Entretien';
      case InterventionType.dimensionnement:
        return 'Dimensionnement';
      case InterventionType.maintenance:
        return 'Maintenance';
      case InterventionType.autre:
        return 'Autre';
    }
  }

  String get label {
    switch (this) {
      case InterventionType.installation:
        return 'Installation';
      case InterventionType.depannage:
        return 'Dépannage';
      case InterventionType.entretien:
        return 'Entretien';
      case InterventionType.dimensionnement:
        return 'Dimensionnement';
      case InterventionType.maintenance:
        return 'Maintenance';
      case InterventionType.autre:
        return 'Autre';
    }
  }
}

// Ajoute ici d'autres enums (rôles, priorités, etc.) si besoin
