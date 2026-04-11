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
  String assignedAgentId;
  String followupstatus;
  String calltype;
  DateTime lastContactedDate;

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
    required this.assignedAgentId,
    required this.followupstatus,
    required this.calltype,
      required this.lastContactedDate,
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

    var added_date = map['ADDED_TIME'];

    if (added_date is Timestamp) {
      added_date = added_date.toDate();
    } else if (added_date is String) {
      added_date = DateTime.tryParse(added_date) ?? DateTime.now();
    } else if (added_date is DateTime) {
      added_date = added_date;
    } else {
      added_date = DateTime.now();
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
      time: DateFormat('hh:mm a').format(added_date),
      priority: map['PRIORITY']?.toString() ?? "Medium",
      assignedAgentId: map['ASSIGNED_AGENT_ID'] ?? map['ADDED_BY_ID'],
      followupstatus: map['FOLLOW_UP_STATUS']?.toString().toUpperCase() ?? "pending",
     calltype: map['INCOMING']?.toString().toUpperCase() ?? "OUTGOING",
      lastContactedDate: map['LAST_CONTACTED_DATE'] is Timestamp
          ? (map['LAST_CONTACTED_DATE'] as Timestamp).toDate()
          : added_date,

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
class LeadCategoryModel {
  final String title;
  final List<String> sub;

  LeadCategoryModel({
    required this.title,
    required this.sub,
  });

  factory LeadCategoryModel.fromMap(Map<String, dynamic> map) {
    return LeadCategoryModel(
      title: map['title']?.toString() ?? '',
      sub: List<String>.from(map['sub'] ?? []),
    );
  }
}
