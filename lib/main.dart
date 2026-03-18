
import 'package:dialo_admin/providers/mainProvider.dart';
import 'package:dialo_admin/views/agents/addUser.dart';
import 'package:dialo_admin/views/agents/web_users.dart';
import 'package:dialo_admin/views/dashboard.dart';
import 'package:dialo_admin/views/report/reportpage.dart';
import 'package:dialo_admin/widget/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'views/calls.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>MainProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home:UsersPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

