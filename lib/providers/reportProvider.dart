import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ReportProvider extends ChangeNotifier {
  FirebaseFirestore fbd = FirebaseFirestore.instance;

  List<Map<String, dynamic>> agentPerformance = [];
  Map<String, int> funnelData = {};

  DateTime? fromDate;
  DateTime? toDate;

  Map<String, String> agentMap = {};

  Future<void> loadAgents() async {
    final snapshot = await fbd.collection('AGENT').get();

    agentMap = {
      for (var doc in snapshot.docs)
        doc.id: doc.data()['NAME'] ?? "Unknown"
    };
  }

  Future<void> fetchReports() async {
    await loadAgents(); // ✅ MUST

    await Future.wait([
      fetchAgentPerformance(),
      fetchFunnel(),
      fetchLeadsReport(),
    ]);

    notifyListeners();
  }

  // Future<void> fetchAgentPerformance() async {
  //   try {
  //     Query query = fbd.collection("LEADS");
  //
  //     // ✅ Date filter (IMPORTANT FIX)
  //     if (fromDate != null && toDate != null) {
  //       query = query
  //           .where(
  //         "ADDED_TIME",
  //         isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate!),
  //       )
  //           .where(
  //         "ADDED_TIME",
  //         isLessThanOrEqualTo: Timestamp.fromDate(toDate!),
  //       );
  //     }
  //
  //     final snapshot = await query.get();
  //
  //     print("TOTAL DOCS (Agent): ${snapshot.docs.length}");
  //
  //     Map<String, Map<String, int>> data = {};
  //
  //     for (var doc in snapshot.docs) {
  //       final lead = doc.data() as Map<String, dynamic>;
  //
  //       String agent =
  //       (lead['AGENT_NAME'] ?? lead['ADDED_BY_ID'] ?? "Unassigned")
  //           .toString();
  //
  //       String status = (lead['STATUS'] ?? "").toString().toLowerCase();
  //       String followUpStatus =
  //       (lead['FOLLOW_UP_STATUS'] ?? "").toString().toLowerCase();
  //
  //       data.putIfAbsent(agent, () => {
  //         "total": 0,
  //         "converted": 0,
  //         "answered": 0, // ✅ ADD THIS
  //       });
  //
  //       /// total
  //       data[agent]!["total"] = data[agent]!["total"]! + 1;
  //
  //       /// answered (your logic)
  //       if (status.contains("contact")) {
  //         data[agent]!["answered"] =
  //             data[agent]!["answered"]! + 1;
  //       }
  //
  //       /// converted
  //       if (status.contains("convert")) {
  //         data[agent]!["converted"] =
  //             data[agent]!["converted"]! + 1;
  //       }
  //     }
  //
  //     /// Convert to list
  //     agentPerformance = data.entries.map((e) {
  //       return {
  //         "agent": e.key,
  //         "total": e.value["total"],
  //         "answered":e.value["answered"],
  //         "converted": e.value["converted"],
  //       };
  //     }).toList();
  //
  //     print("Agent Performance: $agentPerformance");
  //
  //     notifyListeners();
  //   } catch (e) {
  //     print("ERROR fetchAgentPerformance: $e");
  //   }
  // }


  Future<void> fetchAgentPerformance() async {
    try {
      Query query = fbd.collection("LEADS");

      /// ✅ DATE FILTER
      if (fromDate != null && toDate != null) {
        query = query
            .where(
          "ADDED_TIME",
          isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate!),
        )
            .where(
          "ADDED_TIME",
          isLessThanOrEqualTo: Timestamp.fromDate(toDate!),
        );
      }

      final snapshot = await query.get();

      Map<String, Map<String, int>> data = {};

      for (var doc in snapshot.docs) {
        final lead = doc.data() as Map<String, dynamic>;

        /// ✅ GET AGENT ID (FIX FIELD NAME HERE)
        String agentId = (lead['ASSIGNED_AGENT_ID'] ?? lead['ADDED_BY_ID'] ?? lead['ADDED BY ID'] ?? "").toString();

        /// ✅ CONVERT TO NAME
        String agentName = agentMap[agentId] ?? lead['ASSIGNED_AGENT_NAME']?.toString() ?? "Unknown";

        String status = (lead['STATUS'] ?? "").toString().toLowerCase();

        data.putIfAbsent(agentName, () => {
          "total": 0,
          "converted": 0,
          "answered": 0,
        });

        data[agentName]!["total"] =
            data[agentName]!["total"]! + 1;

        if (status.contains("contact")) {
          data[agentName]!["answered"] =
              data[agentName]!["answered"]! + 1;
        }

        if (status.contains("convert")) {
          data[agentName]!["converted"] =
              data[agentName]!["converted"]! + 1;
        }
      }

      agentPerformance = data.entries.map((e) {
        return {
          "agent": e.key,
          "total": e.value["total"],
          "answered": e.value["answered"],
          "converted": e.value["converted"],
        };
      }).toList();

      notifyListeners();
    } catch (e) {
      print("ERROR fetchAgentPerformance: $e");
    }
  }


  Future<void> fetchFunnel() async {
    try {
      Query query = fbd.collection("LEADS");

      // ✅ Date filter
      if (fromDate != null && toDate != null) {
        query = query
            .where(
          "ADDED_TIME",
          isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate!),
        )
            .where(
          "ADDED_TIME",
          isLessThanOrEqualTo: Timestamp.fromDate(toDate!),
        );
      }

      final snapshot = await query.get();

      print("TOTAL DOCS (Funnel): ${snapshot.docs.length}");

      Map<String, int> counts = {
        "total": 0,
        "pending": 0,
        "contacted": 0, // ✅ ADD THIS
        "converted": 0,
      };

      for (var doc in snapshot.docs) {
        final lead = doc.data() as Map<String, dynamic>;

        String status = (lead['STATUS'] ?? "").toString().toLowerCase();

        counts["total"] = counts["total"]! + 1;

        if (status.contains("pending")) {
          counts["pending"] = counts["pending"]! + 1;
        }
        if (status.contains("contact")) {
          counts["contacted"] = counts["contacted"]! + 1;
        }

        if (status.contains("convert")) {
          counts["converted"] = counts["converted"]! + 1;
        }
      }

      funnelData = counts;

      print("Funnel Data: $funnelData");

      notifyListeners();
    } catch (e) {
      print("ERROR fetchFunnel: $e");
    }
  }

  List<Map<String, dynamic>> leadsReport = [];

  List<String> availableAgents = ["All Agents"];

  String selectedAgent = "All Agents";
  String selectedStatus = "All Status";
  String selectedSource = "All Sources";
  String searchQuery = "";


  Future<void> fetchLeadsReport() async {
    try {
      Query query = fbd.collection("LEADS");

      if (fromDate != null && toDate != null) {
        query = query
            .where(
          "ADDED_TIME",
          isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate!),
        )
            .where(
          "ADDED_TIME",
          isLessThanOrEqualTo: Timestamp.fromDate(toDate!),
        );
      }

      final snapshot = await query.get();

      List<Map<String, dynamic>> temp = [];
      Set<String> dynamicAgents = {"All Agents"};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        /// ✅ ADD THIS (IMPORTANT)
        String agentId = (data['ASSIGNED_AGENT_ID'] ?? data['ADDED_BY_ID'] ?? data['ADDED BY ID'] ?? "").toString();
        String agentName = agentMap[agentId] ?? data['ASSIGNED_AGENT_NAME']?.toString() ?? "Unknown";

        dynamicAgents.add(agentName);

        String name = (data['NAME'] ?? "").toString();
        String phone = (data['PHONE'] ?? "").toString();
        String source = (data['SOURCE'] ?? "").toString();
        String status = (data['STATUS'] ?? "").toString();

        /// FILTERS
        if (selectedAgent != "All Agents" && agentName != selectedAgent) continue;

        if (selectedStatus != "All Status" &&
            status.toLowerCase() != selectedStatus.toLowerCase()) continue;

        if (selectedSource != "All Sources" && source != selectedSource) continue;

        if (searchQuery.isNotEmpty &&
            !name.toLowerCase().contains(searchQuery.toLowerCase()) &&
            !phone.contains(searchQuery)) continue;

        temp.add({
          "id": doc.id,
          "name": name,
          "phone": phone,
          "source": source,
          "agent": agentName, // ✅ NOW WORKS
          "status": status,
        });
      }
      
      availableAgents = dynamicAgents.toList();
      if (!availableAgents.contains(selectedAgent)) {
        selectedAgent = "All Agents";
      }

      leadsReport = temp;

      notifyListeners();
    } catch (e) {
      print("ERROR fetchLeadsReport: $e");
    }
  }





  /// FILTER METHODS
  void updateAgent(String val) {
    selectedAgent = val;
    fetchLeadsReport();
  }

  void updateStatusFilter(String val) {
    selectedStatus = val;
    fetchLeadsReport();
  }

  void updateSource(String val) {
    selectedSource = val;
    fetchLeadsReport();
  }

  void searchLeads(String val) {
    searchQuery = val;
    fetchLeadsReport();
  }
}

