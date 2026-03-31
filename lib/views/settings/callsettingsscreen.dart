import 'package:flutter/material.dart';

class CallSettingsScreen extends StatefulWidget {
  CallSettingsScreen({super.key});

  @override
  State<CallSettingsScreen> createState() => _CallSettingsState();
}
class _CallSettingsState extends State<CallSettingsScreen> {
  bool CallRecordingEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: Row(
        children: [

          Container(
            width: 1,
            color: Colors.grey.shade900,
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 32, right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 35,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blueGrey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        ' Call Settings',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    Center(
                      child:Container(
                        width: 1050,
                        height: 250,
                        padding: EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                            ),
                          ],
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Configure Call Recording, Routing, And Business Hours',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Call Recording',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(padding: EdgeInsets.only(left: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    textAlign: TextAlign.left,
                                                    'Enable Call Recording'
                                                ),
                                                SizedBox(height: 4),

                                                Text(
                                                  'Automatically record all incoming and outgoing calls',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: CallRecordingEnabled,
                              activeTrackColor: Colors.deepPurple,
                              onChanged: (value) {
                                setState(() {
                                  CallRecordingEnabled = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}

