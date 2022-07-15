import 'package:flutter/material.dart';
import 'package:note_app_get_post_put/infrastructure/data.dart';
import 'package:note_app_get_post_put/presentation/home/screen_add_notes.dart';

class NoteItem extends StatelessWidget {
  String title;
  String content;
  String id;
  NoteItem({
    Key? key,
    required this.content,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ScreenAddNotes(type: Actiontype.editNote,id: id,)));
      },
      child: Container(
        width: 30,
        height: 50,
        decoration: BoxDecoration(
            // color: Colors.blue,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow:TextOverflow.ellipsis ,
                   
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                
                IconButton(
                    onPressed: () {
                      NoteDB().deleteNote(id);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ],
            ),
            SizedBox(
              height: 100,
              child: Text(content),
            )
          ],
        ),
      ),
    );
  }
}
