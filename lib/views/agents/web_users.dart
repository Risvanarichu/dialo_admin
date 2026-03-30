import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body:   SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [

        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            const Text(
              "USERS",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            
            Container(
              width: 350,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black26),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "SEARCH",
                  border: InputBorder.none,
                ),
              ),
            ),

            Row(
              children: const [
                Icon(Icons.notifications_none, size: 28),
                SizedBox(width: 20),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text("PROFILE")
              ],
            )
          ],
        ),

        const SizedBox(height: 20),

        const Divider(),

        const SizedBox(height: 20),

        /// ADD USER BUTTON
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                  horizontal: 30, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {},
            child: const Text(
              "Add User",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// TABLE WITH SCROLL
        Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black26),
          ),
          child: Column(
            children: [

              /// HEADER
              const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text("NAME",style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text("Role",style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text("Email",style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text("Status",style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text("ACTIONS",style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),

              const Divider(height: 1),

              /// USER LIST SCROLL
              Expanded(
                child: ListView(
                  children: const [
                    UserRow("Shibina", "Manager", "ygyhyu@gmail.com", true),
                    UserRow("Shahid", "Agent", "gygtgy@gmail.com", false),
                    UserRow("Shruthy", "Admin", "s23@gmail.com", true),
                    UserRow("Anas", "Agent", "undujimiik@gmail.com", true),
                    UserRow("Jasim", "Manager", "abcdkoko@gmail.com", false),
                    UserRow("Rahul", "Agent", "rahul@gmail.com", true),
                    UserRow("Afsal", "Manager", "afsal@gmail.com", false),
                  ],
                ),
              )

            ],
          ),
        )
      ],
    ),
  ),
),
    );
  }
}

class UserRow extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final bool active;

  const UserRow(this.name, this.role, this.email, this.active, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [

             
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 14,
                    ),
                    const SizedBox(width: 10),
                    Text(name, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(role, textAlign: TextAlign.center),
                ),
              ),

             
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(email),
                ),
              ),

              
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    active ? "Active" : "Inactive",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

             
              Expanded(
                child: Row(
                  children: [

                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.edit,
                          size: 18, color: Colors.blue),
                    ),

                    const SizedBox(width: 12),

                    const Icon(Icons.block, color: Colors.red)

                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(height: 1)
      ],
    );
  }
}