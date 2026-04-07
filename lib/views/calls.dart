import 'package:dialo_admin/providers/leadProvider.dart';
import 'package:dialo_admin/views/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Calls extends StatefulWidget {
  const Calls({super.key});

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
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
    Expanded(child: Center(child: Text("Time"))),
    Expanded(child: Center(child: Text("Date"))),
    Expanded(child: Center(child: Text("Assigned Agent"))),
    Expanded(child: Center(child: Text("Actions"))),
  ],
),
                    ),
                    Expanded(
                        child:Consumer<LeadProvider>(
  builder: (context, value, child) {
    final leads = value.leads;

    return ListView.builder(
      itemCount: leads.length,
      itemBuilder: (context, index) {
        final lead = leads[index];

        return CallList(
          name: lead.name,
          phone: lead.phone,
          type: lead.source, // inbound/outbound
          status: lead.followupstatus == "pending"
              ? "Missed"
              : "Answered",
          duration: DateFormat('hh:mm a').format(lead.lastContactedDate),// or custom
          date: DateFormat('dd-MM-yyyy').format(lead.lastContactedDate),
          agent: lead.assignedAgent,
        );
      },
    );
  },
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
