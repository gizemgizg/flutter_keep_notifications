import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../utils/notification_helper.dart';
import '../database/app_database.dart';
import '../widgets/scaffold_wrapper_widget.dart';
import '../widgets/snackbar.dart';
import '../widgets/color_picker_widget.dart';
import '../widgets/custom_textform_widget.dart';

class NoteDetailsScreen extends StatefulWidget {
  final Note note;
  final String appBarTitle;

  NoteDetailsScreen({this.note, this.appBarTitle});
  @override
  _NoteDetailsScreenState createState() => _NoteDetailsScreenState(
        note,
        appBarTitle,
      );
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  final Note note;
  final String appBarTitle;
  NotificationHelper notificationHelper;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dbHelper = AppDatabase();
  int color;
  var isEdited = false;
  var isReminderEdited = false;
  String _pickedDate;
  String _pickedTime;

  _NoteDetailsScreenState(this.note, this.appBarTitle);

  ///Build Function
  @override
  Widget build(BuildContext context) {
    //Initializes Picked Date and Time value from Note's Reminder if it exist,
    //Othervise Initializes it with current time and date...
    if (note.reminder != null) {
      _pickedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(note.reminder));
      _pickedTime = DateFormat('kk:mm').format(DateTime.parse(note.reminder));
    } else {
      _pickedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _pickedTime = DateFormat('kk:mm').format(DateTime.now());
    }

    //Initializes notification helper
    notificationHelper = NotificationHelper();

    //Set the color to Note's color
    //Then This Variable is used in AppBar and Screen Background color
    color = note.color;

    //Initializes Title Text Controller
    titleController.text = note.title;
    descriptionController.text = note.description;

