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
  bool showCategories = false;
  bool showLeadStatus = false;
  bool showCallStatus = false;
  bool showLeadCategory = false;
  bool showLeadSource = false;

  final _categoryFormKey = GlobalKey<FormState>();

  final TextEditingController leadStatusController = TextEditingController();
  final TextEditingController callStatusController = TextEditingController();
  final TextEditingController leadCategoryController = TextEditingController();
  final TextEditingController leadSourceController = TextEditingController();
  final TextEditingController additionalCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SettingsProvider>().fetchAllSettings();
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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
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
                    Expanded(child: showCategories ? _additionalDetailsCard(isMobile,provider):const SizedBox()),
                    if (showLeadStatus)
                      _simpleListCard(
                        title: "Add Lead Status",
                        hint: "Enter lead status",
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
                        controller: callStatusController,
                        items: provider.callStatus,
                        onAdd: provider.addCallStatus,
                        onDelete: provider.deleteCallStatus,
                        onSave: provider.saveCallStatus,
                      ),
                    if (showLeadCategory)
                      _simpleListCard(
                        title: "Add Lead Category",
                        hint: "Enter Lead category",
                        controller: leadCategoryController,
                        items: provider.leadCategory,
                        onAdd: provider.addLeadCategory,
                        onDelete: provider.deleteLeadCategory,
                        onSave: provider.saveLeadCategory,
                      ),
                    if (showLeadSource)
                      _simpleListCard(
                        title: "Add Lead Source",
                        hint: "Enter Lead Source",
                        controller: leadSourceController,
                        items: provider.leadSource,
                        onAdd: provider.addleadSource,
                        onDelete: provider.deleteleadSource,
                        onSave: provider.saveLeadSource,
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
          const Text(
            "Add Leads",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              //context.read<SettingsProvider>().clearCategories();
              setState(() {
                showCategories = true;
                showLeadStatus = false;
                showCallStatus = false;
                showLeadCategory = false;
                showLeadSource = false;
              });
            },
            child: _box("Additional Details"),
          ),

          const SizedBox(height: 25),

          const Text(
            "Lead Status",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              // context.read<SettingsProvider>().clearLeadStatus();
              setState(() {
                showCategories = false;
                showLeadStatus = true;
                showCallStatus = false;
                showLeadCategory = false;
                showLeadSource = false;
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
              // context.read<SettingsProvider>().clearCallStatus();
              setState(() {
                showCategories = false;
                showLeadStatus = false;
                showCallStatus = true;
                showLeadCategory = false;
                showLeadSource = false;
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
              // context.read<SettingsProvider>().clearLeadCategory();
              setState(() {
                showCategories = false;
                showLeadStatus = false;
                showCallStatus = false;
                showLeadCategory = true;
                showLeadSource = false;
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
              // context.read<SettingsProvider>().clearLeadSource();
              setState(() {
                showCategories = false;
                showLeadStatus = false;
                showCallStatus = false;
                showLeadCategory = false;
                showLeadSource = true;
              });
            },
            child: _box("Lead Source"),
          ),
        ],
      ),
    );
  }

  Widget _additionalDetailsCard(
      bool isMobile,
      SettingsProvider provider,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Add Additional Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// CATEGORY + ADD BUTTON + DELETE BUTTON
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: provider.additionalCategoryController,
                  decoration: InputDecoration(
                    hintText: "Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              IconButton(
                onPressed: () {
                  provider.addAdditionalSubCategory();
                },
                icon: const Icon(Icons.add),
              ),

              IconButton(
                onPressed: () {
                  provider.clearAdditionalInputFields();
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// SUB CATEGORY FIELD
          TextFormField(
            controller: provider.additionalSubCategoryController,
            decoration: InputDecoration(
              hintText: "Sub",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// ADDED LIST
          if (provider.additionalDetailsList.isNotEmpty)
            Container(
              width: isMobile ? double.infinity : 350,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Added Additional Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.additionalDetailsList.length,
                    itemBuilder: (context, index) {
                      final item = provider.additionalDetailsList[index];
                      final category = item["title"] ?? "";
                      final subList = item["sub"] ?? [];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 6),

                            ...subList.map<Widget>((sub) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                          ),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(sub.toString()),
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        provider.deleteAdditionalSubCategory(
                                          index,
                                          sub.toString(),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

          const SizedBox(height: 25),

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    provider.addAdditionalCategoryToList();
                  },
                  child: const Text("Add Category"),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await provider.saveAdditionalDetails();
                  },
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _simpleListCard({
    required String title,
    required String hint,
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

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Status",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
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
