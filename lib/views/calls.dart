import 'package:dialo_admin/views/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Calls extends StatefulWidget {
  const Calls({super.key});

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: Padding(padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("CALLS",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(child: TextField(
                  decoration: InputDecoration(
                    labelText: "Date Range",
                    hintText: "dd-mm-yyyy",
                    suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  ),
                ),
                ),
                const SizedBox(width: 15,),
                Expanded(child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "Call Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                  ),
                    items: const[
                      DropdownMenuItem(
                        value: "all",
                          child: Text("All Status"),
                      ),
                      DropdownMenuItem(
                        value:"answered" ,
                          child:Text("Answered"),
                      ),
                      DropdownMenuItem(
                        value: "missed",
                          child: Text("Missed"),
                      ),
                    ],
                    onChanged: (value){},
                ),
                ),
                const SizedBox(width: 15,),
                Expanded(child: DropdownButtonFormField(
                    decoration:InputDecoration(
                      labelText: "Agent",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )
                    ),
                    items: const[
                      DropdownMenuItem(value:"all",
                          child: Text("All Agent"),
                      ),
                      DropdownMenuItem(value:"agent1",
                          child: Text("Agent 1"))
                    ], onChanged: (value){}
                ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Expanded(
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,vertical: 12
                      ),
                      color: Colors.grey.shade100,
                     child: Row(
  children: const[
    Expanded(child: Center(child: Text("Caller Name"))),
    Expanded(child: Center(child: Text("Phone Number"))),
    Expanded(child: Center(child: Text("Call Type"))),
    Expanded(child: Center(child: Text("Status"))),
    Expanded(child: Center(child: Text("Duration"))),
    Expanded(child: Center(child: Text("Date"))),
    Expanded(child: Center(child: Text("Assigned Agent"))),
    Expanded(child: Center(child: Text("Actions"))),
  ],
),
                    ),
                    Expanded(
                        child: ListView(
                          shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      children: const[
                      CallList(name: "Finiya",
                          phone: "+91 1234567891",
                          type: "Inbound",
                          status: "Answered",
                          duration: "5:23",
                          date: "06-01-2026",
                          agent: "Shibina"),
                        CallList(name: "Riswana", phone: "+91 6735428956", type: "outbound", status: "Answered", duration: "5:43", date: "12-01-2026", agent: "Shruthi"),
                        CallList(name: "Ayisha", phone: "+91 6735428956", type: "outbound", status: "Answered", duration: "5:43", date: "12-01-2026", agent: "Shruthi"),
                        CallList(name: "Shibin", phone: "+91 6735428956", type: "outbound", status: "Missed", duration: "5:43", date: "12-01-2026", agent: "Shruthi"),
                        CallList(name: "Anshad", phone: "+91 6735428956", type: "outbound", status: "Answered", duration: "5:43", date: "12-01-2026", agent: "Shruthi"),
                        CallList(name: "Shifa", phone: "+91 6735428956", type: "outbound", status: "Answered", duration: "5:43", date: "12-01-2026", agent: "Shruthi"),
                        CallList(name: "Swabirinn", phone: "+91 6735428956", type: "outbound", status: "Missed", duration: "5:43", date: "12-01-2026", agent: "Shruthi"),
                        CallList(name: "Nida", phone: "+91 6735428956", type: "outbound", status: "Answered", duration: "5:43", date: "12-01-2026", agent: "Shruthi"),
                        CallList(name: "Nida", phone: "+91 6735428956", type: "outbound", status: "Answered", duration: "5:43", date: "12-01-2026", agent: "Shruthi"),
                        CallList(name: "Nida", phone: "+91 6735428956", type: "outbound", status: "Answered", duration: "5:43", date: "12-01-2026", agent: "Shruthi"),
                      ],
                    ))
                  ],
                ),
              ))
        ],
      ),),
    );
  }
}

class CallList extends StatelessWidget {
  final String name;
  final String phone;
  final String type;
  final String status;
  final String duration;
  final String date;
  final String agent;

  const CallList ({
    required this.name,
    required this.phone,
    required this.type,
    required this.status,
    required this.duration,
    required this.date,
    required this.agent,
  });
  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child:  Row(
        children: [
          Expanded(child: Center(child: Text(name))),
          Expanded(child: Center(child: Text(phone))),
          Expanded(child: Center(child: Text(type))),
          Expanded(child: Center(child: Container( 
            width: 100,
            
            padding: const EdgeInsets.symmetric(
              horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              color: status == "Answered"
                  ?Colors.green.shade100
                  :Colors.red.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status,textAlign: TextAlign.center,
            style: TextStyle(
              color: status == "Answered"
                  ?Colors.green
                  :Colors.red,
              fontWeight: FontWeight.w600,
              ),
            ),
          ),),
          ),
          Expanded(child: Center(child: Text(duration))),
    Expanded(child: Center(child: Text(date))),
    Expanded(child: Center(child: Text(agent))),


          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone,size: 18,),
              SizedBox(width: 10,),
              Icon(Icons.edit,size: 18,),
            ],
          ))
        ],
      ),
    );
  }
}
