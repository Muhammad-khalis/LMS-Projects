// lib/screens/notes_list_screen.dart
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:my_secure_notes/models/note_model.dart';
import 'package:my_secure_notes/screens/add_edit_note_screen.dart';
import 'package:my_secure_notes/services/auth_service.dart';
import 'package:my_secure_notes/services/firestore_service.dart';
import 'package:provider/provider.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  Future<void> _confirmDeleteNote(
    BuildContext dialogTriggerContext,
    FirestoreService firestoreService,
    Note note,
  ) async {
    // dialogTriggerContext woh context hai jo ListTile ke itemBuilder se pass hua.
    final bool? confirmed = await showDialog<bool>(
      context:
          dialogTriggerContext, // Dialog ke liye passed context istemal karein
      builder: (BuildContext innerDialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete "${note.title}"? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(innerDialogContext).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(innerDialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await firestoreService.deleteNote(noteId: note.id);

        if (!mounted) return; // State ka mounted check karein

        // SnackBar ke liye State ka apna context (this.context) istemal karein
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${note.title}" deleted successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        if (!mounted) return; // State ka mounted check karein

        // SnackBar ke liye State ka apna context (this.context) istemal karein
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete note: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 2),
          ),
        );
        developer.log(
          'Error deleting note',
          name: 'NotesListScreen._confirmDeleteNote',
          error: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Yeh 'context' _NotesListScreenState ka build context hai
    final authService = Provider.of<AuthService>(context, listen: false);
    final firestoreService = Provider.of<FirestoreService>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Secure Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final confirmLogout = await showDialog<bool>(
                context: context, // Build context yahan istemal ho raha hai
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('Logout'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );

              if (confirmLogout == true) {
                await authService.signOut();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Note>>(
        stream: firestoreService.getNotes(),
        builder: (BuildContext streamBuildContext, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            developer.log(
              "Error fetching notes from Firestore.",
              name: "NotesListScreen.StreamBuilder",
              error: snapshot.error,
              stackTrace: snapshot.stackTrace,
            );
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Could not load notes. Please check your connection or try again later.\nDetails: ${snapshot.error?.toString()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No notes yet.\nTap the "+" button below to add your first secure note!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            );
          }

          final notes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: notes.length,
            itemBuilder: (BuildContext listContext, int index) {
              final note = notes[index];
              return Card(
                elevation: 3.0,
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 5.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                  title: Text(
                    note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.push(
                      listContext,
                      MaterialPageRoute(
                        builder: (context) => AddEditNoteScreen(note: note),
                      ),
                    );
                  },
                  onLongPress: () {
                    _confirmDeleteNote(listContext, firestoreService, note);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context, // Build context yahan istemal ho raha hai
            MaterialPageRoute(builder: (context) => const AddEditNoteScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Note'),
        tooltip: 'Add a new note',
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
