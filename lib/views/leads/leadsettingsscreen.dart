import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dialo_admin/providers/settings_provider.dart';

import '../../constants/appcolors.dart';

class LeadSettingsScreen extends StatefulWidget {
  const LeadSettingsScreen({super.key});

  @override
  State<LeadSettingsScreen> createState() => _LeadSettingsScreenState();
}

class _LeadSettingsScreenState extends State<LeadSettingsScreen> {
  bool showAdditionalFields = false;
  bool showLeadStatus = false;
  bool showCallStatus = false;
  bool showLeadCategory = false;
  bool showLeadSource = false;

  final _additionalFieldFormKey = GlobalKey<FormState>();

  final TextEditingController leadStatusController = TextEditingController();
  final TextEditingController callStatusController = TextEditingController();
  final TextEditingController leadCategoryController = TextEditingController();
  final TextEditingController leadSourceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<SettingsProvider>();
      await provider.fetchAllSettings();

      if (provider.additionalFields.isEmpty) {
        provider.addAdditionalField();
      }
    });
  }

  @override
  void dispose() {
    leadStatusController.dispose();
    callStatusController.dispose();
    leadCategoryController.dispose();
    leadSourceController.dispose();
    super.dispose();
  }

  void _hideAll() {
    showAdditionalFields = false;
    showLeadStatus = false;
    showCallStatus = false;
    showLeadCategory = false;
    showLeadSource = false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "LEAD SETTINGS",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _leftCard(),
                    const SizedBox(width: 40),

                    if (showAdditionalFields)
                      _additionalFieldsCard(provider),

                    if (showLeadStatus)
                      _simpleListCard(
                        title: "Add Lead Status",
                        hint: "Enter lead status",
                        listTitle: "Lead Status",
                        controller: leadStatusController,
                        items: provider.leadStatus,
                        onAdd: provider.addLeadStatus,
                        onDelete: provider.deleteLeadStatus,
                        onSave: provider.saveLeadStatus,
                      ),

                    if (showCallStatus)
                      _simpleListCard(
                        title: "Add Call Status",
                        hint: "Enter call status",
                        listTitle: "Call Status",
                        controller: callStatusController,
                        items: provider.callStatus,
                        onAdd: provider.addCallStatus,
                        onDelete: provider.deleteCallStatus,
                        onSave: provider.saveCallStatus,
                      ),

                    if (showLeadCategory)
                      _simpleListCard(
                        title: "Add Lead Category",
                        hint: "Enter lead category",
                        listTitle: "Lead Category",
                        controller: leadCategoryController,
                        items: provider.leadCategory,
                        onAdd: provider.addLeadCategory,
                        onDelete: provider.deleteLeadCategory,
                        onSave: provider.saveLeadCategory,
                      ),

                    if (showLeadSource)
                      _simpleListCard(
                        title: "Add Lead Source",
                        hint: "Enter lead source",
                        listTitle: "Lead Source",
                        controller: leadSourceController,
                        items: provider.leadSource,
                        onAdd: provider.addleadSource,
                        onDelete: provider.deleteleadSource,
                        onSave: provider.saveleadSource,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leftCard() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add Leads", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                _hideAll();
                showAdditionalFields = true;
              });
            },
            child: _box("Additional Fields"),
          ),

          const SizedBox(height: 25),

          const Text(
            "Lead Status",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                _hideAll();
                showLeadStatus = true;
              });
            },
            child: _box("Lead Status"),
          ),

          const SizedBox(height: 25),

          const Text(
            "Call Status",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                _hideAll();
                showCallStatus = true;
              });
            },
            child: _box("Call Status"),
          ),

          const SizedBox(height: 25),

          const Text(
            "Lead Category",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                _hideAll();
                showLeadCategory = true;
              });
            },
            child: _box("Lead Category"),
          ),

          const SizedBox(height: 25),

          const Text(
            "Lead Source",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                _hideAll();
                showLeadSource = true;
              });
            },
            child: _box("Lead Source"),
          ),
        ],
      ),
    );
  }

  Widget _additionalFieldsCard(SettingsProvider provider) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Form(
        key: _additionalFieldFormKey,
        child: Column(
          children: [
            const Text(
              "Add Additional Fields",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(provider.additionalFields.length, (index) {
                      final item = provider.additionalFields[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: item["controller"],
                                    decoration: InputDecoration(
                                      hintText: "Field ${index + 1}",
                                      border: const OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Enter field name";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      provider.updateAdditionalField(
                                        index,
                                        value,
                                      );
                                    },
                                  ),
                                ),

                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    final title = item["controller"]
                                        .text
                                        .trim();

                                    if (title.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                          Text("Enter field name first"),
                                        ),
                                      );
                                      return;
                                    }

                                    provider.addSubCategory(index);
                                  },
                                ),

                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    provider.deleteAdditionalField(index);
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            ...List.generate(item["sub"].length, (subIndex) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 35,
                                  bottom: 10,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller:
                                        item["subcontrollers"][subIndex],
                                        decoration: InputDecoration(
                                          hintText:
                                          "Sub field ${subIndex + 1}",
                                          border: const OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Enter sub field";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          provider.updateSubCategory(
                                            index,
                                            subIndex,
                                            value,
                                          );
                                        },
                                      ),
                                    ),

                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        provider.deleteSubCategory(
                                          index,
                                          subIndex,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),

                    _addedDetailsBox(provider),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.themeColor,
                    ),
                    onPressed: () {
                      final lastField = provider.additionalFields.isNotEmpty
                          ? provider.additionalFields.last["controller"]
                          .text
                          .trim()
                          : "";

                      if (provider.additionalFields.isNotEmpty &&
                          lastField.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Fill current field first"),
                          ),
                        );
                        return;
                      }

                      provider.addAdditionalField();
                    },
                    child: const Text(
                      "Add Field",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.themeColor,
                    ),
                    onPressed: () async {
                      final valid =
                          _additionalFieldFormKey.currentState?.validate() ??
                              false;

                      if (!valid) return;

                      await provider.saveAdditionalFields();
                      await provider.clearAdditionalFields();
                      await provider.fetchAdditionalDetails();

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Additional fields saved successfully"),
                        ),
                      );
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _simpleListCard({
    required String title,
    required String hint,
    required String listTitle,
    required TextEditingController controller,
    required List<String> items,
    required Function(String) onAdd,
    required Function(int) onDelete,
    required Future<void> Function() onSave,
  }) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () {
                  final value = controller.text.trim();

                  if (value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter value first")),
                    );
                    return;
                  }

                  onAdd(value);
                  controller.clear();
                },
              ),
            ],
          ),

          const SizedBox(height: 25),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              listTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: items.isEmpty
                ? const Center(child: Text("No data added"))
                : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      onDelete(index);
                    },
                  ),
                );
              },
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.themeColor,
              ),
              onPressed: () async {
                if (items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Add at least one item")),
                  );
                  return;
                }

                await onSave();
                await context.read<SettingsProvider>().fetchAllSettings();
                controller.clear();

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Saved Successfully")),
                );
              },
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addedDetailsBox(SettingsProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Added Additional Fields",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          if (provider.additionalFieldsList.isEmpty)
            const Text("No data added"),

          ...provider.additionalFieldsList.map((item) {
            final title = item["title"] ?? "";
            final subList = List<String>.from(item["sub"] ?? []);

            if (title.toString().trim().isEmpty) {
              return const SizedBox();
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 5),

                        if (subList.isEmpty)
                          const Text(
                            "No sub fields",
                            style: TextStyle(color: Colors.grey),
                          ),

                        if (subList.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 5,
                            children: subList.map((sub) {
                              return Chip(
                                label: Text(sub),
                                backgroundColor: Colors.blue.shade50,
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _box(String text) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withValues(alpha: 0.3),
            blurRadius: 3,
            spreadRadius: 1,
            offset: const Offset(2, 3),
          ),
        ],
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
    );
  }
}