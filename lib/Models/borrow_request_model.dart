import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowRequestModel {
  final String id;
  final String bookId;
  final String bookTitle;
  final String requesterId;
  final String requesterName;
  final String requesterEmail;
  final String requesterPhone;
  final String ownerId;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime createdAt;
  final DateTime? respondedAt;

  BorrowRequestModel({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.requesterId,
    required this.requesterName,
    required this.requesterEmail,
    required this.requesterPhone,
    required this.ownerId,
    required this.status,
    required this.createdAt,
    this.respondedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'requesterEmail': requesterEmail,
      'requesterPhone': requesterPhone,
      'ownerId': ownerId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'respondedAt':
          respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
    };
  }

  factory BorrowRequestModel.fromMap(Map<String, dynamic> map, String docId) {
    return BorrowRequestModel(
      id: docId,
      bookId: map['bookId'] ?? '',
      bookTitle: map['bookTitle'] ?? '',
      requesterId: map['requesterId'] ?? '',
      requesterName: map['requesterName'] ?? '',
      requesterEmail: map['requesterEmail'] ?? '',
      requesterPhone: map['requesterPhone'] ?? '',
      ownerId: map['ownerId'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      respondedAt: map['respondedAt'] != null
          ? (map['respondedAt'] as Timestamp).toDate()
          : null,
    );
  }
}
