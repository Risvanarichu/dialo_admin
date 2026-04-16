
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  int totalLeads = 0;
  int todaysCalls = 0;
  int upcoming = 0;
  int overdue = 0;

  // 🔥 Call distribution
  int incoming = 0;
  int outgoing = 0;
  int missed = 0;
  int voicemail = 0;

  bool isLoading = false;

  List<FlSpot> leadSpots = [];
  List<FlSpot> callSpots = [];

  Future<void> fetchDashboardCounts() async {
    isLoading = true;
    notifyListeners();

    try {
      final leadSnapshot = await db.collection("LEADS").get();

      totalLeads = leadSnapshot.docs.length;

      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      // reset counters
      todaysCalls = 0;
      upcoming = 0;
      overdue = 0;

      incoming = 0;
      outgoing = 0;
      missed = 0;
      voicemail = 0;

      for (var doc in leadSnapshot.docs) {
        final data = doc.data();

        /// 🔹 DATE LOGIC
        DateTime? followUpDate;

        final value = data["FOLLOW_UP_DATE"];

        if (value is Timestamp) {
          followUpDate = value.toDate();
        } else if (value is String && value.isNotEmpty) {
          followUpDate = DateTime.tryParse(value);
        }

        if (followUpDate != null) {
          final followDateOnly = DateTime(
            followUpDate.year,
            followUpDate.month,
            followUpDate.day,
          );

          if (followDateOnly == today) {
            todaysCalls++;
          } else if (followDateOnly.isAfter(today)) {
            upcoming++;
          } else {
            overdue++;
          }
        }

        /// 🔥 CALL TYPE LOGIC (IMPORTANT)
        /// Firestore field name adjust cheyyanam (example: CALL_TYPE)
        final callType = data["CALL_TYPE"];

        switch (callType) {
          case "incoming":
            incoming++;
            break;
          case "outgoing":
            outgoing++;
            break;
          case "missed":
            missed++;
            break;
          case "voicemail":
            voicemail++;
            break;
        }
      }

      /// 🔹 GRAPH DATA
      await fetchGraphData();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching dashboard: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchGraphData() async {
    try {
      final snapshot = await db.collection("LEADS").get();

      Map<int, int> monthlyLeads = {
        for (int i = 0; i < 12; i++) i: 0
      };

      Map<int, int> monthlyCalls = {
        for (int i = 0; i < 12; i++) i: 0
      };

      for (var doc in snapshot.docs) {
        final data = doc.data();

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