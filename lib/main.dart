import 'package:dialo_admin/views/reportpage.dart';
import 'package:dialo_admin/views/web_users.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: UsersPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

