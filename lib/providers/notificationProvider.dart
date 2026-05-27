import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/models/notificationModel.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {

  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<NotificationModel> notifications = [];
  bool isLoading = false;
  int unreadCount = 0;

  /// REAL-TIME STREAM — call this once in main or SideMenu
  void listenToNotifications() {
    db
        .collection("NOTIFICATIONS")
        .orderBy("TIME", descending: true)
        .snapshots()
        .listen((snapshot) {
      notifications = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data(), doc.id);
      }).toList();

      unreadCount = notifications.where((e) => !e.isRead).length;
      notifyListeners();
    });
  }

  /// FETCH ONCE
  Future<void> fetchNotifications() async {
    try {
      isLoading = true;
      notifyListeners();

      final snapshot = await db
          .collection("NOTIFICATIONS")
          .orderBy("TIME", descending: true)
          .get();

      notifications = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data(), doc.id);
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
      await fetchNotifications();
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
      await fetchNotifications();
    } catch (e) {
      debugPrint("Mark all as read error: $e");
    }
  }
}