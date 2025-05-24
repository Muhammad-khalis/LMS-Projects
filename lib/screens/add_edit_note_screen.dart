// lib/screens/add_edit_note_screen.dart
import 'package:flutter/material.dart';
import 'package:my_secure_notes/models/note_model.dart'; // Note model ko import karein
import 'package:my_secure_notes/services/firestore_service.dart';
import 'package:provider/provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note?
  note; // Note object, jo edit ke waqt pass hoga, add ke waqt null hoga

  // Constructor: note optional hai
  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isLoading = false;
  late bool _isEditing; // Ab yeh const nahi hai

  @override
  void initState() {
    super.initState();
    _isEditing = widget.note != null; // Decide karein ke edit mode hai ya nahi

    // Agar edit mode hai, toh fields ko note ke data se initialize karein
    _titleController = TextEditingController(
      text: _isEditing ? widget.note!.title : '',
    );
    _contentController = TextEditingController(
      text: _isEditing ? widget.note!.content : '',
    );
  }

  Future<void> _saveOrUpdateNote() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final firestoreService = Provider.of<FirestoreService>(
        context,
        listen: false,
      );
      final String title = _titleController.text;
      final String content = _contentController.text;

      try {
        if (_isEditing) {
          // Note ko Update karein
          await firestoreService.updateNote(
            noteId: widget.note!.id, // Note ID zaroori hai update ke liye
            title: title,
            content: content,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note updated successfully!')),
            );
          }
        } else {
          // Naya Note Add karein
          await firestoreService.addNote(title: title, content: content);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note added successfully!')),
            );
          }
        }

        if (mounted) {
          Navigator.of(context).pop(); // Notes list screen par wapas jayein
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save note: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Note' : 'Add New Note',
        ), // Title ab dynamic hai
        centerTitle: true,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save_alt_outlined),
              tooltip: 'Save Note',
              onPressed: _saveOrUpdateNote, // Ab _saveOrUpdateNote call hoga
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter note title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  hintText: 'Write your note here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content for your note';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.save),
                label: Text(
                  _isEditing ? 'Update Note' : 'Save Note',
                  style: const TextStyle(fontSize: 18),
                ), // Label ab dynamic hai
                onPressed: _isLoading ? null : _saveOrUpdateNote,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
