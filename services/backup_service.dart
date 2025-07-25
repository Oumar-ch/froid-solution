import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_service.dart';
import '../config/app_config.dart';

class BackupService {
  static String get backupPath => AppConfig.isProduction
      ? '/storage/emulated/0/FroidSolutions/backups/'
      : '/storage/emulated/0/FroidSolutionsDev/backups/';
  // Créer une sauvegarde automatique
  static Future<String> createBackup() async {
    try {
      final db = await DataService.getDb();
      final documentsDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${documentsDir.path}/backups');

      // Créer le dossier de sauvegarde s'il n'existe pas
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final backupPath = '${backupDir.path}/backup_$timestamp.db';

      // Copier la base de données
      await db.close();
      final dbPath = await getDatabasesPath();
      final sourceFile = File(join(dbPath, 'froid_solution.db'));

      if (await sourceFile.exists()) {
        await sourceFile.copy(backupPath);
      }

      return backupPath;
    } catch (e) {
      throw Exception('Erreur lors de la création de la sauvegarde: $e');
    }
  }

  // Restaurer une sauvegarde
  static Future<void> restoreBackup(String backupPath) async {
    try {
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        throw Exception('Fichier de sauvegarde non trouvé');
      }

      final dbPath = await getDatabasesPath();
      final targetPath = join(dbPath, 'froid_solution.db');

      // Fermer la base de données actuelle
      final db = await DataService.getDb();
      await db.close();

      // Copier la sauvegarde
      await backupFile.copy(targetPath);
    } catch (e) {
      throw Exception('Erreur lors de la restauration: $e');
    }
  }

  // Lister les sauvegardes disponibles
  static Future<List<FileSystemEntity>> listBackups() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${documentsDir.path}/backups');

      if (!await backupDir.exists()) {
        return [];
      }

      final files = await backupDir.list().toList();
      return files.where((file) => file.path.endsWith('.db')).toList();
    } catch (e) {
      throw Exception('Erreur lors de la liste des sauvegardes: $e');
    }
  }

  // Supprimer les anciennes sauvegardes (garder seulement les 5 dernières)
  static Future<void> cleanOldBackups() async {
    try {
      final backups = await listBackups();
      if (backups.length > 5) {
        // Trier par date de modification
        backups.sort(
          (a, b) => File(
            a.path,
          ).lastModifiedSync().compareTo(File(b.path).lastModifiedSync()),
        );

        // Supprimer les plus anciennes
        for (int i = 0; i < backups.length - 5; i++) {
          await backups[i].delete();
        }
      }
    } catch (e) {
      throw Exception('Erreur lors du nettoyage des sauvegardes: $e');
    }
  }

  // Sauvegarde automatique programmée
  static Future<void> scheduleAutoBackup() async {
    try {
      await createBackup();
      await cleanOldBackups();
    } catch (e) {
      // Log l'erreur mais ne pas faire planter l'application
      // En production, remplacer par un système de log approprié
      throw Exception('Erreur lors de la sauvegarde automatique: $e');
    }
  }

  // Exporter les données au format JSON
  static Future<String> exportToJson() async {
    try {
      final db = await DataService.getDb();
      final documentsDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final exportPath = '${documentsDir.path}/export_$timestamp.json';

      // Récupérer toutes les données
      final interventions = await db.query('interventions');
      final clients = await db.query('clients');
      final programmeTasks = await db.query('programme_tasks');
      final techniciens = await db.query('techniciens');
      final interventionsJournalier = await db.query(
        'interventions_journalier',
      );

      final exportData = {
        'timestamp': DateTime.now().toIso8601String(),
        'interventions': interventions,
        'clients': clients,
        'programme_tasks': programmeTasks,
        'techniciens': techniciens,
        'interventions_journalier': interventionsJournalier,
      };

      final exportFile = File(exportPath);
      await exportFile.writeAsString(exportData.toString());

      return exportPath;
    } catch (e) {
      throw Exception('Erreur lors de l\'export JSON: $e');
    }
  }

  // Vérifier l'intégrité des données
  static Future<Map<String, dynamic>> checkDataIntegrity() async {
    try {
      final db = await DataService.getDb();
      final integrity = <String, dynamic>{};

      // Vérifier l'intégrité de la base de données
      final pragmaResult = await db.rawQuery('PRAGMA integrity_check');
      integrity['database'] = pragmaResult.first['integrity_check'] == 'ok';

      // Compter les enregistrements
      final counts = await DataService.getRecordCounts();
      integrity['counts'] = counts;

      // Vérifier les références orphelines
      final orphanedInterventions = await db.rawQuery('''
        SELECT COUNT(*) as count FROM interventions 
        WHERE clientName NOT IN (SELECT name FROM clients)
      ''');
      integrity['orphaned_interventions'] =
          orphanedInterventions.first['count'];

      return integrity;
    } catch (e) {
      throw Exception('Erreur lors de la vérification d\'intégrité: $e');
    }
  }
}
