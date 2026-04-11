
// import 'package:dialo_admin/providers/mainProvider.dart';
import 'package:dialo_admin/providers/agentProvider.dart';
import 'package:dialo_admin/providers/leadProvider.dart';
import 'package:dialo_admin/providers/reportProvider.dart';
import 'package:dialo_admin/providers/settings_provider.dart';
import 'package:dialo_admin/views/agents/web_users.dart';
import 'package:dialo_admin/views/dashboard.dart';
import 'package:dialo_admin/views/leads/leads_list.dart';
import 'package:dialo_admin/views/leads/leadsettingsscreen.dart';
import 'package:dialo_admin/views/report/reportpage.dart';
import 'package:dialo_admin/widget/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'views/calls.dart';
import 'views/followUpPage.dart';

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
        ChangeNotifierProvider(create: (_)=>SettingsProvider()),
        ChangeNotifierProvider(create: (_)=> MainProvider()),
        ChangeNotifierProvider(create: (_)=> LeadProvider()),
        ChangeNotifierProvider(
          create: (_) => ReportProvider()..fetchReports(),
          child: ReportsPage(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home:ReportsPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

