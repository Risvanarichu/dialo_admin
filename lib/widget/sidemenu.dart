import 'package:dialo_admin/constants/appcolors.dart';
import 'package:dialo_admin/views/dashboard.dart';
import 'package:flutter/material.dart';

import '../views/agents/web_users.dart';
import '../views/calls.dart';
import '../views/followUpPage.dart';
import '../views/leads/addlead.dart';
import '../views/leads/leads_list.dart';
import '../views/logoutscreen.dart';
import '../views/report/reportpage.dart';
import '../views/settings/settscreen.dart';



class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  int selectedIndex = 0;

  final List<Widget> pages = [
    // const Center(child: Text("Dashboard Page")),
    // const Center(child: Text("Calls Page")),
    // const Center(child: Text("Leads Page")),
    // const Center(child: Text("Add Lead Page")),
    // const Center(child: Text("Follow Up Page")),
    // const Center(child: Text("Reports Page")),
    // const Center(child: Text("Users Page")),
    // const Center(child: Text("Settings Page")),
    Dashboard(),
    Calls (),
    Leads  (),
    AddLead(),
    FollowUpsPage (),
    ReportsPage(),
    UsersPage (),
    SettingsPage(),
    LogoutPage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [

          /// SIDE MENU
          Container(
            width: 220,
            color: AppColors.whitetext,
            child: Column(
              children: [
                const SizedBox(height: 40),

                _menuItem(Icons.dashboard_outlined, "Dashboard", 0),
                _menuItem(Icons.phone_outlined, "Calls", 1),
                _menuItem(Icons.people_outline, "Leads", 2),
                _menuItem(Icons.person_add_alt_outlined, "Add Lead", 3),
                _menuItem(Icons.event_outlined, "Follow-Up", 4),
                _menuItem(Icons.bar_chart_outlined, "Reports", 5),
                _menuItem(Icons.group_outlined, "Users", 6),
                _menuItem(Icons.settings_outlined, "Settings", 7),

                const Spacer(),

                ListTile(
                  leading: const Icon(Icons.logout, color:AppColors.redColor),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: AppColors.redColor),
                  ),
                  onTap: () {},
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          /// PAGE AREA
          Expanded(
            child: Container(
              color:AppColors.whitetext,
              child: pages[selectedIndex],
            ),
          )
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon,color: AppColors.themeColor,),
      title: Text(title),
      selected: selectedIndex == index,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}
