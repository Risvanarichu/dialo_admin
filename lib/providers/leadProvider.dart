import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/models/leadModel.dart';
import 'package:dialo_admin/views/leads/leads_list.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class LeadProvider extends ChangeNotifier{
  FirebaseFirestore fbd = FirebaseFirestore.instance;
  List<LeadModel>leads=[];
  List<LeadModel> get leadsList => leads;
  List<LeadModel>allLeads =[];
  List<LeadCategoryModel> categoryList = [];
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic> additionalDetails = {};
  bool isCategoryLoading=false;
  bool isLoading = false;
  StreamSubscription? leadSubscription;
  final searchController = TextEditingController();
  String selectedStatus = "All Status";
  String selectedSources = "All Sources";
  String searchQuery = "";

  LeadProvider(){
    listenLeads();
  }

  Future<void> addLead({
    required String name,
    required String phone,
    required String email,
    required String source,
    required String leadStatus,
    required String notes,
  }) async {
    await fbd.collection("LEADS").add({
      "name": name,
      "phone": phone,
      "email": email,
      "source": source,
      "leadStatus": leadStatus,
      "notes": notes,
      "additionalDetails": additionalDetails,
    }

    );
    try {
      final docRef = fbd.collection("LEADS").doc();
      await docRef.set({
        "LEAD_ID": docRef.id,
        "NAME": name.trim(),
        "PHONE": phone.trim(),
        "EMAIL": email.trim(),
        "SOURCE": source.trim(),
        "STATUS": leadStatus.trim(),
        "FOLLOW_UP_STATUS": "pending",
        "NOTES": notes.trim(),
        "ADDED_TIME": FieldValue.serverTimestamp(),
        "ADDED_BY_ID": "web_admin",
        "ASSIGNED_AGENT": "",
        "FOLLOW_UP_DATE": null,
        "FOLLOW_UP_TIME": "",
        "PLACE": "",
        "PRIORITY": "Medium",
      });
    } catch (e) {
      debugPrint("Error adding lead: $e");
      rethrow;
    }
  }

  Future<void> completedLead(String id) async {
    await fbd.collection('LEADS').doc(id).update({
      "FOLLOW_UP_STATUS": "completed",
      "STATUS": "Converted",
    });
  }

  Future<void> rescheduleLead(String id, DateTime date, String time) async {
    await fbd.collection("LEADS").doc(id).update({
      "FOLLOW_UP_DATE": Timestamp.fromDate(date),
      "FOLLOW_UP_TIME": time,
    });
  }

  void listenLeads() {
    isLoading = true;
    notifyListeners();

    leadSubscription?.cancel();

    leadSubscription =
        fbd.collection('LEADS').snapshots().listen((snapshot) {
          leads = snapshot.docs
              .map((doc) => LeadModel.fromMap(doc.id, doc.data()))
              .toList();

          isLoading = false;
          notifyListeners();
        });
  }

  Future<void>fetchLeads()async{
    isLoading = true;
    notifyListeners();

   try {
     final snapshot = await fbd.collection('LEADS').get();

     leads = [];

     for (var doc in snapshot.docs) {
       try {
         leads.add(LeadModel.fromMap(doc.id, doc.data()));
       } catch (e) {
         print("Error in doc ${doc.id}: $e");
       }
     }
   }catch(e) {
     print("Error fetching leads: $e");
   }finally{
     isLoading = false;
     notifyListeners();
   }
   }

  void searchLeads(String query) {
    searchQuery = query;
    isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      leads = allLeads;
    } else {
      final q = query.toLowerCase();

      leads = allLeads.where((lead) {
        return lead.name.toLowerCase().contains(q) ||
            lead.phone.toLowerCase().contains(q) ||
            lead.email.toLowerCase().contains(q);
      }).toList();
    }
    isLoading = false;
    notifyListeners();
  }
  void dispose() {
    leadSubscription?.cancel();
    searchController.dispose();
    super.dispose();
  }
  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();
  }
  Future<void> fetchLeadSettings() async {
    try {
      isCategoryLoading = true;
      notifyListeners();

      final doc = await fbd.collection("LEAD_SETTINGS").doc("categories").get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final rawList = data["categoryList"] ?? data["categories"] ?? [];

        categories = List<Map<String, dynamic>>.from(
          rawList.map((e) => Map<String, dynamic>.from(e)),
        );
      } else {
        categories = [];
      }
    } catch (e) {
      categories = [];
      debugPrint("fetchLeadSettings error: $e");
    } finally {
      isCategoryLoading = false;
      notifyListeners();
    }
  }
  void updateAdditionalDetail(String key, dynamic value) {
    additionalDetails[key] = value;
    notifyListeners();
  }

  void clearAdditionalDetails() {
    additionalDetails.clear();
    notifyListeners();
  }
}