#!/bin/bash

# Script de vérification Firestore
# Ce script teste si toutes les collections sont accessibles

echo "🔍 Test Firestore Collections"
echo "=============================="
echo ""

# Vérifier que Firebase CLI est installé
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI n'est pas installé"
    echo "Installation: npm install -g firebase-tools"
    exit 1
fi

echo "✅ Firebase CLI trouvé"
echo ""

# Lister les collections
echo "📋 Collections dans Firestore:"
echo ""

echo "1️⃣ Collection 'articles'"
firebase firestore:inspect "articles" 2>/dev/null || echo "   ⚠️  Collection vide ou non trouvée"
echo ""

echo "2️⃣ Collection 'events'"
firebase firestore:inspect "events" 2>/dev/null || echo "   ⚠️  Collection vide ou non trouvée"
echo ""

echo "3️⃣ Collection 'results'"
firebase firestore:inspect "results" 2>/dev/null || echo "   ⚠️  Collection vide ou non trouvée"
echo ""

echo "4️⃣ Collection 'schedules'"
firebase firestore:inspect "schedules" 2>/dev/null || echo "   ⚠️  Collection vide ou non trouvée"
echo ""

echo "5️⃣ Collection 'documents'"
firebase firestore:inspect "documents" 2>/dev/null || echo "   ⚠️  Collection vide ou non trouvée"
echo ""

echo "✅ Test complet!"
echo ""
echo "💡 Conseils:"
echo "  - Si une collection est vide, la remplir avec des données"
echo "  - Utiliser data_initializer.dart pour initialiser les données"
echo "  - Vérifier les règles de sécurité Firestore"
echo ""
