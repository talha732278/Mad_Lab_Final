
// note_editor_screen.dart
import 'package:flutter/material.dart';
import 'note.dart';
import 'note_storage.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  void saveNote() async {
    final newNote = Note(
      title: titleController.text,
      content: contentController.text,
      timestamp: DateTime.now(),
    );
    if (widget.note == null) {
      await NoteStorage.addNote(newNote);
    } else {
      await NoteStorage.updateNote(widget.note!, newNote);
    }
    Navigator.pop(context);
  }

  void deleteNote() async {
    if (widget.note != null) {
      await NoteStorage.deleteNote(widget.note!);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: deleteNote,
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TextField(
              controller: contentController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveNote,
        child: const Icon(Icons.save),
      ),
    );
  }
}
