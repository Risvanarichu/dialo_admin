import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  String? id;
  String email;
  DateTime? createdAt;

  Usermodel({
    this.id,
    required this.email,
    this.createdAt
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : Timestamp.now(),
    };
  }

  factory Usermodel.fromMap(Map<String, dynamic> map, String docId){
    return Usermodel(
      id: docId,
      email: map['email'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}