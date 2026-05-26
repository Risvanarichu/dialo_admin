
import 'package:dialo_admin/models/leadModel.dart';
import 'package:dialo_admin/providers/settings_provider.dart';
import 'package:dialo_admin/views/leads/lead_details.dart';
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final bool isWide = constraints.maxWidth > 700;

                              Widget searchField() {
                                return TextField(
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
                                      borderSide: const BorderSide(color: Colors.grey),
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }

                              Widget statusDropdown() {
                                return Consumer2<LeadProvider, SettingsProvider>(
                                  builder: (context, leadProvider, settingsProvider, child) {
                                    final statusItems = [
                                      "All Status",
                                      ...settingsProvider.leadStatus.toSet().toList(),
                                    ];

                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: DropdownButton<String>(
                                        value: statusItems.contains(leadProvider.selectedStatus)
                                            ? leadProvider.selectedStatus
                                            : "All Status",
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: statusItems.map((e) {
                                          return DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            leadProvider.updateStatus(value);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                );
                              }

                              Widget sourceDropdown() {
                                return Consumer2<LeadProvider, SettingsProvider>(
                                  builder: (context, leadProvider, settingsProvider, child) {
                                    final sourceItems = [
                                      "All Sources",
                                      ...settingsProvider.leadSource.toSet().toList(),
                                    ];

                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: DropdownButton<String>(
                                        value: sourceItems.contains(leadProvider.selectedSources)
                                            ? leadProvider.selectedSources
                                            : "All Sources",
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: sourceItems.map((e) {
                                          return DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            leadProvider.updateSource(value);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                              Widget agentDropdown() {
                                return Consumer2<LeadProvider, Agentprovider>(
                                  builder: (context, leadProvider, agentProvider, child) {

                                    final agentItems = [
                                      "all",
                                      ...agentProvider.userList.map((e) => e["ID"].toString()).toSet(),
                                    ];

                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: DropdownButton<String>(
                                        value: agentItems.contains(leadProvider.selectedAgentFilter)
                                            ? leadProvider.selectedAgentFilter
                                            : "all",
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: [
                                          const DropdownMenuItem<String>(
                                            value: "all",
                                            child: Text("All Agents"),
                                          ),

                                          const DropdownMenuItem<String>(
                                            value: "unassigned",
                                            child: Text("Unassigned"),
                                          ),

                                          ...agentProvider.userList.map<DropdownMenuItem<String>>((agent) {
                                            return DropdownMenuItem<String>(
                                              value: agent["ID"].toString(),
                                              child: Text(agent["NAME"] ?? ""),
                                            );
                                          }).toList(),
                                        ],
                                        onChanged: (value) {
                                          if (value != null) {
                                            leadProvider.setAgentFilter(value);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                              return isWide
                                  ? Row(
                                children: [
                                  Expanded(flex: 2, child: searchField()),
                                  const SizedBox(width: 10),
                                  Expanded(child: statusDropdown()),
                                  const SizedBox(width: 10),
                                  Expanded(child: sourceDropdown()),
                                  const SizedBox(width: 10),
                                  if (provider.userRole == "ADMIN")
                                    Expanded(child: agentDropdown()),
                                ],
                              )
                                  : Column(
                                children: [
                                  searchField(),
                                  const SizedBox(height: 10),

                                  statusDropdown(),
                                  const SizedBox(height: 10),

                                  sourceDropdown(),

                                  if (provider.userRole == "ADMIN") ...[
                                    const SizedBox(height: 10),
                                    agentDropdown(),
                                  ],
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 900,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Row(
                                      children: [
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
                                              "No results for '${provider.searchQuery}'",
                                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                                            ),
                                          ),
                                        )
                                      : Column(
                                          children: provider.allLeads
                                              .map((e) => tableRowDynamic(e, context))
                                              .toList(),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
  final mainProvider = context.read<Agentprovider>();

  final assignedId = lead.assignedAgentId.toString().trim();

  final agentExists = mainProvider.userList.any(
        (e) => e["ID"].toString() == assignedId,
  );

  final agentName =
  (!agentExists || assignedId.isEmpty)
      ? "Unassigned"
      : mainProvider.getAgentName(assignedId);

  return InkWell(
    onTap: (){
      Navigator.push(
        context,MaterialPageRoute(builder: (context)=>LeadDetails(lead: lead)),
      );

    },
  child:
    Container(
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
        Expanded(child: Center(child:statusChip(lead.Leadstatus) )),
        Expanded(child: alignCenter(lead.source)),
        Expanded(child: alignCenter(agentName)),
  //       Expanded(child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           GestureDetector(
  // onTap: () {
  // final provider = context.read<LeadProvider>();
  //
  // provider.editData({
  //   "ID": lead.id,
  //   "NAME": lead.name,
  //   "PHONE": lead.phone,
  //   "EMAIL": lead.email,
  //   "SOURCE": lead.source,
  //   "LEAD_STATUS": lead.Leadstatus,
  //   "CALL_STATUS": lead.callStatus,
  //   "NOTES": lead.notes,
  //   "AGENT_ID": lead.assignedAgentId,
  //   "AGENT_NAME": lead.assignedAgentName,
  // });
  //
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (_) => const AddLead(),
  //   ),
  // );
  // },
  //
  //             child: Icon(Icons.edit,color: AppColors.themeColor,),
  //           ),
  //           SizedBox(width: 10,),
  //           GestureDetector(
  //             onTap: () {
  //               showDeleteDialog(context, lead.id);
  //             },
  //             child: Icon(Icons.delete, color: AppColors.redColor),
  //           )
  //         ],
  //       ))
      ],
    ),
    ),
  );
}

void showEditDialog(BuildContext context) {
  final provider = context.read<LeadProvider>();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Edit Lead"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: provider.nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: provider.phoneController,
            decoration: const InputDecoration(labelText: "Phone"),
          ),
          TextField(
            controller: provider.emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: provider.sourceController,
            decoration: const InputDecoration(labelText: "Source"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            provider.clearFields();
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            await provider.updateUser(leadStatus: '', callStatus: '',leadCategory: '', notes: '');
            Navigator.pop(context);
          },
          child: const Text("Update"),
        ),
      ],
    ),
  );
}

void showDeleteDialog(BuildContext context, String id) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Delete Lead"),
      content: const Text("Are you sure you want to delete?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            context.read<LeadProvider>().deleteUser(id);
            Navigator.pop(context);
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

Widget statusChip(String status) {
  final text =status.trim().isEmpty?"NO STATUS":status;
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    ),
    decoration: BoxDecoration(
      color: Colors.blue.shade100,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
  // return Container(
  //   alignment: Alignment.center,
  //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //   decoration:
  //       BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
  //   child: Text(status,
  //   textAlign: TextAlign.center),
  // );
//}
Widget alignCenter(String text) {
  return Align(
    alignment: Alignment.center,
    child: Text(
      text,
      textAlign: TextAlign.center,
    ),
  );
}


