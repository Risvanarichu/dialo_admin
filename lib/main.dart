import 'package:dialo_admin/views/addUser.dart';
import 'package:dialo_admin/views/followUpPage.dart';
import 'package:dialo_admin/views/leadweb.dart';
import 'package:dialo_admin/views/reportpage.dart';
import 'package:dialo_admin/views/addlead.dart';
import 'package:dialo_admin/views/web_users.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: FollowUpsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

