import 'package:flutter/material.dart';
import 'package:note_app_get_post_put/Domain/note_model/note_model.dart';
import 'package:note_app_get_post_put/presentation/home/widget/note_items.dart';

import '../../infrastructure/data.dart';

class AllNotes extends StatelessWidget {
  AllNotes({Key? key}) : super(key: key);
  // final  List<NoteModel> noteListAll=[];
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await NoteDB().getAllNotes();

      // print(_noteList);
    });
    return ValueListenableBuilder(
      valueListenable: NoteDB.allListNotifier,
      builder: (BuildContext ctx, List<NoteModel> newAllList, Widget? _) {
        return GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          padding: const EdgeInsets.all(10),
          children: List.generate(NoteDB.allListNotifier.value.length, (index) {
            final newValue = newAllList[index];
            return newValue.id == null
                ? const ColoredBox(
                  color: Colors.amber,
                )
                : NoteItem(
                    content: newValue.content ?? 'no content',
                    title: newValue.title ?? 'no title',
                    id: newValue.id!,
                  );
          }),
        );
      },
    );
  }
}
