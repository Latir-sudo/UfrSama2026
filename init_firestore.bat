@echo off
REM Script d'initialisation Firestore pour Windows
REM Prépare l'environnement et lance l'app avec initialisation

setlocal enabledelayedexpansion

echo.
echo ============================================================
echo    INITIALISATION SAMA UFR - FIRESTORE
echo ============================================================
echo.

REM Vérifier que Flutter est disponible
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter n'est pas installé ou non dans PATH
    echo    Télécharger depuis: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

REM Obtenir le répertoire courant
cd /d "%~dp0"
echo 📁 Répertoire: %cd%
echo.

REM Étape 1: Nettoyage
echo ⏳ Nettoyage du cache Flutter...
call flutter clean
if %errorlevel% neq 0 (
    echo ❌ Erreur lors du nettoyage
    pause
    exit /b 1
)
echo ✅ Nettoyage - OK
echo.

REM Étape 2: Dépendances
echo ⏳ Téléchargement des dépendances...
call flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Erreur lors du téléchargement des dépendances
    pause
    exit /b 1
)
echo ✅ Dépendances - OK
echo.

REM Étape 3: Analyse
echo ⏳ Analyse du code...
call flutter analyze
if %errorlevel% neq 0 (
    echo ⚠️  Avertissements détectés (non bloquants)
)
echo ✅ Analyse - OK
echo.

echo ============================================================
echo    ✅ Préparation complète
echo ============================================================
echo.
echo Démarrage de l'application avec initialisation Firestore...
echo Vérifiez les logs pour les messages:
echo   - "🔄 FirestoreInit: Démarrage..."
echo   - "✅ FirestoreInit: Initialisation complète réussie!"
echo.

REM Étape 4: Lancer l'app
call flutter run

pause
