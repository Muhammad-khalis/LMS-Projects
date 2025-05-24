// lib/screens/auth_gate.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_secure_notes/screens/login_screen.dart';
import 'package:my_secure_notes/screens/notes_list_screen.dart';

import 'package:provider/provider.dart';
import 'package:my_secure_notes/services/auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // User is logged in
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            // If user is null, show LoginScreen
            return LoginScreen(); // We will create LoginScreen next
          }
          // If user is not null, show NotesListScreen
          return NotesListScreen(); // Placeholder for now
        }
        // Checking connection state (show loading indicator)
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
