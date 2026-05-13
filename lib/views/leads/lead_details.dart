import 'package:dialo_admin/models/leadModel.dart';
import 'package:flutter/material.dart';

import '../../constants/appcolors.dart';

class LeadDetails extends StatelessWidget {
  final LeadModel lead;
  const LeadDetails({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lead.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xffDCE8FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.lightBlueAccent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      lead.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    detailRow("Phone", lead.phone),
                    detailRow("Email", lead.email),
                    detailRow("Status", lead.status),
                    detailRow("Source", lead.source),
                    detailRow("Priority", lead.priority),
                    detailRow("Agent_ID", lead.assignedAgentId),
                  ],
                ),
              ),
            ),

            const Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    print("Add Followup clicked");
                  },
                  label: const Text("Add Follow-up",
                  style: TextStyle(color: AppColors.whitetext),),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    backgroundColor: AppColors.themeColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
Widget detailRow(String title,String value){
  return Padding(padding: 
      const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 90,
        child: Text("$title",style: const TextStyle(
          fontWeight: FontWeight.bold
        ),),),
        Expanded(child: Text(value.isEmpty?"-":value,
        style: const TextStyle(fontSize: 15),))
        
      ],
    ),
  );
}