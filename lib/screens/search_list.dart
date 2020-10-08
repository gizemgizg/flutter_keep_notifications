import 'package:flutter/material.dart';
import 'package:notes/database/app_database.dart';
import 'package:notes/models/note.dart';
import 'package:notes/screens/notes_home_screen.dart';
import 'package:notes/utils/app_settings.dart';
import 'package:notes/widgets/color_picker_widget.dart';
import 'package:sqflite/sqflite.dart';

class SearchList extends StatefulWidget {
  SearchList({Key key}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList>
    with SingleTickerProviderStateMixin {
  List<Note> notesList = List();
  List<Note> filteredList = List();

  int notesListCount = 0;
  final dbHelper = AppDatabase();
  AppSettings settings = AppSettings();

  @override
  void initState() {
    super.initState();

    if (notesList == null) {
      notesList = List<Note>();
    }
    _updateNoteList();

    setState(() {
      filteredList = notesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NotesHomeScreen("Tüm Notlar");
                      },
                    ),
                  );
                }),
          ],
          title: Text(
            "Notlar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: Colors.teal.shade300,
        ),
        body: Center(
          child: Column(children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10), hintText: "Filtrele.."),
              onChanged: (string) {
                setState(() {
                  filteredList = notesList
                      .where((g) => (g.title
                          .toLowerCase()
                          .contains(string.toLowerCase())))
                      .toList();
                });
              },
            ),
            Column(children: NotlariGetir()),
          ]),
        ),
      ),
    );
  }

  _updateNoteList() {
    String queryString = allNotesQuery[settings.showListByValue];

    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dbHelper.getNotesList(queryString);
      noteListFuture.then((noteList) {
        if (mounted)
          setState(() {
            this.notesList =
                settings.sortByAsc ? noteList : noteList.reversed.toList();
            this.notesListCount = noteList.length;
            debugPrint("liste eleman sayısı:" + noteList.length.toString());
          });
      });
    });
  }

  NotlariGetir() {
    return notesList
        .map((g) => Center(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      g.title,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      g.description,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    width: 1000,
                    child: Divider(
                      color: Colors.grey,
                      height: 10000,
                    ),
                  )
                ],
              ),
            ))
        .toList();
  }
}
