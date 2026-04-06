import 'package:dialo_admin/models/leadModel.dart';
import 'package:dialo_admin/providers/leadProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/agentProvider.dart';


class FollowUpPage extends StatefulWidget {
  const FollowUpPage({super.key});

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {

  String selectedFilter = "All";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LeadProvider>().listenLeads();
    });
  }
  @override
  void dispose() {
    context.read<LeadProvider>().leadSubscription?.cancel();
    super.dispose();
  }

  int dueTodayCount(List<LeadModel>leads){
   final now = DateTime.now();
   return leads.where((lead){
     return lead.followupDate.year == now.year &&
     lead.followupDate.month == now.month &&
     lead.followupDate.day == now.day &&
     lead.followupstatus != "COMPLETED";
   }).length;
  }
  int thisWeekCount(List<LeadModel> leads) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return leads.where((lead) {
      return !lead.followupDate.isBefore(startOfWeek) &&
          !lead.followupDate.isAfter(endOfWeek) &&
          lead.followupstatus != "COMPLETED";
    }).length;
  }

  int completedCount(List<LeadModel> leads) {
    return leads.where((lead) => lead.followupstatus == "COMPLETED").length;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeadProvider>();
    List<LeadModel> sortedLeads = List.from(provider.leads);

    sortedLeads.sort((a, b) => b.priorityRank.compareTo(a.priorityRank));
    List<LeadModel> filteredLeads = sortedLeads.where((lead) {
      final now = DateTime.now();

      if (selectedFilter != "Completed" && lead.followupstatus == "COMPLETED") {
        return false;
      }

      bool matchesFilter = true;

      if (selectedFilter == "Due Today") {
        matchesFilter =
            lead.followupDate.year == now.year &&
                lead.followupDate.month == now.month &&
                lead.followupDate.day == now.day;
      } else if (selectedFilter == "This Week") {
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        matchesFilter =
            !lead.followupDate.isBefore(startOfWeek) &&
                !lead.followupDate.isAfter(endOfWeek);
      } else if (selectedFilter == "Completed") {
        matchesFilter = lead.followupstatus == "COMPLETED";
      }

      /// SEARCH
      bool matchesSearch =
          lead.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              lead.assignedAgentId.toLowerCase().contains(searchQuery.toLowerCase()) ||
              lead.priority.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
    print("Loading: ${provider.isLoading}");
    print("Leads count: ${provider.leads.length}");
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      ///  FIXED SCROLL ISSUE
      body:provider.isLoading
        ?const Center(child: CircularProgressIndicator())
        :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER + FILTER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "FOLLOW-UP",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),


                  PopupMenuButton<String>(
                    icon: const Icon(Icons.filter_list, size: 28),
                    onSelected: (value) {
                      setState(() {
                        selectedFilter = value;
                      });
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "All",
                        child: Text("All"),
                      ),
                      const PopupMenuItem(
                        value: "Due Today",
                        child: Text("Due Today"),
                      ),
                      const PopupMenuItem(
                        value: "This Week",
                        child: Text("This Week"),
                      ),
                      const PopupMenuItem(
                        value: "Completed",
                        child: Text("Completed"),
                      ),
                    ],
                  ),
                ],
              ),



              const SizedBox(height: 20),

              /// TOP CARDS
              Row(
                children: [
                  dashboardCard(
                    "Due Today",
                    dueTodayCount(provider.leads).toString(),
                  ),
                  const SizedBox(width: 10),

                  dashboardCard(
                    "This Week",
                    thisWeekCount(provider.leads).toString(),
                  ),
                  const SizedBox(width: 10),

                  dashboardCard(
                    "Completed",
                    completedCount(provider.leads).toString(),
                  ),
                ],
              ),

              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width:250,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          hintText: "search",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 13),
                        ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });

                      },
                    ),
                  ),

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
                child: filteredLeads.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text("No Follow-Ups Found")),
                )
                    : Column(
                  children: [
                    tableHeader(),
                    const Divider(height: 1),

                    ...filteredLeads.map((lead) {
                      return tableRowDynamic(context, lead);
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
        tableCell("FOLLOW_UP_DATE", isHeader: true),
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
  final mainProvider = context.read<MainProvider>();
  final agentName = mainProvider.getAgentName(lead.assignedAgentId);

  final priority = lead.autoPriority;
  Color color(){
    if(priority == "High") return Colors.red;
    if(priority == "Medium") return Colors.orange;
    return Colors.green;
  }

  Color getPrioritycolor() {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
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

          tableCell(DateFormat('dd MMM yyyy').format(lead.followupDate)),
          tableCell(lead.time),
          tableCell(priority,color: getPrioritycolor(),),
          tableCell(agentName),

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
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );

                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    String formattedTime = pickedTime != null
                        ? pickedTime.format(context)
                        : DateFormat('hh:mm a').format(pickedDate);

                    context.read<LeadProvider>().rescheduleLead(
                      lead.id,
                      pickedDate,
                      formattedTime,
                    );
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