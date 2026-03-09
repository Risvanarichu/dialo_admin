import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 40),

          _menuItem(Icons.dashboard_outlined, "Dashboard", false),
          _menuItem(Icons.phone_outlined, "Calls", false),
          _menuItem(Icons.people_outline, "Leads", false),
          _menuItem(Icons.person_add_alt_outlined, "Add lead", false),
          _menuItem(Icons.event_outlined, "Follow-Up", false),
          _menuItem(Icons.bar_chart_outlined, "Reports", false),
          _menuItem(Icons.group_outlined, "Users", false),
          _menuItem(Icons.settings_outlined, "Settings", false),

          const Spacer(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, bool active) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff3570CE)),
      title: Text(title),
      onTap: () {},
    );
  }
}