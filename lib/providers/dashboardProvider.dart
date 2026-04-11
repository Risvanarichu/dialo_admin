import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  int totalLeads = 0;
  int todaysCalls = 0;
  int upcoming = 0;
  int overdue = 0;
  bool isLoading=false;

//   Future<void> fetchLeads() async {
//     final snapshot = await db.collection('LEADS').get();
//
//     totalLeads = snapshot.docs.length;
//
//     // Example calculation
//     upcoming = 0;
//     overdue = 0;
//
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//
//       if (data['FOLLOW_UP_STATUS'] == 'pending') {
//         upcoming++;
//       }
//
//       if (data['FOLLOW_UP_STATUS'] == 'overdue') {
//         overdue++;
//       }
//     }
//
//     notifyListeners();
//   }
  Future<void>fetchDashboardCounts()async{
    isLoading=true;
    notifyListeners();
    try{
      final leadSnapshot=await db.collection("LEADS").get();
      totalLeads=leadSnapshot.docs.length;
      todaysCalls=0;
      upcoming=0;
      overdue=0;
      final now=DateTime.now();
      final today=DateTime(now.year,now.month,now.day);
      for(var doc in leadSnapshot.docs){
        final data=doc.data();
        if (data["followUpDate"]is Timestamp){
          DateTime followUpDate;
          if (data["followUpDate"]!=null){
            followUpDate = (data["followUpDate"] as Timestamp).toDate();
          } else {
            followUpDate = DateTime.parse(data["followUpDate"].toString());
          }
          final followDateOnly = DateTime(
            followUpDate.year,
            followUpDate.month,
            followUpDate.day,
          );
          if (followDateOnly == today) {
            todaysCalls++;
          } else if (followDateOnly.isAfter(today)) {
            upcoming++;
          } else if (followDateOnly.isBefore(today)) {
            overdue++;
          }
        }
      }
      isLoading = false;
      notifyListeners();
    }catch(e){
      debugPrint("Error fetching total leads:$e");
      isLoading=false;
      notifyListeners();
    }
  }
 }