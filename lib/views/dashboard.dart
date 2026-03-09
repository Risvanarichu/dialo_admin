import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/sidemenu.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      drawer: isDesktop ? null : const SideMenu(),
      body: Row(
        children: [
          if (isDesktop) SizedBox(width: 220, child: SideMenu()),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: Color(0xFFE0E0E0),
          ),
          Expanded(
            child: Column(
              children: [
                TopBar(isDesktop: isDesktop),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            DashboardContent(),
                            SizedBox(height: 20),
                            DashboardBottomSection(),
                          ],
                        ),
                        // child: DashboardContent(isDesktop:isDesktop),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class SideMenu extends StatelessWidget {
//   const SideMenu({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 220,
//       color: Colors.white,
//       child: Column(
//         children: [
//           const SizedBox(height: 40),
//           _menuItem(Icons.dashboard_outlined, "Dashboard", false),
//           _menuItem(Icons.phone_outlined, "Calls", false),
//           _menuItem(Icons.people_outline, "Leads", false),
//           _menuItem(Icons.person_add_alt_outlined, "Add lead", false),
//           _menuItem(Icons.event_outlined, "Follow-Up", false),
//           _menuItem(Icons.bar_chart_outlined, "Reports", false),
//           _menuItem(Icons.group_outlined, "Users", false),
//           _menuItem(Icons.settings_outlined, "Settings", false),
//           const Spacer(),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text("Logout", style: TextStyle(color: Colors.red)),
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _menuItem(IconData icon, String title, bool active) {
//     return ListTile(
//       leading: Icon(icon, color: Color(0xff3570CE)),
//       title: Text(title, style: TextStyle(color: Colors.black)),
//     );
//   }
// }

class TopBar extends StatelessWidget {
  final bool isDesktop;

  const TopBar({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Row(
            children: [
              Text(
                "DASHBOARD",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Flexible(
                child: SizedBox(
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.notifications_none),
              const SizedBox(width: 20),
              const CircleAvatar(
                backgroundColor: Color(0xff3570CE),
                child: Icon(Icons.person_outline, color: Colors.black),
              ),
              const SizedBox(width: 8),
              const Text("Profile"),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
      ],
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 25,
        children: const [
          InfoCard(title: "TOTAL LEADS",
            value: "22",
            color: Color(0xffFFF2E8),
            icon: Icons.trending_up,),
          InfoCard(
            title: "TODAY'S CALLS",
            value: "50",
            color: Color(0xffF0FFDE),
            icon: Icons.call,
          ),
          InfoCard(
            title: "UPCOMING",
            value: "10",
            color: Color(0xffFFFCDD),
            icon: Icons.calendar_today,),
          InfoCard(
            title: "OVERDUE",
            value: "5",
            color: Color(0xffF3ECFF),
            icon: Icons.access_time,),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon
  });

  @override
  Widget build(BuildContext) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child:
                  Text(title, style: const TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.w600),
                  )
              ),
              Icon(icon,size: 22,color: Colors.black,)
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AgentPerformance extends StatelessWidget {
  const AgentPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Agent Performance",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            AgentRow("John Smith", " 52 calls", true),
            AgentRow("Sara Johnson", " 49 calls", false),
            AgentRow("Michael clark", " 36 calls", true),
            AgentRow("Emily Davis", " 34 calls", false),
          ],
        ),
      ),
    );
  }
}

class AgentRow extends StatelessWidget {
  final String name;
  final String calls;
  final bool online;

  const AgentRow(this.name, this.calls, this.online, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: online ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 5),
          Text(online ? "online" : "offline", overflow: TextOverflow.ellipsis),
        ],
      ),
      trailing: SizedBox(
        width: 60,
        child: Text(
          calls,
          textAlign: TextAlign.right,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class DashboardBottomSection extends StatelessWidget {
  const DashboardBottomSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 800;

        if (isWide) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: CallAnalytics()),
                  SizedBox(width: 20),
                  Expanded(flex:2,child: AgentPerformance()),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex:2,child: CallDistribution()),
                  SizedBox(width: 20),
                  Expanded(flex:3,child: RecentCalls()),
                ],
              ),
            ],
          );
        }
        return Column(
          children: const [
            CallAnalytics(),
            SizedBox(height: 20),
            AgentPerformance(),
            SizedBox(height: 20),
            CallDistribution(),
            SizedBox(height: 20),
            RecentCalls(),
          ],
        );
      },
    );
  }
}


