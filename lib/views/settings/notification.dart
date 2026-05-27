import 'package:dialo_admin/providers/notificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NotificationProvider>().fetchNotifications();
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
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.notifications.isEmpty) {
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
            itemCount: provider.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final data = provider.notifications[index];

              return Container(
                decoration: BoxDecoration(
                  color: data.isRead ? Colors.white : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: data.isRead
                        ? Colors.grey.shade200
                        : Colors.blue.shade200,
                  ),
                ),
                child: ListTile(
                  onTap: () async {
                    if (!data.isRead) {
                      await provider.markAsRead(data.id);
                    }
                  },
                  leading: CircleAvatar(
                    backgroundColor:
                    data.isRead ? Colors.grey.shade300 : Colors.blue,
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    data.title,
                    style: TextStyle(
                      fontWeight: data.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(data.body),
                  trailing: Text(
                    "${data.time.hour.toString().padLeft(2, '0')}:"
                        "${data.time.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}