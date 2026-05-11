import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/models/leadModel.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LeadProvider extends ChangeNotifier {
  final FirebaseFirestore fbd = FirebaseFirestore.instance;

  String currentPage = "leads";

  List<LeadModel> leads = [];
  List<LeadModel> allLeads = [];

  List<LeadModel> get leadsList => allLeads;

  List<LeadCategoryModel> categoryList = [];
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic> additionalDetails = {};

  Map<String, String> agentMap = {};

  List<String> callStatusList = [];
  String selectedAgentFilter = "all";
  List<String> leadCategoryList = [];


  String selectedCallStatus = "all";
  String selectedStatus = "All Status";
  String selectedSources = "All Sources";
  String searchQuery = "";

  String? agentId;
  String? agentName;
  String? editingId;
  bool isEdit = false;
  bool isButtonLoading=false;
  bool isPageLoading = false;
  bool isLoading = false;
  bool isCategoryLoading = false;

  StreamSubscription? leadSubscription;

  final TextEditingController searchController = TextEditingController();
  String leadStatusValue = "";
  String callTypeValue = "";
  String notesValue = "";
  DateTime? startDate;
  DateTime? endDate;

  String? selectedAgentId;
  String? selectedAgentName;


  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final sourceController = TextEditingController();

  LeadProvider() {
    init();
  }

  void setLoading(bool value){
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
    await fetchLeadSettings();
    await fetchleadCallStatuses();
    listenLeads();
  }

  Future<void> loadAgentData() async {
    final prefs = await SharedPreferences.getInstance();

    agentId = prefs.getString('agentId') ?? "";
    agentName = prefs.getString('name') ?? "Unknown";

    debugPrint("Agent ID: $agentId");
    debugPrint("Agent Name: $agentName");
  }

  Future<void> loadAgents() async {
    try {
      final snapshot = await fbd.collection('AGENT').get();

      agentMap = {
        for (var doc in snapshot.docs)
          doc.id: doc.data()["NAME"] ?? "Unknown",
      };

      notifyListeners();
    } catch (e) {
      debugPrint("loadAgents error: $e");
    }
  }

  void changePage(String page) {
    currentPage = page;
    notifyListeners();
  }

  Future<void> addLead({
    required String name,
    required String phone,
    required String email,
    required String source,
    required String leadStatus,
    required String callType,
    required String notes,
    String? assignedAgentId,
    String? assignedAgentName,
  }) async {
    try {
      final DateTime now = DateTime.now();
      final String id = now.millisecondsSinceEpoch.toString();

      final docRef = fbd.collection("LEADS").doc(id);

      await docRef.set({
        "LEAD_ID": docRef.id,
        "NAME": name.trim(),
        "PHONE": phone.trim(),
        "EMAIL": email.trim(),
        "SOURCE": selectedSources,
        "STATUS": selectedStatus,
        "CALL_TYPE": callType.trim(),
        "FOLLOW_UP_STATUS": "pending",
        "NOTES": notes.trim(),
        "ADDITIONAL_DETAILS": additionalDetails,
        "ADDED_TIME": FieldValue.serverTimestamp(),
        "ADDED_BY_ID": agentId,
        "ASSIGNED_AGENT_ID": assignedAgentId ?? agentId,
        "ASSIGNED_AGENT_NAME": assignedAgentName ?? agentName,
        "FOLLOW_UP_DATE": Timestamp.fromDate(now.add(const Duration(days: 3))),
        "FOLLOW_UP_TIME": "",
        "PLACE": "",
        "PRIORITY": "Medium",
      });

      clearAdditionalDetails();
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

        final String assignedId =
            data["ASSIGNED_AGENT_ID"]?.toString() ?? "";

        if (assignedId.isEmpty) {
          doc.reference.update({
            "ASSIGNED_AGENT_ID": agentId?? this.agentId,
            "ASSIGNED_AGENT_NAME": agentName ?? this.agentName,
            "ADDED_BY_ID": agentId,
          });
        }

        return LeadModel.fromMap(
          doc.id,
          {
            ...data,
            "ASSIGNED_AGENT_NAME": agentMap.containsKey(assignedId)
                ? agentMap[assignedId]
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
      final snapshot = await fbd.collection('LEADS').get();

      leads = snapshot.docs.map((doc) {
        final data = doc.data();

        if (data["ASSIGNED_AGENT_ID"] == null ||
            data["ASSIGNED_AGENT_ID"].toString().isEmpty) {
          doc.reference.update({
            "ASSIGNED_AGENT_ID": agentId ?? this.agentId,
            "ASSIGNED_AGENT_NAME": agentName ?? this.agentName,
            "ADDED_BY_ID": agentId,
          });
        }

        return LeadModel.fromMap(doc.id, data);
      }).toList();

      applyFilters();
    } catch (e) {
      debugPrint("Error fetching leads: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void searchLeads(String query) {
    searchQuery = query;
    applyFilters();
  }

  void updateSource(String source) {
    selectedSources = source;
    applyFilters();
  }

  void updateStatus(String status) {
    selectedStatus = status;
    applyFilters();
  }

  void setleadCallStatus(String status) {
    selectedCallStatus = status;
    applyFilters();
  }

  void applyFilters() {
    final query = searchQuery.toLowerCase();

    allLeads = leads.where((lead) {
      final name = lead.name.toLowerCase();
      final phone = lead.phone.toLowerCase();
      final email = lead.email.toLowerCase();
      final status = lead.status.toUpperCase();
      final source = lead.source.toLowerCase();

      final matchesSearch = query.isEmpty ||
          name.contains(query) ||
          phone.contains(query) ||
          email.contains(query);

      final matchesStatus = selectedStatus == "All Status" ||
          status == selectedStatus.toUpperCase();

      final matchesSource = selectedSources == "All Sources" ||
          source == selectedSources.toLowerCase();

      final callStatus = lead.followupstatus.toLowerCase() == "pending"
          ? "missed"
          : "answered";

      final matchesCallStatus =
          selectedCallStatus == "all" || callStatus == selectedCallStatus;

      final matchesAgent =
          selectedAgentFilter == "all" ||
              lead.assignedAgentId == selectedAgentFilter;

      final matchesDate =
          startDate == null ||
              endDate == null ||
              (lead.lastContactedDate.isAfter(startDate!) &&
                  lead.lastContactedDate.isBefore(endDate!));

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

  Future<void> fetchleadCallStatuses() async {
    try {
      final snapshot = await fbd
          .collection("LEAD_SETTINGS")
          .doc("lead_category")
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final rawList = data["statuses"] ?? [];

        leadCategoryList =
        List<String>.from(rawList.map((e) => e.toString()));
      } else {
        leadCategoryList = [];
      }
    } catch (e) {
      leadCategoryList = [];
      debugPrint("fetchleadcategory error: $e");
    } finally {
      notifyListeners();
    }
  }

  void addLeadStatus(String value) {
    value = value.trim();

    if (value.isEmpty) return;

    if (!leadCategoryList.contains(value)) {
      leadCategoryList.add(value);
      notifyListeners();
    }
  }

  void removeLeadStatus(int index) {
    leadCategoryList.removeAt(index);
    notifyListeners();
  }

  Future<void> saveLeadsStatus() async {
    try {
      await fbd.collection("LEAD_SETTINGS").doc("lead_category").set({
        "statuses": leadCategoryList,
      });
    } catch (e) {
      debugPrint("Error saving lead status: $e");
    }
  }

  Future<void> fetchLeadCategories() async {
    try {
      final snapshot =
      await fbd.collection("LEAD_SETTINGS").doc("categories").get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final rawList = data["categoryList"] ?? data["categories"] ?? [];

        categoryList = List<LeadCategoryModel>.from(
          rawList.map(
                (e) => LeadCategoryModel.fromMap(
              Map<String, dynamic>.from(e),
            ),
          ),
        );
      } else {
        categoryList = [];
      }
    } catch (e) {
      categoryList = [];
      debugPrint("fetchLeadCategories error: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchLeadSettings() async {
    try {
      isCategoryLoading = true;
      notifyListeners();

      final doc =
      await fbd.collection("LEAD_SETTINGS").doc("categories").get();

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

  Future<void> assignAgent(
      String leadId,
      String agentId,
      String agentName,
      ) async {
    try {
      await fbd.collection('LEADS').doc(leadId).update({
        "ASSIGNED_AGENT_ID": agentId,
        "ASSIGNED_AGENT_NAME": agentName,
      });
    } catch (e) {
      debugPrint("Assign Error: $e");
    }
  }

  Future<void> completedLead(String leadId) async {
    await fbd.collection('LEADS').doc(leadId).update({
      "FOLLOW_UP_STATUS": "COMPLETED",
    });
  }

  Future<void> rescheduleLead(
      String leadId,
      DateTime date,
      String time,
      ) async {
    await fbd.collection('LEADS').doc(leadId).update({
      "FOLLOW UP DATE": Timestamp.fromDate(date),
      "FOLLOW UP TIME": time,
      "FOLLOW_UP_STATUS": "pending",
    });
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
        "ADDED_BY_ID": lead.data()["ADDED_BY_ID"] ?? defaultAgentId,
      });
    }

  void editData(Map<String,dynamic>user){
    nameController.text = user["NAME"]??"";
    phoneController.text = user["PHONE"]??"";
    emailController.text = user["EMAIL"]??"";
    sourceController.text = user["SOURCE"]??"";
    leadStatusValue = user["STATUS"] ?? "";
    callTypeValue = user["CALLTYPE"] ?? "";
    notesValue = user["NOTES"] ?? "";

    selectedAgentId = user["AGENT_ID"];
    selectedAgentName = user["AGENT_NAME"];


    editingId = user["ID"];
    isEdit = true;
    notifyListeners();
  }

  Future<void> updateUser({
    required String leadStatus,
    required String callType,
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
            "STATUS": leadStatus,
            "CALLTYPE": callType,
            "NOTES": notes,
            "ASSIGNED_AGENT_ID": agentId ?? this.agentId,
            "ASSIGNED_AGENT_NAME": agentName ?? this.agentName,
          });

      await fetchLeads();
      //clearFields();

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

  Future<void> deleteUser(String id) async{
    try{
      await fbd.collection('LEADS').doc(id).delete();
      await fetchLeads();
    }catch(e){
      print("Delete Error:$e");
    }
  }

  void setPageLoading(bool value){
    isPageLoading = value;
    notifyListeners();
  }

  void setButtonLoading(bool value){
    isButtonLoading = value;
    notifyListeners();
  }

  void clearFields(){
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    sourceController.clear();

    leadStatusValue = "";
    callTypeValue = "";
    notesValue = "";

    selectedAgentId = null;
    selectedAgentName = null;

    editingId = null;
    isEdit = false;

    notifyListeners();
  }


}

   // debugPrint("Fixed old leads ✅");
  }

//   @override
//   void dispose() {
//     leadSubscription?.cancel();
//     searchController.dispose();
//     super.dispose();
//   }
// }