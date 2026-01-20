# 📋 Guide Complet des Collections Firestore - SAMA UFR

## 🎯 Vue d'ensemble

Ce document décrit **TOUTES les collections Firestore** créées par `firestore_complete_init.dart`.

---

## 📊 Collections créées (11 au total)

### ✅ **1. articles** - Ressources éducatives
**Usage:** Affichage d'articles, ressources, documents pédagogiques  
**Utilisé par:** `article.dart` → `getArticlesStream()`  

**Structure:**
```json
{
  "title": "Introduction à Flutter",
  "author": "Dr. Marie Sall",
  "category": "Informatique",
  "type": "PDF",
  "description": "Guide complet",
  "downloads": 42,
  "rating": 4.5,
  "publishDate": "timestamp",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "createdBy": "userId",
  "status": "published",
  "accessLevel": "students_only",
  "tags": ["flutter", "mobile", "dart"]
}
```

**Données initiales:** 3 articles

---

### ✅ **2. events** - Événements universitaires
**Usage:** Affichage d'événements, séminaires, conférences  
**Utilisé par:** `article.dart` → `getEventsStream()`  

**Structure:**
```json
{
  "title": "Session de Tutorat",
  "description": "Description",
  "date": "timestamp",
  "endDate": "timestamp",
  "duration": "14:00-16:00",
  "location": "Salle FS13",
  "organizer": "Club Informatique CI",
  "organizerId": "userId",
  "category": "Tutorat",
  "type": "academic",
  "status": "upcoming",
  "maxParticipants": 50,
  "currentParticipants": 25,
  "participants": ["userId"],
  "registrationRequired": true,
  "isFeatured": true,
  "createdAt": "timestamp",
  "createdBy": "userId"
}
```

**Données initiales:** 2 événements

---

### ✅ **3. results** - Résultats académiques ⭐ ESSENTIEL
**Usage:** Affichage des notes et résultats des étudiants  
**Utilisé par:** `article.dart` → `getStudentResults()`  

**Structure:**
```json
{
  "studentId": "userId",
  "courseName": "Mathématiques",
  "grade": 15.5,
  "status": "Valid",
  "semester": "S1",
  "year": "2025-2026",
  "professor": "Prof. Ibrahima Ba"
}
```

**Données initiales:** 5 résultats (Math, Physique, Chimie, Informatique, Anglais)

**⚠️ IMPORTANT:** `studentId` DOIT correspondre à l'UID Firebase de l'utilisateur

---

### ✅ **4. schedules** - Emploi du temps ⭐ ESSENTIEL
**Usage:** Affichage de l'emploi du temps de la semaine  
**Utilisé par:** `article.dart` → `getScheduleStream(weekStart)`  

**Structure:**
```json
{
  "studentId": "userId",
  "weekStart": "2026-01-19",
  "day": "Lundi",
  "course": "Mathématiques",
  "time": "09:00 - 11:00",
  "room": "A101",
  "professor": "Prof. Ibrahima Ba",
  "type": "Cours"
}
```

**Données initiales:** 7 schedules (Lun-Ven)

**⚠️ IMPORTANT:** 
- `studentId` DOIT correspondre à l'UID Firebase
- `weekStart` format: `YYYY-MM-DD` (lundi de la semaine)

---

### ✅ **5. documents** - Documents étudiants ⭐ ESSENTIEL
**Usage:** Attestations, relevés de notes, certificats  
**Utilisé par:** `article.dart` → `getStudentDocuments()`  

**Structure:**
```json
{
  "studentId": "userId",
  "title": "Attestation de scolarité 2025-2026",
  "description": "Document certifiant votre inscription",
  "type": "attestation",
  "fileType": "PDF",
  "issueDate": "timestamp",
  "uploadDate": "timestamp",
  "status": "available",
  "isOfficial": true,
  "canDownload": true,
  "category": "academique"
}
```

**Données initiales:** 3 documents

**⚠️ IMPORTANT:** `studentId` DOIT correspondre à l'UID Firebase

---

### 6. **users** - Profils utilisateurs
**Usage:** Stockage des informations de profil  
**Utilisé par:** Pages d'authentification et profil  

