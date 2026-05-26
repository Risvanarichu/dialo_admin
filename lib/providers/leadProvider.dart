import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/models/leadModel.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';




class LeadProvider extends ChangeNotifier {
  FirebaseFirestore fbd = FirebaseFirestore.instance;
  String currentPage = "leads";
  List<LeadModel> leads = [];
  DateTime now = DateTime.now();

  List<LeadModel> get leadsList => leads;
  List<LeadModel> allLeads = [];
  List<LeadCategoryModel> categoryList = [];
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic> additionalDetails = {};
  bool isCategoryLoading = false;
  Map<String, String> agentMap = {};
  String selectedCallStatus = "all";
  List<String> callStatusList = [];
  String selectedAgentFilter = "all";

  bool isLoading = false;
  StreamSubscription? leadSubscription;
  final searchController = TextEditingController();
  String selectedStatus = "All Status";
  String selectedSources = "All Sources";
  String searchQuery = "";
  String? agentId;
  String? agentName;
  String? editingId;
  bool isEdit = false;
  bool isButtonLoading = false;
  bool isPageLoading = false;
  var userList;
  String leadStatusValue = "";
  String callStatusValue = "";
  String notesValue = "";
  DateTime? startDate;
  DateTime? endDate;

  String? selectedAgentId;
  String? selectedAgentName;
  String userRole = "";


  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final sourceController = TextEditingController();
  final remarkController = TextEditingController();
  final dateController = TextEditingController();

  var leadCategoryValue;

  LeadProvider() {
    init();
  }

  List<String> get leadCategoryList {
    for (var cat in categoryList) {
      if (cat.title.toLowerCase() == "call type") {
        return cat.sub;
      }
    }
    return [];
  }

  get leadCategory => null;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setDateRange(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
    applyFilters();
  }

  Future<void> init() async {
    await loadAgentData();
    await loadAgents();
    listenLeads();
  }

  Future<void> loadAgentData() async {
    final prefs = await SharedPreferences.getInstance();

    agentId = prefs.getString('agentId') ?? "";
    agentName = prefs.getString('name') ?? "Unknown";
    userRole =
        (prefs.getString('role') ?? "AGENT").toUpperCase().trim();

    print("Agent ID: $agentId");
    print("Agent Name: $agentName");
    print("User Role : $userRole");
  }

  Future<void> loadAgents() async {
    final snapshot = await fbd.collection('AGENT').get();

    agentMap = {
      for(var doc in snapshot.docs)
        doc.id: doc.data()["NAME"] ?? "Unknown"
    };
    notifyListeners();
  }

  void setCallStatus(String status) {
    selectedCallStatus = status;
    notifyListeners();
  }

  void changePage(String page) {
    currentPage = page;
    notifyListeners();
  }

