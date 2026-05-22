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
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Call Settings',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(right: 32, bottom: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 1050),
                                padding: const EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Configure Call Recording, Routing, And Business Hours',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          const Text(
                                            'Call Recording',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Enable Call Recording',
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Automatically record all incoming and outgoing calls',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade600,
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
                                    const SizedBox(width: 20),
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

