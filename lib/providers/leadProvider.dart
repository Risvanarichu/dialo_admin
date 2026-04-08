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
  bool isLoading = false;
  StreamSubscription? leadSubscription;
  final searchController = TextEditingController();
  String selectedStatus = "All Status";
  String selectedSources = "All Sources";
  String searchQuery = "";
  final String agentId = "1775024001964000";

  LeadProvider() {
    listenLeads();
  }

  Future<void> fixOldLeads() async {
    final agents = await fbd.collection('AGENT').get();
    final leads = await fbd.collection('LEADS').get();

    if (agents.docs.isEmpty) return;

    String defaultAgentId = agents.docs.first.id;

    for (var lead in leads.docs) {
      await lead.reference.update({
        "ASSIGNED_AGENT_ID":
        lead.data()["ASSIGNED_AGENT_ID"] ?? defaultAgentId,
        "ADDED_BY_ID":
        lead.data()["ADDED_BY_ID"] ?? defaultAgentId,
      });
    }

    print("Fixed old leads ✅");
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

  Future<void> completedLead(String id) async {
    await fbd.collection('LEADS').doc(id).update({
      "FOLLOW_UP_STATUS": "completed",
      "STATUS": "Converted",
    });
    notifyListeners();
  }

  Future<void> rescheduleLead(String id, DateTime date, String time) async {
    await fbd.collection("LEADS").doc(id).update({
      "FOLLOW_UP_DATE": Timestamp.fromDate(date),
      "FOLLOW_UP_TIME": time,
    });
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
}
