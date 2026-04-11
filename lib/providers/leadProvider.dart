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
  Map<String, String> agentMap = {};
  String selectedCallStatus = "all";
  List<String> callStatusList = [];

  bool isLoading = false;
  StreamSubscription? leadSubscription;
  final searchController = TextEditingController();
  String selectedStatus = "All Status";
  String selectedSources = "All Sources";
  String searchQuery = "";
  final String agentId = "1775024001964000";

  var userList;

  LeadProvider() {         
  init();
}

Future<void> init() async {
  listenLeads();   
}

void setCallStatus(String status) {
  selectedCallStatus = status;
  notifyListeners();
}

  get calltype => null;

  Future<void> addLead({
    required String name,
    required String phone,
    required String email,
    required String source,
    required String leadStatus,
    required String callType,
    required String notes,
  }) async {
    await fbd.collection("LEADS").add({
      "NAME": name,
      "PHONE": phone,
      "EMAIL": email,
      "SOURCE": source,
      "LEAD STATUS": leadStatus,
     "CALL TYPE":calltype,
      "NOTES": notes,
      "ADDITIONAL DETAILS": additionalDetails,
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
        "CALL TYPE":callType.trim(),
        "FOLLOW_UP_STATUS": "pending",
        "NOTES": notes.trim(),
        "ADDED TIME": FieldValue.serverTimestamp(),
        "ADDED BY ID": "web_admin",
        "ASSIGNED AGENT": "",
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

leadSubscription = fbd.collection('LEADS').snapshots().listen((snapshot) {
  leads = snapshot.docs.map((doc) {
    final data = doc.data();

    String agentId = data["ASSIGNED_AGENT_ID"] ?? "";

    if (data["ASSIGNED_AGENT_ID"] == null ||
        data["ASSIGNED_AGENT_ID"].toString().isEmpty) {
      doc.reference.update({
        "ASSIGNED_AGENT_ID": agentId,
        "ADDED_BY_ID": agentId,
      });
    }

return LeadModel.fromMap(
  doc.id,
  {
    ...data,
    "ASSIGNED_AGENT_NAME": agentMap[agentId] ?? "Unknown", 
  },
);
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

      
        if (data["ASSIGNED_AGENT_ID"] == null ||
            data["ASSIGNED_AGENT_ID"].toString().isEmpty) {
          doc.reference.update({
  "ASSIGNED_AGENT_ID": agentId,
  "ASSIGNED_AGENT_NAME": "Anshad", // ✅ add
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
        final callStatus = (lead.followupstatus ?? "") == "pending"
    ? "missed"
    : "answered";
    
final matchesCallStatus =
    selectedCallStatus == "all" ||
    callStatus == selectedCallStatus;

return matchesSearch &&
       matchesStatus &&
       matchesSource &&
       matchesCallStatus;    
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

  Future<void> fetchCallStatuses() async {
    try {
      final snapshot = await fbd.collection("LEAD_SETTINGS").doc("call_statuses").get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final rawList = data["statuses"] ?? [];
        callStatusList = List<String>.from(rawList.map((e) => e.toString()));
      } else {
        callStatusList = [];
      }
    } catch (e) {
      callStatusList = [];
      debugPrint("fetchCallStatuses error: $e");
    } finally {
      
      isLoading = false;
      notifyListeners();
    }
  }


Future<void> fetchLeadCategories() async {
    try {
      final snapshot = await fbd.collection("LEAD_SETTINGS").doc("categories").get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final rawList = data["categoryList"] ?? data["categories"] ?? [];

        categoryList = List<LeadCategoryModel>.from(
          rawList.map((e) => LeadCategoryModel.fromMap(Map<String, dynamic>.from(e))),
        );
      } else {
        categoryList = [];
      }
    } catch (e) {
      categoryList = [];
      debugPrint("fetchLeadCategories error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
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

  Future<void> assignAgent(String leadId, String agentId, String agentName) async {
  try {
    await fbd.collection('LEADS').doc(leadId).update({
      "ASSIGNED_AGENT_ID": agentId,
      "ASSIGNED_AGENT_NAME": agentName, // ✅ add this
    });
  } catch (e) {
    print("Assign Error: $e");
  }
}




  void updateSource(String source) {
    selectedSources = source;
    applyFilters();
  }

  void updateStatus(String s) {}
}
