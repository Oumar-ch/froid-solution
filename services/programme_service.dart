// lib/services/programme_service.dart

import '../models/programme_task.dart';
import 'database_service.dart';

class ProgrammeService {
  // Récupérer toutes les tâches de planning (depuis la base)
  static Future<List<ProgrammeTask>> getAllTasks() async {
    return await DataService.getProgrammeTasks();
  }

  // Ajouter une tâche
  static Future<void> addTask(ProgrammeTask task) async {
    await DataService.addProgrammeTask(task);
  }

  // Modifier une tâche
  static Future<void> updateTask(ProgrammeTask task) async {
    await DataService.updateProgrammeTask(task);
  }

  // Supprimer une tâche
  static Future<void> deleteTask(String id) async {
    await DataService.deleteProgrammeTask(id);
  }
}
