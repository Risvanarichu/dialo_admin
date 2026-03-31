import 'package:dialo_admin/models/leadModel.dart';
import 'package:dialo_admin/providers/leadProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class FollowUpPage extends StatefulWidget {
  const FollowUpPage({super.key});

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {

  @override
  void initState(){
    super.initState();
    Future.microtask((){
      context.read<LeadProvider>().fetchLeads();
    });
  }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeadProvider>();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      /// ✅ FIXED SCROLL ISSUE
      body:provider.isLoading
        ?const Center(child: CircularProgressIndicator())
        :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "FOLLOW-UP",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// TOP CARDS
              Row(
                children: [
                  dashboardCard("Due Today", "23"),
                  const SizedBox(width: 10),
                  dashboardCard("This Week", "15"),
                  const SizedBox(width: 10),
                  dashboardCard("Completed", "50"),
                ],
              ),

              const SizedBox(height: 20),

              /// TABLE
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),

                    /// ROWS
                   child:  provider.leads.isEmpty
                    ?const Center(child: Text("No Follow-Ups Found"),)
                    :Column(
                      children: [
                        tableHeader(),
                        const Divider(height: 1,),

                  ...provider.leads.map((lead){
                    return tableRowDynamic(context,lead);
                  }).toList(),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= CARD =================
Widget dashboardCard(String title, String value) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

/// ================= HEADER =================
Widget tableHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    color: Colors.grey.shade300,
    child: Row(
      children: const [
        tableCell("LEAD NAME", isHeader: true),
        tableCell("ADDED_TIME", isHeader: true),
        tableCell("TIME", isHeader: true),
        tableCell("PRIORITY", isHeader: true),
        tableCell("AGENT", isHeader: true),
        tableCell("ACTIONS", isHeader: true),
      ],
    ),
  );
}

/// ================= ROW =================
Widget tableRowDynamic(BuildContext context,LeadModel lead){
  Color getPrioritycolor(){
    switch(lead.priority){
      case"High":
        return Colors.red;
      case"Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
  return Column(
    children: [
      Padding(padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          tableCell(lead.name),
          tableCell(DateFormat('hh:mm a').format(lead.addedTime)),
          tableCell(lead.time),
          tableCell(lead.priority,color: getPrioritycolor(),),
          tableCell(lead.agent),

          Expanded(child: Wrap(
            spacing: 5,
            children: [
              GestureDetector(
                onTap: (){
                  context.read<LeadProvider>().completedLead(lead.id);
                },
                child: actionButton("Complete", Colors.green),
              ),

              GestureDetector(
                onTap: ()async{
                  DateTime? picked = await showDatePicker(context: context,
                      initialDate:DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                  );
                if(picked != null){
                  context.read<LeadProvider>().rescheduleLead(lead.id,picked);
                }
                },
                child: actionButton("Reschedule", Colors.blue),
              )
            ],
          ))
        ],
      ),),
      const Divider(height: 1,),
    ],
  );
}

/// ================= CELL =================
class tableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final Color? color;

  const tableCell(this.text,
      {this.isHeader = false, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black,
          ),
        ),
      ),
    );
  }
}

/// ================= BUTTON =================
Widget actionButton(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        color: Colors.white,
      ),
    ),
  );
}