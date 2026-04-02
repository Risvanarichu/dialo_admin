import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> categories = [];
  List<String> callStatus = [];
final TextEditingController categoryController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  SettingsProvider() {
    fetchCategories();
  }

  // Future<void> saveCategories() async {
  //   List<Map<String, dynamic>> clearCategories =
  //   categories.map((e) {
  //     return {
  //       "title": e["title"],
  //       "sub": e["sub"],
  //     };
  //   }).toList();
  //
  //   // await db.collection("LEAD_SETTINGS").doc("categories").set({
  //   //   "categoryList": clearCategories,
  //   //   "callStatus": callStatus,
  //   // });
  // }

  Future<void> saveCategories() async {
    final docRef = db.collection("LEAD_SETTINGS").doc("categories");

    final doc = await docRef.get();

    List<Map<String, dynamic>> existingCategories = [];
    List<String> existingCallStatus = [];

    if (doc.exists) {
      final data = doc.data();
      existingCategories = List<Map<String, dynamic>>.from(
          data?["categoryList"] ?? []);
      // existingCallStatus =
      // List<String>.from(data?["callStatus"] ?? []);
    }

    List<Map<String, dynamic>> newCategories =
    categories.map((e) {
      return {
        "title": e["title"],
        // "controller":TextEditingController(),
        "sub": e["sub"],
        // "subcontrollers": [],
      };
    }).toList();

    // ✅ MERGE old + new
    existingCategories.addAll(newCategories);

    // ✅ Remove duplicates (optional)
    existingCategories = existingCategories.toSet().toList();

    await docRef.set({
      "categoryList": existingCategories,
      // "callStatus": callStatus.isNotEmpty
      //     ? callStatus
      //     : existingCallStatus,
    });
  }

  void addCategory() {
    categories.add({
      "title": "",
      "controller":TextEditingController(),
      "sub": [],
      "subcontrollers": [],
    });
    notifyListeners();
  }
  void addCallStatus(String value) {
    value = value.trim();

    if (value.isEmpty || callStatus.contains(value)) return;

    callStatus.add(value);
    notifyListeners();
  }

  void deleteCategory(int index) {
    categories[index]["controller"].dispose();
    for(var c in categories[index]["subcontrollers"]){
      c.dispose();
    }
    categories.removeAt(index);
    notifyListeners();
  }
  void deleteCallStatus(String value){
    value=value.trim();
    if(value.isEmpty)return;
    callStatus.remove(value);
    notifyListeners();
  }

  void updateCategory(int index, String value) {
    categories[index]["title"] = value;
  }

  void addSubCategory(int index) {
    if (categories[index]["sub"] != null && categories[index]["sub"].isNotEmpty) {
      String lastSub = categories[index]["sub"].last.toString().trim();
      if (lastSub.isEmpty) return;
    }

    categories[index]["sub"].add("");
    categories[index]["subcontrollers"].add(TextEditingController());
    notifyListeners();
  }

  void updateSubCategory(int index, int subIndex, String value) {
    categories[index]["sub"][subIndex] = value;
  }

  void deleteSubCategory(int index, int subIndex) {
    categories[index]["sub"].removeAt(subIndex);
    notifyListeners();
  }
  Future<void> fetchCategories() async {
    final doc = await db.collection("LEAD_SETTINGS").doc("categories").get();

    if (doc.exists) {
      final data = doc.data();

      categories = List<Map<String, dynamic>>.from(
        (data?["categoryList"] ?? []).map((e) {
          List<String> subList = List<String>.from(e["sub"] ?? []);

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

      callStatus = List<String>.from(data?["callStatus"] ?? []);

      notifyListeners();
    }
  }

  // Future<void> fetchCategories() async {
  //   final doc = await db.collection("LEAD_SETTINGS").doc("categories").get();
  //
  //   if (doc.exists) {
  //     final data = doc.data();
  //
  //     categories = List<Map<String, dynamic>>.from(
  //       (data?["categoryList"] ?? []).map((e) => {
  //         "title": e["title"],
  //         "sub": List<String>.from(e["sub"] ?? []),
  //       }),
  //     );
  //
  //     callStatus = List<String>.from(data?["callStatus"] ?? []);
  //
  //     notifyListeners();
  //   }
  // }
  Future<void>fetchCallStatus()async{
    final doc=await db.collection("LEAD SETTINGS").doc("CALL STATUS").get();
    if(doc.exists){
      final data=doc.data();
    }
  }

  void clearCategories() {
    categories = [
      {
        "title": "",
        "controller":TextEditingController(),
        "sub": [],
        "subcontrollers":[],
      }
    ];
    notifyListeners();
  }
  void clearCallStatus(){
    callStatus.clear();
    notifyListeners();
  }
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }
 // Future<void> saveCallStatus() async {
 //    await db.collection("LEAD_SETTINGS").doc("call_status").set({
 //      "callStatus": callStatus,
 //    });
 //  }

  Future<void> saveCallStatus() async {
    final docRef = db.collection("LEAD_SETTINGS").doc("call_status");

    final doc = await docRef.get();

    List<String> existing = [];

    if (doc.exists) {
      existing = List<String>.from(doc.data()?["callStatus"] ?? []);
    }

    existing.addAll(callStatus);

    // remove duplicates
    existing = existing.toSet().toList();

    await docRef.set({
      "callStatus": existing,
    });
  }
}