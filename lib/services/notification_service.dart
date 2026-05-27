import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationService {

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  /// SAVE NOTIFICATION TO FIRESTORE
  static Future<void> triggerNotification({
    required String title,
    required String body,
    required String leadName,
    required String agentId,
  }) async {
    try {
      await db.collection("NOTIFICATIONS").add({
        "TITLE": title,
        "BODY": body,
        "LEAD_NAME": leadName,
        "AGENT_ID": agentId,
        "IS_READ": false,
        "TIME": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Failed to save notification: $e");
    }
  }
}