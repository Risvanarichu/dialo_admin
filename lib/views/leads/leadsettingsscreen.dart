import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dialo_admin/providers/settings_provider.dart';

class LeadSettingsScreen extends StatefulWidget {
  const LeadSettingsScreen({super.key});

  @override
  State<LeadSettingsScreen> createState() => _LeadSettingsScreenState();
}

class _LeadSettingsScreenState extends State<LeadSettingsScreen> {
  bool showCategories = false;
  bool showCallStatus = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SettingsProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: Row(
        children: [
          Container(width: 1, color: Colors.black),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "LEAD SETTINGS",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: Center(
                      child: Container(
                        width: 1100,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _leftCard(),
                            if (showCategories) _categoryCard(provider),
                            if (showCallStatus) _callStatusCard(provider),
                          ],
                        ),
                      ),
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

  /// LEFT MENU
  Widget _leftCard() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add Leads"),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                showCategories = true;
                showCallStatus = false;
              });
            },
            child: _box("Categories"),
          ),

          const SizedBox(height: 40),

          const Text("Lead Status"),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                showCallStatus = true;
                showCategories = false;
              });
            },
            child: _box("Call Status"),
          ),
        ],
      ),
    );
  }

  /// CATEGORY CARD
  Widget _categoryCard(SettingsProvider provider) {
    return Container(
      width: 420,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Categories"),
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: [
                  ...List.generate(provider.categories.length, (index) {
                    var cat = provider.categories[index];

                    return Column(
                      children: [
                        /// CATEGORY ROW
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                key: ValueKey(cat["title"]),
                                initialValue: cat["title"],
                                decoration: InputDecoration(
                                  hintText: "Category",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? "Required"
                                    : null,
                                onChanged: (value) {
                                  provider.updateCategory(index, value);
                                },
                              ),
                            ),

                            const SizedBox(width: 8),

                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.blue),
                              onPressed: () {
                                provider.addSubCategory(index);
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                provider.deleteCategory(index);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// SUB CATEGORIES
                        Column(
                          children: [
                            ...List.generate(cat["sub"].length, (subIndex) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(bottom: 10, left: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        key: ValueKey(cat["sub"][subIndex]),
                                        initialValue:
                                        cat["sub"][subIndex],
                                        decoration: InputDecoration(
                                          hintText: "Sub Category",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                          ),
                                        ),
                                        validator: (value) =>
                                        value == null ||
                                            value.trim().isEmpty
                                            ? "Required"
                                            : null,
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
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        provider.deleteSubCategory(
                                            index, subIndex);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),

                        const SizedBox(height: 10),
                      ],
                    );
                  }),

                  ElevatedButton(
                    onPressed: () {
                      if(provider.categories.isNotEmpty &&
                      provider.categories.last["title"].toString().trim().isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter Category first")),
                        );
                        return;
                      }
                      provider.addCategory();
                    },
                    child: const Text("Add Category"),
                  ),
                ],
              ),
            ),

            /// SAVE BUTTON
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await provider.saveCategories();
                  provider.clearCategories();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Saved Successfully")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  /// CALL STATUS CARD
  Widget _callStatusCard(SettingsProvider provider) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          const Text("Call Status"),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: statusController,
                  decoration: InputDecoration(
                    hintText: "Enter status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (
                  statusController.text.isNotEmpty){
                    provider.callStatus.add(statusController.text);
                    statusController.clear();
                    provider.notifyListeners();
                  }
                },
              ),
            ],
          ),

          Expanded(
            child: ListView(
              children: provider.callStatus
                  .map((e) => ListTile(title: Text(e)))
                  .toList(),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              await provider.saveCategories();
              provider.clearCategories();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _box(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text),
    );
  }
}