import 'package:flutter/material.dart';
import '../locale_controller.dart';

/// Écran des paramètres de l'application.
///
/// Cette page permet à l'utilisateur de configurer des options comme le
/// thème de l'application (clair/sombre) et de gérer son compte.
/// Elle est conçue comme un `StatefulWidget` pour gérer l'état local du
/// commutateur de thème, bien qu'une solution de gestion d'état globale
/// (comme Provider ou Riverpod) serait nécessaire pour appliquer le thème
/// à toute l'application.
class SettingsScreen extends StatefulWidget {
  // Aucun AppBar local à supprimer dans SettingsScreen
  /// Constructeur constant pour une meilleure performance.
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Préférences de filtres par écran (à centraliser dans un vrai modèle ou stockage persistant)
  final Map<String, Map<String, bool>> _filterPrefs = {
    'InterventionListScreen': {
      'showTypeFilter': true,
      'showStatusFilter': true,
    },
    // Ajouter d'autres écrans ici si besoin
  };

  /// Variable d'état pour contrôler la position du commutateur de thème.
  /// `true` pour le mode sombre, `false` pour le mode clair.
  bool _isDarkModeEnabled = false;

  /// Initialise l'état du widget.
  ///
  /// Nous utilisons `WidgetsBinding.instance.addPostFrameCallback` pour nous
  /// assurer que le `context` est pleinement disponible. Cela nous permet
  /// de lire la luminosité du thème actuel et d'initialiser le commutateur
  /// dans la bonne position au premier affichage de l'écran.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Détermine le mode de luminosité actuel à partir du thème de l'application.
      final Brightness platformBrightness = Theme.of(context).brightness;
      // Met à jour l'état local pour que le commutateur reflète le thème actuel.
      if (mounted) {
        setState(() {
          _isDarkModeEnabled = (platformBrightness == Brightness.dark);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Récupération des styles du thème actuel pour garantir la cohérence visuelle.
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        // ==========================================================
        // Section Langue
        // ==========================================================
        _buildSectionTitle('Langue', textTheme),
        const SizedBox(height: 8.0),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<Locale>(
              decoration: const InputDecoration(
                labelText: 'Choisir la langue',
                border: OutlineInputBorder(),
              ),
              value: LocaleController.locale.value,
              items: const [
                DropdownMenuItem(value: Locale('fr'), child: Text('Français')),
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  LocaleController.setLocale(locale);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        // ==========================================================
        // Section 1 : Apparence
        // ==========================================================
        _buildSectionTitle('Apparence', textTheme),
        const SizedBox(height: 8.0),
        Card(
          // La carte hérite automatiquement son style (coins arrondis, couleur, etc.)
          // du `cardTheme` défini dans `AppTheme`.
          child: ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Mode Sombre'),
            trailing: Switch(
              value: _isDarkModeEnabled,
              onChanged: (bool value) {
                // Met à jour l'état local lorsque le commutateur est actionné.
                setState(() {
                  _isDarkModeEnabled = value;
                });
                // NOTE : Pour une application réelle, il faudrait appeler ici
                // un gestionnaire de thème global pour changer le thème de
                // toute l'application.
                // Exemple : ThemeProvider.of(context).setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        // ==========================================================
        // Section Filtres par écran
        // ==========================================================
        _buildSectionTitle('Filtres par écran', textTheme),
        const SizedBox(height: 8.0),
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Interventions', style: textTheme.titleMedium),
              ),
              SwitchListTile(
                title: const Text('Afficher le filtre Type'),
                value:
                    _filterPrefs['InterventionListScreen']!['showTypeFilter']!,
                onChanged: (val) => setState(
                  () =>
                      _filterPrefs['InterventionListScreen']!['showTypeFilter'] =
                          val,
                ),
              ),
              SwitchListTile(
                title: const Text('Afficher le filtre Statut'),
                value:
                    _filterPrefs['InterventionListScreen']!['showStatusFilter']!,
                onChanged: (val) => setState(
                  () =>
                      _filterPrefs['InterventionListScreen']!['showStatusFilter'] =
                          val,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24.0), // Espace vertical entre les sections
        // ==========================================================
        // Section 2 : Compte
        // ==========================================================
        _buildSectionTitle('Compte', textTheme),
        const SizedBox(height: 8.0),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Notifications'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Logique de navigation vers l'écran des notifications.
                },
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  color: colorScheme
                      .error, // Couleur sémantique pour une action destructive.
                ),
                title: Text(
                  'Se déconnecter',
                  style: TextStyle(color: colorScheme.error),
                ),
                onTap: () {
                  // Logique de déconnexion de l'utilisateur.
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Widget helper pour construire un titre de section de manière cohérente.
  Widget _buildSectionTitle(String title, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: textTheme.headlineMedium?.copyWith(
          fontSize: 16, // Taille légèrement réduite pour un titre de section
        ),
      ),
    );
  }
}
