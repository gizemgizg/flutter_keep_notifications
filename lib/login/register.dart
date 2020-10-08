import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/notes_home_screen.dart';

import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("images/registerr.png"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 50, right: 50, bottom: 250, top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(labelText: 'Ad Soyad'),
                  validator: (val) =>
                      val.length < 1 ? 'Ad Soyad Gerekli' : null,
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
                left: 50, right: 50, bottom: 170, top: 100),
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
                left: 50, right: 50, bottom: 160, top: 230),
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
                left: 150, right: 50, bottom: 170, top: 400),
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
                          return Login();
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Kayıt Ol",
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
