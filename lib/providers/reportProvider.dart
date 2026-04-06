import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ReportProvider extends ChangeNotifier {
  FirebaseFirestore fbd = FirebaseFirestore.instance;

  List<Map<String, dynamic>> agentPerformance = [];
  Map<String, int> funnelData = {};

  DateTime? fromDate;
  DateTime? toDate;

  Future<void> fetchReports() async {
    await fetchAgentPerformance();
    await fetchFunnel();
  }


  Future<void> fetchAgentPerformance() async {
    Query query = fbd.collection("LEADS");


    if (fromDate != null && toDate != null) {
      query = query
          .where("ADDED_TIME", isGreaterThanOrEqualTo: fromDate)
          .where("ADDED_TIME", isLessThanOrEqualTo: toDate);
    }

    final snapshot = await query.get();

    Map<String, Map<String, int>> data = {};

    for (var doc in snapshot.docs) {
      final lead = doc.data() as Map<String, dynamic>;

      String agent = (lead['ASSIGNED_AGENT'] == null ||
          lead['ASSIGNED_AGENT'] == "")
          ? "Unassigned"
          : lead['ASSIGNED_AGENT'];

      String status = (lead['STATUS'] ?? "").toString();

      data.putIfAbsent(agent, () => {
        "total": 0,
        "converted": 0,
      });


      data[agent]!["total"] = data[agent]!["total"]! + 1;


      if (status.toUpperCase() == "CONVERTED") {
        data[agent]!["converted"] =
            data[agent]!["converted"]! + 1;
      }
    }

    agentPerformance = data.entries.map((e) {
      return {
        "agent": e.key,
        "total": e.value["total"],
        "converted": e.value["converted"],
      };
    }).toList();

    notifyListeners();
  }

  Future<void> fetchFunnel() async {
    Query query = fbd.collection("LEADS");
    if (fromDate != null && toDate != null) {
      query = query
          .where("ADDED_TIME", isGreaterThanOrEqualTo: fromDate)
          .where("ADDED_TIME", isLessThanOrEqualTo: toDate);
    }

    final snapshot = await query.get();

    Map<String, int> counts = {
      "total": 0,
      "pending": 0,
      "converted": 0,
    };

    for (var doc in snapshot.docs) {
      final lead = doc.data() as Map<String, dynamic>;

      String status = (lead['STATUS'] ?? "").toString().toLowerCase();

      counts["total"] = counts["total"]! + 1;

      if (status == "pending") {
        counts["pending"] = counts["pending"]! + 1;
      }

      if (status == "converted") {
        counts["converted"] = counts["converted"]! + 1;
      }
    }

    funnelData = counts;

    notifyListeners();
  }
}