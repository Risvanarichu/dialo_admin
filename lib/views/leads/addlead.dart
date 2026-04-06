import 'package:dialo_admin/providers/leadProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final notesCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LeadProvider>().fetchLeadSettings();
    });
  }
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: Row(
        children: [
          //if (!isMobile) _sideBar(),
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

  // Widget _sideBar() {
  //   return Container(
  //     width: 240,
  //     color: Colors.white,
  //     child: Column(
  //       children: [
  //         const SizedBox(height: 30),
  //         _menu(Icons.dashboard, "Dashboard"),
  //         _menu(Icons.call, "Calls"),
  //         _menu(Icons.people, "Leads"),
  //         _menu(Icons.person_add_alt_1, "Add lead", active: true),
  //         _menu(Icons.calendar_month, "Follow-Up"),
  //         _menu(Icons.bar_chart, "Reports"),
  //         _menu(Icons.people_outline, "Users"),
  //         _menu(Icons.settings, "Settings"),
  //         const Spacer(),
  //         Container(
  //           width: double.infinity,
  //           color: const Color(0xFFFFEEEE),
  //           child: TextButton.icon(
  //             onPressed: () {},
  //             icon: const Icon(Icons.logout, color: Colors.red),
  //             label: const Text("Logout", style: TextStyle(color: Colors.red)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _menu(IconData icon, String text, {bool active = false}) {
    return ListTile(
      leading: Icon(icon, color: active ? Colors.blue : Colors.grey),
      title: Text(
        text,
        style: TextStyle(
          color: active ? Colors.blue : Colors.black,
          fontWeight: active ? FontWeight.w600 : FontWeight.normal,
        ),
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
            _input("EMAIL ADDRESS*", emailCtrl),
            _input("SOURCES*", sourceCtrl),
          ),
          const SizedBox(height: 16),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: SizedBox(
          //     width: isMobile ? double.infinity : 460,
          //     child: _input("LEAD STATUS*", leadStatusCtrl,showDropdown: true),
          //   ),
          // ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: isMobile ? double.infinity : 460,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("LEAD STATUS*"),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: leadStatusCtrl.text.isEmpty
                        ? null
                        : leadStatusCtrl.text,
                    icon: const Icon(Icons.arrow_drop_down),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "New", child: Text("New")),
                      DropdownMenuItem(
                        value: "Contacted",
                        child: Text("Contacted"),
                      ),
                      DropdownMenuItem(value: "Rejected", child: Text("Rejected")),
                      DropdownMenuItem(value: "Accepted", child: Text("Accepted")),
                      DropdownMenuItem(value: "Joined", child: Text("Joined")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        leadStatusCtrl.text = value ?? "";
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _additionaldetailsCard (bool isMobile) {
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
          const Text("Additional Details",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),),
          const SizedBox(height: 16),
          if(provider.categories.isEmpty)
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
                (e) => DropdownMenuItem(
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
          ),
        ),
      ],
    );
  }
  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          onChanged: (value) {
            context.read<LeadProvider>().additionalDetails[label] = value;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowFields(bool isMobile, Widget left, Widget right) {
    if (isMobile) {
      return Column(children: [left, const SizedBox(height: 16), right]);
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
    bool showDropdown = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

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
          controller: controller,
          readOnly: showDropdown,
          onTap: showDropdown
              ? () async {
                  final selected = await showMenu<String>(
                    context: context,
                    position: const RelativeRect.fromLTRB(50, 150, 50, 50),
                    items: ["New", "Contacted", "Accepted","Rejected","joined"]
                        .map(
                          (e) =>
                              PopupMenuItem<String>(value: e, child: Text(e)),
                        )
                        .toList(),
                  );
                  if (selected != null) {
                    controller.text = selected;
                  }
                }
              : null,
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
          decoration: const InputDecoration(border: OutlineInputBorder()),
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
          child: const Text("Cancel",style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () async{
            if (_formKey.currentState!.validate()){
              try{
                await context.read<LeadProvider>().addLead(name: fullNameCtrl.text, phone: phoneCtrl.text, email: emailCtrl.text, source: sourceCtrl.text, leadStatus: leadStatusCtrl.text, notes: notesCtrl.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Lead Added Successfully")),
                );
                fullNameCtrl.clear();
                phoneCtrl.clear();
                emailCtrl.clear();
                sourceCtrl.clear();
                leadStatusCtrl.clear();
                notesCtrl.clear();
                setState(() {
                });
              }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save lead:$e")),);
              }
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("Save",style: TextStyle(color: Colors.white,),
        ),
        )],
    );
  }
}
