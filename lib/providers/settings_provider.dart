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

  Future<void> saveCategories() async {
    List<Map<String, dynamic>> clearCategories =
    categories.map((e) {
      return {
        "title": e["title"],
        "sub": e["sub"],
      };
    }).toList();

    await db.collection("LEAD_SETTINGS").doc("categories").set({
      "categoryList": clearCategories,
      "callStatus": callStatus,
    });
  }

  void addCategory() {
    categories.add({
      "title": "",
      "sub": [],
    });
    notifyListeners();
  }

  void deleteCategory(int index) {
    categories.removeAt(index);
    notifyListeners();
  }

  void updateCategory(int index, String value) {
    categories[index]["title"] = value;
  }

  void addSubCategory(int index) {
    categories[index]["sub"].add("");
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
        (data?["categoryList"] ?? []).map((e) => {
          "title": e["title"],
          "sub": List<String>.from(e["sub"] ?? []),
        }),
      );

      callStatus = List<String>.from(data?["callStatus"] ?? []);

      notifyListeners();
    }
  }

  void clearCategories() {
    categories = [
      {
        "title": "",
        "sub": [],
      }
    ];
    notifyListeners();
  }
}