**Structure:**
```json
{
  "uid": "userId",
  "email": "student@example.com",
  "displayName": "Étudiant",
  "firstName": "Jean",
  "lastName": "Dupont",
  "role": "student",
  "department": "Informatique",
  "level": "L1",
  "semester": "S1",
  "registrationNumber": "ST2025001",
  "phoneNumber": "+221771234567",
  "profilePhoto": "",
  "bio": "Étudiant en Informatique",
  "joinDate": "timestamp",
  "lastLogin": "timestamp",
  "status": "active"
}
```

**Données initiales:** 1 profil utilisateur

---

### 7. **exams** - Examens et évaluations
**Usage:** Calendrier d'examens, informations sur les évaluations  

**Structure:**
```json
{
  "title": "Examen Mathématiques S1",
  "course": "Mathématiques",
  "date": "timestamp",
  "startTime": "09:00",
  "endTime": "11:00",
  "duration": "2h",
  "location": "Amphithéâtre Principal",
  "department": "Informatique",
  "semester": "S1",
  "year": "2025-2026",
  "examType": "written",
  "maxScore": 20,
  "passingScore": 10,
  "instructions": "Aucun document autorisé",
  "status": "scheduled",
  "isPublished": true,
  "createdAt": "timestamp"
}
```

**Données initiales:** 2 examens

---

### 8. **requests** - Demandes administratives
**Usage:** Suivi des demandes (diplômes, relevés, etc.)  

**Structure:**
```json
{
  "studentId": "userId",
  "requestType": "diploma",
  "title": "Demande de diplôme",
  "description": "Demande de diplôme de Licence",
  "requestDate": "timestamp",
  "estimatedCompletion": "15 jours",
  "status": "pending",
  "priority": "normal",
  "trackingNumber": "REQ2025001",
  "assignedTo": "admin_001"
}
```

**Données initiales:** 2 demandes

---

### 9. **news** - Actualités universitaires
**Usage:** Affichage des actualités et annonces  

**Structure:**
```json
{
  "title": "Ouverture des inscriptions",
  "content": "Les inscriptions débuteront le 15 Janvier...",
  "excerpt": "Les inscriptions débutent bientôt...",
  "author": "Direction Académique",
  "publishDate": "timestamp",
  "category": "administration",
  "targetAudience": "all",
  "status": "published",
  "isPinned": true,
  "views": 350,
  "likes": 25
}
```

**Données initiales:** 2 actualités

---

### 10. **courses** - Cours/Unités d'enseignement
**Usage:** Catalogue de cours disponibles  

**Structure:**
```json
{
  "courseId": "INF301",
  "name": "Algorithmique",
  "description": "Introduction à l'algorithmique",
  "credits": 6,
  "semester": "S1",
  "year": "2025-2026",
  "department": "Informatique",
  "professor": "Prof. Amar Diallo",
  "professorId": "userId",
  "studentsCount": 45,
  "status": "active",
  "startDate": "timestamp"
}
```

**Données initiales:** 3 cours

---

### 11. **notifications** - Notifications utilisateurs
**Usage:** Système de notifications pour les étudiants  

**Structure:**
```json
{
  "userId": "userId",
  "title": "Bienvenue!",
  "message": "Bienvenue sur la plateforme SAMA UFR",
  "type": "welcome",
  "read": false,
  "createdAt": "timestamp",
  "expiresAt": "timestamp"
}
```

**Données initiales:** 3 notifications

---

## 🚀 Comment utiliser le script

### Option 1: Initialisation automatique au démarrage

Décommente la ligne dans `main.dart`:
```dart
await FirestoreCompleteInit.initializeAllCollections();
```

Puis relance l'app:
```bash
flutter run
```

Le script affichera des logs comme:
```
🚀 Initialisation complète de Firestore pour: HunVo6IeApPfvwezakiVdMbxv7i2
============================================================
📚 Initialisation des ARTICLES...
  ✅ 3 articles ajoutés
🎉 Initialisation des ÉVÉNEMENTS...
  ✅ 2 événements ajoutés
📊 Initialisation des RÉSULTATS...
  ✅ 5 résultats ajoutés
📅 Initialisation des SCHEDULES...
  ✅ 7 schedules ajoutés pour la semaine du 2026-01-19
...
✅ INITIALISATION COMPLÈTE RÉUSSIE!
```

### Option 2: Initialisation manuelle depuis un bouton

