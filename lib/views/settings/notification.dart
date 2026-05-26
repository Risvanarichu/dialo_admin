import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "title": "Follow-up Reminder",
        "message": "Call Rahul Sharma regarding CRM.",
        "time": "2 min ago",
        "priority": "High",
        "lead": "Rahul Sharma",
        "icon": Icons.call,
        "color": Colors.red,
      },
      {
        "title": "New Lead Assigned",
        "message": "New lead Neha Patel assigned.",
        "time": "15 min ago",
        "priority": "Medium",
        "lead": "Neha Patel",
        "icon": Icons.person_add,
        "color": Colors.green,
      },
      {
        "title": "Overdue Follow-up",
        "message": "2 follow-ups are overdue.",
        "time": "1 hour ago",
        "priority": "High",
        "lead": "Task",
        "icon": Icons.access_time,
        "color": Colors.orange,
      },
      {
        "title": "Lead Status Changed",
        "message": "Lead moved to Negotiation.",
        "time": "2 hours ago",
        "priority": "Medium",
        "lead": "Amit Verma",
        "icon": Icons.sync,
        "color": Colors.purple,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 15),
          Icon(Icons.more_vert),
          SizedBox(width: 15),
        ],
      ),

      body: Column(
        children: [

          /// FILTERS
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [

                _filterButton(
                  title: "All",
                  count: "12",
                  selected: true,
                ),

                const SizedBox(width: 10),

                _filterButton(
                  title: "Unread",
                  count: "8",
                ),

                const SizedBox(width: 10),

                _filterButton(
                  title: "Mentions",
                  count: "3",
                ),
              ],
            ),
          ),

          /// TODAY TEXT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "Mark all as read",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          /// LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: notifications.length,
              itemBuilder: (context, index) {

                final data = notifications[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(15),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// BLUE DOT
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// ICON
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: (data["color"] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          data["icon"] as IconData,
                          color: data["color"] as Color,
                        ),
                      ),

                      const SizedBox(width: 15),

                      /// CONTENT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(
                                  child: Text(
                                    data["title"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                Text(
                                  data["time"].toString(),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(
                              data["message"].toString(),
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: data["priority"] == "High"
                                        ? Colors.red.shade50
                                        : Colors.green.shade50,

                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),

                                  child: Text(
                                    data["priority"].toString(),

                                    style: TextStyle(
                                      color:
                                      data["priority"] == "High"
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Text(
                                  "Lead • ${data["lead"]}",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,

        selectedItemColor: Colors.deepPurple,

        unselectedItemColor: Colors.grey,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Leads",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 35),
            label: "Add Lead",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Follow Ups",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
        ],
      ),
    );
  }

  Widget _filterButton({
    required String title,
    required String count,
    bool selected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: selected
            ? Colors.deepPurple
            : Colors.white,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(
        children: [

          Text(
            title,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: 8),

          CircleAvatar(
            radius: 10,

            backgroundColor: selected
                ? Colors.white24
                : Colors.grey.shade200,

            child: Text(
              count,
              style: TextStyle(
                fontSize: 12,
                color: selected
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}