    //Adds listener to title and description controller
    //if either controller text changes isEdited will become true
    titleController.addListener(() {
      print('Değiştirildi');
      isEdited = true;
      note.title = titleController.text;
    });
    descriptionController.addListener(() {
      print('Değiştirildi');
      isEdited = true;
      note.description = descriptionController.text;
    });
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        titleController.text.length == 0 &&
                descriptionController.text.length == 0
            ? _saveNote('false')
            : _saveNote('true');
      },
      child: ScaffoldWrapperWidget(
        appBar: appBar,
        body: Builder(
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(10),
            color: colors[color],
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (note.archived == 'true' && note.trashed == 'false')
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '[Arşivlenmiş Notlar]',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  if (note.trashed == 'true')
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '[Silinen Notlar]',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: note.lastEdited != null
                        ? Text(
                            'Son Düzenlenen: ${note.lastEdited}',
                            style: TextStyle(color: Colors.black),
                          )
                        : Text(''),
                  ),
                  CustomTextFormWidget(
                    note: note,
                    hintText: 'Başlık',
                    textEditingController: titleController,
                    maxLength: 50,
                    textSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomTextFormWidget(
                    note: note,
                    hintText: 'Açıklama',
                    textEditingController: descriptionController,
                    maxLength: 1000,
                    textSize: 20,
                    fontWeight: FontWeight.bold,
                    minLine: 1,
                    maxLine: 14,
                  ),
                  note.reminder != null
                      ? InkWell(
                          onTap: () async {
                            String res = await _showAddReminderDialog();
                            _handleAddReminderResult(context, res);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.add_alert,
                                  color: Colors.black,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Text(
                                    note.reminder,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.black,
                                      decoration: note.markAsDone == 'true'
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Text(''),
                  ColorPickerWidget(
                    selectedIndex: color,
                    onTap: (index) {
                      isEdited = true;
                      setState(() {});
                      note.color = index;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Getter for AppBar
  Widget get appBar {
    return AppBar(
      titleSpacing: 5,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          titleController.text.length == 0 &&
                  descriptionController.text.length == 0
              ? _saveNote('false')
              : _saveNote('true');
        },
      ),
      elevation: 0,
      backgroundColor: colors[color],
      actions: _buildAppBarActions(),
      title: Text(
        widget.appBarTitle,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  ///Fuction to return list of all the action icons
  List<Widget> _buildAppBarActions() {
    return <Widget>[
      //Draws add alert icon
      if (note.trashed == 'false')
        Builder(
          builder: (context) =>
              _drawAppBarActionIcon(Icons.add_alert, 'Uyarı Ekle', () async {
            String res = await _showAddReminderDialog();
            _handleAddReminderResult(context, res);
          }),
        ),

      //Draws archive icon only if the note is not trashed
      //Otherwise Draws nothing
      if (note.trashed == 'false')
        note.archived == 'true'
            ? Builder(
                builder: (context) => _drawAppBarActionIcon(
                    Icons.unarchive, 'Arşivden Çıkarma Notu', () {
                  showSnackBar(context, 'Not Arşivlenmedi');
                  _unArchiveNote();
                }),
              )
            : Builder(
                builder: (context) =>
                    _drawAppBarActionIcon(Icons.archive, 'Arşiv Notu', () {
                  showSnackBar(context, 'Not Arşivlendi');
                  _archiveNote();
                }),
              ),

      //Draws restore_from_trash icon if note is trashed
      if (note.trashed == 'true')
        Builder(
          builder: (context) => _drawAppBarActionIcon(
              Icons.restore_from_trash, 'Notu Geri Yükle', () {
            showSnackBar(context, 'Not Çöp Kutusundan Geri Yüklenir');
            _restoreNoteFromTrash();
          }),
        ),

      //Draws delete icon
      //if trashed draws delete forever icon
      note.trashed == 'false'
          ? Builder(
              builder: (context) =>
                  _drawAppBarActionIcon(Icons.delete, 'Silinen Not', () {
                showSnackBar(context, 'Not Çöp Kutusuna Gönderildi');
                _trashNote();
              }),
            )
          : Builder(
              builder: (context) => _drawAppBarActionIcon(
                  Icons.delete_forever, 'Kalıcı Olarak Sil', () {
                _showDeleteDialog(context);
              }),
            ),
    ];
  }

  ///Function to show Note delete Dialog
  ///
  ///show when the note is in trash
  _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Notu Sil"),
          content: Text("Bu notu silmek istiyor musunuz?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Hayır"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Evet"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteNote();
              },
            ),
          ],
        );
      },
    );
  }

  ///Draws AppBar Action Icons
  ///
  ///[icon] Icon to be drawn
  ///
  ///[tooltip] String tooltip for the icon
  ///
  ///[onPressed] Function to be excecuted when the icon is tapped
  Widget _drawAppBarActionIcon(
    IconData icon,
    String tooltip,
    Function onPressed,
  ) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.black,
      ),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }

  ///Function to show dialog to add reminder to Note
  ///
  ///Adds reminder to note
  ///
  ///Returns true if succefully add reminder
  ///
  ///false Otherwise
  _showAddReminderDialog() async {
    String res = await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        //Return the Alert Dialog
        builder: (context, setState) => AlertDialog(
          title: Text('Hatırlatıcı Ekle'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          //Alert Dialog Container
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //Date Picker Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_pickedDate),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text('Tarih Seçiniz'),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: note.reminder != null
                                ? DateTime.parse(note.reminder)
                                : DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          ).then(
                            (value) {
                              if (value != null) {
                                print('object');
                                isReminderEdited = true;
                                isEdited = true;
                                setState(() {
                                  _pickedDate = DateFormat('yyyy-MM-dd')
                                      .format(DateTime.parse(value.toString()));
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                //Time Picker Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_pickedTime),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text('Saat Seçiniz'),
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: note.reminder != null
                                ? TimeOfDay(
                                    hour: int.parse(note.reminder
                                        .substring(11, 16)
                                        .split(':')[0]),
                                    minute: int.parse(note.reminder
                                        .substring(11, 16)
                                        .split(':')[1]),
                                  )
                                : TimeOfDay.now(),
                          ).then((value) {
                            if (value != null) {
                              isReminderEdited = true;
                              isEdited = true;
                              _pickedTime = DateFormat('kk:mm').format(
                                  DateTime(0, 0, 0, value.hour, value.minute));
                              setState(() {});
                            }
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            if (note.reminder != null)
              FlatButton(
                color: Colors.red,
                child: Text('Sil'),
                onPressed: () {
                  _deleteReminder(context);
                  Navigator.of(context).pop('sil');
                },
              ),
            FlatButton(
              child: Text('İptal Et'),
              onPressed: () {
                Navigator.of(context).pop('iptal et');
              },
            ),
            FlatButton(
              child: Text('Kaydet'),
              onPressed: () {
                isReminderEdited = true;
                isEdited = true;
                Navigator.of(context).pop('kaydet');
              },
              color: Colors.blue,
            ),
          ],
          actionsPadding: EdgeInsets.all(8),
        ),
      ),
    );
    return res;
  }

  ///Handles the result returned from Reminder Dialog
  ///
  ///Returns String.
  ///
  ///If result is 'save', sets the Reminder
  ///
  ///If result is 'delete', deletes the reminder.
  ///
  ///If result is 'cancel' Do nothing.
  _handleAddReminderResult(BuildContext context, String result) async {
    if (result == 'kaydet') {
      showSnackBar(context, 'Hatırlatıcı ayarlandı');
      setState(() {
        note.reminder = _pickedDate + ' ' + _pickedTime;
      });
    } else if (result == 'sil') {
      showSnackBar(context, 'Hatırlatıcı Kaldırıldı');
    } else {}
  }

  ///Saves the note to the database and move back to previous screen
  _saveNote(String res) async {
    int reminderId;
    _moveBack(res);

    if (res != 'false') {
      //Check if Note's id is not equal to null
      //it its equal to null then this will create new note
      //Otherwise it will Update existing one
      if (note.id != null) {
        reminderId = note.id;
        if (isEdited)
          note.lastEdited =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        await dbHelper.updateNote(note);
      } else {
        note.createdDate =
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
        note.lastEdited =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        reminderId = await dbHelper.insertOne(note);
      }

      //Check if a Note have reminder and isReminder is true
      //If the condition passes this will register Scheduled notification on specified time and date
      if (note.reminder != null && isReminderEdited) {
        note.markAsDone = 'false';
        await dbHelper.updateNote(note);
        notificationHelper.scheduledNotification(
          _pickedDate,
          _pickedTime,
          reminderId,
          note.title,
          note.description,
        );
      }
    }
  }

  ///Moves back to the Previous Screen
  _moveBack(String res) {
    Navigator.pop(context, res);
  }

  ///Delete the note
  _deleteNote() async {
    await dbHelper.deleteNote(note.id);
    await notificationHelper.deleteNotification(note.id);
    _saveNote('silindi');
  }

  ///Trash the note
  _trashNote() async {
    note.trashed = 'true';
  }

  ///Archive the note
  _archiveNote() {
    note.archived = 'true';
  }

  ///UnArchive the note
  _unArchiveNote() {
    note.archived = 'false';
  }

  ///Restores note from trash
  _restoreNoteFromTrash() {
    note.trashed = 'false';
  }

  ///Delects the Reminder of a note
  ///
  ///[note.reminder] will be set to null
  ///
  _deleteReminder(BuildContext context) async {
    await notificationHelper.deleteNotification(note.id);
    note.reminder = null;
    setState(() {});
  }
}
