// lib/models/programme.dart

import 'programme_task.dart';

class Programme {
  final String id;
  final DateTime date;
  final List<ProgrammeTask> tasks;

  Programme({
    required this.id,
    required this.date,
    required this.tasks,
  });
}
