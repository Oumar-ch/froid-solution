import 'screens/main_navigation.dart';

import 'package:flutter/material.dart';
// ...existing code...
import 'theme/app_theme.dart';
import 'screens/intervention_form.dart';
import 'models/intervention_model.dart';
import 'constants/intervention_constants.dart';
import 'services/database_service.dart';
import 'services/client_service.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'locale_controller.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  LocaleController.loadLocale().then((_) {
    runApp(const MyApp());
  });
}

/// Le widget racine de l'application.
///
/// `MyApp` est un `StatelessWidget` car sa configuration (thème, routes)
/// est définie à l'initialisation et ne change pas pendant l'exécution.
/// Il configure le `MaterialApp`, qui fournit les fonctionnalités de base
/// nécessaires à la plupart des applications (navigation, thèmes, etc.).
class MyApp extends StatelessWidget {
  // Utilitaire pour récupérer les noms des clients
  Future<List<String>> _getClientNames() async {
    try {
      final clients = await ClientService().getClients();
      return clients.map((c) => c.name).toList();
    } catch (_) {
      return [];
    }
  }

  /// Constructeur constant pour une meilleure performance de build.
  /// Flutter peut ainsi mettre en cache et réutiliser ce widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleController.locale,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'Dashboard Applicatif',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          locale: locale,
          home: MainNavigation(onToggleTheme: () {}, isDark: false),
          routes: {
            '/add_intervention': (context) => FutureBuilder<List<String>>(
              future: _getClientNames(),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return NeonInterventionForm(
                  clients: snapshot.data!,
                  onSubmit:
                      ({
                        required String client,
                        required String type,
                        required String description,
                        required DateTime installationDate,
                      }) async {
                        final typeEnum = InterventionType.values.firstWhere(
                          (e) => e.label == type,
                          orElse: () => InterventionType.autre,
                        );
                        final statusEnum = InterventionStatus.values.firstWhere(
                          (e) => e.label == 'À faire',
                          orElse: () => InterventionStatus.aFaire,
                        );
                        await DataService.addIntervention(
                          Intervention(
                            id: '',
                            date: DateTime.now(),
                            type: typeEnum,
                            description: description,
                            status: statusEnum,
                            clientName: client,
                            installationDate: installationDate,
                          ),
                        );
                        Navigator.of(context).pop(true);
                      },
                );
              },
            ),
          },
          // ...existing code...
        );
      },
    );
  }
}
