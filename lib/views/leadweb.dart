import 'package:flutter/material.dart';

class Leads extends StatelessWidget {
  const Leads  ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Container(
          //   width: 230,
          //   color: Colors.white,
          //   child: Column(
          //     children: [
          //       const SizedBox(height: 30),
          //       Column(
          //         children: const [
          //
          //           Text("DIALO", style: TextStyle(fontWeight: FontWeight.bold)),
          //           Text("CALL CENTER", style: TextStyle(fontSize: 10)),
          //         ],
          //       ),
          //       const SizedBox(height: 30),
          //       sideItem(Icons.dashboard_outlined, "Dashboard"),
          //       sideItem(Icons.call_outlined, "Calls"),
          //       sideItem(Icons.people_alt_outlined, "Leads"),
          //       sideItem(Icons.person_add_alt_1_outlined, "Add lead"),
          //       sideItem(Icons.calendar_month_outlined, "Follow-Up"),
          //       sideItem(Icons.bar_chart_outlined, "Reports"),
          //       sideItem(Icons.group_outlined, "Users"),
          //       const Spacer(),
          //       Container(
          //         color: Colors.red.shade50,
          //         child: ListTile(
          //           leading: const Icon(Icons.logout, color: Colors.red),
          //           title: const Text("Logout",
          //               style: TextStyle(color: Colors.red)),
          //           onTap: () {},
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

        
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
                                  decoration: InputDecoration(
                                    hintText: "Search By Name Phone",
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
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
                    
                     
                          ...leads.map((e) => tableRow(e)).toList(),
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
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

Widget tableRow(Lead lead) {
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
        Expanded(child: Text(lead.name)),
        Expanded(child: Text(lead.phone)),
        Expanded(child: Text(lead.email)),
        Expanded(child: statusChip(lead.status)),
        Expanded(child: Text(lead.source)),
        Expanded(child: Text(lead.agent)),
      ],
    ),
  );
}

Widget statusChip(String status) {
  Color color;
  switch (status) {
    case "New":
      color = Colors.blue.shade300;
      break;
    case "Converted":
      color = Colors.orange.shade300;
      break;
    default:
      color = Colors.green.shade300;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    child: Text(status),
  );
}

class Lead {
  final String name, phone, email, status, source, agent;
  Lead(this.name, this.phone, this.email, this.status, this.source, this.agent);
}

final List<Lead> leads = [
  Lead("Riswana", "+123-456-7788", "ris@gmail.com", "New", "Website", "Shibina"),
  Lead("Aysha", "+123-456-7890", "ais@gmail.com", "Converted", "Phone Call", "Shruthi"),
  Lead("Finya", "+123-456-7890", "fin@gmail.com", "Interested", "Referral", "Anas"),
  Lead("Shibin", "+123-456-7890", "shi@gmail.com", "New", "Social Media", "Jasim"),
  Lead("Anshad", "+123-456-7890", "ans@gmail.com", "Converted", "Email Campaign", "Shibina"),
  Lead("Hisana", "+123-456-7890", "his@gmail.com", "Interested", "Phone Call", "Anas"),
  Lead("Faiha", "+123-456-7890", "fai@gmail.com", "New", "Website", "Shahid"),
  Lead("Nida", "+123-456-7890", "nid@gmail.com", "Converted", "Referral", "Shruthi"),
  Lead("Nasla", "+123-456-7890", "nas@gmail.com", "Interested", "Social Media", "Jasim"),
  Lead("Jafna", "+123-456-7890", "jaf@gmail.com", "New", "Email Campaign", "Shibina"),
];
  
