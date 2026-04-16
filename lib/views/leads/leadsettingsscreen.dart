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
  bool showCallStatus = false;

  final _categoryFormKey = GlobalKey<FormState>();
  final _callStatusformKey = GlobalKey<FormState>();
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
          //Container(width: 1, color: Colors.black),

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
                      child: Padding(
                        padding: const EdgeInsets.all(80),
                        child: Container(
                         // width: 1100,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
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
              Provider.of<SettingsProvider>(context, listen: false).clearCategories();
              setState(() {
                showCategories = true;
                showCallStatus = false;
              });
            },
            child: _box("Additional Details"),
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
        key: _categoryFormKey,
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
                               // key: ValueKey(cat["title"]),
                    controller: cat["controller"],
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
                              icon: const Icon(Icons.add,color: Colors.blue),
                              onPressed: () {
                                if (cat["controller"].text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Enter category first")),
                                  );
                                  return;
                                }

                                if (cat["subcontrollers"] != null && cat["subcontrollers"].isNotEmpty) {
                                  final lastController = cat["subcontrollers"].last as TextEditingController;

                                  if (lastController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Fill the first sub category")),
                                    );
                                    return;
                                  }
                                }

                                provider.addSubCategory(index);
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete,color: Colors.red,),
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
                                        //key: ValueKey(cat["sub"][subIndex]),
                                       // initialValue:
                                controller: cat["subcontrollers"][subIndex],
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
                                      icon: const Icon(Icons.delete,color: Colors.red,),
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
                    style:ElevatedButton.styleFrom(backgroundColor: AppColors.themeColor),
                    onPressed: () {
                      if(provider.categories.isNotEmpty &&
                          (provider.categories.last["title"]??"").toString().trim().isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter Category first")),
                        );
                        return;
                      }
                      provider.addCategory();
                    },
                    child: const Text("Add Category",style: TextStyle(color: Colors.white),
                  ),
                    )
                ],
              ),
            ),

            /// SAVE BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.themeColor,
              ),
              onPressed: () async {
                try {
                  print("SAVE BUTTON CLICKED");

                  final isValid = _categoryFormKey.currentState?.validate() ?? false;
                  print("FORM VALID = $isValid");

                  if (!isValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all required fields")),
                    );
                    return;
                  }

                  await provider.saveCategories();

                  print("SAVE COMPLETED");

                  if (!mounted) return;

                  provider.clearCategories();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Saved Successfully")),
                  );
                } catch (e) {
                  print("SAVE ERROR = $e");

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Save failed: $e")),
                  );
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// CALL STATUS CARD
  Widget _callStatusCard(SettingsProvider provider) {
    GlobalKey<FormState> key;
    return Form(
      key: _callStatusformKey,
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            const Text("Call Status",style: TextStyle(fontSize:20),),
const SizedBox(height: 30,),
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
                  icon: const Icon(Icons.add,color: Colors.blue),
                  onPressed: () {
                    if (
                    statusController.text.isNotEmpty){
                      provider.addCallStatus(statusController.text);
                      statusController.clear();
                      provider.notifyListeners();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete,color: Colors.red,),
                  onPressed: () {
                  statusController.dispose();
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
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.themeColor,
          ),
          onPressed: () async {
            try {
              if (provider.callStatus.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Add at least one status")),
                );
                return;
              }

              await provider.saveCallStatus();

              provider.clearCallStatus();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Saved Successfully")),
              );
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Save failed: $e")),
              );
            }
          },
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _box(String text) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:  Colors.white,
        boxShadow:[
          BoxShadow(
            color: Colors.blueGrey.withBlue(1),
            blurRadius: 3,
            spreadRadius: 1,
            offset: const Offset(2,3),
          )
        ] ,
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(text),
    );
  }
}