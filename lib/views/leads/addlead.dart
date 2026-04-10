import 'package:dialo_admin/providers/leadProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddLead extends StatefulWidget {
  const AddLead({super.key});

  @override
  State<AddLead> createState() => _AddLeadState();
}

class _AddLeadState extends State<AddLead> {
  final _formKey = GlobalKey<FormState>();

  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final sourceCtrl = TextEditingController();
  final leadStatusCtrl = TextEditingController();
  final callTypeCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final phoneRegex = RegExp(r'^[6-9]\d{9}$');

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LeadProvider>().fetchLeadSettings();
    });
  }

  @override
  void dispose() {
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    sourceCtrl.dispose();
    leadStatusCtrl.dispose();
    callTypeCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _topBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _formCard(isMobile),
                          const SizedBox(height: 24),
                          _additionaldetailsCard(isMobile),
                          const SizedBox(height: 24),
                          _notesSection(),
                          const SizedBox(height: 24),
                          _actionButtons(),
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

  Widget _topBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "ADD NEW LEAD",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Divider(height: 1),
        ],
      ),
    );
  }

  Widget _formCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          _rowFields(
            isMobile,
            _input("FULL NAME*", fullNameCtrl),
            _input("PHONE NUMBER*", phoneCtrl, phone: true),
          ),
          const SizedBox(height: 16),
          _rowFields(
            isMobile,
            _input("EMAIL ADDRESS*", emailCtrl,),
            _input("SOURCES*", sourceCtrl),
          ),
          const SizedBox(height: 16),
          _rowFields(
            isMobile,
            _leadStatusDropdown(),
            _calltypeDropdown(),
          ),
        ],
      ),
    );
  }

  Widget _leadStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("LEAD STATUS*"),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: leadStatusCtrl.text.isEmpty ? null : leadStatusCtrl.text,
          icon: const Icon(Icons.arrow_drop_down),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          items: const [
            DropdownMenuItem(value: "New", child: Text("New")),
            DropdownMenuItem(value: "Contacted", child: Text("Contacted")),
            DropdownMenuItem(value: "Rejected", child: Text("Rejected")),
            DropdownMenuItem(value: "Accepted", child: Text("Accepted")),
            DropdownMenuItem(value: "Joined", child: Text("Joined")),
          ],
          onChanged: (value) {
            setState(() {
              leadStatusCtrl.text = value ?? "";
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select lead status";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _calltypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("CALL TYPE*"),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: callTypeCtrl.text.isEmpty ? null : callTypeCtrl.text,
          icon: const Icon(Icons.arrow_drop_down),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          items: const [
            DropdownMenuItem(value: "Incoming", child: Text("Incoming")),
            DropdownMenuItem(value: "Outgoing", child: Text("Outgoing")),
          ],
          onChanged: (value) {
            setState(() {
              callTypeCtrl.text = value ?? "";
            });
          },
        ),
      ],
    );
  }

  Widget _additionaldetailsCard(bool isMobile) {
    final provider = context.watch<LeadProvider>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          const Text(
            "Additional Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (provider.categories.isEmpty)
            const Text("No additional details found")
          else
            ...provider.categories.map((cat) {
              final String title = cat["title"] ?? "";
              final List subList = cat["sub"] ?? [];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: subList.isNotEmpty
                    ? _buildDropdownField(title, subList)
                    : _buildTextField(title),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List subList) {
    final provider = context.watch<LeadProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: provider.additionalDetails[label],
          items: subList
              .map<DropdownMenuItem<String>>(
                (e) => DropdownMenuItem<String>(
              value: e.toString(),
              child: Text(e.toString()),
            ),
          )
              .toList(),
          onChanged: (value) {
            context.read<LeadProvider>().additionalDetails[label] = value;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label) {
    final provider=context.watch<LeadProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          key: ValueKey("${label}_${provider.additionalDetails[label] ?? ""}"),
          initialValue: provider.additionalDetails[label] ?? "",
          onChanged: (value) {
            context.read<LeadProvider>().additionalDetails[label] = value;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowFields(bool isMobile, Widget left, Widget right) {
    if (isMobile) {
      return Column(
        children: [
          left,
          const SizedBox(height: 16),
          right,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 24),
        Expanded(child: right),
      ],
    );
  }

  Widget _input(
      String label,
      TextEditingController controller, {
        bool phone = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: phone ? TextInputType.phone : TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          validator: (value) {
            final text=value?.trim()??"";
            if (label.contains("*") && (value == null || value.trim().isEmpty)) {
              return "Required";
            }
            if(label=="EMAIL ADDRESS*"&&!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(text)){
              return "Enter a valid email";
            }
            if(phone&& !RegExp(r'^[6-9]\d{9}$').hasMatch(text)){
              return"Enter Valid phone number";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _notesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("NOTES"),
        const SizedBox(height: 6),
        TextFormField(
          controller: notesCtrl,
          maxLines: 4,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                await context.read<LeadProvider>().addLead(
                  name: fullNameCtrl.text,
                  phone: phoneCtrl.text,
                  email: emailCtrl.text,
                  source: sourceCtrl.text,
                  leadStatus: leadStatusCtrl.text,
                  notes: notesCtrl.text,
                  callType:callTypeCtrl.text,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Lead Added Successfully")),
                );

                fullNameCtrl.clear();
                phoneCtrl.clear();
                emailCtrl.clear();
                sourceCtrl.clear();
                leadStatusCtrl.clear();
                callTypeCtrl.clear();
                notesCtrl.clear();
                context.read<LeadProvider>().additionalDetails.clear();
                setState(() {});
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to save lead: $e")),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}