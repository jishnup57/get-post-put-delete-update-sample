import 'package:flutter/material.dart';
import 'package:note_app_get_post_put/Domain/note_model/note_model.dart';
import 'package:note_app_get_post_put/infrastructure/data.dart';

enum Actiontype { addNote, editNote }

class ScreenAddNotes extends StatelessWidget {
  final Actiontype type;
  String? id;
  ScreenAddNotes({Key? key, required this.type, this.id}) : super(key: key);

  Widget get saveButton => TextButton.icon(
        onPressed: () {
          switch (type) {
            case Actiontype.addNote:
              //add note
              save();

              break;

            case Actiontype.editNote:

              //edit note
              saveEditedNote();
              break;
          }
        },
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: const Text(
          "save",
          style: TextStyle(color: Colors.white),
        ),
      );
  final _titleControlleer = TextEditingController();
  final _noteControlleer = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (type == Actiontype.editNote) {
      if (id == null) {
        Navigator.of(context).pop();
      }
      final notes = NoteDB().getNoteById(id!);
      if (notes == null) {
        Navigator.of(context).pop();
      }
      _titleControlleer.text = notes!.title ?? 'no title';
      _noteControlleer.text = notes.content ?? 'no content';
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("ADD Note"),
        actions: [saveButton],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: _titleControlleer,
              decoration: const InputDecoration(
                  labelText: "Enter title", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _noteControlleer,
              maxLines: 4,
              maxLength: 120,
              decoration: const InputDecoration(
                  labelText: "Enter Notes", border: OutlineInputBorder()),
            )
          ],
        ),
      ),
    );
  }

  Future<void> save() async {
    final title = _titleControlleer.text;
    final notes = _noteControlleer.text;
    final newNote = NoteModel.create(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      content: notes,
    );
    final result = NoteDB().createNote(newNote);
    NoteDB().getAllNotes();
    if (result != null) {
      Navigator.of(_scaffoldKey.currentContext!).pop();
    } else {
      print('Notes not saved');
    }
  }

  void saveEditedNote() {
    final title = _titleControlleer.text;
    final content = _noteControlleer.text;
    final editedNote=  NoteModel.create(
      id: id,
      title: title,
      content: content,
    );
     final notesAfterUpdate=NoteDB().updateNote(editedNote);
     if (notesAfterUpdate==Null) {
       print('Unable to update');
     }else{
      Navigator.of(_scaffoldKey.currentContext!).pop();
     }
  }
} 