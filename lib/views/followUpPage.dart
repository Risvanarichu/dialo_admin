import 'package:flutter/material.dart';

class FollowUpsPage extends StatelessWidget {
  const FollowUpsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            const Text(
              "Follow-ups",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Manage scheduled follow-ups with leads",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// STATS CARDS
            Row(
              children: [
                statCard("Due Today", "23", Icons.error_outline, Colors.red),
                const SizedBox(width: 20),
                statCard("This Week", "67", Icons.access_time, Colors.blue),
                const SizedBox(width: 20),
                statCard("Completed", "142", Icons.check_circle_outline,
                    Colors.green),
              ],
            ),

            const SizedBox(height: 25),

            /// TABLE
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      columnSpacing: 45,
                    columns: const [
                      DataColumn(label: Text("LEAD NAME",style: TextStyle(fontWeight:FontWeight.bold ,fontSize: 15),)),
                      DataColumn(label: Text("FOLLOW-UP DATE",style: TextStyle(fontWeight:FontWeight.bold ,fontSize: 15))),
                      DataColumn(label: Text("TIME",style: TextStyle(fontWeight:FontWeight.bold ,fontSize: 15))),
                      DataColumn(label: Text("PRIORITY",style: TextStyle(fontWeight:FontWeight.bold ,fontSize: 15))),
                      DataColumn(label: Text("ASSIGNED AGENT",style: TextStyle(fontWeight:FontWeight.bold ,fontSize: 15))),
                      DataColumn(label: Text("ACTIONS",style: TextStyle(fontWeight:FontWeight.bold ,fontSize: 15))),
                    ],
                    rows: [
                      followRow(
                        "Alice Cooper",
                        "2026-01-06",
                        "10:00 AM",
                        "High",
                        Colors.red,
                        "John Smith",
                      ),
                      followRow(
                        "Bob Martin",
                        "2026-01-06",
                        "02:00 PM",
                        "Medium",
                        Colors.orange,
                        "Emily Davis",
                      ),
                      followRow(
                        "Daniel Kim",
                        "2026-01-07",
                        "09:30 AM",
                        "High",
                        Colors.red,
                        "Sarah Miller",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// CARD WIDGET
  Widget statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Icon(icon, color: color),
            ],
          ),
        ),
      ),
    );
  }

  /// TABLE ROW
  DataRow followRow(
      String name,
      String date,
      String time,
      String priority,
      Color priorityColor,
      String agent) {
    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(Text(date)),
        DataCell(Text(time)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              priority,
              style: TextStyle(color: priorityColor),
            ),
          ),
        ),
        DataCell(Text(agent)),
        DataCell(
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {},
                child: const Text("Complete"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {},
                child: const Text("Reschedule"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}