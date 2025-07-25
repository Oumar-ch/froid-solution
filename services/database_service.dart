// ignore_for_file: empty_catches, deprecated_member_use

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../utils/app_logger.dart';
import 'dart:ui';
import '../models/intervention_model.dart';
import '../constants/intervention_constants.dart';
import '../models/client.dart';
import '../models/programme_task.dart';
import '../models/technicien.dart';
import '../models/intervention_journalier.dart';

class DataService {
  static Future<Database> getDb() async {
    try {
      final dbPath = await getDatabasesPath();
      final db = await openDatabase(
        join(dbPath, 'froid_solution.db'),
        onCreate: (db, version) async {
          await _createTables(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          // Gestion des migrations
          if (oldVersion < 2) {
            await _upgradeToVersion2(db);
          }
          // Migration version 3 : ajout des colonnes heure, typeIntervention, equipement
          if (oldVersion < 3) {
            try {
              await db.execute(
                'ALTER TABLE programme_tasks ADD COLUMN heure TEXT',
              );
            } catch (e) {}
            try {
              await db.execute(
                'ALTER TABLE programme_tasks ADD COLUMN typeIntervention TEXT',
              );
            } catch (e) {}
            try {
              await db.execute(
                'ALTER TABLE programme_tasks ADD COLUMN equipement TEXT',
              );
            } catch (e) {}
          }
          // Migration version 4 : ajout de la table intervention_events
          if (oldVersion < 4) {
            try {
              await db.execute('''
                CREATE TABLE IF NOT EXISTS intervention_events(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  interventionId INTEGER NOT NULL,
                  eventType TEXT NOT NULL,
                  status TEXT NOT NULL,
                  eventDate TEXT NOT NULL
                )
              ''');
            } catch (e) {}
          }
          // Migration version 5 : ajout de la colonne 'date' à interventions
          if (oldVersion < 5) {
            try {
              await db.execute(
                "ALTER TABLE interventions ADD COLUMN date TEXT",
              );
            } catch (e) {}
          }
        },
        version: 5, // Passe la version à 5 pour forcer la migration
      );
      // Vérification de la présence des tables critiques
      final requiredTables = [
        'interventions',
        'clients',
        'programme_tasks',
        'techniciens',
        'interventions_journalier',
        'intervention_events',
      ];
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      );
      final existingTables = tables.map((e) => e['name']).toSet();
      bool missingTable = false;
      for (final table in requiredTables) {
        if (!existingTables.contains(table)) {
          missingTable = true;
          break;
        }
      }
      if (missingTable) {
        await _createTables(db);
      }
      return db;
    } catch (e) {
      throw Exception('Erreur lors de l\'ouverture de la base de données: $e');
    }
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE interventions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clientName TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        installationDate TEXT NOT NULL,
        completedDates TEXT,
        status TEXT NOT NULL DEFAULT 'à faire'
      )
    ''');
    await db.execute('''
      CREATE TABLE clients(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        contact TEXT NOT NULL,
        address TEXT NOT NULL,
        contratType TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE programme_tasks(
        id TEXT PRIMARY KEY,
        titre TEXT NOT NULL,
        date TEXT NOT NULL,
        client TEXT NOT NULL,
        telephone TEXT,
        adresse TEXT,
        commentaire TEXT,
        technicienId TEXT,
        heure TEXT,
        typeIntervention TEXT,
        equipement TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE interventions_journalier(
        id TEXT PRIMARY KEY,
        programmeId TEXT NOT NULL,
        heure TEXT NOT NULL,
        type TEXT NOT NULL,
        equipement TEXT NOT NULL,
        client TEXT NOT NULL,
        statut TEXT NOT NULL DEFAULT 'à faire'
      )
    ''');
    await db.execute('''
      CREATE TABLE techniciens(
        id TEXT PRIMARY KEY,
        nom TEXT NOT NULL,
        numero TEXT,
        adresse TEXT,
        habilitation TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE intervention_events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        interventionId INTEGER NOT NULL,
        eventType TEXT NOT NULL, -- 'validation', 'refus', etc.
        status TEXT NOT NULL,    -- 'validée', 'non validée', etc.
        eventDate TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _upgradeToVersion2(Database db) async {
    // Migration vers version 2 si nécessaire
    try {
      await db.execute(
        'ALTER TABLE interventions_journalier ADD COLUMN statut TEXT DEFAULT "à faire"',
      );
    } catch (e) {
      // La colonne existe déjà
    }
    // Ajout migration pour programme_tasks (heure, typeIntervention, equipement)
    try {
      await db.execute('ALTER TABLE programme_tasks ADD COLUMN heure TEXT');
    } catch (e) {}
    try {
      await db.execute(
        'ALTER TABLE programme_tasks ADD COLUMN typeIntervention TEXT',
      );
    } catch (e) {}
    try {
      await db.execute(
        'ALTER TABLE programme_tasks ADD COLUMN equipement TEXT',
      );
    } catch (e) {}
    // Ajout migration pour techniciens (numero, adresse, habilitation)
    try {
      await db.execute('ALTER TABLE techniciens ADD COLUMN numero TEXT');
    } catch (e) {}
    try {
      await db.execute('ALTER TABLE techniciens ADD COLUMN adresse TEXT');
    } catch (e) {}
    try {
      await db.execute('ALTER TABLE techniciens ADD COLUMN habilitation TEXT');
    } catch (e) {}
  }

  // --- Interventions ---
  static Future<List<Intervention>> getInterventions() async {
    try {
      AppLogger.log('Récupération des interventions', tag: 'DB');
      final db = await getDb();
      final List<Map<String, dynamic>> maps = await db.query('interventions');
      return List.generate(maps.length, (i) => Intervention.fromMap(maps[i]));
    } catch (e, st) {
      AppLogger.error(
        'Erreur lors de la récupération des interventions',
        tag: 'DB',
        error: e,
        stackTrace: st,
      );
      throw Exception('Erreur lors de la récupération des interventions: $e');
    }
  }

  static Future<void> addIntervention(Intervention intervention) async {
    try {
      final db = await getDb();
      final map = intervention.toMap();
      map.remove('id'); // Retirer l'ID pour l'auto-incrémentation
      await db.insert(
        'interventions',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'intervention: $e');
    }
  }

  static Future<void> updateIntervention(Intervention intervention) async {
    try {
      final db = await getDb();
      final result = await db.update(
        'interventions',
        intervention.toMap(),
        where: 'id = ?',
        whereArgs: [intervention.id],
      );
      if (result == 0) {
        throw Exception(
          'Aucune intervention trouvée avec l\'ID \\${intervention.id}',
        );
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'intervention: $e');
    }
  }

  static Future<void> deleteIntervention(int id) async {
    try {
      final db = await getDb();
      final result = await db.delete(
        'interventions',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result == 0) {
        debugPrint('Aucune intervention trouvée avec l\'ID $id');
        // Suppression silencieuse : ne rien faire, pas d'exception
        return;
      }
    } catch (e) {
      // Suppression silencieuse : ne jamais lever d'exception
      debugPrint('Erreur lors de la suppression de l\'intervention: $e');
      return;
    }
  }

  // ---- AJOUTER OU MODIFIER LE STATUT (validation ou non) ----
  static Future<void> setStatus(int id, String status) async {
    try {
      final db = await getDb();
      final result = await db.update(
        'interventions',
        {'status': status},
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result == 0) {
        throw Exception('Aucune intervention trouvée avec l\'ID $id');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du statut: $e');
    }
  }

  // --- Gestion des clients ---
  static Future<List<Client>> getClients() async {
    try {
      AppLogger.log('Récupération des clients', tag: 'DB');
      final db = await getDb();
      final List<Map<String, dynamic>> maps = await db.query('clients');
      return maps.map((e) => Client.fromMap(e)).toList();
    } catch (e, st) {
      AppLogger.error(
        'Erreur lors de la récupération des clients',
        tag: 'DB',
        error: e,
        stackTrace: st,
      );
      throw Exception('Erreur lors de la récupération des clients: $e');
    }
  }

  static Future<void> addClient(Client client) async {
    try {
      // Validation des données
      if (client.name.trim().isEmpty) {
        throw Exception('Le nom du client ne peut pas être vide');
      }
      if (client.contact.trim().isEmpty) {
        throw Exception('Le contact du client ne peut pas être vide');
      }
      if (client.address.trim().isEmpty) {
        throw Exception('L\'adresse du client ne peut pas être vide');
      }

      final db = await getDb();
      await db.insert(
        'clients',
        client.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du client: $e');
    }
  }

  static Future<void> deleteClient(String id) async {
    try {
      final db = await getDb();
      final result = await db.delete(
        'clients',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result == 0) {
        debugPrint('Aucun client trouvé avec l\'ID $id');
        // Suppression silencieuse : ne rien faire, pas d'exception
        return;
      }
    } catch (e) {
      // Suppression silencieuse : ne jamais lever d'exception
      debugPrint('Erreur lors de la suppression du client: $e');
      return;
    }
  }

  static Future<void> updateClient(Client client) async {
    try {
      // Validation des données - Seul le nom est obligatoire
      if (client.name.trim().isEmpty) {
        throw Exception('Le nom du client ne peut pas être vide');
      }

      final db = await getDb();
      final result = await db.update(
        'clients',
        client.toMap(),
        where: 'id = ?',
        whereArgs: [client.id],
      );
      if (result == 0) {
        throw Exception('Aucun client trouvé avec l\'ID ${client.id}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du client: $e');
    }
  }

  // --- Programme Tasks ---
  static Future<List<ProgrammeTask>> getProgrammeTasks() async {
    try {
      final db = await getDb();
      final List<Map<String, dynamic>> maps = await db.query('programme_tasks');
      return maps.map((e) => ProgrammeTask.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des tâches: $e');
    }
  }

  static Future<void> addProgrammeTask(ProgrammeTask task) async {
    try {
      // Validation des données
      if (task.titre.trim().isEmpty) {
        throw Exception('Le titre de la tâche ne peut pas être vide');
      }
      if (task.client?.trim().isEmpty ?? true) {
        throw Exception('Le client de la tâche ne peut pas être vide');
      }

      final db = await getDb();
      await db.insert(
        'programme_tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la tâche: $e');
    }
  }

  static Future<void> updateProgrammeTask(ProgrammeTask task) async {
    try {
      // Validation des données
      if (task.titre.trim().isEmpty) {
        throw Exception('Le titre de la tâche ne peut pas être vide');
      }
      if (task.client?.trim().isEmpty ?? true) {
        throw Exception('Le client de la tâche ne peut pas être vide');
      }

      final db = await getDb();
      final result = await db.update(
        'programme_tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      if (result == 0) {
        throw Exception('Aucune tâche trouvée avec l\'ID ${task.id}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la tâche: $e');
    }
  }

  static Future<void> deleteProgrammeTask(String id) async {
    try {
      final db = await getDb();
      final result = await db.delete(
        'programme_tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result == 0) {
        debugPrint('Aucune tâche trouvée avec l\'ID $id');
        // Suppression silencieuse : ne rien faire, pas d'exception
        return;
      }
    } catch (e) {
      // Suppression silencieuse : ne jamais lever d'exception
      debugPrint('Erreur lors de la suppression de la tâche: $e');
      return;
    }
  }

  // --- Techniciens ---
  static Future<List<Technicien>> getTechniciens() async {
    try {
      final db = await getDb();
      final List<Map<String, dynamic>> maps = await db.query('techniciens');
      return maps.map((e) => Technicien.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des techniciens: $e');
    }
  }

  static Future<void> addTechnicien(Technicien technicien) async {
    try {
      // Validation des données
      if (technicien.nom.trim().isEmpty) {
        throw Exception('Le nom du technicien ne peut pas être vide');
      }
      if (technicien.habilitation.trim().isEmpty) {
        throw Exception('Le niveau d\'habilitation est requis');
      }
      final db = await getDb();
      await db.insert(
        'techniciens',
        technicien.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du technicien: $e');
    }
  }

  static Future<void> updateTechnicien(Technicien technicien) async {
    try {
      if (technicien.nom.trim().isEmpty) {
        throw Exception('Le nom du technicien ne peut pas être vide');
      }
      if (technicien.habilitation.trim().isEmpty) {
        throw Exception('Le niveau d\'habilitation est requis');
      }
      final db = await getDb();
      final result = await db.update(
        'techniciens',
        technicien.toMap(),
        where: 'id = ?',
        whereArgs: [technicien.id],
      );
      if (result == 0) {
        throw Exception(
          'Aucun technicien trouvé avec l\'ID \\${technicien.id}',
        );
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du technicien: $e');
    }
  }

  static Future<void> deleteTechnicien(String id) async {
    try {
      final db = await getDb();
      final result = await db.delete(
        'techniciens',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result == 0) {
        debugPrint('Aucun technicien trouvé avec l\'ID $id');
        // Suppression silencieuse : ne rien faire, pas d'exception
        return;
      }
    } catch (e) {
      // Suppression silencieuse : ne jamais lever d'exception
      debugPrint('Erreur lors de la suppression du technicien: $e');
      return;
    }
  }

  // Ajouter une intervention du jour
  static Future<void> addInterventionDuJour(
    InterventionDuJour intervention,
  ) async {
    try {
      // Validation des données
      // Validation : type ne doit pas être InterventionType.autre
      if (intervention.type == InterventionType.autre) {
        throw Exception('Le type de l\'intervention ne peut pas être "Autre"');
      }
      if (intervention.client.trim().isEmpty) {
        throw Exception('Le client de l\'intervention ne peut pas être vide');
      }

      final db = await getDb();
      await db.insert(
        'interventions_journalier',
        intervention.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'intervention du jour: $e');
    }
  }

  // Récupérer toutes les interventions d'un programme
  static Future<List<InterventionDuJour>> getInterventionsForProgramme(
    String programmeId,
  ) async {
    try {
      final db = await getDb();
      final List<Map<String, dynamic>> maps = await db.query(
        'interventions_journalier',
        where: 'programmeId = ?',
        whereArgs: [programmeId],
      );
      return maps.map((e) => InterventionDuJour.fromMap(e)).toList();
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération des interventions du programme: $e',
      );
    }
  }

  // Supprimer une intervention du jour
  static Future<void> deleteInterventionDuJour(String id) async {
    try {
      final db = await getDb();
      final result = await db.delete(
        'interventions_journalier',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result == 0) {
        debugPrint('Aucune intervention du jour trouvée avec l\'ID $id');
        // Suppression silencieuse : ne rien faire, pas d'exception
        return;
      }
    } catch (e) {
      // Suppression silencieuse : ne jamais lever d'exception
      debugPrint(
        'Erreur lors de la suppression de l\'intervention du jour: $e',
      );
      return;
    }
  }

  // --- Intervention Events ---
  static Future<void> addInterventionEvent({
    required int interventionId,
    required String eventType,
    required String status,
    required DateTime eventDate,
  }) async {
    final db = await getDb();
    await db.insert('intervention_events', {
      'interventionId': interventionId,
      'eventType': eventType,
      'status': status,
      'eventDate': eventDate.toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getInterventionEvents(
    int interventionId,
  ) async {
    final db = await getDb();
    return await db.query(
      'intervention_events',
      where: 'interventionId = ?',
      whereArgs: [interventionId],
      orderBy: 'eventDate DESC',
    );
  }

  // Méthodes utilitaires pour vérifier l'intégrité des données
  static Future<bool> checkDatabaseIntegrity() async {
    try {
      final db = await getDb();
      final result = await db.rawQuery('PRAGMA integrity_check');
      return result.first['integrity_check'] == 'ok';
    } catch (e) {
      return false;
    }
  }

  // Méthode pour sauvegarder les données
  static Future<void> backupDatabase() async {
    try {
      final db = await getDb();
      final dbPath = await getDatabasesPath();
      final backupPath = join(dbPath, 'froid_solution_backup.db');

      // Créer une copie de la base de données
      await db.rawQuery('VACUUM INTO ?', [backupPath]);
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde: $e');
    }
  }

  // Méthode pour compter les enregistrements
  static Future<Map<String, int>> getRecordCounts() async {
    try {
      final db = await getDb();
      final counts = <String, int>{};

      final tables = [
        'interventions',
        'clients',
        'programme_tasks',
        'techniciens',
        'interventions_journalier',
      ];

      for (final table in tables) {
        final result = await db.rawQuery(
          'SELECT COUNT(*) as count FROM $table',
        );
        counts[table] = result.first['count'] as int;
      }

      return counts;
    } catch (e) {
      throw Exception('Erreur lors du comptage des enregistrements: $e');
    }
  }

  /// Ajoute des interventions de test pour visualiser les graphiques
  static Future<void> addFakeInterventions() async {
    final now = DateTime.now();
    final fakeList = [
      Intervention(
        id: '1',
        date: now.subtract(const Duration(days: 10)),
        type: InterventionType.maintenance,
        description: 'Entretien annuel',
        status: InterventionStatus.validee,
        clientName: 'Client A',
        installationDate: now.subtract(const Duration(days: 10)),
      ),
      Intervention(
        id: '2',
        date: now.subtract(const Duration(days: 3)),
        type: InterventionType.depannage,
        description: 'Panne compresseur',
        status: InterventionStatus.aFaire,
        clientName: 'Client B',
        installationDate: now.subtract(const Duration(days: 3)),
      ),
      Intervention(
        id: '3',
        date: now.subtract(const Duration(days: 1)),
        type: InterventionType.installation,
        description: 'Pose nouvelle chambre froide',
        status: InterventionStatus.enRetard,
        clientName: 'Client C',
        installationDate: now.subtract(const Duration(days: 1)),
      ),
      // Intervention critique de test (urgente et en retard)
      Intervention(
        id: '4',
        date: now.subtract(const Duration(days: 5)),
        type: InterventionType.maintenance,
        description: 'Test intervention urgente',
        status: InterventionStatus.urgent,
        clientName: 'Client Critique',
        installationDate: now.subtract(const Duration(days: 5)),
      ),
    ];
    for (final i in fakeList) {
      await addIntervention(i);
    }
  }

  /// Supprime les interventions de test critiques (statut 'urgent', 'en retard' ou client 'Client Critique')
  static Future<void> deleteFakeCriticalInterventions() async {
    try {
      final db = await getDb();
      await db.delete(
        'interventions',
        where: "status = ? OR status = ? OR clientName = ?",
        whereArgs: ['urgent', 'en retard', 'Client Critique'],
      );
    } catch (e) {
      debugPrint(
        'Erreur lors de la suppression des interventions de test critiques: $e',
      );
    }
  }
}

// Widget utilitaire pour effet glassmorphism
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  const GlassCard({
    required this.child,
    this.borderRadius = 18,
    this.blur = 18,
    this.opacity = 0.18,
    this.margin,
    this.padding,
    this.elevation = 2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: Colors.white.withOpacity(isDark ? opacity * 1.5 : opacity),
      elevation: elevation,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.2,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