  Future<void> fixOldLeads() async {
    final agents = await fbd.collection('AGENT').get();
    final leadsSnapshot = await fbd.collection('LEADS').get();

    String? defaultAgentId =
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
    required String callStatus,
    required String notes,
    String? assignedAgentId,
    String? assignedAgentName, required String leadCategory, required Map<String, dynamic> additionalDetails,
  }) async {
    try {
      String leadId = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();

      final docRef = fbd.collection("LEADS").doc(leadId);
      await docRef.set({
        "LEAD_ID": docRef.id,
        "NAME": name.trim(),
        "PHONE": phone.trim(),
        "EMAIL": email.trim(),
        "SOURCE": source.trim(),
        "LEAD_STATUS": leadStatus.trim(),
        "CALL_STATUS": callStatus.trim(),
        "LEAD_CATEGORY": leadCategory.trim(),
        "FOLLOW_UP_STATUS": "pending",
        "NOTES": notes.trim(),
        "ADDITIONAL_LEAD_DETAILS": additionalDetails,
        "ADDED_TIME": FieldValue.serverTimestamp(),
        "ADDED_BY_ID": agentId,
        "ASSIGNED_AGENT_ID": assignedAgentId ?? agentId,
        "ASSIGNED_AGENT_NAME": assignedAgentName ?? agentName,
        "FOLLOW_UP_DATE": now.add(Duration(days: 3)),
        "FOLLOW_UP_TIME": "",
        "PLACE": "",
        "PRIORITY": "High",
        "LAST_CONTACTED_DATE": now,
      });
    } catch (e) {
      debugPrint("Error adding lead: $e");
      rethrow;
    }
  }


  // void listenLeads() {
  //   isLoading = true;
  //   notifyListeners();
  //
  //   leadSubscription?.cancel();
  //
  //   leadSubscription = fbd.collection('LEADS').snapshots().listen((snapshot) {
  //     leads = snapshot.docs.map((doc) {
  //       final data = doc.data();
  //
  //       String assignedAgentId = data["ASSIGNED_AGENT_ID"] ?? "";
  //
  //       if (assignedAgentId
  //           .toString()
  //           .isEmpty) {
  //         doc.reference.update({
  //           "ASSIGNED_AGENT_ID": agentId ?? this.agentId,
  //           "ASSIGNED_AGENT_NAME": agentName ?? this.agentName,
  //           "ADDED_BY_ID": agentId,
  //         });
  //       }
  //
  //       return LeadModel.fromMap(
  //         doc.id,
  //         {
  //           ...data,
  //           "ASSIGNED_AGENT_NAME":
  //           agentMap.containsKey(assignedAgentId)
  //               ? agentMap[assignedAgentId]
  //               : data["ASSIGNED_AGENT_NAME"] ?? "Unassigned",
  //         },
  //       );
  //     }).toList();
  //
  //     applyFilters();
  //
  //     isLoading = false;
  //     notifyListeners();
  //   });
  // }


  void listenLeads() {
    isLoading = true;
    notifyListeners();

    leadSubscription?.cancel();

    Query query = fbd.collection('LEADS');

    /// IF AGENT → ONLY THEIR LEADS
    if (userRole.trim().toUpperCase() != "ADMIN") {
      query = query.where(
        "ASSIGNED_AGENT_ID",
        isEqualTo: agentId,
      );
    }

    leadSubscription = query.snapshots().listen((snapshot) {
      leads = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        String assignedAgentId = data["ASSIGNED_AGENT_ID"] ?? "";

        return LeadModel.fromMap(
          doc.id,
          {
            ...data,
            "ASSIGNED_AGENT_NAME":
            agentMap.containsKey(assignedAgentId)
                ? agentMap[assignedAgentId]
                : data["ASSIGNED_AGENT_NAME"] ?? "Unassigned",
          },
        );
      }).toList();

      applyFilters();

      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> fetchLeads() async {
    isLoading = true;
    notifyListeners();

    try {
      Query query = fbd.collection('LEADS');

      if (userRole != "ADMIN") {
        query = query.where(
          "ASSIGNED_AGENT_ID",
          isEqualTo: agentId,
        );
      }

      final snapshot = await query.get();
      leads = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;


        if (data["ASSIGNED_AGENT_ID"] == null ||
            data["ASSIGNED_AGENT_ID"]
                .toString()
                .isEmpty) {
          doc.reference.update({
            "ASSIGNED_AGENT_ID": agentId ?? this.agentId,
            "ASSIGNED_AGENT_NAME": agentName ?? this.agentName, // ✅ add
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
      final name = lead.name.toLowerCase();
      final phone = lead.phone.toLowerCase();
      final email = lead.email.toLowerCase();
      final status = lead.Leadstatus.toUpperCase();
      final callStatus = lead.callStatus.toUpperCase();
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
              source.toLowerCase() == selectedSources.toLowerCase();
      // final callStatus= (lead.followupstatus ) == "pending"
      //     ? "missed"
      //     : "answered";

      final matchesCallStatus =
          selectedCallStatus == "all" ||
              callStatus == selectedCallStatus;

      final matchesAgent =
          selectedAgentFilter == "all" ||
              lead.assignedAgentId == selectedAgentFilter;

      final matchesDate =
          startDate == null ||
              endDate == null ||
              (lead.lastContactedDate.isAfter(
                  startDate!.subtract(const Duration(days: 1))) &&
                  lead.lastContactedDate.isBefore(
                      endDate!.add(const Duration(days: 1))));

      return matchesSearch &&
          matchesStatus &&
          matchesSource &&
          matchesCallStatus &&
          matchesAgent &&
          matchesDate;
    }).toList();

    notifyListeners();
  }

  @override
  void dispose() {
    leadSubscription?.cancel();
    searchController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    sourceController.dispose();
    super.dispose();
  }

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();
  }

  Future<void> fetchCallStatuses() async {
    try {
      final snapshot = await fbd.collection("LEAD_SETTINGS").doc(
          "call_statuses").get();

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
      final snapshot = await fbd
          .collection("LEAD_SETTINGS")
          .doc("categories")
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final rawList = data["categoryList"] ?? data["categories"] ?? [];

        categoryList = List<LeadCategoryModel>.from(
          rawList.map((e) =>
              LeadCategoryModel.fromMap(Map<String, dynamic>.from(e))),
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

  Future<void> assignAgent(String leadId, String agentId,
      String agentName) async {
    try {
      await fbd.collection('LEADS').doc(leadId).update({
        "ASSIGNED_AGENT_ID": agentId,
        "ASSIGNED_AGENT_NAME": agentName,
      });
    } catch (e) {
      print("Assign Error: $e");
    }
  }


  void updateSource(String source) {
    selectedSources = source;
    applyFilters();
  }

  void updateStatus(String s) {
    selectedStatus = s;
    applyFilters();
  }

  Future<void> completedLead(String leadId) async {
    await fbd.collection('LEADS').doc(leadId).update({
      "FOLLOW_UP_STATUS": "COMPLETED",
    });
  }

  Future<void> rescheduleLead(String leadId, DateTime date, String time) async {
    await fbd.collection('LEADS').doc(leadId).update({
      "FOLLOW UP DATE": now.add(const Duration(days: 3)),
      "FOLLOW UP TIME": time,
      "FOLLOW_UP_STATUS": "pending",
    });
  }

  void editData(Map<String, dynamic>user) {
    nameController.text = user["NAME"] ?? "";
    phoneController.text = user["PHONE"] ?? "";
    emailController.text = user["EMAIL"] ?? "";
    sourceController.text = user["SOURCE"] ?? "";
    leadStatusValue = user["LEAD_STATUS"] ?? "";
    callStatusValue = user["CALL_STATUS"] ?? "";
    leadCategoryValue = user["LEAD_CATEGORY"] ?? "";
    notesValue = user["NOTES"] ?? "";

    selectedAgentId = user["AGENT_ID"];
    selectedAgentName = user["AGENT_NAME"];


    editingId = user["ID"];
    isEdit = true;
    notifyListeners();
  }

  Future<void> updateUser({
    required String leadStatus,
    required String callStatus,
    required String leadCategory,
    required String notes,
    String? agentId,
    String? agentName,
  }) async {
    try {
      setLoading(true);

      if (editingId == null) return;


      await fbd.collection('LEADS').doc(editingId).update(
          {
            "NAME": nameController.text.trim(),
            "PHONE": phoneController.text.trim(),
            "EMAIL": emailController.text.trim(),
            "SOURCE": sourceController.text.trim(),

            // ✅ ADD THESE
            "LEAD_STATUS": leadStatus,
            "CALL_STATUS": callStatus,
            "LEAD_CATEGORY": leadCategory,
            "NOTES": notes,
            "ASSIGNED_AGENT_ID": agentId ?? this.agentId,
            "ASSIGNED_AGENT_NAME": agentName ?? this.agentName,
          });

      await fetchLeads();
      clearFields();
    } catch (e) {
      print("Update Error: $e");
    } finally {
      setLoading(false);
    }
  }

  void setAgentFilter(String agentId) {
    selectedAgentFilter = agentId;
    applyFilters();
  }

  Future<void> deleteUser(String id) async {
    try {
      await fbd.collection('LEADS').doc(id).delete();
      await fetchLeads();
    } catch (e) {
      print("Delete Error:$e");
    }
  }

  void setPageLoading(bool value) {
    isPageLoading = value;
    notifyListeners();
  }

  void setButtonLoading(bool value) {
    isButtonLoading = value;
    notifyListeners();
  }

//   Future<void> addFollowUp({
//     required String leadId,
//     required String callStatus,
//     required String leadStatus,
//     required String leadCategory,
//     required String priority,
//     required String remarks,
//     String? email,
//     DateTime? followUpDate,
//   }) async {
//     try {
//       setButtonLoading(true);
//
//       final ref = fbd
//           .collection('LEADS')
//           .doc(leadId)
//           .collection('FOLLOWUPS')
//           .doc();
//
//       await ref.set({
//         "FOLLOWUP_ID": ref.id,
//         "CALL_STATUS": callStatus,
//         "LEAD_STATUS": leadStatus,
//         "LEAD_CATEGORY": leadCategory,
//         "PRIORITY": priority,
//         "EMAIL": email ?? "",
//         "REMARKS": remarks,
//         "DATE": followUpDate ?? DateTime.now(),
//         "CREATED_AT": FieldValue.serverTimestamp(),
//       });
//
//       /// update main lead
//       await fbd.collection('LEADS').doc(leadId).update({
//         "LEAD_STATUS": leadStatus,
//         "FOLLOW_UP_STATUS": "pending",
//         "PRIORITY": priority,
//         "LAST_REMARK": remarks,
//         "LAST_CONTACTED": FieldValue.serverTimestamp(),
//       });
//
//     } catch (e) {
//       debugPrint("Follow-up error: $e");
//       rethrow;
//     } finally {
//       setButtonLoading(false);
//     }
//   }
//
//   void clearFields(){
//     nameController.clear();
//     phoneController.clear();
//     emailController.clear();
//     sourceController.clear();
//
//     leadStatusValue = "";
//     callStatusValue = "";
//     leadCategoryValue = "";
//     notesValue = "";
//
//     selectedAgentId = null;
//     selectedAgentName = null;
//
//     editingId = null;
//     isEdit = false;
//
//     notifyListeners();
//   }
//
//
// }
  Future<void> addFollowUp({
    required String leadId,
    required String callStatus,
    required String leadStatus,
    required String leadCategory,
    required String priority,
    required String remarks,
    required String email,
    DateTime? followUpDate,
    DateTime? lastContactedDate,
  }) async {
    try {
      isButtonLoading = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection("LEADS")
          .doc(leadId)
          .collection("FOLLOW_UPS")
          .add({
        "CALL_STATUS": callStatus,
        "LEAD_STATUS": leadStatus,
        "LEAD_CATEGORY": leadCategory,
        "PRIORITY": priority,
        "REMARKS": remarks,
        "EMAIL": email,
        "FOLLOW_UP_DATE": followUpDate,
        "LAST_CONTACTED_DATE":DateTime.now(),
        "CREATED_AT": FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection("LEADS")
          .doc(leadId)
          .update({
        "CALL_STATUS": callStatus,
        "LEAD_STATUS": leadStatus,
        "LEAD_CATEGORY": leadCategory,
        "PRIORITY": priority,
        "LAST_REMARK": remarks,
        "FOLLOW_UP_DATE": followUpDate,
        "LAST_CONTACTED_DATE":DateTime.now(),
        "LAST_CONTACTED_DATE":lastContactedDate ?? DateTime.now(),
      });

      remarkController.clear();
      emailController.clear();
      dateController.clear();
    }catch(e){
      debugPrint("FollowUp Error:$e");
    }finally{
      isButtonLoading = false;
      notifyListeners();
    }
  }

  void clearFields() {}
}
