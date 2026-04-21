import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/addUserModel.dart';

class DashboardProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  int totalLeads = 0;
  int todaysCalls = 0;
  int upcoming = 0;
  int overdue = 0;
  bool isLoading = false;

  List<FlSpot>leadSpots = [];
  List<FlSpot>callSpots = [];

//   Future<void> fetchLeads() async {
//     final snapshot = await db.collection('LEADS').get();
//
//     totalLeads = snapshot.docs.length;
//
//     // Example calculation
//     upcoming = 0;
//     overdue = 0;
//
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//
//       if (data['FOLLOW_UP_STATUS'] == 'pending') {
//         upcoming++;
//       }
//
//       if (data['FOLLOW_UP_STATUS'] == 'overdue') {
//         overdue++;
//       }
//     }
//
//     notifyListeners();
//   }
  Future<void> fetchDashboardCounts() async {
    isLoading = true;
    notifyListeners();
    try {
      final leadSnapshot = await db.collection("LEADS").get();
      totalLeads = leadSnapshot.docs.length;
      DateTime now = DateTime.now();

// Start of today (00:00)
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

// End of today (23:59)
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));
      final todaysSnapshot = await db
          .collection("LEADS")
          .where("FOLLOW_UP_DATE", isGreaterThanOrEqualTo: startOfDay)
          .where("FOLLOW_UP_DATE", isLessThan: endOfDay)
          .get();

      todaysCalls = todaysSnapshot.docs.length;
      upcoming = 0;
      overdue = 0;

      final today = DateTime(now.year, now.month, now.day);
      for (var doc in leadSnapshot.docs) {
        final data = doc.data();
        final value = data["ADDED_TIME"];
        if (value == null) continue;
        DateTime? followUpDate;
        if (value is Timestamp) {
          followUpDate = value.toDate();
        } else if (value is String && value.isNotEmpty) {
          followUpDate = DateTime.tryParse(value);
        }
        if (followUpDate == null) continue;

        final followDateOnly = DateTime(
          followUpDate.year,
          followUpDate.month,
          followUpDate.day,
        );
        if (followDateOnly == today) {
          todaysCalls++;
        } else if (followDateOnly.isAfter(today)) {
          upcoming++;
        } else if (followDateOnly.isBefore(today)) {
          overdue++;
        }
      }
      await fetchGraphData();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching total leads:$e");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchGraphData() async {
    try {
      final snapshot = await db.collection("LEADS").get();

      Map<int, int> monthlyLeads = {
        0: 0,
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0,
        6: 0,
        7: 0,
        8: 0,
        9: 0,
        10: 0,
        11: 0,
      };

      Map<int, int> monthlyCalls = {
        0: 0,
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0,
        6: 0,
        7: 0,
        8: 0,
        9: 0,
        10: 0,
        11: 0,
      };

      for (var doc in snapshot.docs) {
        final data = doc.data();
        debugPrint("Lead data: $data");

        DateTime? createdDate;
        DateTime? followUpDate;

        final createdValue = data["ADDED_TIME"];
        final followValue = data["FOLLOW_UP_DATE"];

        if (createdValue is Timestamp) {
          createdDate = createdValue.toDate();
        } else if (createdValue is String && createdValue.isNotEmpty) {
          createdDate = DateTime.tryParse(createdValue);
        }

        if (followValue is Timestamp) {
          followUpDate = followValue.toDate();
        } else if (followValue is String && followValue.isNotEmpty) {
          followUpDate = DateTime.tryParse(followValue);
        }

        if (createdDate != null) {
          monthlyLeads[createdDate.month - 1] =
              (monthlyLeads[createdDate.month - 1] ?? 0) + 1;
        }

        if (followUpDate != null) {
          monthlyCalls[followUpDate.month - 1] =
              (monthlyCalls[followUpDate.month - 1] ?? 0) + 1;
        }
      }

      leadSpots = monthlyLeads.entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
          .toList();

      callSpots = monthlyCalls.entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching graph data: $e");
    }
  }
}
// Stream<List<Agent_Add_Model>> getAgents() {
//   return fbd.collection("AGENT").snapshots().map((snapshot) {
//     return snapshot.docs.map((doc) {
//       return Agent_Add_Model.fromMap(doc.id, doc.data());
//     }).toList();
//   });
// }