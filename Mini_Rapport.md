              Application Mobile SAMA UFR

                   Page de Garde:

Titre du Projet :  Application Mobile de Gestion Universitaire des UFR: SAMA UFR

                   Equipe de Développement :
-Fatou           Badji    badji.fatou@ugb.edu.sn          P321560  L3INFO SI
-Francois Latir  Diouf    diouf.francois-latir@ugb.edu.sn P331133  L3INFO SI
 21 Janvier 2026


                    Présentation des Fonctionnalités

L'application mobile SAMA UFR est une plateforme de gestion universitaire des UFR développée en Flutter pour les étudiants, enseignants et administrateurs de l'UFR. Les principales fonctionnalités incluent :

                    Fonctionnalités Principales :
1. **Authentification et Inscription :**
   -Connexion sécurisée via Firebase Authentication
   -Inscription avec différents rôles (étudiant, enseignant, administrateur)
   -Gestion des profils utilisateurs

2. **Interface Étudiant :**
   -Consultation des cours et ressources pédagogiques
   -Accès aux notes et résultats d'examens
   -Visualisation des événements universitaires
   -Accès aux articles et actualités

3. **Interface Enseignant :**
   -Gestion des cours et ressources
   -Publication de notes et résultats
   -Gestion des événements
   -Accès aux données administratives

4. **Interface Administrateur :**
   -Gestion complète des utilisateurs
   -Administration des événements
   -Gestion des documents officiels
   -Supervision des demandes et notifications

## Captures d'Écran :
-Page de connexion
-Page d'accueil étudiant
-Page d'accueil enseignant
-Page d'accueil administrateur
-Page des événements
-Page des notes/résultats

## Structure des Données
L'application utilise Firebase Firestore comme base de données NoSQL avec la structure suivante :

## Collections Principales :
-users : Profils des utilisateurs (étudiants, enseignants, administrateurs)
  -Champs : uid, email, firstName, lastName, role, createdAt, updatedAt
-teachers : Données spécifiques aux enseignants
-courses : Informations sur les formations/cours
-articles : Articles et ressources pédagogiques
-events : Événements universitaires
-results : Notes et résultats d'examens
-schedules : Emplois du temps
-documents : Documents officiels
-exams : Informations sur les examens
-requests : Demandes des utilisateurs
-news : Actualités de l'université
-notifications : Notifications système
-favorites : Favoris des utilisateurs

## Modèle de Données :
Chaque collection contient des documents avec des champs appropriés selon le type de données. L'application utilise des références entre collections pour maintenir la cohérence des données.

## Organisation du Code Source:
Le projet est organisé selon cette architecture :

lib/
|-- main.dart                     Point d'entrée de l'application
|-- firebase_options.dart         Configuration Firebase
|-- constant.dart                 Constantes globales
|-- LandingPage.dart              Page de redirection selon le rôle
|-- InscriptionPage.dart          Page de connexion/inscription
|-- HomePage.dart                 Page d'accueil générale
|-- login_page.dart               Page de connexion
|-- Accueil/
│   |-- main.dart                 Accueil alternatif
|-- AdminPage/                    Pages administrateur
│   |-- admin.dart
│   |-- AdminHomePage.dart
│   |-- carte.dart
│   |-- Event.dart
│   |-- resultat.dart
|-- EnsPage/                      Pages enseignant
│   |-- accueil_page.dart
│   |-- accueil.dart
│   |-- cours.dart
│   |-- EnseigantHomePage.dart
│   |-- notes.dart
│   |-- ressources.dart
|-- EtuPage/                      Pages étudiant
│   |--article.dart
│   |-- carte.dart
│   |-- detail_pages.dart
│   |-- EtuPage.dart
│   |-- event.dart
│   |-- models.dart
│   |-- more_detail_pages.dart
│   |-- resultat.dart
|-- service/                      Services métier
│   |-- admin_service.dart
│   |-- auth.dart
│   |-- firestore_service.dart
│   |-- student_service.dart
│   |-- teacher_service.dart
|-- utils/                        Utilitaires
    |-- app_colors.dart
    |-- data_initializer.dart
    |-- firebase_init.dart
    |-- firestore_complete_init.dart
    |-- firestore_initializer.dart
    |-- init_test_data.dart
                      Architecture :
-MVVM Pattern : Séparation entre logique métier (services) et interface utilisateur (pages)
-Provider : Gestion d'état pour la réactivité
-Services : Couche d'abstraction pour les appels Firebase
-Utils : Fonctions utilitaires et initialisation des données

                    Technologies Principales :
-Flutter : Framework de développement mobile cross-platform
-Dart : Langage de programmation
-Firebase :
  -Authentication: Gestion de l'authentification
  -Firestore : Base de données NoSQL
  -Core : Initialisation Firebase

                    Outils de Développement :
-Android Studio / VS Code: Environnements de développement
-Firebase Console : Gestion des services Firebase
-Git: Contrôle de version

                    Rôles des Membres de l'Équipe
Francois et Fatou :
-Responsabilités :
  -Développement de l'architecture générale de l'application
  -Implémentation de l'authentification Firebase
  -Conception et développement des interfaces utilisateur
  -Intégration de Firestore pour la gestion des données
  -Tests et débogage de l'application
  -Rédaction de la documentation technique

- **Contributions Spécifiques :**
  -Création des services Firestore (firestore_service.dart)
  -Développement des pages principales (LandingPage, InscriptionPage)
  -Implémentation de la logique de redirection par rôle
  -Configuration Firebase et initialisation des données
  -Organisation modulaire du code source
