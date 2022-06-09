import 'package:flutter/material.dart';

import 'database/app_database.dart';
import 'models/contact.dart';
import 'screens/dashboard.dart';

void main() {
  runApp(const MyApp());
  save(Contact(0, 'Gusatavo', 1597)).then((id){
    findAll().then((contacts) => debugPrint(contacts.toString()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Dashboard(),
    );
  }
}


