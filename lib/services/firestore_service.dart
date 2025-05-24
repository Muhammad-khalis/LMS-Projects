// lib/services/firestore_service.dart
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_secure_notes/models/note_model.dart'; // Import your Note model

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  // Add a new note
  Future<void> addNote({required String title, required String content}) async {
    if (_userId == null) {
      throw Exception("User not logged in. Cannot add note.");
    }
    try {
      await _db.collection('notes').add({
        'userId': _userId,
        'title': title,
        'content': content,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
    } on FirebaseException catch (e) {
      // Handle potential Firestore errors (e.g., permission denied if rules are wrong)
      log("Error adding note: ${e.message}" as num); // For debugging
      throw Exception("Failed to add note: ${e.message}");
    }
  }

  // Get a stream of notes for the current user
  Stream<List<Note>> getNotes() {
    if (_userId == null) {
      // Return an empty stream or throw an error if user is not logged in
      // Depending on how you want to handle this in the UI
      return Stream.value([]);
      // Or: throw Exception("User not logged in. Cannot fetch notes.");
    }
    return _db
        .collection('notes')
        .where('userId', isEqualTo: _userId) // Crucial for user-specific data
        .orderBy(
          'updatedAt',
          descending: true,
        ) // Show most recently updated first
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList(),
        );
  }

  // Update an existing note
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    if (_userId == null) {
      throw Exception("User not logged in. Cannot update note.");
    }
    try {
      // First, verify the note belongs to the current user (optional, rules should enforce this)
      // DocumentSnapshot noteDoc = await _db.collection('notes').doc(noteId).get();
      // if (!noteDoc.exists || noteDoc.data()?['userId'] != _userId) {
      //   throw Exception("Note not found or permission denied.");
      // }

      await _db.collection('notes').doc(noteId).update({
        'title': title,
        'content': content,
        'updatedAt': Timestamp.now(),
        // 'userId' should not be updated here
      });
    } on FirebaseException catch (e) {
      log("Error updating note: ${e.message}" as num); // For debugging
      throw Exception("Failed to update note: ${e.message}");
    }
  }

  // Delete a note
  Future<void> deleteNote({required String noteId}) async {
    if (_userId == null) {
      throw Exception("User not logged in. Cannot delete note.");
    }
    try {
      // Optional: Verify note ownership before deleting, though rules are primary defense
      // DocumentSnapshot noteDoc = await _db.collection('notes').doc(noteId).get();
      // if (!noteDoc.exists || noteDoc.data()?['userId'] != _userId) {
      //   throw Exception("Note not found or permission denied for deletion.");
      // }
      await _db.collection('notes').doc(noteId).delete();
    } on FirebaseException catch (e) {
      log("Error deleting note: ${e.message}" as num); // For debugging
      throw Exception("Failed to delete note: ${e.message}");
    }
  }
}