Ajoute un bouton dans une page admin:
```dart
FloatingActionButton(
  onPressed: () async {
    await FirestoreCompleteInit.initializeAllCollections();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Données initialisées!')),
    );
  },
  child: Icon(Icons.refresh),
)
```

---

## ✅ Vérification de la configuration

Après initialisation, vérifie dans Firebase Console:

1. **Firestore Database** → Collections
2. Vérifie que ces 11 collections existent:
   - [ ] articles (3 docs)
   - [ ] events (2 docs)
   - [ ] results (5 docs)
   - [ ] schedules (7 docs)
   - [ ] documents (3 docs)
   - [ ] users (1 doc)
   - [ ] exams (2 docs)
   - [ ] requests (2 docs)
   - [ ] news (2 docs)
   - [ ] courses (3 docs)
   - [ ] notifications (3 docs)

---

## 🔐 Règles de sécurité Firestore recommandées

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Collections publiques (lecture libre)
    match /articles/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == resource.data.createdBy;
    }
    match /events/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == resource.data.organizerId;
    }
    match /news/{document=**} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    match /courses/{document=**} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    // Collections privées (utilisateur seulement)
    match /results/{document=**} {
      allow read: if request.auth.uid == resource.data.studentId;
      allow write: if false;
    }
    match /schedules/{document=**} {
      allow read: if request.auth.uid == resource.data.studentId;
      allow write: if false;
    }
    match /documents/{document=**} {
      allow read: if request.auth.uid == resource.data.studentId;
      allow write: if false;
    }
    match /requests/{document=**} {
      allow read: if request.auth.uid == resource.data.studentId;
      allow write: if request.auth.uid == resource.data.studentId;
    }
    match /notifications/{document=**} {
      allow read: if request.auth.uid == resource.data.userId;
      allow write: if false;
    }
    
    // Profil utilisateur
    match /users/{userId} {
      allow read: if request.auth.uid == userId;
      allow write: if request.auth.uid == userId;
    }
  }
}
```

---

## 📊 Statistiques des données initiales

| Collection | Documents | Utilisateur spécifique |
|------------|-----------|------------------------|
| articles | 3 | Non (partagé) |
| events | 2 | Non (partagé) |
| **results** | **5** | **OUI** ⚠️ |
| **schedules** | **7** | **OUI** ⚠️ |
| **documents** | **3** | **OUI** ⚠️ |
| users | 1 | OUI |
| exams | 2 | Non (partagé) |
| requests | 2 | OUI |
| news | 2 | Non (partagé) |
| courses | 3 | Non (partagé) |
| notifications | 3 | OUI |
| **TOTAL** | **36 documents** | - |

**⚠️ Les collections marquées nécessitent que `studentId` corresponde à l'UID Firebase!**

---

## 🐛 Dépannage

### Problème: Les données ne s'affichent pas
**Solution:**
1. Vérifie que l'utilisateur est authentifié
2. Vérifie dans Firebase Console que les collections existent
3. Vérifie que `studentId` = `user.uid` pour results/schedules/documents
4. Regarde les logs: `✅ Résultats reçus: X`

### Problème: Permission denied
**Solution:**
1. Mets à jour les règles de sécurité Firestore (voir plus haut)
2. Redéploie les règles dans Firebase Console

### Problème: Données dupliquées après exécution
**Solution:**
Le script supprime automatiquement les anciennes données avant d'ajouter les nouvelles.

---

## 📝 Notes

- ✅ Le script crée **automatiquement** les collections s'il ne sont pas créées
- ✅ Chaque execution **réinitialise** les données (utile pour les tests)
- ✅ Les `timestamp` sont générés **automatiquement** (`Timestamp.now()`)
- ✅ Le `weekStart` est calculé **automatiquement** (lundi de la semaine courante)
- ⚠️ Le `userId` utilisé est celui de l'utilisateur **actuellement connecté**

---

## 🎯 Prochaines étapes

1. ✅ Décommenter l'initialisation dans `main.dart`
2. ✅ Lancer l'app: `flutter run`
3. ✅ Vérifier les logs pour "✅ INITIALISATION COMPLÈTE RÉUSSIE!"
4. ✅ Tester l'app - tous les tableaux/événements doivent s'afficher
5. ✅ Vérifier Firestore Console pour confirmer les collections

