import 'package:dialo_admin/models/leadModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/agentProvider.dart';
import '../../providers/leadProvider.dart';

class Leads extends StatelessWidget {
  const Leads  ({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeadProvider>();
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body:provider.isLoading
          ?const Center(child: CircularProgressIndicator())
          : Row(
        children: [


          Expanded(
            child: Column(
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: const Text("LEADS",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child:SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [

                              /// 🔍 SEARCH (takes more space)
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  onChanged: (value) {
                                    context.read<LeadProvider>().searchLeads(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Search...",
                                    prefixIcon: const Icon(Icons.search),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// 🎯 STATUS FILTER
                              Expanded(
                                child: Consumer<LeadProvider>(
                                  builder: (context, provider, child) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey)
                                      ),
                                      child: DropdownButton(
                                        value: provider.selectedStatus,
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: ["All Status", "New", "Converted", "Interested"]
                                            .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                            .toList(),
                                        onChanged: (value) {
                                          provider.updateStatus(value!);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// 📊 SOURCE FILTER
                              Expanded(
                                child: Consumer<LeadProvider>(
                                  builder: (context, provider, child) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey)
                                      ),
                                      child: DropdownButton(
                                        value: provider.selectedSources,
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: ["All Sources", "Facebook", "Website", "Call"]
                                            .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                            .toList(),
                                        onChanged: (value) {
                                          provider.updateSource(value!);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),


                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.grey.shade200
                            ),
                            child: Row(
                              children:  [
                                tableHead("Name"),
                                tableHead("Phone"),
                                tableHead("Email"),
                                tableHead("Status"),
                                tableHead("Source"),
                                tableHead("Assigned Agent"),
                              ],
                            ),
                          ),


                          provider.allLeads.isEmpty
                              ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                "N o results for '${provider.searchQuery}'",
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                          )
                              : Column(
                            children: provider.allLeads
                                .map((e) => tableRowDynamic(e,context))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}

Widget sideItem(IconData icon, String text) {
  return ListTile(
    leading: Icon(icon, color: Colors.blue),
    title: Text(text),
    onTap: () {},
  );
}

Widget dropdown(String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton(
        value: value,
        items: [value]
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) {},
      ),
    ),
  );
}

Widget tableHead(String text) {
  return Expanded(
    child: Text(text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget tableRowDynamic(LeadModel lead, BuildContext context) {
  final mainProvider = context.read<MainProvider>();
  final agentName = mainProvider.getAgentName(lead.assignedAgentId);

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border(
        left: BorderSide(color: Colors.grey),
        right: BorderSide(color: Colors.grey),
        bottom: BorderSide(color: Colors.grey),
      ),
    ),
    child: Row(
      children: [
        Expanded(child: alignCenter(lead.name)),
        Expanded(child: alignCenter(lead.phone)),
        Expanded(child: alignCenter(lead.email)),
        Expanded(child: Center(child: statusChip(lead.status))),
        Expanded(child: alignCenter(lead.source)),
        Expanded(child: alignCenter(agentName)),
      ],
    ),
  );
}

Widget statusChip(String status) {
  final s = status.trim().toUpperCase();
  Color color;
  switch (s) {
    case "NEW":
      color = Colors.blue.shade300;
      break;
    case "CONVERTED":
      color = Colors.orange.shade300;
      break;
    case "INTERESTED":
      color = Colors.green;
      break;
    default:
      color = Colors.grey.shade300;
  }

  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    child: Text(status,
    textAlign: TextAlign.center),
  );
}

class Lead {
  final String name, phone, email, status, source, agent;
  Lead(this.name, this.phone, this.email, this.status, this.source, this.agent);
}

Widget alignCenter(String text) {
  return Align(
    alignment: Alignment.center,
    child: Text(
      text,
      textAlign: TextAlign.center,
    ),
  );
}


