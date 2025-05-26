import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'note.dart';

class NoteStorage {
  static const _key = 'notes';

  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List jsonList = json.decode(jsonString);
    return jsonList.map((e) => Note.fromJson(e)).toList();
  }

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(notes.map((n) => n.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  static Future<void> addNote(Note note) async {
    final notes = await loadNotes();
    notes.add(note);
    await saveNotes(notes);
  }

  static Future<void> updateNote(Note oldNote, Note newNote) async {
    final notes = await loadNotes();
    final index = notes.indexWhere(
      (n) =>
          n.title == oldNote.title &&
          n.timestamp.toIso8601String() == oldNote.timestamp.toIso8601String(),
    );
    if (index != -1) {
      notes[index] = newNote;
      await saveNotes(notes);
    }
  }

  static Future<void> deleteNote(Note note) async {
    final notes = await loadNotes();
    notes.removeWhere(
      (n) =>
          n.title == note.title &&
          n.timestamp.toIso8601String() == note.timestamp.toIso8601String(),
    );
    await saveNotes(notes);
  }
}
