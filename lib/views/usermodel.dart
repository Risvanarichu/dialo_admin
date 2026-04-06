import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  String? id;
  String email;
  String name;
  String employeeid;
  String image;
  String role;
  String? password;

  DateTime? createdAt;

  Usermodel({
    this.id,
    required this.email,
    required this.name,
    required this.employeeid,
    required this.image,
    required this.role,
    this.password,
    this.createdAt
  });

  Map<String, dynamic> toMap() {
    return {
      'EMAIL': email,
      'NAME' : name,
      'EMPLOYEEID' : employeeid,
      'IMAGE' : image,
      'ROLE' : role,
      'PASSWORD' : password,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : Timestamp.now(),
    };
  }

  factory Usermodel.fromMap(Map<String, dynamic> map, String docId){
    return Usermodel(
      id: docId,
      email: map['EMAIL'] ?? '',
      name: map['NAME'] ?? '',
      employeeid: map['EMPLOYEEID'] ?? '',
      image: map['IMAGE'] ?? '',
      role: map['ROLE'] ?? '',
      password: map['PASSWORD'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}