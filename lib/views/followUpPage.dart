import 'package:flutter/material.dart';

import 'package:flutter/material.dart';




class FollowupPage extends StatelessWidget {
  const FollowupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /// SIDEBAR
          Container(
            width: 220,
            color: Colors.grey.shade100,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text("DIALO",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),

                sidebarItem(Icons.dashboard, "Dashboard"),
                sidebarItem(Icons.call, "Calls"),
                sidebarItem(Icons.person, "Leads"),
                sidebarItem(Icons.add, "Add Lead"),
                sidebarItem(Icons.follow_the_signs, "Follow-Up", selected: true),
                sidebarItem(Icons.bar_chart, "Reports"),
                sidebarItem(Icons.group, "Users"),
                sidebarItem(Icons.settings, "Settings"),

                const Spacer(),

                Container(
                  width: double.infinity,
                  color: Colors.red.shade100,
                  padding: const EdgeInsets.all(12),
                  child: const Text("Logout",
                      style: TextStyle(color: Colors.red)),
                )
              ],
            ),
          ),

          /// MAIN CONTENT
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "FOLLOW-UP",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  /// TOP CARDS
                  Row(
                    children: [
                      dashboardCard("Due Today", "23", Colors.red),
                      const SizedBox(width: 10),
                      dashboardCard("This Week", "15", Colors.blue),
                      const SizedBox(width: 10),
                      dashboardCard("Completed", "50", Colors.green),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// TABLE
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          tableHeader(),
                          const Divider(height: 1),

                          Expanded(
                            child: ListView(
                              children: const [
                                tableRow("Shibin", "2026-01-08", "10:00 AM",
                                    "High", "Shibina"),
                                tableRow("Riswana", "2026-01-09", "01:30 PM",
                                    "Medium", "Shahid"),
                                tableRow("Finiya", "2026-01-10", "10:45 AM",
                                    "High", "Shruthy"),
                                tableRow("Anshad", "2026-01-15", "10:20 AM",
                                    "Medium", "Shruthy"),
                                tableRow("Aysha", "2026-01-15", "11:30 AM",
                                    "Low", "Shibina"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget sidebarItem(IconData icon, String title, {bool selected = false}) {
  return Container(
    color: selected ? Colors.blue.shade50 : Colors.transparent,
    child: ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
    ),
  );
}

Widget dashboardCard(String title, String value, Color color) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

Widget tableHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    color: Colors.grey.shade300,
    child: Row(
      children: const [
        Expanded(child: Text("LEAD NAME")),
        Expanded(child: Text("FOLLOW-UP DATE")),
        Expanded(child: Text("TIME")),
        Expanded(child: Text("PRIORITY")),
        Expanded(child: Text("ASSIGNED AGENT")),
        Expanded(child: Text("ACTIONS")),
      ],
    ),
  );
}

class tableRow extends StatelessWidget {
  final String name, date, time, priority, agent;

  const tableRow(this.name, this.date, this.time, this.priority, this.agent,
      {super.key});

  Color getPriorityColor() {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: [
              Expanded(child: Text(name)),
              Expanded(child: Text(date)),
              Expanded(child: Text(time)),
              Expanded(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getPriorityColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(priority,
                      style: TextStyle(color: getPriorityColor())),
                ),
              ),
              Expanded(child: Text(agent)),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text("Complete",
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text("Reschedule",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}