// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_secure_notes/screens/auth_gate.dart';
import 'package:my_secure_notes/services/auth_service.dart';
import 'package:my_secure_notes/services/firestore_service.dart'; // <-- ADD THIS IMPORT
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp()); // Use const for MyApp constructor
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Changed to MultiProvider
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(
          // <-- ADD THIS PROVIDER
          create: (_) => FirestoreService(),
        ),
      ],
      child: MaterialApp(
        title: 'MySecureNotes',
        theme: ThemeData(
          // Consider using ColorScheme for more modern theming
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true, // Enable Material 3
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthGate(), // Use const for AuthGate
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
