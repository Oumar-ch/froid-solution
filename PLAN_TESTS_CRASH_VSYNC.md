# Plan de Tests Systématiques - Crash VSync

## Problème Identifié
L'application crash systématiquement avec l'erreur VSync :
```
../../../flutter/shell/platform/embedder/embedder.cc (3240): 'FlutterEngineOnVsync' returned 'kInternalInconsistency'. Could not notify the running engine instance of a Vsync event.
Lost connection to device.
```

## Hypothèses
1. **Fermeture automatique du dialogue** : Le crash se produit lors de `Navigator.of(context).pop()`
2. **Opérations de base de données** : Le crash se produit lors de `ClientService().updateClient()`
3. **Combinaison des deux** : Le crash se produit lors de l'interaction entre sauvegarde DB + fermeture dialogue
4. **Problème Flutter Windows** : Bug spécifique à l'engine Flutter sur Windows desktop

## Tests Créés

### TEST 0: Dialog Minimal (minimal_test_dialog.dart)
- **But** : Tester uniquement la fermeture automatique d'un dialogue
- **Contenu** : Pas de base de données, juste fermeture après délai
- **Attendu** : Si crash → problème avec fermeture automatique

### TEST 1: Dialog Isolé (test_crash_dialog.dart)
- **But** : Tester dialogue avec simulation de sauvegarde (pas de vraie DB)
- **Contenu** : Simulation d'attente + fermeture automatique
- **Attendu** : Si crash → problème avec fermeture, si pas crash → problème avec DB

### TEST 2: Dialog Sans Fermeture (no_close_edit_dialog.dart)
- **But** : Tester sauvegarde vraie en base sans fermeture automatique
- **Contenu** : Vraie sauvegarde DB + fermeture manuelle seulement
- **Attendu** : Si crash → problème avec DB, si pas crash → problème avec fermeture auto

### TEST 3: Dialog Simple avec Fermeture (simple_edit_dialog.dart)
- **But** : Test complet (DB + fermeture auto) - celui qui crash actuellement
- **Contenu** : Sauvegarde DB + fermeture automatique après délai
- **Attendu** : Crash confirmé

## Protocole de Test
1. Lancer l'application
2. Aller dans Clientèle
3. Cliquer sur "🧪 TESTS DE CRASH"
4. Effectuer les tests dans l'ordre : 0, 1, 2, 3
5. Noter à quel moment précis le crash se produit

## Résultats Attendus
- **TEST 0 crash** : Problème Flutter Windows avec fermeture automatique de dialogues
- **TEST 1 crash** : Problème avec la logique de délai/attente
- **TEST 2 crash** : Problème avec les opérations de base de données
- **TEST 3 seul crash** : Problème avec la combinaison DB + fermeture auto

## Solutions Potentielles Selon les Résultats
- **Si TEST 0 crash** : Utiliser fermeture manuelle ou différée avec microtask
- **Si TEST 2 crash** : Problème avec sqflite sur Windows, utiliser transactions ou timeouts
- **Si seul TEST 3 crash** : Séparer sauvegarde DB et fermeture dialogue

## Fichiers Créés/Modifiés
- `lib/screens/minimal_test_dialog.dart` - Test 0
- `lib/screens/test_crash_dialog.dart` - Test 1  
- `lib/screens/no_close_edit_dialog.dart` - Test 2
- `lib/screens/simple_edit_dialog.dart` - Test 3 (existant)
- `lib/screens/crash_test_screen.dart` - Interface de test
- `lib/screens/clientele_screen.dart` - Bouton d'accès aux tests

## État Actuel
- Tous les fichiers de test créés
- Application en cours de lancement pour tests
- Tests prêts à être exécutés systématiquement
