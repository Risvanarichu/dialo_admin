import 'package:dialo_admin/providers/mainProvider.dart';
import 'package:dialo_admin/views/agents/addUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
                onPressed: () {
                  context.read<MainProvider>().clearFields();
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>const AddUserPage()));
                },
                child: const Text(
                  "Add User",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TABLE CONTAINER
            Expanded(
              child: Consumer<MainProvider>(
                 builder: (context,provider,child) {
                   if(provider.userList.isEmpty){
                     return const Center(child: Text("No Users Found"),);
                   }
                   return Container(
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
                        // buildRow("Shibina", "Manager", "ygyhyu@gmail.com", true),
                        // buildRow("Shahid", "Agent", "gygtgy@gmail.com", false),
                        // buildRow("Shruthy", "Admin", "s23@gmail.com", true),
                        // buildRow("Anas", "Agent", "undujiimik@gmail.com", true),
                        // buildRow("Jasim", "Manager", "abcdkoko@gmail.com", false),
                        // buildRow("Rahul", "Agent", "rahul@gmail.com", true),
                        Expanded(child: ListView(
                          children: provider.userList.map((user){
                            return buildRow(
                              user["NAME"]?? "",
                              user["ROLE"]?? "",
                              user["EMAIL"]?? "",
                              user["STATUS"]?? true,
                              onEdit: (){
                                provider.editData(user);
                                Navigator.push(context, MaterialPageRoute(builder: (_)=> const AddUserPage()),
                                );
                              },
                              onDelete:(){
                                showDialog(context: context,
                                    builder: (_)=> AlertDialog(
                                      title: const Text("Delete User?"),
                                      content: const Text("Are you sure?"),
                                      actions: [
                                        TextButton(onPressed: ()=> Navigator.pop(context),
                                            child: const Text("Cancel"),
                                        ),
                                        TextButton(onPressed: ()async{
                                          await provider.deleteUser(user["ID"]);
                                          Navigator.pop(context);
                                        },

                                            child:const Text("Delete") )
                                      ],
                                    )
                                );

                              },
                            );
                          }).toList(),
                        ))
                      ],
                    ),
                                 );
                 }
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
    String name,
String role,
String email,
bool isActive,{
      VoidCallback? onDelete,
      VoidCallback? onEdit,
}) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade300),
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
              height: 28,
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
              height: 28,
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
              children: [
               GestureDetector(
                 onTap: onEdit,
                 child: const Icon(Icons.edit,color: Colors.blue,),
               ),
                const SizedBox(width: 10),
               GestureDetector(
                 onTap: onDelete,
                 child: const Icon(Icons.delete,color: Colors.red,),
               )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}