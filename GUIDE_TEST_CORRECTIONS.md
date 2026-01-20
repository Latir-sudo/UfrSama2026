# Guide de Test - Vérification des Corrections

## ✅ Étapes pour tester l'application

### 1. **Recompilation du projet**
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### 2. **Lancer le hot reload**
```bash
flutter run
```

### 3. **Vérifier la console Flutter**
- ❌ Il ne doit PAS y avoir d'erreurs de type cast
- ❌ Il ne doit PAS y avoir d'erreurs "undefined method"
- ✅ Les logs doivent montrer les erreurs Firestore (si existantes)

## 📋 Points de test spécifiques

### A. Écran de chargement
**Comportement attendu:**
- ✅ L'écran affiche un indicateur de chargement
- ✅ Après 2-5 secondes (selon la connexion), le contenu apparaît
- ❌ L'écran NE DOIT PAS rester bloqué indéfiniment

### B. Section "Mes résultats"
**Conditions d'affichage:**
- ✅ S'affiche si `_results` n'est pas vide
- ✅ Le tableau affiche: Matière | Note | Statut
- ✅ Les notes sont affichées avec 2 décimales (ex: 15.50)
- ❌ Les anciens noms de champs (matiere, note, statu) ne doivent PAS être utilisés

### C. Section "Mon emploi du temps"
**Conditions d'affichage:**
- ✅ S'affiche si `_schedules` n'est pas vide
- ✅ Le tableau affiche: Jour | Matière | Heure | Salle
- ❌ Les anciens noms de champs (jour, matiere, heure, salle) ne doivent PAS être utilisés

### D. Gestion d'erreurs
**À observer dans la console:**
- ✅ Messages d'erreur detaillés (ex: "Erreur articles: <raison>")
- ✅ L'application continue à fonctionner même si une source de données échoue
- ✅ Le bouton refresh permet de réessayer

### E. Conditions sans données
**Comportement attendu:**
- ✅ Si pas d'articles: la section n'apparaît pas (mais pas d'erreur)
- ✅ Si pas de résultats: la section n'apparaît pas (mais pas d'erreur)
- ✅ Autres sections affichent toujours (Forum, Actualités, Stats, etc.)

## 🔍 Vérification Firestore

### Avant de tester, assurez-vous que:

#### 1. Collection 'results'
```json
{
  "studentId": "uid_de_l_utilisateur",
  "courseName": "Algorithmique",      // ✅ IMPORTANT: courseName (pas matiere)
  "grade": 15.5,                      // ✅ IMPORTANT: grade (pas note)
  "status": "validé"                  // ✅ IMPORTANT: status (pas statu)
}
```

#### 2. Collection 'schedules'
```json
{
  "studentId": "uid_de_l_utilisateur",
  "day": "Lundi",                     // ✅ IMPORTANT: day (pas jour)
  "course": "Algorithmique",          // ✅ IMPORTANT: course (pas matiere)
  "time": "10h-12h",                  // ✅ IMPORTANT: time (pas heure)
  "room": "Fs12",                     // ✅ IMPORTANT: room (pas salle)
  "weekStart": "2026-01-19"
}
```

#### 3. Collection 'documents'
```json
{
  "studentId": "uid_de_l_utilisateur",
  "title": "Relevé de notes",
  "description": "Semestre 1 2025-2026"
}
```

#### 4. Collection 'articles'
```json
{
  "title": "Introduction à Flutter",
  "author": "John Doe",
  "category": "Informatique",
  "type": "PDF",
  "downloads": 42,
  "rating": 4.5,
  "publishDate": Timestamp
}
```

#### 5. Collection 'events'
```json
{
  "title": "Masterclass IA",
  "description": "Conférence sur l'IA",
  "date": Timestamp (future),
  "duration": "2h",
  "location": "Amphi B",
  "organizer": "Club CI",
  "category": "Conférence"
}
```

## 🐛 Débogage avancé

### Si l'écran reste bloqué:
```dart
// Ajouter des logs dans _initData():
print('🔵 Chargement articles...');
print('🔵 Chargement événements...');
print('🔵 Chargement emploi du temps...');
print('🔵 Chargement documents...');
print('🔵 Chargement résultats...');
```

### Si les données n'apparaissent pas:
1. **Vérifier studentId:**
   - Ouvrir Firebase Console
   - Chercher l'UID de l'utilisateur
   - Vérifier que `studentId` dans Firestore = `user.uid`

2. **Vérifier les conditions d'affichage:**
   - Utiliser `print(_results.length)` pour vérifier
   - Vérifier que les modèles désérialisent correctement

3. **Vérifier les règles Firestore:**
   ```
   match /results/{document=**} {
     allow read, write: if request.auth.uid == resource.data.studentId;
   }
   ```

### Logs utiles à chercher:
```
// ✅ Bon signe:
Erreur articles: Network error - but data was loaded

// ❌ Mauvais signe:
Erreur articles: [cloud_firestore/permission-denied]
Erreur résultats: [firebase_core/not-initialized]
```

## 📊 Checklist finale

- [ ] L'application démarre sans erreur
- [ ] Le splash loading disparaît après 2-5 secondes
- [ ] Au moins une section de contenu s'affiche
- [ ] Les tableaux de résultats et emploi du temps affichent les données correctement
- [ ] Les noms de colonne sont en français et corrects
- [ ] Le bouton refresh fonctionne
- [ ] Pas de message d'erreur "undefined method" ou "undefined property"
- [ ] La console ne montre pas de crashes
- [ ] Le code compile sans avertissements d'imports inutilisés

## 🚀 Déploiement

Une fois tous les tests réussis:
```bash
flutter build apk      # Pour Android
flutter build ios      # Pour iOS
```

---

**Note:** Si vous trouvez d'autres erreurs, consultez l'[Analyse détaillée](./ANALYSE_ERREURS_CORRECTION.md)
