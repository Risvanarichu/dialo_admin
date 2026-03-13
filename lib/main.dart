import 'package:dialo_admin/providers/mainProvider.dart';
import 'package:dialo_admin/views/reportpage.dart';
import 'package:dialo_admin/widget/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/calls.dart';

void main() {
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
        home:SideMenu(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

