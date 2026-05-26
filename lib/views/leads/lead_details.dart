import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/models/leadModel.dart';
import 'package:dialo_admin/providers/leadProvider.dart';
import 'package:dialo_admin/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';
import 'addlead.dart';

class LeadDetails extends StatelessWidget {
  final LeadModel lead;

  const LeadDetails({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          lead.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _topLeadCard(context),
            const SizedBox(height: 18),
            Expanded(child: _followUpSection(context)),
          ],
        ),
      ),
    );
  }

  Widget _topLeadCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xffd3d2fb),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff8d89fb)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 42,
              color: Colors.grey.shade500,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      lead.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff263238),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Lead priority: ${lead.priority.isEmpty ? "-" : lead.priority}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Wrap(
                  spacing: 18,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _topInfo(Icons.email_outlined, lead.email),
                    _divider(),
                    _topText("Status", lead.Leadstatus, red: true),
                    _divider(),
                    _topText("Source", lead.source),
                    _divider(),
                    _topText("Priority", lead.priority, red: true),
                    _divider(),
                    _topText("Agent ID", lead.assignedAgentId),
                  ],
                ),
              ],
            ),
          ),

          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AddFollowUpDialog(
                  leadId: lead.id,
                  leadEmail: lead.email,
                ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Add Follow-up",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.themeColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),

          const SizedBox(width: 10),

          IconButton(
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
                MaterialPageRoute(builder: (_) => const AddLead()),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.black87),
          ),

          IconButton(
            onPressed: () {
              _showDeleteDialog(context, lead.id);
            },
            icon: const Icon(Icons.delete, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _followUpSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Followup Report",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xff263238),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("LEADS")
                  .doc(lead.id)
                  .collection("FOLLOW_UPS")
                  .orderBy("CREATED_AT", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No follow-ups added"));
                }

                final followups = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: followups.length,
                  itemBuilder: (context, index) {
                    final data =
                    followups[index].data() as Map<String, dynamic>;

                    final date = data["FOLLOW_UP_DATE"] is Timestamp
                        ? (data["FOLLOW_UP_DATE"] as Timestamp).toDate()
                        : null;

                    return _followUpTimelineCard(data, date, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _topInfo(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: Colors.black87),
        const SizedBox(width: 7),
        Text(
          value.isEmpty ? "-" : value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _topText(String title, String value, {bool red = false}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 14),
        children: [
          TextSpan(
            text: "$title : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value.isEmpty ? "-" : value,
            style: TextStyle(
              color: red ? Colors.redAccent : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 22,
      width: 1,
      color: Colors.grey.shade400,
    );
  }
}

class AddFollowUpDialog extends StatefulWidget {
  final String leadId;
  final String leadEmail;

  const AddFollowUpDialog({
    super.key,
    required this.leadId,
    required this.leadEmail,
  });

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
  TimeOfDay? selectedTime;
  DateTime lastCalledDate = DateTime.now();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.leadEmail;

    Future.microtask(() {
      context.read<SettingsProvider>().fetchAllSettings();
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    dateController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  String formatLastCalledDate() {
    return "${lastCalledDate.day.toString().padLeft(2, '0')}-"
        "${lastCalledDate.month.toString().padLeft(2, '0')}-"
        "${lastCalledDate.year} "
        "${TimeOfDay.fromDateTime(lastCalledDate).format(context)}";
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final provider = context.watch<LeadProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Follow-up",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                _label("Reminder Date & Time"),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: _decoration("Select date and time"),
                  onTap: _pickDateTime,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Required";
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                _label("Last Called Date"),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.blue),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          formatLastCalledDate(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: lastCalledDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate == null) return;

                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(lastCalledDate),
                          );

                          if (pickedTime == null) return;

                          setState(() {
                            lastCalledDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        },
                        child: const Text("Change"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _label("Call Status"),
                _dropdown(
                  "Call Status",
                  settings.callStatus,
                  callStatus,
                      (value) => setState(() => callStatus = value),
                ),

                _label("Lead Status"),
                _dropdown(
                  "Lead Status",
                  settings.leadStatus,
                  leadStatus,
                      (value) => setState(() => leadStatus = value),
                ),

                _label("Lead Category"),
                _dropdown(
                  "Lead Category",
                  settings.leadCategory,
                  leadCategory,
                      (value) => setState(() => leadCategory = value),
                ),

                _label("Priority"),
                _dropdown(
                  "Priority",
                  const ["High", "Medium", "Low"],
                  priority,
                      (value) => setState(() => priority = value),
                ),

                _label("Email"),
                TextFormField(
                  controller: emailController,
                  decoration: _decoration("Email"),
                ),

                const SizedBox(height: 12),

                _label("Remarks"),
                TextFormField(
                  controller: remarkController,
                  maxLines: 3,
                  decoration: _decoration("Remarks"),
                ),

                const SizedBox(height: 22),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: provider.isButtonLoading
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          await context.read<LeadProvider>().addFollowUp(
                            leadId: widget.leadId,
                            callStatus: callStatus!,
                            leadStatus: leadStatus!,
                            leadCategory: leadCategory!,
                            priority: priority!,
                            remarks: remarkController.text.trim(),
                            email: emailController.text.trim(),
                            lastContactedDate: lastCalledDate,
                            followUpDate: selectedDate,
                          );

                          if (!mounted) return;

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                              Text("Follow-up added successfully"),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.themeColor,
                      ),
                      child: provider.isButtonLoading
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    selectedTime = pickedTime;

    selectedDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    dateController.text =
    "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year} "
        "${pickedTime.format(context)}";

    setState(() {});
  }

  Widget _dropdown(
      String label,
      List<String> list,
      String? value,
      Function(String?) onChanged,
      ) {
    final uniqueList = list.toSet().toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: uniqueList.contains(value) ? value : null,
        hint: Text(label),
        items: uniqueList.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) return "Required";
          return null;
        },
        decoration: _decoration(label),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}

Widget _followUpTimelineCard(
    Map<String, dynamic> data,
    DateTime? date,
    int index,
    ) {
  final dateText = date == null
      ? "-"
      : "${date.day.toString().padLeft(2, '0')}\n${_monthName(date.month)}, ${date.year}";

  final timeText = date == null
      ? "-"
      : _formatTime(date);

  final lastCalled = data["LAST_CONTACTED_DATE"] is Timestamp
      ? (data["LAST_CONTACTED_DATE"] as Timestamp).toDate()
      : null;

   final lastCalledText = lastCalled == null
      ? "-"
      : "${lastCalled.day.toString().padLeft(2, '0')}-"
      "${lastCalled.month.toString().padLeft(2, '0')}-"
      "${lastCalled.year} ${_formatTime(lastCalled)}";

  return IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.grey.shade300,
                child: Text(
                  dateText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff263238),
                  ),
                ),
              ),
            ],
          ),
        ),

        Column(
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: Color(0xff00B894),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Container(
                width: 2,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),

        const SizedBox(width: 22),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Wrap(
                    spacing: 45,
                    runSpacing: 22,
                    children: [
                      _reportItem(
                        "Call Status",
                        data["CALL_STATUS"] ?? "-",
                        Icons.call,
                        Colors.green,
                      ),
                      _reportItem(
                        "Lead Status",
                        data["LEAD_STATUS"] ?? "-",
                        Icons.people_alt,
                        Colors.orange,
                      ),
                      _reportItem(
                        "Category",
                        data["LEAD_CATEGORY"] ?? "-",
                        Icons.description,
                        Colors.deepPurple,
                      ),
                      _reportItem(
                        "Priority",
                        data["PRIORITY"] ?? "-",
                        Icons.flag,
                        (data["PRIORITY"] == "High")
                            ? Colors.red
                            : Colors.orange,
                      ),
                      _reportItem(
                        "Reminder Date",
                        date == null
                            ? "-"
                            : "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} $timeText",
                        Icons.calendar_month,
                        Colors.black87,
                      ),
                      _reportItem(
                        "Remarks",
                        data["REMARKS"] ?? "-",
                        Icons.notes,
                        Colors.black87,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _reportItem(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    ) {
  return SizedBox(
    width: 180,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xff263238),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value.toString().isEmpty ? "-" : value.toString(),
                style: TextStyle(
                  fontSize: 13,
                  color: title == "Priority" && value == "High"
                      ? Colors.red
                      : Colors.black87,
                  fontWeight: title == "Priority"
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _label(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    ),
  );
}

String _monthName(int month) {
  const months = [
    "",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  return months[month];
}

String _formatTime(DateTime date) {
  final hour = date.hour > 12
      ? date.hour - 12
      : date.hour == 0
      ? 12
      : date.hour;

  final minute = date.minute.toString().padLeft(2, '0');
  final period = date.hour >= 12 ? "PM" : "AM";

  return "$hour:$minute $period";
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
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await context.read<LeadProvider>().deleteUser(leadId);
              Navigator.pop(context);
              Navigator.pop(context);
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