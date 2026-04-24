import 'package:dialo_admin/constants/appcolors.dart';
import 'package:dialo_admin/loginpage.dart';
import 'package:dialo_admin/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/agents/addUser.dart';
import '../views/agents/web_users.dart';
import '../views/calls.dart';
import '../views/followUpPage.dart';
import '../views/leads/addlead.dart';
import '../views/leads/leads_list.dart';
import '../views/report/reportpage.dart';
import '../views/settings/settscreen.dart';


class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  int selectedIndex = 0;
  String userRole = 'USER';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role') ?? 'USER';
    });
  }

  final List<Widget> pages = [
    Dashboard(),
    Calls(),
    Leads(),
    AddLead(),
    FollowUpPage(),
    ReportsPage(),
    UsersPage(),
    SettingsPage(),
    AddUserPage(),
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

                /// LOGO + NAME
                const SizedBox(height: 30),

                Column(
                  children: [
                    CircleAvatar(
                      radius:35,
                    child: Image.asset("assets/side_logo.png"),
                    // backgroundImage: AssetImage(
                    //   "assets/dialo-logo1.png"),
                    ),
            SizedBox(height: 8),
    Text(
                      "DIALO",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// MENU ITEMS
                _menuItem(Icons.dashboard_outlined, "Dashboard", 0),
                _menuItem(Icons.phone_outlined, "Calls", 1),
                _menuItem(Icons.people_outline, "Leads", 2),
                _menuItem(Icons.person_add_alt_outlined, "Add Lead", 3),
                _menuItem(Icons.event_outlined, "Follow-Up", 4),
                _menuItem(Icons.bar_chart_outlined, "Reports", 5),
                if (userRole == 'ADMIN') _menuItem(Icons.group_outlined, "Users", 6),
                if (userRole == 'ADMIN') _menuItem(Icons.settings_outlined, "Settings", 7),

                const Spacer(),

                /// LOGOUT
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.redColor),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: AppColors.redColor),
                  ),
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          /// PAGE AREA
          Expanded(
            child: Container(
              color: AppColors.whitetext,
              child: pages[selectedIndex],
            ),
          )
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: AppColors.themeColor),
      title: Text(title),
      selected: selectedIndex == index,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }

  void _showLogoutDialog(BuildContext context){
    showDialog(context: context,
        barrierDismissible:false,
        builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Logout",
        style: TextStyle(color: Colors.black),),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("Cancel"),
          ),
          ElevatedButton(
              style:ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: ()async{
          final prefs=await SharedPreferences.getInstance();
          await prefs.clear();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage(),
          ),
          (route) => false,
          );
          }, child: const Text("Logout",style: TextStyle(color: Colors.white),))
        ],
      );
        });
  }
}