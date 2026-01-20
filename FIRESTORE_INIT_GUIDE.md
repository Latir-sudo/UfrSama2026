# 📚 Guide d'Initialisation Firestore - SAMA UFR

## Vue d'ensemble

Ce guide explique comment initialiser Firestore avec toutes les collections et données de test nécessaires pour l'application SAMA UFR.

## Collections créées

### 1. **users**
Contient les profils utilisateurs (étudiants, enseignants, administrateurs).

**Champs:**
- `name` (String): Nom de l'utilisateur
- `email` (String): Email
- `role` (String): 'etudiant', 'enseignant', ou 'admin'
- `status` (String): 'Active' ou 'Inactive'
- `createdAt` (Timestamp): Date de création

### 2. **courses**
Contient les formations/programmes académiques.

**Champs:**
- `name` (String): Nom de la formation
- `code` (String): Code de la formation
- `ufr` (String): UFR responsable
- `level` (String): Niveaux (L1, L2, L3, M1, M2)
- `studentCount` (Integer): Nombre d'étudiants
- `status` (String): 'Active' ou 'Inactive'
- `teacherId` (String): ID du professeur responsable (optionnel)
- `createdAt` (Timestamp): Date de création

### 3. **articles**
Contient les articles et actualités pour étudiants.

**Champs:**
- `title` (String): Titre de l'article
- `content` (String): Contenu
- `category` (String): Catégorie
- `date` (Timestamp): Date de publication
- `author` (String): Auteur
- `views` (Integer): Nombre de vues
- `createdAt` (Timestamp): Date de création

### 4. **events**
Contient les événements du campus.

**Champs:**
- `title` (String): Titre de l'événement
- `description` (String): Description
- `date` (Timestamp): Date et heure
- `location` (String): Lieu
- `category` (String): Type d'événement
- `attendees` (Integer): Nombre de participants attendus
- `createdAt` (Timestamp): Date de création

### 5. **results**
Contient les résultats d'examens des étudiants.

**Champs:**
- `studentId` (String): UID de l'étudiant
- `courseName` (String): Nom du cours
- `grade` (Double): Note obtenue
- `status` (String): 'Validé' ou 'Non validé'
- `credits` (Integer): Crédits obtenus
- `date` (Timestamp): Date du résultat
- `createdAt` (Timestamp): Date de création

### 6. **schedules**
Contient l'emploi du temps des étudiants.

**Champs:**
- `studentId` (String): UID de l'étudiant
- `course` (String): Nom du cours
- `day` (String): Jour de la semaine
- `time` (String): Horaire (format: HH:MM - HH:MM)
- `room` (String): Salle/Lieu
- `professor` (String): Nom du professeur
- `weekStart` (String): Début de semaine (format: YYYY-MM-DD)
- `createdAt` (Timestamp): Date de création

### 7. **documents**
Contient les documents officiels.

**Champs:**
- `title` (String): Titre du document
- `type` (String): Type (PDF, Word, etc.)
- `size` (Integer): Taille en bytes
- `uploadDate` (Timestamp): Date de téléchargement
- `uploadedBy` (String): Email du responsable
- `createdAt` (Timestamp): Date de création

### 8. **exams**
Contient les examens programmés.

**Champs:**
- `course` (String): Nom du cours
- `date` (Timestamp): Date et heure
- `time` (String): Horaire
- `location` (String): Lieu
- `duration` (Integer): Durée en minutes
- `coefficient` (Integer): Coefficient de l'examen
- `createdAt` (Timestamp): Date de création

### 9. **requests**
Contient les demandes des étudiants.

**Champs:**
- `studentName` (String): Nom de l'étudiant
- `type` (String): Type de demande
- `description` (String): Description
- `status` (String): 'Approuvé', 'En cours', 'Rejeté'
- `requestDate` (Timestamp): Date de la demande
- `createdAt` (Timestamp): Date de création

### 10. **news**
Contient les actualités du campus.

**Champs:**
- `title` (String): Titre
- `content` (String): Contenu
- `date` (Timestamp): Date de publication
- `priority` (String): 'high', 'medium', 'low'
- `createdAt` (Timestamp): Date de création

### 11. **notifications**
Contient les notifications pour les utilisateurs.

**Champs:**
- `userId` (String): UID du destinataire
- `title` (String): Titre
- `message` (String): Message
- `type` (String): Type de notification
- `read` (Boolean): Statut de lecture
- `createdAt` (Timestamp): Date de création

## Options d'initialisation

### Option 1: Automatique au démarrage (Recommandé)

Le `main.dart` est déjà configuré pour appeler l'initialisation:

