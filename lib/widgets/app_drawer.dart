import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/screens/notes_home_screen.dart';
import '../screens/app_settings_screen.dart';

//coder gizemgizg

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.all(8.0),
        children: <Widget>[
          //Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Center(
              child: Text(
                'Not Defteri',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          _buildDrawerListTile(
            'Notlar',
            Icons.note,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NotesHomeScreen('Tüm Notlar');
                  },
                ),
              );
            },
          ),
          _buildDrawerListTile(
            'Hatırlatma',
            Icons.add_alert,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NotesHomeScreen('Hatırlatma');
                  },
                ),
              );
            },
          ),
          _buildDrawerListTile(
            'Arsiv',
            Icons.archive,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NotesHomeScreen('Arsiv');
                  },
                ),
              );
            },
          ),
          _buildDrawerListTile(
            'Çöp Kutusu',
            Icons.delete,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NotesHomeScreen('Çöp Kutusu');
                  },
                ),
              );
            },
          ),
          Divider(
            color: Colors.black,
          ),
          _buildDrawerListTile(
            'Ayarlar',
            Icons.settings,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AppSettingsScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ///Function to build drawer List tiles.
  ///
  ///[title] is title of the list item.
  ///
  ///[icon] is the leading icon for the list item.
  ///
  ///[onTap] is the function called when the a list item is tapped.
  ///
  Widget _buildDrawerListTile(String title, IconData icon, Function onTap) {
    return ListTile(
      contentPadding: EdgeInsets.all(12.0),
      dense: true,
      leading: Icon(
        icon,
      ),
      title: Text(
        title,
        style: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ),
      ),
      onTap: onTap,
    );
  }
}
