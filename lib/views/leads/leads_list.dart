import 'package:dialo_admin/models/leadModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                              Expanded(
                                child: TextField(
                                  onChanged: (value){
                                    provider.searchLeads(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Search By Name Phone",
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),

                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              dropdown("All Status"),
                              const SizedBox(width: 20),
                              dropdown("All Sources"),
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


                          provider.leads.isEmpty
                              ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                "No results for '${provider.searchQuery}'",
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                          )
                              : Column(
                            children: provider.leads
                                .map((e) => tableRow(e))
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

Widget tableRow(LeadModel lead) {
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
        Expanded(child: alignCenter(lead.agent)),
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
    default:
      color = Colors.green.shade300;
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

  
