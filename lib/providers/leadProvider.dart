import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/models/leadModel.dart';
import 'package:dialo_admin/views/leads/leads_list.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class LeadProvider extends ChangeNotifier {
  FirebaseFirestore fbd = FirebaseFirestore.instance;
  List<LeadModel> leads = [];

  List<LeadModel> get leadsList => leads;
  List<LeadModel> allLeads = [];
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
  final String agentId = "1775141226586000";

  LeadProvider() {
    listenLeads();
  }

  Future<void> fixOldLeads() async {
    final agents = await fbd.collection('AGENT').get();
    final leadsSnapshot = await fbd.collection('LEADS').get();

    String defaultAgentId =
    agents.docs.isNotEmpty ? agents.docs.first.id : agentId;

    for (var lead in leadsSnapshot.docs) {
      await lead.reference.update({
        "ASSIGNED_AGENT_ID":
        lead.data()["ASSIGNED_AGENT_ID"] ?? defaultAgentId,
        "ADDED_BY_ID":
        lead.data()["ADDED_BY_ID"] ?? defaultAgentId,
      });
    }

    print("Fixed old leads ✅");
  }

    Future<void> addLead({
      required String name,
      required String phone,
      required String email,
      required String source,
      required String leadStatus,
      required String callType,
      required String notes,
    }) async {
      try {
        final docRef = fbd.collection("LEADS").doc();

        await docRef.set({
          "LEAD_ID": docRef.id,
          "NAME": name.trim(),
          "PHONE": phone.trim(),
          "EMAIL": email.trim(),
          "SOURCE": source.trim(),
          "STATUS": leadStatus.trim(),
          "CALL TYPE": callType.trim(),
          "FOLLOW_UP_STATUS": "pending",
          "NOTES": notes.trim(),
          "ADDITIONAL DETAILS": additionalDetails,
          "ADDED TIME": FieldValue.serverTimestamp(),
          "ADDED BY ID": agentId,
          "ASSIGNED_AGENT_ID": agentId,
          "FOLLOW UP DATE": null,
          "FOLLOW UP TIME": "",
          "PLACE": "",
          "PRIORITY": "Medium",
        });
      } catch (e) {
        debugPrint("Error adding lead: $e");
        rethrow;
      }
    }



  void listenLeads() {
    isLoading = true;
    notifyListeners();

    leadSubscription?.cancel();

    leadSubscription = fbd.collection('LEADS').snapshots().listen((snapshot) {
      leads = snapshot.docs.map((doc) {
        final data = doc.data();

        if (data["ASSIGNED_AGENT_ID"] == null ||
            data["ASSIGNED_AGENT_ID"].toString().isEmpty) {
          doc.reference.update({
            "ASSIGNED_AGENT_ID": agentId,
            "ADDED_BY_ID": agentId,
          });
        }

        return LeadModel.fromMap(doc.id, data);
      }).toList();

      applyFilters();

      isLoading = false;
      notifyListeners();
    });
  }

  // Future<void> fetchLeads() async {
  //   isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     final snapshot = await fbd.collection('LEADS').get();
  //
  //     leads = [];
  //
  //     for (var doc in snapshot.docs) {
  //       try {
  //         leads.add(LeadModel.fromMap(doc.id, doc.data()));
  //       } catch (e) {
  //         print("Error in doc ${doc.id}: $e");
  //       }
  //     }
  //   } catch (e) {
  //     print("Error fetching leads: $e");
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchLeads() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await fbd.collection('LEADS').get();

      leads = snapshot.docs.map((doc) {
        final data = doc.data();

        /// ✅ AUTO FIX
        if (data["ASSIGNED_AGENT_ID"] == null ||
            data["ASSIGNED_AGENT_ID"].toString().isEmpty) {
          doc.reference.update({
            "ASSIGNED_AGENT_ID": agentId,
            "ADDED_BY_ID": agentId,
          });
        }

        return LeadModel.fromMap(doc.id, data);
      }).toList();
    } catch (e) {
      print("Error fetching leads: $e");
    }

    isLoading = false;
    applyFilters();
    notifyListeners();
  }

  void searchLeads(String query) {
    searchQuery = query;
    applyFilters();
  }

  void applyFilters() {
    final query = searchQuery.toLowerCase();

    allLeads = leads.where((lead) {
      final name = lead.name.toLowerCase() ;
      final phone = lead.phone.toLowerCase() ;
      final email = lead.email.toLowerCase() ;
      final status = lead.status.toUpperCase();
      final calltype = lead.calltype.toUpperCase();
      final source = lead.source.toUpperCase();

      final matchesSearch =
          query.isEmpty ||
          name.contains(query) ||
          phone.contains(query) ||
          email.contains(query);

      final matchesStatus =
          selectedStatus == "All Status" ||
          status == selectedStatus.toUpperCase();

      final matchesSource =
          selectedSources == "All Sources" ||
          source == selectedSources.toUpperCase();

      return matchesSearch && matchesStatus && matchesSource;
    }).toList();

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

  Future<void> assignAgent(String leadId, String agentId) async {
    try {
      await fbd.collection('LEADS').doc(leadId).update({
        "ASSIGNED_AGENT_ID": agentId,
      });
    } catch (e) {
      print("Assign Error: $e");
    }
  }

  void updateStatus(String status) {
    selectedStatus = status;
    applyFilters();
  }

  void updateSource(String source) {
    selectedSources = source;
    applyFilters();
  }

  Future<void> completedLead(String leadId) async {
    await fbd.collection('LEADS').doc(leadId).update({
      "FOLLOW_UP_STATUS": "COMPLETED",
    });
  }

  Future<void> rescheduleLead(
      String leadId, DateTime date, String time) async {
    await fbd.collection('LEADS').doc(leadId).update({
      "FOLLOW UP DATE": date,
      "FOLLOW UP TIME": time,
      "FOLLOW_UP_STATUS": "pending",
    });
  }
}
