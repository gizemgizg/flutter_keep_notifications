import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes/login/login.dart';
import 'package:provider/provider.dart';
import 'app_localizations.dart';
import 'utils/app_theme.dart';
import './screens/notes_home_screen.dart';
import './database/app_database.dart';
import './models/note.dart';
import './screens/note_details_screen.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: false,
    onDidReceiveLocalNotification: (id, title, body, payload) async {
      // your call back to the UI
    },
  );
  var initializationSettings = InitializationSettings(
    initializationSettingsAndroid,
    initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    // onNotificationClick(payload);  your call back to the UI
    print('Notification Tapped and id is $payload');
    var dbHelper = AppDatabase();
    List<Note> note = await dbHelper.getNotesList(
        'SELECT * FROM node_table WHERE id = ${int.parse(payload)}');

    await MyApp.navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (context) => NoteDetailsScreen(
          note: note[0],
          appBarTitle: 'Notu Düzenle',
        ),
      ),
    );
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      child: Consumer<AppTheme>(
        builder: (context, notifier, child) => MaterialApp(
          supportedLocales: [
            Locale('en', 'US'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          navigatorKey: navigatorKey,
          title: 'DirectNote',
          debugShowCheckedModeBanner: false,
          theme: notifier.darkTheme ? dark : light,
          home: Login(),
        ),
      ),
    );
  }
}
