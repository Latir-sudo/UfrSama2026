import 'package:cloud_firestore/cloud_firestore.dart';

/// =======================
/// ARTICLE
/// =======================
class ArticleModel {
  final String id;
  final String title;
  final String author;
  final String category;
  final String type;
  final int downloads;
  final double rating;
  final DateTime publishDate;
  final String? description;

  ArticleModel({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.type,
    required this.downloads,
    required this.rating,
    required this.publishDate,
    this.description,
  });

  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ArticleModel(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      category: data['category'] ?? '',
      type: data['type'] ?? 'PDF',
      downloads: (data['downloads'] ?? 0).toInt(),
      rating: (data['rating'] ?? 0.0).toDouble(),
      publishDate:
          (data['publishDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      description: data['description'],
    );
  }
}

/// =======================
/// EVENT
/// =======================
class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String duration;
  final String location;
  final String organizer;
  final String category;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.location,
    required this.organizer,
    required this.category,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      duration: data['duration'] ?? '',
      location: data['location'] ?? '',
      organizer: data['organizer'] ?? '',
      category: data['category'] ?? '',
    );
  }
}

/// =======================
/// COURSE RESULT
/// =======================
class CourseResult {
  final String id;
  final String courseName;
  final double grade;
  final String status;

  CourseResult({
    required this.id,
    required this.courseName,
    required this.grade,
    required this.status,
  });

  factory CourseResult.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CourseResult(
      id: doc.id,
      courseName: data['courseName'] ?? '',
      grade: (data['grade'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'en cours',
    );
  }
}

/// =======================
/// SCHEDULE
/// =======================
class Schedule {
  final String id;
  final String day;
  final String course;
  final String time;
  final String room;

  Schedule({
    required this.id,
    required this.day,
    required this.course,
    required this.time,
    required this.room,
  });

  factory Schedule.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Schedule(
      id: doc.id,
      day: data['day'] ?? '',
      course: data['course'] ?? '',
      time: data['time'] ?? '',
      room: data['room'] ?? '',
    );
  }
}

/// =======================
/// USER PROFILE
/// =======================
class UserProfile {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String role;

  UserProfile({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      role: data['role'] ?? 'student',
    );
  }
}

/// =======================
/// STUDENT STATS
/// =======================
class StudentStats {
  final double averageGrade;
  final int validatedCourses;
  final int totalCredits;
  final int rank;

  StudentStats({
    required this.averageGrade,
    required this.validatedCourses,
    required this.totalCredits,
    required this.rank,
  });

  factory StudentStats.fromFirestore(Map<String, dynamic> data) {
    return StudentStats(
      averageGrade: (data['averageGrade'] ?? 0.0).toDouble(),
      validatedCourses: (data['validatedCourses'] ?? 0).toInt(),
      totalCredits: (data['totalCredits'] ?? 0).toInt(),
      rank: (data['rank'] ?? 0).toInt(),
    );
  }
}

/// =======================
/// NEWS
/// =======================
class NewsModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final List<String> tags;
  final String author;
  final DateTime publishDate;
  final int views;
  final bool isPublished;
  final String? imageUrl;
  final String? pdfUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.tags,
    required this.author,
    required this.publishDate,
    required this.views,
    required this.isPublished,
    this.imageUrl,
    this.pdfUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return NewsModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? 'Général',
      tags: List<String>.from(data['tags'] ?? []),
      author: data['author'] ?? 'Administration',

      publishDate:
          (data['publishDate'] as Timestamp?)?.toDate() ?? DateTime.now(),

      views: (data['views'] ?? 0).toInt(),
      isPublished: data['isPublished'] ?? false,
      imageUrl: data['imageUrl'],
      pdfUrl: data['pdfUrl'],

      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'tags': tags,
      'author': author,
      'publishDate': Timestamp.fromDate(publishDate),
      'views': views,
      'isPublished': isPublished,
      'imageUrl': imageUrl,
      'pdfUrl': pdfUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
