import 'package:dialo_admin/constants/appcolors.dart';
import 'package:dialo_admin/loginpage.dart';
import 'package:dialo_admin/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/loginprovider.dart';
import '../views/agents/addUser.dart';
import '../views/agents/web_users.dart';
import '../views/followUpPage.dart';
import '../views/leads/addlead.dart';
import '../views/leads/leads_list.dart';
import '../views/report/reportpage.dart';
import '../views/settings/settscreen.dart';


class SideMenu extends StatefulWidget {
  final int selectedIndex;
  final Widget? child;
  const SideMenu({super.key, this.selectedIndex = 0, this.child});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  late int selectedIndex;
// String userRole='USER';


  @override
  void initState() {
    super.initState();

    selectedIndex = widget.selectedIndex;

    context.read<Loginprovider>().loadUserRole();
  }


  final List<Widget> pages = [
    Dashboard(),
    // Calls(),
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
    final prov = context.watch<Loginprovider>();
    return Scaffold(
      body: Row(
        children: [

          /// SIDE MENU
          Container(
            width: 220,
            color: AppColors.whitetext,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        /// LOGO + NAME
                        const SizedBox(height: 30),

                        Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              child: Image.asset("assets/side_logo.png"),
                            ),
                            const SizedBox(height: 8),
                            const Text(
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
                        // _menuItem(Icons.phone_outlined, "Calls", 1),
                        _menuItem(Icons.people_outline, "Leads", 1),
                        _menuItem(Icons.person_add_alt_outlined, "Add Lead", 2),
                        _menuItem(Icons.event_outlined, "Follow-Up", 3),
                        _menuItem(Icons.bar_chart_outlined, "Reports", 4),
                        if (prov.userRole == 'ADMIN')
                          _menuItem(Icons.group_outlined, "Users", 5),
                        if (prov.userRole == 'ADMIN')
                          _menuItem(Icons.settings_outlined, "Settings", 6),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 1),

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
              child: widget.child != null && selectedIndex == widget.selectedIndex
                  ? widget.child!
                  : pages[selectedIndex],
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