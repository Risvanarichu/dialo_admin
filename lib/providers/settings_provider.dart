import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> additionalFields = [];
  List<Map<String, dynamic>> savedAdditionalFields = [];

  List<String> leadStatus = [];
  List<String> callStatus = [];
  List<String> leadCategory = [];
  List<String> leadSource = [];

  Map<String, dynamic> additionalDetails = {};

  final TextEditingController additionalCategoryController =
  TextEditingController();

  final TextEditingController additionalSubCategoryController =
  TextEditingController();

  List<Map<String, dynamic>> additionalFieldsList = [];

  SettingsProvider() {
    fetchAllSettings();
  }

  Future<void> fetchAllSettings() async {
    await fetchAdditionalFields();
    await fetchLeadStatus();
    await fetchCallStatus();
    await fetchLeadCategory();
    await fetchLeadSource();
    await fetchAdditionalDetails();
  }

  // ================= ADDITIONAL DETAILS =================

  Future<void> fetchAdditionalDetails() async {
    final doc =
    await db.collection("LEAD_SETTINGS").doc("additional_details").get();

    if (doc.exists) {
      additionalFieldsList =
      List<Map<String, dynamic>>.from(doc.data()?["categoryList"] ?? []);
    } else {
      additionalFieldsList = [];
    }

    notifyListeners();
  }

  void addAdditionalCategoryToList() {
    final category = additionalCategoryController.text.trim();
    final sub = additionalSubCategoryController.text.trim();

    if (category.isEmpty) return;

    additionalFieldsList.add({
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

    final index = additionalFieldsList.indexWhere(
          (element) =>
      element["title"].toString().toLowerCase() == category.toLowerCase(),
    );

    if (index != -1) {
      final subList =
      List<String>.from(additionalFieldsList[index]["sub"] ?? []);

      if (!subList.contains(sub)) {
        subList.add(sub);
      }

      additionalFieldsList[index]["sub"] = subList;
    } else {
      additionalFieldsList.add({
        "title": category,
        "sub": [sub],
      });
    }

    additionalSubCategoryController.clear();
    notifyListeners();
  }

  void deleteAdditionalSubCategory(int categoryIndex, String sub) {
    final subList =
    List<String>.from(additionalFieldsList[categoryIndex]["sub"] ?? []);
    subList.remove(sub);
    additionalFieldsList[categoryIndex]["sub"] = subList;

    notifyListeners();
  }

  void clearAdditionalInputFields() {
    additionalCategoryController.clear();
    additionalSubCategoryController.clear();
    notifyListeners();
  }

  void clearAdditionalDetails() {
    additionalDetails.clear();
    notifyListeners();
  }

  Future<void> saveAdditionalDetails() async {
    final cleanList = additionalFieldsList
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

    await db.collection("LEAD_SETTINGS").doc("additional_details").set({
      "categoryList": cleanList,
    }, SetOptions(merge: true));

    await fetchAdditionalDetails();
    clearAdditionalInputFields();
  }

  void updateAdditionalDetail(String label, String? value) {
    additionalDetails[label] = value;
    notifyListeners();
  }

  // ================= ADDITIONAL FIELDS =================

  void addAdditionalField() {
    additionalFields.add({
      "title": "",
      "controller": TextEditingController(),
      "sub": [],
      "subcontrollers": [],
    });

    notifyListeners();
  }

  void updateAdditionalField(int index, String value) {
    additionalFields[index]["title"] = value;
    notifyListeners();
  }

  void deleteAdditionalField(int index) {
    additionalFields[index]["controller"]?.dispose();

    for (var c in additionalFields[index]["subcontrollers"]) {
      c.dispose();
    }

    additionalFields.removeAt(index);

    if (additionalFields.isEmpty) {
      addAdditionalField();
    }

    notifyListeners();
  }

  void addSubCategory(int index) {
    final title = additionalFields[index]["title"].toString().trim();

    if (title.isEmpty) return;

    if (additionalFields[index]["sub"].isNotEmpty) {
      final last = additionalFields[index]["sub"].last.toString().trim();
      if (last.isEmpty) return;
    }

    additionalFields[index]["sub"].add("");
    additionalFields[index]["subcontrollers"].add(TextEditingController());

    notifyListeners();
  }

  void updateSubCategory(int index, int subIndex, String value) {
    additionalFields[index]["sub"][subIndex] = value;
    notifyListeners();
  }

  void deleteSubCategory(int index, int subIndex) {
    additionalFields[index]["subcontrollers"][subIndex].dispose();
    additionalFields[index]["subcontrollers"].removeAt(subIndex);
    additionalFields[index]["sub"].removeAt(subIndex);

    notifyListeners();
  }

  Future<void> clearAdditionalFields() async {
    for (var cat in additionalFields) {
      cat["controller"]?.dispose();

      for (var c in cat["subcontrollers"]) {
        c.dispose();
      }
    }

    additionalFields.clear();

    additionalFields.add({
      "title": "",
      "controller": TextEditingController(),
      "sub": [],
      "subcontrollers": [],
    });

    notifyListeners();
  }

  Future<void> saveAdditionalFields() async {
    final newList = additionalFields
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

    await db.collection("LEAD_SETTINGS").doc("additional_details").set({
      "categoryList": newList,
    }, SetOptions(merge: true));

    await fetchAdditionalFields();
    await fetchAdditionalDetails();
  }

  Future<void> fetchAdditionalFields() async {
    final doc =
    await db.collection("LEAD_SETTINGS").doc("additional_details").get();

    if (!doc.exists) {
      clearAdditionalFields();
      return;
    }

    final data = doc.data();
    final rawList = data?["categoryList"] ?? [];

    for (var cat in additionalFields) {
      cat["controller"]?.dispose();

      for (var c in cat["subcontrollers"]) {
        c.dispose();
      }
    }

    additionalFields = List<Map<String, dynamic>>.from(
      rawList.map((e) {
        final subList = List<String>.from(e["sub"] ?? []);

        return {
          "title": e["title"] ?? "",
          "controller": TextEditingController(text: e["title"] ?? ""),
          "sub": subList,
          "subcontrollers":
          subList.map((sub) => TextEditingController(text: sub)).toList(),
        };
      }),
    );

    if (additionalFields.isEmpty) {
      additionalFields.add({
        "title": "",
        "controller": TextEditingController(),
        "sub": [],
        "subcontrollers": [],
      });
    }

    savedAdditionalFields = List<Map<String, dynamic>>.from(rawList);
    additionalFieldsList = List<Map<String, dynamic>>.from(rawList);

    notifyListeners();
  }

  // ================= LEAD STATUS =================

  void addLeadStatus(String value) {
    value = value.trim();
    if (value.isEmpty) return;
    // if (leadStatus.contains(value)) return;
    if (leadStatus.any(
          (e) => e.toLowerCase() == value.toLowerCase(),
    )) {
      return;
    }

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
      "leadStatusList": cleanList,
    }, SetOptions(merge: true));

    await fetchLeadStatus();
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
      "callStatusList": cleanList,
    }, SetOptions(merge: true));

    await fetchCallStatus();
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

  // ================= LEAD CATEGORY =================

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
      "leadCategoryList": cleanList,
    }, SetOptions(merge: true));

    await fetchLeadCategory();
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

  // ================= LEAD SOURCE =================

  void addleadSource(String value) {
    value = value.trim();

    if (value.isEmpty) return;
    if (leadSource.contains(value)) return;

    leadSource.add(value);
    notifyListeners();
  }

  void deleteleadSource(int index) {
    leadSource.removeAt(index);
    notifyListeners();
  }

  Future<void> saveleadSource() async {
    final cleanList = leadSource
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    await db.collection("LEAD_SETTINGS").doc("lead_source").set({
      "leadSourceList": cleanList,
    }, SetOptions(merge: true));

    await fetchLeadSource();
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

  // ================= SAVE ALL =================

  Future<void> saveAllSettings() async {
    await saveAdditionalFields();
    await saveLeadStatus();
    await saveCallStatus();
    await saveLeadCategory();
    await saveleadSource();
  }

  // ================= CLEAR ALL =================

  Future<void> clearAllFromFirebaseAndScreen() async {
    await db.collection("LEAD_SETTINGS").doc("additional_details").set({
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

    clearAdditionalFields();
    leadStatus.clear();
    callStatus.clear();
    leadCategory.clear();
    leadSource.clear();
    additionalFieldsList.clear();
    additionalDetails.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    additionalCategoryController.dispose();
    additionalSubCategoryController.dispose();

    for (var cat in additionalFields) {
      cat["controller"]?.dispose();

      for (var c in cat["subcontrollers"]) {
        c.dispose();
      }
    }

    super.dispose();
  }
}