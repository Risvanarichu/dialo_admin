import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/models/addUserModel.dart';
import 'package:dialo_admin/models/leadModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<AgentPerformanceModel> agentPerformance = [];
  List<RecentCallModel> recentCalls = [];

  int totalLeads = 0;
  int todaysCalls = 0;
  int upcoming = 0;
  int overdue = 0;

  int answered = 0;
  int missed = 0;
  int voicemail = 0;
  int other = 0;

bool isLoading = false;
  List<FlSpot> leadSpots = [];
  List<FlSpot> callSpots = [];

  // var agentLoading;
  Future<Map<String, String>> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();

    String role =
    (prefs.getString("role") ?? "").trim().toUpperCase();

    String agentId =
    (prefs.getString("agentId") ?? "").trim();

    debugPrint("ROLE => $role");
    debugPrint("AGENT ID => $agentId");

    return {
      "role": role,
      "agentId": agentId,
    };
  }

  Future<void> fetchDashboardCounts() async {
    // isLoading = true;
    // notifyListeners();

    totalLeads = 0;
    todaysCalls = 0;
    upcoming = 0;
    overdue = 0;

    answered = 0;
    missed = 0;
    voicemail = 0;
    other = 0;

    leadSpots = [];
    callSpots = [];
    recentCalls = [];
    agentPerformance = [];

    try {
      final loginData = await getLoginData();

      String role = loginData["role"] ?? "";
      String agentId = loginData["agentId"] ?? "";
      Query query = db.collection("LEADS");

      if (role.toUpperCase() == "AGENT") {
        query = query.where(
          "ASSIGNED_AGENT_ID",
          isEqualTo: agentId,
        );
      }

      final leadSnapshot = await query.get();

      totalLeads = leadSnapshot.docs.length;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      todaysCalls = 0;
      upcoming = 0;
      overdue = 0;

      answered = 0;
      missed = 0;
      voicemail = 0;
      other = 0;

      for (var doc in leadSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        DateTime? followUpDate;
        final followValue = data["FOLLOW_UP_DATE"];

        if (followValue is Timestamp) {
          followUpDate = followValue.toDate();
        } else if (followValue is String && followValue.isNotEmpty) {
          followUpDate = DateTime.tryParse(followValue);
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

        final String callStatus = (data["FOLLOW_UP_STATUS"] ?? data["STATUS"] ?? "")
            .toString()
            .trim()
            .toLowerCase();

        if (callStatus == "answered" || callStatus == "completed") {
          answered++;
        } else if (callStatus == "missed") {
          missed++;
        } else if (callStatus == "voicemail") {
          voicemail++;
        } else if (callStatus.isNotEmpty) {
          other++;
        }
      }

      await fetchGraphData();
    } catch (e) {
      debugPrint("Error fetching dashboard: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchGraphData() async {
    try {
      final loginData = await getLoginData();

      String role = loginData["role"] ?? "";
      String agentId = loginData["agentId"] ?? "";

      Query query = db.collection("LEADS");

      if (role.toUpperCase() == "AGENT") {
        query = query.where(
          "ASSIGNED_AGENT_ID",
          isEqualTo: agentId,
        );
      }

      final snapshot = await query.get();

      Map<int, int> monthlyLeads = {
        for (int i = 0; i < 12; i++) i: 0,
      };

      Map<int, int> monthlyCalls = {
        for (int i = 0; i < 12; i++) i: 0,
      };

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

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

  Future<void> fetchDashBoardAgentPerformance() async {
    try {
      final loginData = await getLoginData();

      String role = loginData["role"] ?? "";
      // String agentId = loginData["agentId"] ?? "";

      /// ✅ AGENT LOGIN -> DON'T LOAD AGENT BOX
      if (role.toUpperCase() == "AGENT") {
        agentPerformance = [];
        notifyListeners();
        return;
      }

      isLoading = true;
      notifyListeners();

      final snapshot = await db.collection("AGENT").get();

      agentPerformance = snapshot.docs.map((doc) {
        final data = doc.data();

        return AgentPerformanceModel(
          name: data["NAME"] ?? "",
          totalCalls: 0,
          online: data["STATUS"] ?? false,
        );
      }).toList();

    } catch (e) {
      debugPrint("Error fetching agent performance: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchRecentCalls() async {
    try {
      isLoading = true;
      notifyListeners();

      final loginData = await getLoginData();

      String role = loginData["role"] ?? "";
      String agentId = loginData["agentId"] ?? "";

      Query<Map<String, dynamic>> query =
      db.collection("LEADS");

      /// ✅ If agent login -> only fetch assigned leads
      if (role.toUpperCase() == "AGENT") {
        query = query.where(
          "ASSIGNED_AGENT_ID",
          isEqualTo: agentId,
        );
      }

      final snapshot = await query
          .orderBy("ADDED_TIME", descending: true)
          .limit(5)
          .get();

      recentCalls = snapshot.docs.map((doc) {
        final data = doc.data();

        final String name =
        (data["NAME"] ?? "Unknown").toString();

        final String status =
        (data["FOLLOW_UP_STATUS"] ?? "Pending").toString();

        DateTime? createdTime;

        final timeValue = data["ADDED_TIME"];

        if (timeValue is Timestamp) {
          createdTime = timeValue.toDate();
        } else if (timeValue is String &&
            timeValue.isNotEmpty) {
          createdTime = DateTime.tryParse(timeValue);
        }

        String timeAgo = "Just now";

        if (createdTime != null) {
          final diff = DateTime.now().difference(createdTime);

          if (diff.inSeconds < 60) {
            timeAgo = "${diff.inSeconds} sec ago";
          } else if (diff.inMinutes < 60) {
            timeAgo = "${diff.inMinutes} min ago";
          } else if (diff.inHours < 24) {
            timeAgo = "${diff.inHours} hr ago";
          } else {
            timeAgo = "${diff.inDays} days ago";
          }
        }

        Color callColor = Colors.orange;

        switch (status.toLowerCase()) {
          case "completed":
          case "answered":
            callColor = Colors.green;
            break;

          case "missed":
            callColor = Colors.red;
            break;

          case "pending":
            callColor = Colors.orange;
            break;

          default:
            callColor = Colors.blue;
        }

        return RecentCallModel(
          name: name,
          type: status,
          timeAgo: timeAgo,
          callColor: callColor,
        );
      }).toList();

    } catch (e) {
      debugPrint("Error fetching recent calls: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}