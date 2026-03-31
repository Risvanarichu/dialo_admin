import 'package:cloud_firestore/cloud_firestore.dart';

class LeadModel{
  String id;
  String name;
  DateTime addedTime;
  String time;
  String priority;
  String agent;
  String status;

  LeadModel({
    required this.id,
    required this.name,
    required this.addedTime,
    required this.time,
    required this.priority,
    required this.agent,
    required this.status,
});
  factory LeadModel.fromMap(String id,Map<String,dynamic>map){
    return LeadModel(
      id:id,
      name: map['NAME']??'',
        addedTime: (map['ADDED_TIME'] as Timestamp?)?.toDate() ?? DateTime.now(),
      time: map['ADDED_TIME']?? '',
      priority: map['PRIORITY']?? 'Medium',
      agent: map['ASSIGNED_AGENT']??'',
      status: map['FOLLOW_UP_STATUS']??'pending'
    );
  }
}