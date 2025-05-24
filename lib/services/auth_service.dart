// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
// No longer need: import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Sign Up with Email & Password
  // Throws FirebaseAuthException on failure, returns User on success
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      return userCredential.user;
    } on FirebaseAuthException {
      // Let the calling UI widget handle the exception and show appropriate feedback
      rethrow;
    }
  }

  // Sign In with Email & Password
  // Throws FirebaseAuthException on failure, returns User on success
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      return userCredential.user;
    } on FirebaseAuthException {
      // Let the calling UI widget handle the exception and show appropriate feedback
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
