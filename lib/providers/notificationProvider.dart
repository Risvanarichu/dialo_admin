import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/models/notificationModel.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<NotificationModel> notifications = [];
  bool isLoading = false;
  int unreadCount = 0;

  String _currentUserId = "";
  String _userRole = "";

  /// REAL-TIME STREAM
  void listenToNotifications(String currentUserId, String userRole) {
    _currentUserId = currentUserId;
    _userRole = userRole;

    Query query = db.collection("NOTIFICATIONS");

    // If not admin, only show notifications for this agent
    if (userRole.toUpperCase() != "ADMIN") {
      query = query.where("AGENT_ID", isEqualTo: currentUserId);
    }

    query.orderBy("TIME", descending: true).snapshots().listen((snapshot) {
      notifications = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      unreadCount = notifications.where((e) => !e.isRead).length;
      notifyListeners();
    });
  }

  /// FETCH ONCE
  Future<void> fetchNotifications(String currentUserId, String userRole) async {
    _currentUserId = currentUserId;
    _userRole = userRole;

    try {
      isLoading = true;
      notifyListeners();

      Query query = db.collection("NOTIFICATIONS");

      if (userRole.toUpperCase() != "ADMIN") {
        query = query.where("AGENT_ID", isEqualTo: currentUserId);
      }

      final snapshot = await query.orderBy("TIME", descending: true).get();

      notifications = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      unreadCount = notifications.where((e) => !e.isRead).length;
    } catch (e) {
      debugPrint("Fetch notifications error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// MARK SINGLE AS READ
  Future<void> markAsRead(String id) async {
    try {
      await db.collection("NOTIFICATIONS").doc(id).update({
        "IS_READ": true,
      });
      if (_currentUserId.isNotEmpty) {
        await fetchNotifications(_currentUserId, _userRole);
      }
    } catch (e) {
      debugPrint("Mark as read error: $e");
    }
  }

  /// MARK ALL AS READ
  Future<void> markAllAsRead() async {
    try {
      final unread = notifications.where((e) => !e.isRead).toList();

      for (final n in unread) {
        await db.collection("NOTIFICATIONS").doc(n.id).update({
          "IS_READ": true,
        });
      }
      if (_currentUserId.isNotEmpty) {
        await fetchNotifications(_currentUserId, _userRole);
      }
    } catch (e) {
      debugPrint("Mark all as read error: $e");
    }
  }
}