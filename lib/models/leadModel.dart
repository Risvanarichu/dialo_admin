import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LeadModel {
  String id;
  String name;
  String phone;
  String email;
  String source;
  String status;
  DateTime followupDate;
  String followupTime;
  String time;
  String priority;
  String agent;
  String followupstatus;

  LeadModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.source,
    required this.status,
    required this.followupDate,
    required this.followupTime,
    required this.time,
    required this.priority,
    required this.agent,
    required this.followupstatus,
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
      name: map['NAME']?.toString().toUpperCase() ?? "",
      phone: map['PHONE']?.toString()??"",
      email: map['EMAIL']?.toString()??"",
      source: map['SOURCE']?.toString()??"",
      status: map['STATUS']?.toString().toUpperCase()??"",
      followupDate: followDate,
      followupTime: map['FOLLOW_UP_TIME']?.toString() ?? "",
      time: map['FOLLOW_UP_TIME']?.toString() ??
          DateFormat('hh:mm a').format(followDate),
      priority: map['PRIORITY']?.toString() ?? "Medium",
      agent: map['ADDED_BY_ID']?.toString().toUpperCase() ?? "No Agent",
      followupstatus: map['FOLLOW_UP_STATUS']?.toString().toUpperCase() ?? "pending",

    );
  }
}
extension LeadPriority on LeadModel {
  int get priorityRank {
    final now = DateTime.now();

    final diff = followupDate.difference(
      DateTime(now.year, now.month, now.day),
    ).inDays;

    if (diff <= 2) return 3;
    if (diff <= 7) return 2;
    return 1;
  }

  String get autoPriority {
    switch (priorityRank) {
      case 3:
        return "High";
      case 2:
        return "Medium";
      default:
        return "Low";
    }
  }
}
