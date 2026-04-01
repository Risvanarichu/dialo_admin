import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/models/leadModel.dart';
import 'package:dialo_admin/views/leads/leads_list.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class LeadProvider extends ChangeNotifier{
  FirebaseFirestore fbd = FirebaseFirestore.instance;
  List<LeadModel>leads=[];
  List<LeadModel> get leadsList => leads;
  List<LeadModel>allLeads =[];
  bool isLoading = false;
  StreamSubscription? leadSubscription;
  final searchController = TextEditingController();
  String selectedStatus = "All Status";
  String selectedSources = "All Sources";
  String searchQuery = "";

  LeadProvider(){
    listenLeads();
  }


  void listenLeads() {
    isLoading = true;
    notifyListeners();

    leadSubscription?.cancel();

    leadSubscription =
        fbd.collection('LEADS').snapshots().listen((snapshot) {
          leads = snapshot.docs
              .map((doc) => LeadModel.fromMap(doc.id, doc.data()))
              .toList();

          isLoading = false;
          notifyListeners();
        });
  }

  Future<void>fetchLeads()async{
    isLoading = true;
    notifyListeners();

   try {
     final snapshot = await fbd.collection('LEADS').get();

     leads = [];

     for (var doc in snapshot.docs) {
       try {
         leads.add(LeadModel.fromMap(doc.id, doc.data()));
       } catch (e) {
         print("Error in doc ${doc.id}: $e");
       }
     }
   }catch(e) {
     print("Error fetching leads: $e");
   }finally{
     isLoading = false;
     notifyListeners();
   }
   }

  Future<void> completedLead(String id) async {
    await fbd.collection('LEADS').doc(id).update({
      "FOLLOW_UP_STATUS": "completed",
      "STATUS":"Converted",
    });
  }
  Future<void> rescheduleLead(String id, DateTime date, String time) async {
    await fbd.collection("LEADS").doc(id).update({
      "FOLLOW_UP_DATE": Timestamp.fromDate(date),
      "FOLLOW_UP_TIME": time,
    });
  }

  void searchLeads(String query) {
    searchQuery = query;
    isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      leads = allLeads;
    } else {
      final q = query.toLowerCase();

      leads = allLeads.where((lead) {
        return lead.name.toLowerCase().contains(q) ||
            lead.phone.toLowerCase().contains(q) ||
            lead.email.toLowerCase().contains(q);
      }).toList();
    }
    isLoading = false;
    notifyListeners();
  }
}