```dart
import 'package:sama_ufr/utils/firestore_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialiser TOUTES les collections Firestore
  await FirestoreInitializer().initializeAllCollections();

  runApp(const MyApp());
}
```

**Avantages:**
- Automatique et facile
- Données créées lors du premier lancement
- Ne recrée pas si déjà existantes

### Option 2: Bouton administrateur

Ajouter un bouton dans AdminPage pour réinitialiser les données:

```dart
// Dans AdminPage
ElevatedButton(
  onPressed: () async {
    await FirestoreInitializer().initializeAllCollections();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Données réinitialisées'))
    );
  },
  child: Text('Réinitialiser Firestore'),
)
```

### Option 3: CLI script (pour développement)

Créer un script Dart autonome:

```bash
dart lib/utils/firestore_initializer.dart
```

## Services disponibles

### AdminService
Récupère les données administratives:

```dart
final adminService = AdminService();

// Statistiques
final stats = await adminService.getUsersStatistics();
print('Étudiants: ${stats['students']}');

// Formations
final formations = await adminService.getFormations();

// Utilisateurs
final users = await adminService.getUsersList();

// Documents officiels
final docs = await adminService.getOfficialDocuments();

// Flux en temps réel
adminService.getUsersStream().listen((users) {
  print('Utilisateurs mis à jour: ${users.length}');
});
```

### TeacherService
Récupère les données enseignant:

```dart
final teacherService = TeacherService();

// Cours du professeur
final courses = await teacherService.getTeacherCourses();

// Notes pour un cours
final grades = await teacherService.getCourseGrades(courseId);

// Ressources pédagogiques
final resources = await teacherService.getTeachingResources();

// Flux en temps réel
teacherService.getTeacherCoursesStream().listen((courses) {
  print('Cours mis à jour: ${courses.length}');
});
```

### StudentService
Récupère les données étudiant (existant):

```dart
final studentService = StudentService();

// Résultats
final results = await studentService.getStudentResults();

// Emploi du temps
final schedule = studentService.getScheduleStream();

// Articles
final articles = studentService.getArticlesStream();
```

## Vérification des données

Pour vérifier que les données sont correctement créées:

1. **Console Firebase:**
   - Aller à [Firebase Console](https://console.firebase.google.com)
   - Sélectionner votre projet
   - Aller à Firestore Database
   - Vérifier que toutes les collections apparaissent

2. **Logs de l'application:**
   ```
   🔄 FirestoreInit: Démarrage de l'initialisation des collections...
   ✅ 5 utilisateurs créés
   ✅ 4 formations créées
   ✅ 3 articles créés
   ...
   🔄 FirestoreInit: ✅ Initialisation complète réussie!
   ```

3. **Affichage dans l'appli:**
   - Articles s'affichent dans la page d'accueil
   - Résultats et emploi du temps apparaissent
   - Événements sont visibles
   - Navigation fonctionne vers les pages détail

## Troubleshooting

### Erreur: "Pas d'utilisateur connecté"
**Solution:** Assurez-vous d'être connecté avant de démarrer l'app. Les données utilisateur spécifiques (résultats, emploi du temps) nécessitent un utilisateur connecté.

### Les collections existent déjà mais sont vides
**Solution:** L'initialisation ne recrée pas les collections existantes. Supprimer manuellement la collection dans Firebase Console, puis relancer l'app.

### Les données ne s'affichent pas dans l'UI
**Solution:** 
1. Vérifier dans Firebase Console que les données existent
2. Vérifier les logs pour les erreurs Firestore
3. Vérifier que les noms de collections correspondent entre le service et l'initializer

## Performance

- **Batches:** L'initialisation utilise Firestore Batches pour écrire jusqu'à 500 documents en une seule transaction
- **Limite:** Les requêtes utilisent `.limit()` pour éviter de charger trop de données
- **Timeouts:** Les futures incluent des timeouts de 30 secondes
- **Indexation:** Firestore crée automatiquement les index nécessaires

## Prochaines étapes

1. ✅ Exécuter l'initialisation (automatique au démarrage)
2. ✅ Vérifier les données dans Firebase Console
3. ✅ Tester l'app et naviguer entre les pages
4. 🔄 Ajuster les données de test si nécessaire
5. 🔄 Configurer les règles de sécurité Firestore

## Fichiers associés

- `lib/utils/firestore_initializer.dart` - Script d'initialisation
- `lib/service/admin_service.dart` - Services administrateur
- `lib/service/teacher_service.dart` - Services enseignant
- `lib/service/student_service.dart` - Services étudiant (existant)
- `lib/main.dart` - Point d'entrée avec initialisation

---

**Note:** Les données de test utilisent des noms et emails fictifs. Pour la production, adapter les données selon vos besoins réels.
