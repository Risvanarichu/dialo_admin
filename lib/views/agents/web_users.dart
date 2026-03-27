import 'package:dialo_admin/providers/mainProvider.dart';
import 'package:dialo_admin/views/agents/addUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';


class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Padding(
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
                      child:  Consumer<MainProvider>(
                        builder: (context,provider,child) {
                          return TextField(
                            controller: provider.searchController,
                            onChanged: (value){
                              provider.searchUser(value);
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                            ),
                          );
                        }
                      ),
                    ),

                    /// PROFILE
                    Row(
                      children: const [
                        Icon(Icons.notifications_none),
                        SizedBox(width: 20),
                        CircleAvatar(
                          backgroundColor: AppColors.themeColor,
                          child: Icon(Icons.person, color: AppColors.whitetext),
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
                      backgroundColor: AppColors.themeColor,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () async {
                      final provider = context.read<MainProvider>();
                      provider.setPageLoading(true);

                      await Future.delayed(
                          const Duration(milliseconds: 300));

                      provider.clearFields();

                      provider.setPageLoading(false);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AddUserPage()),
                      );
                    },
                    child: const Text(
                      "Add User",
                      style: TextStyle(color: AppColors.whitetext),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// TABLE CONTAINER
                Expanded(
                  child: Consumer<MainProvider>(
                     builder: (context,provider,child) {
                       // if(provider.isLoading){
                       //   return const Center(
                       //     child: CircularProgressIndicator(),
                       //   );
                       // }
                       if(provider.filteredUserList.isEmpty)  {
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
                            Expanded(child: ListView(
                              children: provider.filteredUserList.map((user){
                                return buildRow(
                                  user["NAME"]?? "",
                                  user["ROLE"]?? "",
                                  user["EMAIL"]?? "",
                                  user["STATUS"]?? true,
                                  imageUrl:user["IMAGE"]??"",
                                  onEdit: (){
                                    provider.editData(user);
                                    Navigator.push(context, MaterialPageRoute(builder: (_)=> const AddUserPage()),
                                    );
                                  },
                                  onDelete:(){
                                    showDialog(context: context,
                                        builder: (_)=> AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: const Text("Delete User?"),
                                          content: const Text("Are you sure?"),
                                          actions: [
                                            ElevatedButton(
                                              style:ElevatedButton.styleFrom(
                                            backgroundColor:AppColors.themeColor
                                        ),
                                              onPressed: ()=> Navigator.pop(context),
                                                child: const Text("Cancel",
                                                style: TextStyle(color: AppColors.whitetext),),
                                            ),
                                            ElevatedButton(
                                                style:ElevatedButton.styleFrom(
                                                    backgroundColor:AppColors.themeColor
                                                ),
                                                onPressed: ()async{
                                              await provider.deleteUser(user["ID"]);
                                              Navigator.pop(context);
                                            },

                                                child:const Text("Delete",
                                                style: TextStyle(color: AppColors.whitetext),) )
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
          Consumer<MainProvider>(
              builder: (context,provider,child){
                if(!provider.isLoading)return const SizedBox();
                return fullScreenLoader();
              }
              )
        ],
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
      VoidCallback? onEdit, required imageUrl,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.themeColor,
                  backgroundImage:( imageUrl != null && imageUrl.toString().isNotEmpty)
                  ? NetworkImage(imageUrl)
                  :null,
                  child: (imageUrl == null || imageUrl.toString().isEmpty)
                  ?const Icon(Icons.person,size: 16,color: Colors.white,)
                  :null,
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(name,
                    overflow: TextOverflow.ellipsis,
                    ),
                ),
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
Widget fullScreenLoader(){
  return Container(
    color: Colors.black.withOpacity(0.2),
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  );
}