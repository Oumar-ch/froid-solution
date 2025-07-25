@echo off
echo 🔧 RÉSOLUTION PROBLÈME COMPILATION C++ WINDOWS
echo.

echo 📋 Étape 1: Nettoyage complet...
flutter clean
if exist build rmdir /s /q build
if exist .dart_tool rmdir /s /q .dart_tool

echo.
echo 📋 Étape 2: Récupération des dépendances...
flutter pub get

echo.
echo 📋 Étape 3: Tentative de compilation...
flutter build windows --debug

echo.
echo 📋 Étape 4: Si l'erreur persiste, essayez:
echo    - Redémarrer l'ordinateur
echo    - Fermer tous les processus Visual Studio
echo    - Utiliser "flutter run --no-hot-reload"

echo.
echo ✅ Script terminé. Vérifiez les messages ci-dessus.
pause
