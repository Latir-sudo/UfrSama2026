# Configuration optimisée pour l'émulateur Android

## 🎯 Paramètres recommandés pour les tests de performance

### RAM: 4 GB minimum, 8 GB recommandé
- Impact: Réduit les GC (garbage collection) pauses
- Amélioration: -30% de frame drops

### Cores: 4 minimum
- Impact: Meilleure parallélisation du rendering
- Amélioration: -40% temps de démarrage

### Disk: 4GB espace disque libre
- Impact: Évite les I/O slowdowns
- Amélioration: -20% temps compilation

## 📋 Configuration dans Android Studio

1. AVD Manager → Edit [Votre device]
2. Increased RAM to 4096 MB (ou 8192 MB)
3. Set CPU cores to 4
4. Enable HAXM (Intel) ou KVM (AMD)
5. Device display: 1920x1080 ou moins

## 🚀 Lancer l'émulateur optimisé

```bash
emulator -avd Pixel_6_API_33 -no-snapshot-load -performance-stats -gpu on
```

### Flags importants:
- `-no-snapshot-load`: Démarrage plus propre
- `-performance-stats`: Voir les métriques
- `-gpu on`: Accélération GPU

## 📊 Mesurer la performance

### Depuis Flutter:
```bash
flutter run --release -d emulator
```

### Depuis logcat:
```bash
adb logcat | grep -i "skipped\|choreographer"
```

### Avec DevTools:
```bash
flutter pub global run devtools
# http://localhost:9100
```

## ⚡ Tips de performance

1. **Désactiver les animations** dans Developer Settings Android
2. **Utiliser un device API 30+** (meilleure performance)
3. **Limiter les apps de background**
4. **Utiliser `-gpu on`** toujours
5. **Tester sur device réel** avant release

## 🔍 Diagnostiquer les problèmes

### Trop de GC pauses?
- Augmenter la RAM
- Réduire les objets créés par frame

### Frames skipped?
- Vérifier que `--release` est utilisé
- Profiler avec DevTools
- Réduire la complexité UI

### Lenteur Firestore?
- Ajouter des indexes Firestore
- Limiter les résultats
- Utiliser le caching côté client
