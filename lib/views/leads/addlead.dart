import 'package:dialo_admin/providers/leadProvider.dart';
import 'package:dialo_admin/providers/settings_provider.dart';
import 'package:dialo_admin/widget/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/agentProvider.dart';
import 'leads_list.dart';

class AddLead extends StatefulWidget {
  const AddLead({super.key});

  @override
  State<AddLead> createState() => _AddLeadState();
}

class _AddLeadState extends State<AddLead> {
  final _formKey = GlobalKey<FormState>();

  final leadStatusCtrl = TextEditingController();
  final callStatusCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  bool isSaving = false;
  String userRole = "";

  String selectedLeadCategory = "";
  String? selectedAgentId;
  String? selectedAgentName;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final leadProvider = context.read<LeadProvider>();
      final settingsProvider = context.read<SettingsProvider>();

      await settingsProvider.fetchAllSettings();

      if (leadProvider.isEdit) {
        leadStatusCtrl.text = leadProvider.leadStatusValue;
        callStatusCtrl.text = leadProvider.callStatusValue;
        notesCtrl.text = leadProvider.notesValue;

        selectedAgentId = leadProvider.selectedAgentId;
        selectedAgentName = leadProvider.selectedAgentName;
      }

      final prefs = await SharedPreferences.getInstance();

