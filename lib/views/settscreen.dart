import 'package:flutter/material.dart';

import 'callsettingsscreen.dart';
import 'leadsettingsscreen.dart';


class SettingsScreen extends StatelessWidget{
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Row(
        children: [


          Container(
            width: 1,
            color: Colors.grey.shade900,
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade900,
                          width: 1,
                        ),
                      ),
                    ),

                    child: Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  Expanded(


                    child: SizedBox(
                      width: 850,
                      child:  GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 150,
                        mainAxisSpacing: 35,
                        childAspectRatio: 3.5,
                        children: [
                          SettingsCard(
                            title: 'Call Settings',
                            subtitle: "Configure Call Recording, Routing\nand Business Hours ",
                            onTap: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => CallSettingsScreen(),
                                ),
                              );
                            },
                          ),


                          SettingsCard(
                            title: "User Management",
                            subtitle: "Manage User Roles, Permission And\nAccess Controls",
                            onTap: (){},
                          ),

                          SettingsCard(
                            title: "Lead Settings",
                            subtitle: "Configure Lead Sources Status\nand Assignment Rules",
                            onTap: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LeadSettingsScreen(),
                                ),
                              );
                            },
                          ),
                          SettingsCard(
                            title: "Notification Settings",
                            subtitle: "Set up Email, SMS And In-App Notification",
                            onTap: (){},
                          ),
                        ],
                      ),



                    ),
                  ),


                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}



class SettingsCard extends StatelessWidget{
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  SettingsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return  InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade600,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.chevron_right,
                  size: 22,
                ),
              ],
            ),
            SizedBox(height: 6,),

            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),


    );
  }
}