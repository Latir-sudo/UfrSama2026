#!/bin/bash

# Script d'optimisation et build pour Sama UFR
# Usage: chmod +x build_optimized.sh && ./build_optimized.sh

echo "🚀 Sama UFR - Build Optimisé"
echo "=============================="

# Nettoyer les builds précédentes
echo "🧹 Nettoyage des builds précédentes..."
flutter clean

# Mettre à jour les dépendances
echo "📦 Mise à jour des dépendances..."
flutter pub get

# Analyser le code pour les problèmes
echo "🔍 Analyse du code..."
flutter analyze

# Builder en mode release
echo "🔨 Compilation en mode release..."
flutter build apk --release --split-per-abi

# Afficher les tailles
echo ""
echo "📊 Taille des APKs générés:"
ls -lh build/app/outputs/apk/release/

echo ""
echo "✅ Build terminé avec succès!"
echo ""
echo "📱 Pour installer l'APK:"
echo "   adb install build/app/outputs/apk/release/app-release.apk"
echo ""
echo "🧪 Pour tester la performance:"
echo "   flutter run --release"
