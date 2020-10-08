import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/app_localizations.dart';
import 'package:notes/login/register.dart';
import 'package:notes/screens/notes_home_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("images/loginn.jpeg"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 180, right: 10, bottom: 550),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Direct Note",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 50, right: 50, bottom: 20, top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (val) => val.length < 1 ? 'Email Gerekli' : null,
                  cursorColor: Colors.black,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 50, right: 50, bottom: 20, top: 230),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                  ),
                  validator: (val) => val.length < 1 ? 'Şifre Gerekli' : null,
                  cursorColor: Colors.black,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 100, right: 50, bottom: 20, top: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.grey,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NotesHomeScreen("Tüm Notlar");
                        },
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('Giriş'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 200, right: 50, bottom: 20, top: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.grey,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Register();
                        },
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('Kayıt ol'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
//        [Your content here]
        ],
      ),
    );
  }
}
