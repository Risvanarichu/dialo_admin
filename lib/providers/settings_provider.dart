import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;




  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> savedCategories = [];

  List<String> leadStatus = [];
  List<String> callStatus = [];
  List<String> leadCategory = [];
  List<String> leadSource = [];
  Map<String, dynamic> additionalDetails = {};

  SettingsProvider() {
    fetchAllSettings();
  }



  Future<void> fetchAllSettings() async {
    await fetchCategories();
    await fetchLeadStatus();
    await fetchCallStatus();
    await fetchLeadCategory();
    await fetchLeadSource();
  }
  final TextEditingController additionalCategoryController =
  TextEditingController();

  final TextEditingController additionalSubCategoryController =
  TextEditingController();

  List<Map<String, dynamic>> additionalDetailsList = [];

  void addAdditionalCategoryToList() {
    final category = additionalCategoryController.text.trim();
    final sub = additionalSubCategoryController.text.trim();

    if (category.isEmpty) return;

    additionalDetailsList.add({
      "title": category,
      "sub": sub.isEmpty ? [] : [sub],
    });

    additionalCategoryController.clear();
    additionalSubCategoryController.clear();

    notifyListeners();
  }

  void addAdditionalSubCategory() {
    final category = additionalCategoryController.text.trim();
    final sub = additionalSubCategoryController.text.trim();

    if (category.isEmpty || sub.isEmpty) return;

    final index = additionalDetailsList.indexWhere(
          (element) => element["title"] == category,
    );

    if (index != -1) {
      additionalDetailsList[index]["sub"].add(sub);
    } else {
      additionalDetailsList.add({
        "title": category,
        "sub": [sub],
      });
    }

    additionalSubCategoryController.clear();
    notifyListeners();
  }

  void deleteAdditionalSubCategory(int categoryIndex, String sub) {
    additionalDetailsList[categoryIndex]["sub"].remove(sub);
    notifyListeners();
  }

  void clearAdditionalInputFields() {
    additionalCategoryController.clear();
    additionalSubCategoryController.clear();
    notifyListeners();
  }

  Future<void> saveAdditionalDetails() async {
    await FirebaseFirestore.instance
        .collection("LEAD_SETTINGS")
        .doc("additional_details")
        .set({
      "detailsList": additionalDetailsList,
    });

    clearAdditionalInputFields();
  }

  // ================= CATEGORIES =================

  void addCategory() {
    categories.add({
      "title": "",
      "controller": TextEditingController(),
      "sub": [],
      "subcontrollers": [],
    });
    notifyListeners();
  }

  void updateCategory(int index, String value) {
    categories[index]["title"] = value;
    notifyListeners();
  }

  void deleteCategory(int index) {
    categories[index]["controller"]?.dispose();

    for (var c in categories[index]["subcontrollers"]) {
      c.dispose();
    }

    categories.removeAt(index);

    if (categories.isEmpty) {
      addCategory();
    }

    notifyListeners();
  }

  void addSubCategory(int index) {
    final title = categories[index]["title"].toString().trim();

    if (title.isEmpty) {
      return;
    }

    if (categories[index]["sub"].isNotEmpty) {
      final last = categories[index]["sub"].last.toString().trim();
      if (last.isEmpty) return;
    }

    categories[index]["sub"].add("");
    categories[index]["subcontrollers"].add(TextEditingController());

    notifyListeners();
  }

  void updateSubCategory(int index, int subIndex, String value) {
    categories[index]["sub"][subIndex] = value;
    notifyListeners();
  }

  void deleteSubCategory(int index, int subIndex) {
    categories[index]["subcontrollers"][subIndex].dispose();
    categories[index]["subcontrollers"].removeAt(subIndex);
    categories[index]["sub"].removeAt(subIndex);
    notifyListeners();
  }

  void clearCategories() {
    for (var cat in categories) {
      cat["controller"]?.dispose();

      for (var c in cat["subcontrollers"]) {
        c.dispose();
      }
    }

    categories.clear();

    categories.add({
      "title": "",
      "controller": TextEditingController(),
      "sub": [],
      "subcontrollers": [],
    });

    notifyListeners();
  }

  // Future<void> saveCategories() async {
  //   final cleanList = categories
  //       .where((e) => e["title"].toString().trim().isNotEmpty)
  //       .map((e) {
  //     return {
  //       "title": e["title"].toString().trim(),
  //       "sub": List<String>.from(e["sub"])
  //           .where((s) => s.toString().trim().isNotEmpty)
  //           .toList(),
  //     };
  //   }).toList();
  //
  //   await db.collection("LEAD_SETTINGS").doc("categories").set({
  //     "categoryList": cleanList,
  //   });
  // }
  Future<void> saveCategories() async {
    final newList = categories
        .where((e) => e["title"].toString().trim().isNotEmpty)
        .map((e) {
      return {
        "title": e["title"].toString().trim(),
        "sub": List<String>.from(e["sub"] ?? [])
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toSet()
            .toList(),
      };
    }).toList();

    await db.collection("LEAD_SETTINGS").doc("categories").set({
      "categoryList": newList,
    }, SetOptions(merge: true));

    await fetchCategories();
  }
  Future<void> fetchCategories() async {
    final doc = await db.collection("LEAD_SETTINGS").doc("categories").get();

    if (!doc.exists) {
      clearCategories();
      return;
    }

    final data = doc.data();
    final rawList = data?["categoryList"] ?? [];

    for (var cat in categories) {
      cat["controller"]?.dispose();

      for (var c in cat["subcontrollers"]) {
        c.dispose();
      }
    }

    categories = List<Map<String, dynamic>>.from(
      rawList.map((e) {
        final subList = List<String>.from(e["sub"] ?? []);

        return {
          "title": e["title"] ?? "",
          "controller": TextEditingController(text: e["title"] ?? ""),
          "sub": subList,
          "subcontrollers": subList
              .map((sub) => TextEditingController(text: sub))
              .toList(),
        };
      }),
    );

    if (categories.isEmpty) {
      categories.add({
        "title": "",
        "controller": TextEditingController(),
        "sub": [],
        "subcontrollers": [],
      });
    }
    savedCategories=List<Map<String,dynamic>>.from(rawList);

    notifyListeners();
  }

  // ================= LEAD STATUS =================

  void addLeadStatus(String value) {
    value = value.trim();
    if (value.isEmpty) return;
    if (leadStatus.contains(value)) return;

    leadStatus.add(value);
    notifyListeners();
  }

  void deleteLeadStatus(int index) {
    leadStatus.removeAt(index);
    notifyListeners();
  }

  void clearLeadStatus() {
    leadStatus.clear();
    notifyListeners();
  }

  Future<void> saveLeadStatus() async {
    final cleanList = leadStatus
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    await db.collection("LEAD_SETTINGS").doc("lead_status").set({
      "leadStatusList": FieldValue.arrayUnion(cleanList),
    },
        SetOptions(merge: true)
    );
  }

  Future<void> fetchLeadStatus() async {
    final doc = await db.collection("LEAD_SETTINGS").doc("lead_status").get();

    if (doc.exists) {
      leadStatus = List<String>.from(doc.data()?["leadStatusList"] ?? []);
    } else {
      leadStatus = [];
    }

    notifyListeners();
  }

  // ================= CALL STATUS =================

  void addCallStatus(String value) {
    value = value.trim();
    if (value.isEmpty) return;
    if (callStatus.contains(value)) return;

    callStatus.add(value);
    notifyListeners();
  }

  void deleteCallStatus(int index) {
    callStatus.removeAt(index);
    notifyListeners();
  }

  void clearCallStatus() {
    callStatus.clear();
    notifyListeners();
  }

  Future<void> saveCallStatus() async {
    final cleanList = callStatus
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    await db.collection("LEAD_SETTINGS").doc("call_status").set({
      "callStatusList":FieldValue.arrayUnion(cleanList),
    },
        SetOptions(merge: true)
    );
  }

  Future<void> fetchCallStatus() async {
    final doc = await db.collection("LEAD_SETTINGS").doc("call_status").get();

    if (doc.exists) {
      callStatus = List<String>.from(doc.data()?["callStatusList"] ?? []);
    } else {
      callStatus = [];
    }

    notifyListeners();
  }

  // ================= CALL CATEGORY =================

  void addLeadCategory(String value) {
    value = value.trim();
    if (value.isEmpty) return;
    if (leadCategory.contains(value)) return;

    leadCategory.add(value);
    notifyListeners();
  }

  void deleteLeadCategory(int index) {
    leadCategory.removeAt(index);
    notifyListeners();
  }

  void clearLeadCategory() {
    leadCategory.clear();
    notifyListeners();
  }

  Future<void> saveLeadCategory() async {
    final cleanList = leadCategory
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    await db.collection("LEAD_SETTINGS").doc("lead_category").set({
      "leadCategoryList":FieldValue.arrayUnion(cleanList),
    },
        SetOptions(merge: true));
  }

  Future<void> fetchLeadCategory() async {
    final doc = await db.collection("LEAD_SETTINGS").doc("lead_category").get();

    if (doc.exists) {
      leadCategory = List<String>.from(doc.data()?["leadCategoryList"] ?? []);
    } else {
      leadCategory = [];
    }

    notifyListeners();
  }

  // ================= SAVE ALL =================

  Future<void> saveAllSettings() async {
    await saveCategories();
    await saveLeadStatus();
    await saveCallStatus();
    await saveLeadCategory();
  }

  // ================= CLEAR ALL =================

  // void clearAllFields() {
  //   for (var cat in categories) {
  //     cat["controller"]?.dispose();
  //
  //     for (var c in cat["subcontrollers"]) {
  //       c.dispose();
  //     }
  //   }
  //
  //   categories.clear();
  //
  //   categories.add({
  //     "title": "",
  //     "controller": TextEditingController(),
  //     "sub": [],
  //     "subcontrollers": [],
  //   });
  //
  //   leadStatus.clear();
  //   callStatus.clear();
  //   leadCategory.clear();
  //   leadSource.clear();
  //
  //   notifyListeners();
  // }

  // ================= DELETE FIRESTORE ALSO =================

  Future<void> clearAllFromFirebaseAndScreen() async {
    await db.collection("LEAD_SETTINGS").doc("categories").set({
      "categoryList": [],
    });

    await db.collection("LEAD_SETTINGS").doc("lead_status").set({
      "leadStatusList": [],
    });

    await db.collection("LEAD_SETTINGS").doc("call_status").set({
      "callStatusList": [],
    });

    await db.collection("LEAD_SETTINGS").doc("lead_category").set({
      "leadCategoryList": [],
    });
    await db.collection("LEAD_SETTINGS").doc("lead_source").set({
      "leadSourceList": [],
    });

   // clearAllFields();
  }

  @override
  void dispose() {
    for (var cat in categories) {
      cat["controller"]?.dispose();

      for (var c in cat["subcontrollers"]) {
        c.dispose();
      }
    }

    super.dispose();
  }

  void addleadSource(String value) {
    value = value.trim();

    if (value.isEmpty) return;
    if (leadSource.contains(value)) return;

    leadSource.add(value);
    notifyListeners();
  }

  Future<void> deleteleadSource(int index) async {
    leadSource.removeAt(index);

    await db.collection("LEAD_SETTINGS").doc("lead_source").set({
      "leadSourceList": leadSource,
    });

    notifyListeners();
  }

  Future<void> saveleadSource() async {
    final cleanList = leadSource
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    await db.collection("LEAD_SETTINGS").doc("lead_source").set({
      "leadSourceList": FieldValue.arrayUnion(cleanList),
    }, SetOptions(merge: true));
  }

  Future<void> fetchLeadSource() async {
    final doc = await db.collection("LEAD_SETTINGS").doc("lead_source").get();

    if (doc.exists) {
      leadSource = List<String>.from(doc.data()?["leadSourceList"] ?? []);
    } else {
      leadSource = [];
    }

    notifyListeners();
  }

  Future<void> saveLeadSource() async {
    final cleanList = leadSource
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    await db.collection("LEAD_SETTINGS").doc("LEAD_CATEGORY").set({
      "leadCategoryList":FieldValue.arrayUnion(cleanList),
    },
        SetOptions(merge: true));

  }

  void updateAdditionalDetail(String label, String? value) {
    additionalDetails[label]=value;
    notifyListeners();
  }
}


