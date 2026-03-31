import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/models/leadModel.dart';
import 'package:dialo_admin/views/leads/leads_list.dart';
import 'package:flutter/widgets.dart';

class LeadProvider extends ChangeNotifier{
  FirebaseFirestore fbd = FirebaseFirestore.instance;
  List<LeadModel>leads=[];
  bool isLoading = false;

  Future<void>fetchLeads()async{
    isLoading = true;
    notifyListeners();

    final snapshot = await fbd.collection('LEADS').get();
    leads = snapshot.docs.map((doc){
      return LeadModel.fromMap(doc.id,doc.data());
    }).toList();
isLoading = false;
    notifyListeners();
  }

  Future<void> completedLead(String id) async{
    await fbd.collection('LEADS').doc(id).update({
      "FOLLOW_UP_STATUS":"completed"
    });
  }
  Future<void>rescheduleLead(String id,DateTime date)async{
    await fbd.collection("LEADS").doc(id).update({
      "ADDED_TIME":date
    });
    fetchLeads();
  }
}