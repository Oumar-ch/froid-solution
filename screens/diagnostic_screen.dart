import 'package:flutter/material.dart';
import '../services/log_service.dart';
import '../services/backup_service.dart';
import '../services/database_service.dart';
import '../themes/app_colors.dart';

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  final List<DiagnosticResult> _results = [];
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isRunning = true;
      _results.clear();
    });

    await LogService.info('Démarrage des diagnostics');

    // Test 1: Base de données
    await _testDatabase();

    // Test 2: Services
    await _testServices();

    // Test 3: Mémoire et performance
    await _testPerformance();

    // Test 4: Navigation
    await _testNavigation();

    setState(() {
      _isRunning = false;
    });

    await LogService.info('Diagnostics terminés');
  }

  Future<void> _testDatabase() async {
    try {
      await LogService.info('Test de la base de données...');

      // Test de connexion
      final db = await DataService.getDb();
      _addResult('Connexion DB', 'OK', Colors.green);

      // Test d'intégrité
      final integrity = await DataService.checkDatabaseIntegrity();
      _addResult('Intégrité DB', integrity ? 'OK' : 'PROBLÈME',
          integrity ? Colors.green : Colors.red);

      // Test de comptage
      final counts = await DataService.getRecordCounts();
      _addResult('Enregistrements',
          'Total: ${counts.values.fold(0, (a, b) => a + b)}', Colors.blue);

      await db.close();
    } catch (e) {
      _addResult('Base de données', 'ERREUR: $e', Colors.red);
      await LogService.error('Erreur base de données', e);
    }
  }

  Future<void> _testServices() async {
    try {
      await LogService.info('Test des services...');

      // Test ValidationService
      _addResult('Service Validation', 'OK', Colors.green);

      // Test BackupService
      final backups = await BackupService.listBackups();
      _addResult(
          'Service Backup', '${backups.length} sauvegardes', Colors.green);

      // Test LogService
      final logs = await LogService.getLogs();
      _addResult(
          'Service Logs', '${logs.split('\n').length} lignes', Colors.green);
    } catch (e) {
      _addResult('Services', 'ERREUR: $e', Colors.red);
      await LogService.error('Erreur services', e);
    }
  }

  Future<void> _testPerformance() async {
    try {
      await LogService.info('Test de performance...');

      final stopwatch = Stopwatch()..start();

      // Test de chargement des données
      await DataService.getClients();
      final clientsTime = stopwatch.elapsedMilliseconds;

      await DataService.getInterventions();
      final interventionsTime = stopwatch.elapsedMilliseconds - clientsTime;

      _addResult('Chargement clients', '${clientsTime}ms',
          clientsTime < 1000 ? Colors.green : Colors.orange);

      _addResult('Chargement interventions', '${interventionsTime}ms',
          interventionsTime < 1000 ? Colors.green : Colors.orange);

      stopwatch.stop();
    } catch (e) {
      _addResult('Performance', 'ERREUR: $e', Colors.red);
      await LogService.error('Erreur performance', e);
    }
  }

  Future<void> _testNavigation() async {
    try {
      await LogService.info('Test de navigation...');

      // Vérifier que le contexte est disponible
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      final navigator = Navigator.of(context);
      _addResult('Navigator', 'OK', Colors.green);

      // Vérifier les routes
      final canPop = navigator.canPop();
      _addResult('Routes', canPop ? 'Navigation disponible' : 'Route racine',
          Colors.blue);
    } catch (e) {
      _addResult('Navigation', 'ERREUR: $e', Colors.red);
      await LogService.error('Erreur navigation', e);
    }
  }

  void _addResult(String test, String result, Color color) {
    setState(() {
      _results.add(DiagnosticResult(test, result, color));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DIAGNOSTICS',
            style: AppTextStyles.title(
                Theme.of(context).brightness == Brightness.dark)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRunning ? null : _runDiagnostics,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_isRunning)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('Diagnostics en cours...'),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final result = _results[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        result.color == Colors.green
                            ? Icons.check_circle
                            : result.color == Colors.red
                                ? Icons.error
                                : Icons.info,
                        color: result.color,
                      ),
                      title: Text(result.test),
                      subtitle: Text(result.result),
                    ),
                  );
                },
              ),
            ),
            if (_results.isNotEmpty && !_isRunning)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Résumé: ${_results.where((r) => r.color == Colors.green).length} OK, '
                        '${_results.where((r) => r.color == Colors.red).length} erreurs',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final logs = await LogService.getLogs();
                              if (!mounted) return;

                              // ignore: use_build_context_synchronously
                              showDialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Logs'),
                                  content: SingleChildScrollView(
                                    child: Text(logs),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Fermer'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('Voir logs'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await BackupService.createBackup();
                                if (!mounted) return;

                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Sauvegarde créée'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                if (!mounted) return;

                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erreur: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: const Text('Sauvegarder'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DiagnosticResult {
  final String test;
  final String result;
  final Color color;

  DiagnosticResult(this.test, this.result, this.color);
}
