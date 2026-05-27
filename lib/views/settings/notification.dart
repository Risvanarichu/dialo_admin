import 'package:dialo_admin/models/leadModel.dart';
import 'package:dialo_admin/models/notificationModel.dart';
import 'package:dialo_admin/providers/leadProvider.dart';
import 'package:dialo_admin/providers/notificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      final agentId = prefs.getString('agentId') ?? "";
      final role = prefs.getString('role') ?? "AGENT";

      if (mounted) {
        context.read<NotificationProvider>().fetchNotifications(agentId, role);
        context.read<LeadProvider>().listenLeads();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationProvider>().markAllAsRead();
            },
            child: const Text("Mark all read"),
          ),
        ],
      ),
      body: Consumer2<NotificationProvider, LeadProvider>(
        builder: (context, notifProv, leadProv, child) {
          if (notifProv.isLoading && notifProv.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Combine Firestore notifications and Overdue leads
          final List<dynamic> combinedList = [];

          // Add Firestore notifications
          combinedList.addAll(notifProv.notifications);

          // Add Overdue leads
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final overdueLeads = leadProv.leads.where((lead) {
            final followDate = DateTime(
              lead.followupDate.year,
              lead.followupDate.month,
              lead.followupDate.day,
            );
            return followDate.isBefore(today) &&
                lead.followupstatus.toUpperCase() == "PENDING";
          }).toList();

          combinedList.addAll(overdueLeads);

          // Sort by time (Notifications have .time, LeadModel has .followupDate)
          combinedList.sort((a, b) {
            DateTime timeA = a is NotificationModel ? a.time : (a as LeadModel).followupDate;
            DateTime timeB = b is NotificationModel ? b.time : (b as LeadModel).followupDate;
            return timeB.compareTo(timeA);
          });

          if (combinedList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text("No notifications yet",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: combinedList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = combinedList[index];

              if (item is NotificationModel) {
                return _notificationTile(context, item, notifProv);
              } else {
                return _overdueLeadTile(context, item as LeadModel);
              }
            },
          );
        },
      ),
    );
  }

  Widget _notificationTile(BuildContext context, NotificationModel data, NotificationProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: data.isRead ? Colors.white : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: data.isRead ? Colors.grey.shade200 : Colors.blue.shade200,
        ),
      ),
      child: ListTile(
        onTap: () async {
          if (!data.isRead) {
            await provider.markAsRead(data.id);
          }
        },
        leading: CircleAvatar(
          backgroundColor: data.isRead ? Colors.grey.shade300 : Colors.blue,
          child: const Icon(Icons.notifications, color: Colors.white, size: 20),
        ),
        title: Text(
          data.title,
          style: TextStyle(
            fontWeight: data.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(data.body),
        trailing: Text(
          DateFormat('HH:mm').format(data.time),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _overdueLeadTile(BuildContext context, LeadModel lead) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade400,
          child: const Icon(Icons.priority_high, color: Colors.white, size: 20),
        ),
        title: Text(
          "Overdue Follow-up: ${lead.name}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Scheduled for ${DateFormat('dd MMM').format(lead.followupDate)}"),
        trailing: const Icon(Icons.chevron_right, color: Colors.red),
        onTap: () {
          // Navigate to lead details
        },
      ),
    );
  }
}
