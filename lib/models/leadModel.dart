import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LeadModel {
  String id;
  String name;
  DateTime followupDate;
  String followupTime;
  String time;
  String priority;
  String agent;
  String status;

  LeadModel({
    required this.id,
    required this.name,
    required this.followupDate,
    required this.followupTime,
    required this.time,
    required this.priority,
    required this.agent,
    required this.status,
  });

  factory LeadModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime followDate;

    var value = map['FOLLOW_UP_DATE'];

    if (value is Timestamp) {
      followDate = value.toDate();
    } else if (value is String) {
      followDate = DateTime.tryParse(value) ?? DateTime.now();
    } else if (value is DateTime) {
      followDate = value;
    } else {
      followDate = DateTime.now();
    }

    return LeadModel(
      id: id,
      name: map['NAME']?.toString() ?? "No Name",
      followupDate: followDate,
      followupTime: map['FOLLOW_UP_TIME']?.toString() ?? "",
      time: map['FOLLOW_UP_TIME']?.toString() ??
          DateFormat('hh:mm a').format(followDate),
      priority: map['PRIORITY']?.toString() ?? "Medium",
      agent: map['ASSIGNED_AGENT']?.toString() ?? "No Agent",
      status: map['FOLLOW_UP_STATUS']?.toString() ?? "pending",

    );
  }
}
