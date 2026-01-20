# Guide d'Initialisation des Données Firestore

## 🚀 Initialiser les données de test dans Firestore

Il y a déjà un fichier `data_initializer.dart` qui contient les données de test. Voici comment l'utiliser:

### Option 1: Initialiser automatiquement au premier démarrage

Modifiez `main.dart`:

```dart
import 'package:sama_ufr/utils/data_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialiser les données de test
  final user = FirebaseAuth.instance.currentUser;
  if (user != null && /* première fois */) {
    await DataInitializer.initializeData(user.uid);
  }
  
  runApp(const MyApp());
}
```

### Option 2: Initialiser manuellement via Firebase Console

1. **Aller dans Firebase Console** → Firestore Database
2. **Créer les collections manuellement:**
   - articles
   - events
   - results
   - schedules
   - documents
   - users

3. **Ajouter des documents de test**

### Option 3: Utiliser le script d'initialisation

1. Connectez-vous à Firebase CLI:
```bash
firebase login
```

2. Sélectionnez le projet:
```bash
firebase use --add
```

3. Déployez les données (à faire en Dart):
```dart
// Appelé une fois au démarrage
await DataInitializer.initializeData(userId);
```

---

## 📊 Structure de données attendue

### Articles (collection 'articles')
- Chaque article doit avoir: title, author, category, type, downloads, rating, publishDate
- Catégories supportées: Informatique, Mathématiques, Physique, Développement Mobile

### Événements (collection 'events')
- Chaque événement doit avoir: title, description, date, duration, location, organizer, category
- Categories: Conférence, Atelier, Sport, Culture
- La date doit être ≥ à aujourd'hui (filtrée dans le service)

### Résultats (collection 'results')
- Chaque résultat doit avoir: studentId, courseName, grade, status
- studentId doit correspondre au UID Firebase de l'utilisateur
- Status: "validé", "échoué", "en attente"

### Emploi du temps (collection 'schedules')
- Chaque horaire doit avoir: studentId, weekStart, day, course, time, room
- weekStart format: "YYYY-MM-DD"
- Days: Lundi, Mardi, Mercredi, Jeudi, Vendredi

### Documents (collection 'documents')
- Chaque document doit avoir: studentId, title, description, fileUrl
- studentId doit correspondre au UID Firebase de l'utilisateur

---

## ✅ Checklist de configuration

- [ ] Collection 'articles' créée et peuplée
- [ ] Collection 'events' créée et peuplée
- [ ] Collection 'results' créée et peuplée (avec votre studentId)
- [ ] Collection 'schedules' créée et peuplée (avec votre studentId)
- [ ] Collection 'documents' créée et peuplée (avec votre studentId)
- [ ] Collection 'users' créée avec profil utilisateur
- [ ] Règles de sécurité Firestore configurées
- [ ] Indexes Firestore créés (si nécessaire)

---

## 🔐 Règles de Sécurité Firestore

Allez dans Firestore Console → Règles et appliquez:

```
service cloud.firestore {
  match /databases/{database}/documents {
    // Permet à tous les utilisateurs authentifiés de lire les articles
    match /articles/{document=**} {
      allow read: if request.auth != null;
      allow write: if false;  // Modification par admin seulement
    }

    // Permet à tous les utilisateurs authentifiés de lire les événements
    match /events/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == resource.data.organizerId;
    }

    // Permet à chaque étudiant de lire ses résultats
    match /results/{document=**} {
      allow read: if request.auth.uid == resource.data.studentId;
      allow write: if false;  // Modification par admin seulement
    }

    // Permet à chaque étudiant de lire son emploi du temps
    match /schedules/{document=**} {
      allow read: if request.auth.uid == resource.data.studentId;
      allow write: if false;  // Modification par admin seulement
    }

    // Permet à chaque utilisateur de gérer ses documents
    match /documents/{document=**} {
      allow read, write: if request.auth.uid == resource.data.studentId;
    }

    // Profil utilisateur
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}
```

---

## 🧪 Tester l'intégration

### Test 1: Vérifier que les données se chargent
1. Démarrer l'app: `flutter run --release`
2. Vérifier que les événements, résultats et emploi du temps s'affichent
3. Si rien n'apparaît, vérifier la console pour les erreurs Firestore

### Test 2: Vérifier que les modifications sont reflétées
1. Ajouter un événement dans Firebase Console
2. Vérifier qu'il apparaît dans l'app en temps réel (max 2 secondes)

### Test 3: Vérifier les permissions
1. Créer un autre utilisateur
2. Vérifier qu'il ne voit que ses propres résultats/documents

---

## 🐛 Dépannage

### "Erreur articles: PERMISSION_DENIED"
- Vérifier les règles de sécurité Firestore
- S'assurer que l'utilisateur est authentifié

### "Les données ne se mettent pas à jour"
- Vérifier que `snapshots()` est utilisé (streaming)
- Vérifier la connexion réseau
- Vérifier que les documents ont bien changé dans Firebase

### "Les données ne s'affichent pas du tout"
- Vérifier que les collections existent
- Vérifier que les documents ont les bonnes clés
- Vérifier que `studentId` correspond au UID de l'utilisateur

---

## 📞 Support

Si vous avez des problèmes:
1. Vérifiez la console Dart pour les erreurs
2. Vérifiez Firebase Console → Firestore
3. Vérifiez les règles de sécurité
4. Vérifiez la structure des documents
