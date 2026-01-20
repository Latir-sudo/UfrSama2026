#!/usr/bin/env python3
"""
Script de création des collections Firestore
Exécute l'initialisation Firestore via Flutter
"""

import subprocess
import sys
import os

def init_firestore():
    """Initialiser les collections Firestore"""
    
    print("=" * 60)
    print("🔄 Initialisation des collections Firestore")
    print("=" * 60)
    
    # Vérifier que Flutter est installé
    try:
        subprocess.run(['flutter', '--version'], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("❌ Flutter n'est pas installé ou non trouvé dans PATH")
        return False
    
    # Obtenir le répertoire du projet
    project_dir = os.path.dirname(os.path.abspath(__file__))
    
    print(f"\n📁 Répertoire du projet: {project_dir}")
    
    # Étapes d'initialisation
    steps = [
        ("Nettoyage du cache Flutter", ['flutter', 'clean']),
        ("Téléchargement des dépendances", ['flutter', 'pub', 'get']),
        ("Analyse du code", ['flutter', 'analyze']),
    ]
    
    for step_name, command in steps:
        print(f"\n⏳ {step_name}...")
        try:
            result = subprocess.run(
                command,
                cwd=project_dir,
                capture_output=False,
                timeout=300
            )
            if result.returncode != 0:
                print(f"❌ Erreur lors de: {step_name}")
                return False
            print(f"✅ {step_name} - OK")
        except subprocess.TimeoutExpired:
            print(f"⏱️  Timeout lors de: {step_name}")
            return False
        except Exception as e:
            print(f"❌ Erreur: {e}")
            return False
    
    print("\n" + "=" * 60)
    print("⏭️  Prêt pour flutter run")
    print("=" * 60)
    print("\nCommande pour démarrer l'app:")
    print("  flutter run")
    print("\nL'initialisation Firestore se fera automatiquement au démarrage.")
    print("Vérifiez les logs pour:")
    print("  ✅ FirestoreInit messages")
    print("=" * 60)
    
    return True

def main():
    """Point d'entrée principal"""
    success = init_firestore()
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()
