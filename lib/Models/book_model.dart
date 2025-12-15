import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final String ownerUid;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final bool isAvailable;
  final String? borrowerUid;
  final String? borrowerName;
  final DateTime createdAt;
  final List<String> imageUrls;
  final int pendingRequestsCount;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.ownerUid,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    this.isAvailable = true,
    this.borrowerUid,
    this.borrowerName,
    required this.createdAt,
    this.imageUrls = const [],
    this.pendingRequestsCount = 0,
  });

  // Convert BookModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'ownerUid': ownerUid,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'isAvailable': isAvailable,
      'borrowerUid': borrowerUid,
      'borrowerName': borrowerName,
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrls': imageUrls,
      'pendingRequestsCount': pendingRequestsCount,
    };
  }

  // Create BookModel from Firestore document
  factory BookModel.fromMap(Map<String, dynamic> map, String docId) {
    return BookModel(
      id: docId,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      description: map['description'] ?? '',
      ownerUid: map['ownerUid'] ?? '',
      ownerName: map['ownerName'] ?? '',
      ownerPhone: map['ownerPhone'] ?? '',
      ownerEmail: map['ownerEmail'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      borrowerUid: map['borrowerUid'],
      borrowerName: map['borrowerName'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      pendingRequestsCount: map['pendingRequestsCount'] ?? 0,
    );
  }
}
