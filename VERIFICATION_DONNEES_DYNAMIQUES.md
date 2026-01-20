# Vérification - Données Dynamiques Firestore

## ✅ STATUT ACTUEL

### Article Page (lib/EtuPage/article.dart)
- **Événements**: ✅ Dynamiques - `widget.studentService.getEventsStream()`
- **Résultats**: ✅ Dynamiques - `widget.studentService.getStudentResults()`
- **Emploi du temps**: ✅ Dynamiques - `widget.studentService.getScheduleStream(weekStart)`
- **Articles**: ✅ Dynamiques - `widget.studentService.getArticlesStream(category)`
- **Documents**: ✅ Dynamiques - `widget.studentService.getStudentDocuments()`

### StudentService (lib/service/student_service.dart)
Toutes les méthodes utilisent Firestore:
- ✅ `getArticlesStream()` → collection 'articles'
- ✅ `getEventsStream()` → collection 'events'
- ✅ `getStudentResults()` → collection 'results'
- ✅ `getScheduleStream()` → collection 'schedules'
- ✅ `getStudentDocuments()` → collection 'documents'

---

## 📋 COLLECTIONS FIRESTORE REQUISES

Assurez-vous que ces collections existent dans Firebase Console:

### 1. **articles**
```json
{
  "id": "doc_id",
  "title": "Titre",
  "author": "Auteur",
  "category": "Informatique|Mathématiques|Physique|Développement Mobile",
  "type": "PDF|Word|...",
  "downloads": 245,
  "rating": 4.8,
  "publishDate": "2024-01-19T10:00:00Z",
  "description": "Description",
  "createdAt": "timestamp",
  "createdBy": "userId",
  "status": "published",
  "accessLevel": "public|students_only"
}
```

### 2. **events**
```json
{
  "id": "doc_id",
  "title": "Titre événement",
  "description": "Description",
  "date": "2024-01-25T10:00:00Z",
  "duration": "2h",
  "location": "Salle 204",
  "organizer": "Club Informatique",
  "organizerId": "userId",
  "category": "Conférence|Atelier|Sport|Culture",
  "status": "upcoming",
  "maxParticipants": 100,
  "currentParticipants": 45,
  "participants": ["userId1", "userId2"],
  "createdAt": "timestamp",
  "createdBy": "userId"
}
```

### 3. **results**
```json
{
  "id": "doc_id",
  "studentId": "userId",
  "courseName": "Algorithmique",
  "grade": 15.5,
  "status": "validé|échoué|en attente",
  "createdAt": "timestamp",
  "semester": "S1",
  "courseId": "ALGO101"
}
```

### 4. **schedules**
```json
{
  "id": "doc_id",
  "studentId": "userId",
  "weekStart": "2024-01-15",
  "day": "Lundi|Mardi|Mercredi|Jeudi|Vendredi",
  "course": "Algorithmique",
  "time": "10h-12h",
  "room": "Fs12",
  "type": "Cours|TD|TP",
  "teacher": "Dr. Dupont",
  "createdAt": "timestamp"
}
```

### 5. **documents**
```json
{
  "id": "doc_id",
  "studentId": "userId",
  "title": "Relevé de notes",
  "description": "Relevé du semestre 1",
  "fileUrl": "https://...",
  "fileType": "PDF|Word",
  "uploadedAt": "timestamp",
  "category": "academique|administratif|..."
}
```

---

## 🔍 COMMENT VÉRIFIER QUE TOUT EST DYNAMIQUE

### Test 1: Ajouter un document Firestore
1. Aller dans Firebase Console
2. Ajouter un document à la collection "events"
3. Relancer l'app et vérifier que le nouvel événement apparaît

### Test 2: Modifier un document
1. Modifier un titre d'événement dans Firebase
2. Vérifier que le changement est reflété en temps réel dans l'app

### Test 3: Supprimer un document
1. Supprimer un résultat dans Firebase
2. Vérifier que le résultat disparaît de l'app

### Test 4: Vérifier les erreurs Firestore
1. Mettre un breakpoint dans la console Dart
2. Ouvrir Logcat/Console
3. Chercher "Erreur articles:", "Erreur résultats:", etc.

---

## 🚀 DÉPLOIEMENT

### Avant de déployer:
- [ ] Tous les documents Firestore sont créés
- [ ] Les règles de sécurité Firestore sont configurées
- [ ] Les indexes Firestore sont créés (si nécessaire)
- [ ] Les données de test sont correctes

### Commandes utiles:

#### Initialiser les données de test:
```dart
// Dans main.dart, appelez une fois:
import 'package:sama_ufr/utils/data_initializer.dart';

// Au démarrage:
await DataInitializer.initializeData(userId);
```

#### Vérifier les règles Firestore:
```
service cloud.firestore {
  match /databases/{database}/documents {
    match /articles/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == resource.data.createdBy;
    }
    match /events/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == resource.data.organizerId;
    }
    match /results/{document=**} {
      allow read: if request.auth.uid == resource.data.studentId;
      allow write: if request.auth.uid == resource.data.studentId;
    }
    match /schedules/{document=**} {
      allow read: if request.auth.uid == resource.data.studentId;
      allow write: if request.auth.uid == resource.data.studentId;
    }
    match /documents/{document=**} {
      allow read, write: if request.auth.uid == resource.data.studentId;
    }
  }
}
```

---

## 📊 RÉSUMÉ DYNAMIQUE

| Données | Source | Status |
|---------|--------|--------|
| Articles | Firestore collection 'articles' | ✅ Dynamique |
| Événements | Firestore collection 'events' | ✅ Dynamique |
| Résultats | Firestore collection 'results' | ✅ Dynamique |
| Emploi du temps | Firestore collection 'schedules' | ✅ Dynamique |
| Documents | Firestore collection 'documents' | ✅ Dynamique |
| Statistiques | Firestore document 'users/{uid}/stats' | ✅ Dynamique |
| Profil | Firestore document 'users/{uid}' | ✅ Dynamique |

---

## 🔧 DÉPANNAGE

### Les données ne s'affichent pas?
1. Vérifier que l'utilisateur est authentifié
2. Vérifier que les documents existent dans Firestore
3. Vérifier les règles de sécurité Firestore
4. Vérifier la console pour les erreurs: "Erreur récupération..."

### Les données mettent du temps à charger?
1. Ajouter `.limit()` dans les requêtes (déjà fait)
2. Créer des indexes Firestore
3. Réduire la taille des documents
4. Utiliser la pagination pour les grandes listes

### Les mutations ne sont pas reflétées?
1. Vérifier que `snapshots()` est utilisé (streaming)
2. Vérifier les règles de sécurité pour les écritures
3. S'assurer que `studentId` correspond au UID de l'utilisateur

---

## 📚 RESSOURCES

- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/start)
- [Flutter Firebase](https://firebase.flutter.dev/)
