import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';
import '../models/user_model.dart';
import '../models/borrow_request_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new book
  Future<String?> addBook({
    required String title,
    required String author,
    required String description,
    required UserModel owner,
    List<String> imageUrls = const [],
  }) async {
    try {
      DocumentReference docRef = await _firestore.collection('books').add({
        'title': title,
        'author': author,
        'description': description,
        'ownerUid': owner.uid,
        'ownerName': owner.name,
        'ownerPhone': owner.phone,
        'ownerEmail': owner.email,
        'isAvailable': true,
        'borrowerUid': null,
        'createdAt': FieldValue.serverTimestamp(),
        'imageUrls': imageUrls,
      });

      // Update the document with its own ID
      await docRef.update({'id': docRef.id});

      return null; // Success
    } catch (e) {
      return 'Error adding book: $e';
    }
  }

  // Get all available books (excluding user's own books)
  Stream<List<BookModel>> getAvailableBooks(String currentUserUid) {
    return _firestore
        .collection('books')
        .where('isAvailable', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BookModel.fromMap(doc.data(), doc.id))
          .where((book) => book.ownerUid != currentUserUid)
          .toList();
    });
  }

  // Get user's own books
  Stream<List<BookModel>> getUserBooks(String userUid) {
    return _firestore
        .collection('books')
        .where('ownerUid', isEqualTo: userUid)
        .snapshots()
        .map((snapshot) {
      final books = snapshot.docs.map((doc) {
        return BookModel.fromMap(doc.data(), doc.id);
      }).toList();
      books.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return books;
    });
  }

  // Get borrowed books
  Stream<List<BookModel>> getBorrowedBooks(String userUid) {
    return _firestore
        .collection('books')
        .where('borrowerUid', isEqualTo: userUid)
        .snapshots()
        .map((snapshot) {
      final books = snapshot.docs.map((doc) {
        return BookModel.fromMap(doc.data(), doc.id);
      }).toList();
      books.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return books;
    });
  }

  // Create a borrow request
  Future<String?> createBorrowRequest({
    required String bookId,
    required String bookTitle,
    required String ownerId,
    required UserModel requester,
  }) async {
    try {
      // Check if user already has a pending request for this book
      final existingRequest = await _firestore
          .collection('borrow_requests')
          .where('bookId', isEqualTo: bookId)
          .where('requesterId', isEqualTo: requester.uid)
          .where('status', isEqualTo: 'pending')
          .get();

      if (existingRequest.docs.isNotEmpty) {
        return 'You already have a pending request for this book';
      }

      // Create new request
      DocumentReference docRef =
          await _firestore.collection('borrow_requests').add({
        'bookId': bookId,
        'bookTitle': bookTitle,
        'requesterId': requester.uid,
        'requesterName': requester.name,
        'requesterEmail': requester.email,
        'requesterPhone': requester.phone,
        'ownerId': ownerId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'respondedAt': null,
      });

      await docRef.update({'id': docRef.id});

      // Update book's pending request count
      await _updateBookRequestCount(bookId);

      return null; // Success
    } catch (e) {
      return 'Error creating borrow request: $e';
    }
  }

  // Get pending requests for a book
  Stream<List<BorrowRequestModel>> getBookRequests(String bookId) {
    return _firestore
        .collection('borrow_requests')
        .where('bookId', isEqualTo: bookId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      final requests = snapshot.docs
          .map((doc) => BorrowRequestModel.fromMap(doc.data(), doc.id))
          .toList();
      // Sort in Dart instead of Firestore
      requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return requests;
    });
  }

  // Get all pending requests for owner's books
  Stream<List<BorrowRequestModel>> getOwnerRequests(String ownerId) {
    return _firestore
        .collection('borrow_requests')
        .where('ownerId', isEqualTo: ownerId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      final requests = snapshot.docs
          .map((doc) => BorrowRequestModel.fromMap(doc.data(), doc.id))
          .toList();
      // Sort in Dart instead of Firestore
      requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return requests;
    });
  }

  // Get user's sent requests
  Stream<List<BorrowRequestModel>> getUserRequests(String userId) {
    return _firestore
        .collection('borrow_requests')
        .where('requesterId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final requests = snapshot.docs
          .map((doc) => BorrowRequestModel.fromMap(doc.data(), doc.id))
          .toList();
      // Sort in Dart instead of Firestore
      requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return requests;
    });
  }

  // Approve borrow request
  Future<String?> approveBorrowRequest({
    required String requestId,
    required String bookId,
    required String borrowerId,
    required String borrowerName,
  }) async {
    try {
      // Update request status
      await _firestore.collection('borrow_requests').doc(requestId).update({
        'status': 'approved',
        'respondedAt': FieldValue.serverTimestamp(),
      });

      // Update book
      await _firestore.collection('books').doc(bookId).update({
        'isAvailable': false,
        'borrowerUid': borrowerId,
        'borrowerName': borrowerName,
      });

      // Reject all other pending requests for this book
      final otherRequests = await _firestore
          .collection('borrow_requests')
          .where('bookId', isEqualTo: bookId)
          .where('status', isEqualTo: 'pending')
          .get();

      for (var doc in otherRequests.docs) {
        if (doc.id != requestId) {
          await doc.reference.update({
            'status': 'rejected',
            'respondedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      // Update book's pending request count
      await _updateBookRequestCount(bookId);

      return null; // Success
    } catch (e) {
      return 'Error approving request: $e';
    }
  }

  // Reject borrow request
  Future<String?> rejectBorrowRequest(String requestId, String bookId) async {
    try {
      await _firestore.collection('borrow_requests').doc(requestId).update({
        'status': 'rejected',
        'respondedAt': FieldValue.serverTimestamp(),
      });

      // Update book's pending request count
      await _updateBookRequestCount(bookId);

      return null; // Success
    } catch (e) {
      return 'Error rejecting request: $e';
    }
  }

  // Update book's pending request count
  Future<void> _updateBookRequestCount(String bookId) async {
    final requests = await _firestore
        .collection('borrow_requests')
        .where('bookId', isEqualTo: bookId)
        .where('status', isEqualTo: 'pending')
        .get();

    await _firestore.collection('books').doc(bookId).update({
      'pendingRequestsCount': requests.docs.length,
    });
  }

  // Return a book
  Future<String?> returnBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).update({
        'isAvailable': true,
        'borrowerUid': null,
        'borrowerName': null,
      });
      return null; // Success
    } catch (e) {
      return 'Error returning book: $e';
    }
  }

  // Delete a book
  Future<String?> deleteBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).delete();
      return null; // Success
    } catch (e) {
      return 'Error deleting book: $e';
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
}
