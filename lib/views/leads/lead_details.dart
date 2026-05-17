import 'package:dialo_admin/models/leadModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';
import '../../providers/leadProvider.dart';
import '../../providers/settings_provider.dart';
import 'addlead.dart';

class LeadDetails extends StatelessWidget {
  final LeadModel lead;
  const LeadDetails({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lead.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xffDCE8FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.lightBlueAccent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      lead.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    detailRow("Phone", lead.phone),
                    detailRow("Email", lead.email),
                    detailRow("Status", lead.Leadstatus),
                    detailRow("Source", lead.source),
                    detailRow("Priority", lead.priority),
                    detailRow("Agent_ID", lead.assignedAgentId),

                    const SizedBox(height: 20),

                    /// 🔽 BUTTONS AT BOTTOM RIGHT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        /// ✏️ EDIT BUTTON
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<LeadProvider>().editData({
                              "ID": lead.id,
                              "NAME": lead.name,
                              "PHONE": lead.phone,
                              "EMAIL": lead.email,
                              "SOURCE": lead.source,
                              "LEAD_STATUS": lead.Leadstatus,
                              "CALL_STATUS": lead.callStatus,
                              "NOTES": lead.notes,
                              "AGENT_ID": lead.assignedAgentId,
                              "AGENT_NAME": lead.assignedAgentName,
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>  AddLead(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit,color: AppColors.whitetext,),
                          label: const Text("Edit",style:
                            TextStyle(color: AppColors.whitetext),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.themeColor,
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// 🗑 DELETE BUTTON
                        ElevatedButton.icon(
                          onPressed: () {
                            _showDeleteDialog(context, lead.id);
                          },
                          icon: const Icon(Icons.delete,color: AppColors.whitetext,),
                          label: const Text("Delete",style:
                          TextStyle(color: AppColors.whitetext)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                onPressed: () {
      showDialog(
      context: context,
      builder: (context) => AddFollowUpDialog(leadId: lead.id),
      );
      },
                  label: const Text("Add Follow-up",
                  style: TextStyle(color: AppColors.whitetext),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    backgroundColor: AppColors.themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:BorderRadius.circular(5),
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showDeleteDialog(BuildContext context, String leadId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete Lead"),
        content: const Text("Are you sure you want to delete this lead?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await context.read<LeadProvider>().deleteUser(leadId);
              Navigator.pop(context);
              Navigator.pop(context); // go back after delete
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
Widget detailRow(String title,String value){
  return Padding(padding: 
      const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 90,
        child: Text("$title",style: const TextStyle(
          fontWeight: FontWeight.bold
        ),),),
        Expanded(child: Text(value.isEmpty?"-":value,
        style: const TextStyle(fontSize: 15),))
        
      ],
    ),
  );
}

class AddFollowUpDialog extends StatefulWidget {
  final String leadId;

  const AddFollowUpDialog({super.key, required this.leadId});

  @override
  State<AddFollowUpDialog> createState() => _AddFollowUpDialogState();
}

class _AddFollowUpDialogState extends State<AddFollowUpDialog> {
  final _formKey = GlobalKey<FormState>();


  String? callStatus;
  String? leadStatus;
  String? leadCategory;
  String? priority;

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final provider = context.watch<LeadProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Add Follow-up",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                /// Called Date
                _label("Called Date"),
                TextFormField(
                  controller: context.watch<LeadProvider>().dateController,
                  readOnly: true,
                  decoration: _decoration("CALLED DATE*"),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      selectedDate = picked;
                      provider.dateController.text =
                      "${picked.year}-${picked.month}-${picked.day}";
                    }
                  },
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 12),

                /// Call Status
                _label("Call Status"),
                _dropdown(
                  "CALL STATUS*",
                  settings.callStatus,
                  callStatus,
                      (v) => setState(() => callStatus = v),
                ),

                /// Lead Status
                _label("Lead Status"),
                _dropdown(
                  "LEAD STATUS*",
                  settings.leadStatus,
                  leadStatus,
                      (v) => setState(() => leadStatus = v),
                ),

                /// Lead Category
                _label("Lead Category"),
                _dropdown(
                  "LEAD CATEGORY*",
                  settings.leadCategory,
                  leadCategory,
                      (v) => setState(() => leadCategory = v),
                ),

                /// Priority (static or move to settings later)
                _label("Priority"),
                _dropdown(
                  "PRIORITY*",
                  ["High", "Medium", "Low"],
                  priority,
                      (v) => setState(() => priority = v),
                ),

                const SizedBox(height: 12),

                /// Email
                _label("Email"),
                TextFormField(
                  controller: context.watch<LeadProvider>().emailController,
                  decoration: _decoration("EMAIL"),
                ),

                const SizedBox(height: 12),

                /// Remarks
               _label("Remarks"),
                TextFormField(
                  controller: context.watch<LeadProvider>().remarkController,
                  maxLines: 3,
                  decoration: _decoration("REMARKS"),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),

                    ElevatedButton(
                      onPressed: provider.isButtonLoading
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await context
                                .read<LeadProvider>()
                                .addFollowUp(
                              leadId: widget.leadId,
                              callStatus: callStatus!,
                              leadStatus: leadStatus!,
                              leadCategory: leadCategory!,
                              priority: priority!,
                              remarks: provider.remarkController.text,
                              email: provider.emailController.text,
                              followUpDate: selectedDate,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                Text("Follow-up added successfully"),
                              ),
                            );

                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          }
                        }
                      },
                      child: provider.isButtonLoading
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text("Submit"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropdown(
      String label,
      List<String> list,
      String? value,
      Function(String?) onChanged,
      ) {
    final uniqueList = list.toSet().toList(); // ✅ remove duplicates

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: uniqueList.contains(value) ? value : null, // ✅ safe value
        hint: Text(label),
        items: uniqueList.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? "Required" : null,
        decoration: _decoration(label),
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}

Widget _label(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    ),
  );
}