class RecentCalls extends StatelessWidget {
  const RecentCalls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Call Activity",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            const Divider(),
            CallRow("Sarah", "Outgoing", "5 min", "4 Seconds ago", Colors.red),
            CallRow("James", "Voicemail", "4 min", "5 minutes ago", Colors.red),
            CallRow(
              "Rachel",
              "Outgoing",
              "3 min",
              "3 minutes ago",
              Colors.green,
            ),
            CallRow(
              "Michelle",
              "Incoming",
              "11 min",
              "11 minutes ago",
              Colors.red,
            ),
            CallRow(
              "Lucy",
              "Outgoing",
              "2 min",
              "25 minutes ago",
              Colors.red,
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}

class CallRow extends StatelessWidget {
  final String name;
  final String type;
  final String duration;
  final String time;
  final Color callColor;
  final bool showDivider;

  const CallRow(
      this.name,
      this.type,
      this.duration,
      this.time,
      this.callColor, {
        this.showDivider = true,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.call, color: Colors.blue, size: 18),
              const SizedBox(width: 12),

              Expanded(flex: 2, child: Text(name)),
              Expanded(flex: 2, child: Text(type)),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(Icons.call, color: callColor, size: 16),
                    const SizedBox(width: 6),
                    Text(duration),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  time,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

class CallAnalytics extends StatelessWidget {
  const CallAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFEFF1F3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text("Call Analyst",style: TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 9,
                minY: 0,
                maxY: 100,

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, _) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 25,
                      getTitlesWidget: (value, _) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 15),
                      FlSpot(1, 5),
                      FlSpot(2, 25),
                      FlSpot(3, 65),
                      FlSpot(4, 50),
                      FlSpot(5, 25),
                      FlSpot(6, 35),
                      FlSpot(7, 75),
                      FlSpot(8, 25),
                      FlSpot(9, 30),
                    ],
                    isCurved: false,
                    barWidth: 1,
                    color: Color(0xFFA023F3),
                    dotData: FlDotData(show: true,
                        getDotPainter: (spot,percent,barData,index){
                          return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: barData.color??Color(0xFFA023F3)
                          );
                        }),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 85),
                      FlSpot(1, 88),
                      FlSpot(2, 0),
                      FlSpot(3, 55),
                      FlSpot(4, 78),
                      FlSpot(5, 48),
                      FlSpot(6, 30),
                      FlSpot(7, 28),
                      FlSpot(8, 55),
                      FlSpot(9, 45),
                    ],
                    isCurved: false,
                    color: Color(0xFFA17985),
                    barWidth: 1,
                    dotData: FlDotData(show: true,
                        getDotPainter: (spot,percent,barData,index){
                          return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: barData.color??Color(0xFFA17985)
                          );
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CallDistribution extends StatelessWidget {
  const CallDistribution({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String,dynamic>>callData=[
      {"label":"Incoming","value":55.0,"color":Colors.blue},
      {"label":"Outgoing","value":35.0,"color":Colors.green},
      {"label":"Missed","value":5.0,"color":Colors.red},
      {"label":"Voicemail","value":5.0,"color":Colors.yellow},
    ];
    double total = callData.fold(0,
          (sum,item)=>sum+(item["value"]as double),
    );
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white,
          border: Border.all(color: Colors.black )),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Call Distribution",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  "Today's Calls:1,245",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
                // LegendItem(color: Colors.blue, text: "Incoming"),
                // LegendItem(color: Colors.green, text: "Outgoing"),
                // LegendItem(color: Colors.red, text: "Missed"),
                // LegendItem(color: Colors.yellow, text: "Voicemail"),
                ...callData.map((data){
                  final percent=((data["value"]/total)*100).toStringAsFixed(0);
                  return LegendItem(color: data["color"], text: "${data["label"]}-$percent%",);
                }).toList(),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 50,
                      sections: callData.map((data){
                        return PieChartSectionData(
                          value: data["value"],
                          color: data["color"],
                          showTitle: false,
                        );
                      }).toList()
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Today's Calls:",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "1,245",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
