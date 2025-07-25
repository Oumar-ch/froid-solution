# Guide de Tests Manuels - Crash VSync

## Instructions pour effectuer les tests

### Étape 1: Lancer l'application
```bash
cd "C:\Users\xxxx\3D Objects\froid_solution_service_technique"
flutter run --debug
```

### Étape 2: Accéder aux tests
1. Ouvrir l'application
2. Aller dans l'écran "CLIENTELLE"
3. Cliquer sur le bouton orange "🧪 TESTS DE CRASH"

### Étape 3: Effectuer les tests dans l'ordre

#### TEST 0: Dialog Minimal (PURPLE)
- **But** : Tester uniquement la fermeture automatique
- **Action** : Cliquer sur "TEST 0: Dialog minimal fermeture"
- **Résultat attendu** : Le dialogue se ferme automatiquement après 100ms
- **Si crash** : Le problème vient de la fermeture automatique de dialogues

#### TEST 1: Dialog Isolé (ORANGE)
- **But** : Simulation de sauvegarde sans base de données
- **Action** : Cliquer sur "TEST 1: Dialog isolé (pas de DB)"
- **Résultat attendu** : Simulation d'1 seconde + fermeture automatique
- **Si crash** : Le problème vient de la logique d'attente + fermeture

#### TEST 2: Dialog Sans Fermeture Auto (BLUE)
- **But** : Vraie sauvegarde en base sans fermeture automatique
- **Action** : Cliquer sur "TEST 2: Édition sans fermeture auto"
- **Étapes** :
  1. Modifier le nom du client
  2. Cliquer "Sauvegarder"
  3. Attendre le message "Sauvegardé avec succès !"
  4. Cliquer "Fermer après succès" OU "Fermer manuellement"
- **Si crash après sauvegarde** : Le problème vient des opérations de base de données
- **Si crash après fermeture manuelle** : Le problème vient de la fermeture elle-même

#### TEST 3: Dialog Complet (RED) - CRASH ATTENDU
- **But** : Test complet qui crash actuellement
- **Action** : Cliquer sur "TEST 3: Édition avec fermeture auto (CRASH)"
- **Résultat attendu** : Crash avec erreur VSync

### Étape 4: Analyser les résultats

#### Scénario A: TEST 0 crash
- **Conclusion** : Problème Flutter Windows avec fermeture automatique
- **Solution** : Utiliser seulement fermeture manuelle

#### Scénario B: TEST 1 crash
- **Conclusion** : Problème avec la logique de délai
- **Solution** : Modifier la méthode de fermeture (microtask, différé, etc.)

#### Scénario C: TEST 2 crash pendant sauvegarde
- **Conclusion** : Problème avec sqflite/base de données
- **Solution** : Modifier database_service.dart ou changer de base de données

#### Scénario D: TEST 2 crash après fermeture manuelle
- **Conclusion** : Problème général avec fermeture de dialogues
- **Solution** : Utiliser Navigator differently ou changer d'approche

#### Scénario E: Seul TEST 3 crash
- **Conclusion** : Problème avec combinaison DB + fermeture auto
- **Solution** : Séparer sauvegarde et fermeture avec un délai plus long

### Étape 5: Logs à observer
Regarder la console pour ces messages :
- `🧪 LANCEMENT TEST X`
- `🔧 Dialog - Début sauvegarde`
- `🔧 Dialog - Avant/Après ClientService.updateClient`
- `🔧 Dialog - Fermeture dialog`
- Erreur VSync crash

### Fichiers à restaurer après tests
Si vous voulez revenir à l'écran d'édition original :
1. Modifier `lib/screens/clientele_screen.dart`
2. Remplacer `NoCloseEditDialog` par l'import de `edit_client_screen.dart`
3. Remplacer l'appel dialog par navigation vers écran complet

### Prochaines étapes selon résultats
1. **Tests 0-1 OK, 2-3 crash** : Problème base de données
2. **Test 0 crash** : Problème fermeture automatique Flutter Windows
3. **Tous crash** : Problème général Flutter Windows desktop
4. **Seul TEST 3 crash** : Problème timing sauvegarde + fermeture
