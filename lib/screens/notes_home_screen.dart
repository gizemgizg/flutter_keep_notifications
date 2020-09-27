import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflite/sqflite.dart';
import '../widgets/scaffold_wrapper_widget.dart';
import '../widgets/app_drawer.dart';
import '../models/note.dart';
import '../database/app_database.dart';
import '../utils/app_settings.dart';
import '../widgets/notes_widget.dart';
import '../widgets/snackbar.dart';
import './note_details_screen.dart';

class NotesHomeScreen extends StatefulWidget {
  final appBarTitle;

  NotesHomeScreen(this.appBarTitle);

  @override
  _NotesHomeScreenState createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  List<Note> notesList;
  int notesListCount = 0;
  final dbHelper = AppDatabase();
  AppSettings settings = AppSettings();

  //Build Method
  @override
  Widget build(BuildContext context) {
    if (notesList == null) {
      notesList = List<Note>();
    }
    _updateNoteList();
    return ScaffoldWrapperWidget(
      drawer: AppDrawer(),
      appBar: appBar,
      body: notesListCount == 0
          ? Container(
              child: Center(
                child: Text('Herhangi bir notunuz yok. Not Ekle'),
              ),
            )
          : settings.showAsGridView ? getNotesGridView() : getNotesListView(),
      floatingActionButton: floatingActionButton(),
    );
  }

  ///Getter for Appbar
  ///
  Widget get appBar {
    return AppBar(
      titleSpacing: 1,
      title: Text(
        widget.appBarTitle,
      ),
      actions: <Widget>[
        settings.showAsGridView
            ? notesViewTypeIcon(
                Icon(
                  Icons.list,
                ),
                'Liste Görünümü Olarak Göster')
            : notesViewTypeIcon(
                Icon(
                  Icons.grid_on,
                ),
                'Izgara Görünümü Olarak Göster'),
        settings.showListByValue == 0
            ? settings.sortByAsc
                ? sortingIcon(
                    Icon(FontAwesome.sort_alpha_desc), 'Azalan şekilde sırala')
                : sortingIcon(
                    Icon(FontAwesome.sort_alpha_asc), 'Artan şekilde sırala')
            : settings.sortByAsc
                ? sortingIcon(Icon(FontAwesome.sort_numeric_desc),
                    'Azalan şekilde sırala')
                : sortingIcon(
                    Icon(FontAwesome.sort_numeric_asc), 'Artan şekilde sırala'),
        if (widget.appBarTitle != 'Hatırlatma') buildDropDownButton,
      ],
    );
  }

  ///Draws grid or list icon depending on showAsGridValue.
  ///
  ///[icon] Icon to draw.
  ///
  ///[tootip] String.
  ///
  ///Returns IconButton Widget.
  ///
  Widget notesViewTypeIcon(Widget icon, String tooltip) {
    return IconButton(
      icon: icon,
      tooltip: tooltip,
      onPressed: () {
        setState(() {
          settings.toggleShowAsGrid();
        });
      },
    );
  }

  ///Draws sorting icon depending on showListByValue
  ///
  ///Draw sort_alpha icon if showListBy value is 0
  ///
  ///Otherwise draws sort_numeric icon.
  ///
  ///Return IconButton Widget.
  Widget sortingIcon(Widget icon, String tooltip) {
    return IconButton(
      icon: icon,
      tooltip: tooltip,
      onPressed: () {
        setState(() {
          settings.toggleSortByAsc();
          _updateNoteList();
        });
      },
    );
  }

  Widget get buildDropDownButton => DropdownButtonHideUnderline(
        child: DropdownButton(
          value: settings.showListByValue,
          items: [
            DropdownMenuItem(
              child: Text('Başlık'),
              value: 0,
            ),
            DropdownMenuItem(
              child: Text('Oluşturulma Tarihi'),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text('Son Düzenlenen'),
              value: 2,
            ),
          ],
          onChanged: (value) {
            setState(() {
              settings.changeShowListByValue(value);
              _updateNoteList();
            });
          },
          icon: Icon(FontAwesome.sort),
          hint: Text('Listeyi Göster'),
        ),
      );

  ///Return all the notes as Staggered Grid View.
  ///
  Widget getNotesGridView() {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: notesListCount,
      itemBuilder: (ctx, int index) => GestureDetector(
        onTap: () {
          moveToNoteDetailsScreen(index, ctx);
        },
        child: NotesWidget(notesList[index]),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  ///Return all the notes as List View.
  ///
  Widget getNotesListView() {
    return ListView.builder(
      itemCount: notesListCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              moveToNoteDetailsScreen(index, context);
            },
            child: NotesWidget(notesList[index]),
          ),
        );
      },
    );
  }

  ///Floating action button
  ///
  ///Return Floating action button.
  Widget floatingActionButton() {
    return Builder(
      builder: (context) => FloatingActionButton(
        onPressed: () {
          print(DateTime.now().toString());
          moveToNoteDetailsScreen(-1, context);
        },
        tooltip: 'Not Ekle',
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  ///Moves to the notes edit screen or add edit screen.
  ///
  void moveToNoteDetailsScreen(int index, BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => index == -1
            ? NoteDetailsScreen(
                note: Note(
                  title: '',
                  description: '',
                  color: 0,
                ),
                appBarTitle: 'Not Ekle',
              )
            : NoteDetailsScreen(
                note: notesList[index],
                appBarTitle: 'Notu Düzenle',
              ),
      ),
    );
    if (result == 'true') {
      _updateNoteList();
    } else if (result == 'false') {
      showSnackBar(context, 'Boş Not Kaydedilemez');
    } else if (result == 'trashed') {
      showSnackBar(context, 'Çöp kutusuna not eklendi');
    } else if (result == 'archived') {
      showSnackBar(context, 'Not Arşivlendi');
    } else if (result == 'deleted') {
      showSnackBar(context, 'Not Kalıcı Olarak Silindi');
      _updateNoteList();
    }
  }

  ///Update the notesList on successfull note save.
  ///
  _updateNoteList() {
    String queryString;
    if (widget.appBarTitle == 'Tüm Notlar') {
      queryString = allNotesQuery[settings.showListByValue];
    } else if (widget.appBarTitle == 'Hatırlatma') {
      queryString = reminderQuery;
    } else if (widget.appBarTitle == 'Çöp Kutusu') {
      queryString = trashQuery[settings.showListByValue];
    } else {
      queryString = archivedQuery[settings.showListByValue];
    }
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dbHelper.getNotesList(queryString);
      noteListFuture.then((noteList) {
        if (mounted)
          setState(() {
            this.notesList =
                settings.sortByAsc ? noteList : noteList.reversed.toList();
            this.notesListCount = noteList.length;
          });
      });
    });
  }
}
