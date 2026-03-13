import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final companyCtrl = TextEditingController();
  final leadStatusCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
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
                          _notesSection(),
                          const SizedBox(height: 40),
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
            _input("COMPANY*", companyCtrl),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: isMobile ? double.infinity : 460,
              child: _input("LEAD STATUS*", leadStatusCtrl),
            ),
          ),
        ],
      ),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: phone ? TextInputType.phone : TextInputType.text,
          inputFormatters: phone
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ]
              : null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Cancel"),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("Save"),
        ),
      ],
    );
  }
}
