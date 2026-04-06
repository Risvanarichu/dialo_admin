import 'package:flutter/material.dart';


class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// TOP BAR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "USERS",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                /// SEARCH
                Container(
                  width: 300,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                /// PROFILE
                Row(
                  children: const [
                    Icon(Icons.notifications_none),
                    SizedBox(width: 20),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Text("PROFILE"),
                  ],
                )
              ],
            ),

            const SizedBox(height: 20),

            /// ADD USER BUTTON
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Add User",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TABLE CONTAINER
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [

                  /// HEADER
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12)),
                    ),
                    child: const Row(
                      children: [
                        TableHeader("NAME", flex: 2),
                        TableHeader("Role", flex: 2),
                        TableHeader("Email", flex: 3),
                        TableHeader("Status", flex: 2),
                        TableHeader("ACTIONS", flex: 2),
                      ],
                    ),
                  ),

                  /// ROWS
                  buildRow("Shibina", "Manager", "ygyhyu@gmail.com", true),
                  buildRow("Shahid", "Agent", "gygtgy@gmail.com", false),
                  buildRow("Shruthy", "Admin", "s23@gmail.com", true),
                  buildRow("Anas", "Agent", "undujiimik@gmail.com", true),
                  buildRow("Jasim", "Manager", "abcdkoko@gmail.com", false),
                  buildRow("Rahul", "Agent", "rahul@gmail.com", true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// HEADER
class TableHeader extends StatelessWidget {
  final String text;
  final int flex;

  const TableHeader(this.text, {super.key, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// ROW
Widget buildRow(
    String name, String role, String email, bool isActive) {
  return Container(
    height: 60, // ✅ SAME HEIGHT FOR ALL ROWS
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade300), // ✅ DIVIDER
      ),
    ),
    child: Row(
      children: [

        /// NAME
        Expanded(
          flex: 2,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(name),
              ],
            ),
          ),
        ),

        /// ROLE
        Expanded(
          flex: 2,
          child: Center(
            child: Container(
              height: 28, // ✅ SAME SIZE
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(role),
            ),
          ),
        ),

        /// EMAIL
        Expanded(
          flex: 3,
          child: Center(child: Text(email)),
        ),

        /// STATUS
        Expanded(
          flex: 2,
          child: Center(
            child: Container(
              height: 28, // ✅ SAME SIZE
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.blue.shade200
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(isActive ? "Active" : "Inactive"),
            ),
          ),
        ),

        /// ACTIONS
        Expanded(
          flex: 2,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.edit, color: Colors.blue),
                SizedBox(width: 10),
                Icon(Icons.block, color: Colors.red),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}