import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String leadName;
  final String agentId;
  final DateTime time;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.leadName,
    required this.agentId,
    required this.time,
    required this.isRead,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String docId) {
    return NotificationModel(
      id: docId,
      title: map["TITLE"] ?? "",
      body: map["BODY"] ?? "",
      leadName: map["LEAD_NAME"] ?? "",
      agentId: map["AGENT_ID"] ?? "",
      time: (map["TIME"] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map["IS_READ"] ?? false,
    );
  }
}