      if (mounted) {
        setState(() {
          userRole = (prefs.getString("role") ?? "").toUpperCase();
        });
      }
    });
  }

  @override
  void dispose() {
    leadStatusCtrl.dispose();
    callStatusCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: Column(
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
                    additionalDetailsFields(),
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
    );
  }

  Widget _topBar() {
    final provider = context.watch<LeadProvider>();

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Text(
        provider.isEdit ? "EDIT LEAD" : "ADD NEW LEAD",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _formCard(bool isMobile) {
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
          _rowFields(
            isMobile,
            _input("FULL NAME*", provider.nameController),
            _input("PHONE NUMBER*", provider.phoneController, phone: true),
          ),
          const SizedBox(height: 16),
          _rowFields(
            isMobile,
            _input("EMAIL ADDRESS*", provider.emailController),
            _sourceDropdown(),
          ),
          const SizedBox(height: 16),
          _rowFields(
            isMobile,
            _leadStatusDropdown(),
            _callStatusDropdown(),
          ),
          const SizedBox(height: 16),
          if (userRole == "ADMIN") ...[
            _rowFields(
              isMobile,
              _agentDropdown(),
              _leadCategoryDropdown(),
            ),
          ] else ...[
            _leadCategoryDropdown(),
          ],
        ],
      ),
    );
  }

  Widget _sourceDropdown() {
    final settingsProvider = context.watch<SettingsProvider>();
    final leadProvider = context.watch<LeadProvider>();

    final sourceValue =
    settingsProvider.leadSource.contains(leadProvider.sourceController.text)
        ? leadProvider.sourceController.text
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("SOURCES*"),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: sourceValue,
          hint: const Text("Select Source"),
          items: settingsProvider.leadSource.map((source) {
            return DropdownMenuItem<String>(
              value: source,
              child: Text(source),
            );
          }).toList(),
          onChanged: (value) {
            leadProvider.sourceController.text = value ?? "";
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select source";
            }
            return null;
          },
          decoration: _dropdownDecoration(),
        ),
      ],
    );
  }

  Widget _leadStatusDropdown() {
    final provider = context.watch<SettingsProvider>();

    final validValue =
    provider.leadStatus.contains(leadStatusCtrl.text)
        ? leadStatusCtrl.text
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("LEAD STATUS*"),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: validValue,
          hint: const Text("Select Lead Status"),
          items: provider.leadStatus.map((status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
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
          decoration: _dropdownDecoration(),
        ),
      ],
    );
  }

  Widget _callStatusDropdown() {
    final provider = context.watch<SettingsProvider>();

    final validValue =
    provider.callStatus.contains(callStatusCtrl.text)
        ? callStatusCtrl.text
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("CALL STATUS*"),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: validValue,
          hint: const Text("Select Call Status"),
          items: provider.callStatus.map((status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              callStatusCtrl.text = value ?? "";
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select call status";
            }
            return null;
          },
          decoration: _dropdownDecoration(),
        ),
      ],
    );
  }

  Widget _leadCategoryDropdown() {
    final provider = context.watch<SettingsProvider>();

    final validValue =
    provider.leadCategory.contains(selectedLeadCategory)
        ? selectedLeadCategory
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("LEAD CATEGORY*"),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: validValue,
          hint: const Text("Select Lead Category"),
          items: provider.leadCategory.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedLeadCategory = value ?? "";
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select lead category";
            }
            return null;
          },
          decoration: _dropdownDecoration(),
        ),
      ],
    );
  }

  Widget _agentDropdown() {
    final agentProvider = context.watch<Agentprovider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("ASSIGNED AGENT*"),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedAgentId != null &&
              agentProvider.userList
                  .map((e) => e["ID"])
                  .contains(selectedAgentId)
              ? selectedAgentId
              : null,
          hint: const Text("Select Agent"),
          items: agentProvider.userList.map<DropdownMenuItem<String>>((agent) {
            return DropdownMenuItem<String>(
              value: agent["ID"],
              child: Text(agent["NAME"]),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedAgentId = value;

              final selectedAgent = agentProvider.userList.firstWhere(
                    (e) => e["ID"] == value,
                orElse: () => {},
              );

              selectedAgentName = selectedAgent["NAME"]?.toString();
            });
          },
          decoration: _dropdownDecoration(),
        ),
      ],
    );
  }

  Widget additionalDetailsFields() {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final list = settingsProvider.additionalFieldsList;

        if (list.isEmpty) {
          return const SizedBox();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Additional Fields",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...list.map((item) {
                final String title = item["title"] ?? "";
                final List<String> subList =
                List<String>.from(item["sub"] ?? []);

                if (subList.isNotEmpty) {
                  final selectedValue =
                  settingsProvider.additionalDetails[title];

                  final validValue =
                  subList.contains(selectedValue) ? selectedValue : null;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: DropdownButtonFormField<String>(
                      value: validValue,
                      hint: Text("Select $title"),
                      decoration: _dropdownDecoration(label: title),
                      items: subList.map((sub) {
                        return DropdownMenuItem<String>(
                          value: sub,
                          child: Text(sub),
                        );
                      }).toList(),
                      onChanged: (value) {
                        settingsProvider.updateAdditionalDetail(title, value);
                      },
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    initialValue:
                    settingsProvider.additionalDetails[title] ?? "",
                    decoration: _dropdownDecoration(label: title),
                    onChanged: (value) {
                      settingsProvider.updateAdditionalDetail(title, value);
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
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
          decoration: _dropdownDecoration(),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SideMenu(selectedIndex: 1,)),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 16),
        // ElevatedButton(
        //   onPressed: () async {
        //     if (_formKey.currentState!.validate()) {
        //       final leadProvider = context.read<LeadProvider>();
        //       final settingsProvider = context.read<SettingsProvider>();
        //
        //       try {
        //         if (leadProvider.isEdit) {
        //           await leadProvider.updateUser(
        //             leadStatus: leadStatusCtrl.text,
        //             callStatus: callStatusCtrl.text,
        //             leadCategory: selectedLeadCategory,
        //             notes: notesCtrl.text,
        //             agentId: selectedAgentId,
        //             agentName: selectedAgentName,
        //           );
        //
        //           ScaffoldMessenger.of(context).showSnackBar(
        //             const SnackBar(content: Text("Lead Updated Successfully")),
        //           );
        //         } else {
        //           await leadProvider.addLead(
        //             name: leadProvider.nameController.text.trim(),
        //             phone: leadProvider.phoneController.text.trim(),
        //             email: leadProvider.emailController.text.trim(),
        //             source: leadProvider.sourceController.text.trim(),
        //             leadStatus: leadStatusCtrl.text.trim(),
        //             notes: notesCtrl.text.trim(),
        //             callStatus: callStatusCtrl.text.trim(),
        //             leadCategory: selectedLeadCategory,
        //             additionalDetails: settingsProvider.additionalDetails,
        //             assignedAgentId: selectedAgentId,
        //             assignedAgentName: selectedAgentName,
        //           );
        //
        //           ScaffoldMessenger.of(context).showSnackBar(
        //             const SnackBar(content: Text("Lead Added Successfully")),
        //           );
        //         }
        //
        //         leadProvider.clearFields();
        //         settingsProvider.additionalDetails.clear();
        //
        //         Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(builder: (_) => const SideMenu(selectedIndex: 2,)),
        //         );
        //       } catch (e) {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(content: Text("Failed to save lead: $e")),
        //         );
        //       }
        //     }
        //   },
        //   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        //   child: const Text("Save", style: TextStyle(color: Colors.white)),
        // ),

        ElevatedButton(
          onPressed: isSaving
              ? null
              : () async {
            if (_formKey.currentState!.validate()) {

              setState(() {
                isSaving = true;
              });

              final leadProvider = context.read<LeadProvider>();
              final settingsProvider = context.read<SettingsProvider>();

              try {

                if (leadProvider.isEdit) {

                  await leadProvider.updateUser(
                    leadStatus: leadStatusCtrl.text,
                    callStatus: callStatusCtrl.text,
                    leadCategory: selectedLeadCategory,
                    notes: notesCtrl.text,
                    agentId: selectedAgentId,
                    agentName: selectedAgentName,
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lead Updated Successfully"),
                    ),
                  );

                } else {

                  await leadProvider.addLead(
                    name: leadProvider.nameController.text.trim(),
                    phone: leadProvider.phoneController.text.trim(),
                    email: leadProvider.emailController.text.trim(),
                    source: leadProvider.sourceController.text.trim(),
                    leadStatus: leadStatusCtrl.text.trim(),
                    notes: notesCtrl.text.trim(),
                    callStatus: callStatusCtrl.text.trim(),
                    leadCategory: selectedLeadCategory,
                    additionalDetails: settingsProvider.additionalDetails,
                    assignedAgentId: selectedAgentId,
                    assignedAgentName: selectedAgentName,
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lead Added Successfully"),
                    ),
                  );
                }

                leadProvider.clearFields();
                settingsProvider.additionalDetails.clear();

                if (!mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SideMenu(selectedIndex: 1),
                  ),
                );

              } catch (e) {

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to save lead: $e"),
                  ),
                );

              } finally {

                if (mounted) {
                  setState(() {
                    isSaving = false;
                  });
                }
              }
            }
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),

          child: isSaving
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
          inputFormatters: phone
              ? [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ]
              : [],
          decoration: _dropdownDecoration(),
          validator: (value) {
            final text = value?.trim() ?? "";

            if (label.contains("*") && text.isEmpty) {
              return "Required";
            }

            if (label == "EMAIL ADDRESS*" &&
                !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(text)) {
              return "Enter a valid email";
            }

            if (phone && !RegExp(r'^[6-9]\d{9}$').hasMatch(text)) {
              return "Enter valid phone number";
            }

            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration({String? label}) {
    return InputDecoration(
      labelText: label,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}