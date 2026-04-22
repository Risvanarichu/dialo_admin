import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/dashboardProvider.dart';
import '../widget/sidemenu.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DashboardProvider>().fetchDashboardCounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      // drawer: isDesktop ? null : const SideMenu(),
      body: Row(
        children: [
          // if (isDesktop) const SizedBox(width: 220, child: SideMenu()),
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
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DashboardContent(),
                            SizedBox(height: 20),
                            DashboardBottomSection(),
                          ],
                        ),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.notifications_none),
              const SizedBox(width: 20),
              const CircleAvatar(
                backgroundColor: Color(0xff3570CE),
                child: Icon(Icons.person_outline, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text("Profile"),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
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
        children: [
          Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              return InfoCard(
                title: "TOTAL LEADS",
                value: provider.totalLeads.toString(),
                color: const Color(0xffFFF2E8),
                icon: Icons.trending_up,
              );
            },
          ),
          Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              return InfoCard(
                title: "TODAY'S CALLS",
                value: provider.todaysCalls.toString(),
                color: const Color(0xffF0FFDE),
                icon: Icons.call,
              );
            },
          ),
          Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              return InfoCard(
                title: "UPCOMING",
                value: provider.upcoming.toString(),
                color: const Color(0xffFFFCDD),
                icon: Icons.calendar_today,
              );
            },
          ),
          Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              return InfoCard(
                title: "OVERDUE",
                value: provider.overdue.toString(),
                color: const Color(0xffF3ECFF),
                icon: Icons.access_time,
              );
            },
          ),
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
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
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
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(icon, size: 22, color: Colors.black),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
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
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Agent Performance",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 15),
            AgentRow("John Smith", "52 calls", true),
            AgentRow("Sara Johnson", "49 calls", false),
            AgentRow("Michael Clark", "36 calls", true),
            AgentRow("Emily Davis", "34 calls", false),
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
      leading: const CircleAvatar(
        backgroundColor: Color(0xff3570CE),
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.diamond,
            size: 12,
            color: online ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 5),
          Text(
            online ? "online" : "offline",
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: SizedBox(
        width: 70,
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
  const DashboardBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 800;

        if (isWide) {
          return Column(
            children: const [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: CallAnalytics()),
                  SizedBox(width: 20),
                  Expanded(flex: 2, child: AgentPerformance()),
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: CallDistribution()),
                  SizedBox(width: 20),
                  Expanded(flex: 3, child: RecentCalls()),
                ],
              ),
            ],
          );
        }

        return const Column(
          children: [
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
          children: const [
            Text(
              "Recent Call Activity",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            Divider(),
            CallRow("Sarah", "Outgoing", "5 min", "4 seconds ago", Colors.red),
            CallRow("James", "Voicemail", "4 min", "1 minute ago", Colors.red),
            CallRow("Rachel", "Outgoing", "3 min", "5 minutes ago", Colors.green),
            CallRow("Michelle", "Incoming", "11 min", "11 minutes ago", Colors.red),
            CallRow("Lucy", "Outgoing", "2 min", "25 minutes ago", Colors.red, showDivider: false),
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
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFEFF1F3), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Daily Calls vs Converted Leads",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
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
                      horizontalInterval: 25,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: Colors.black54, width: 1),
                        bottom: BorderSide(color: Colors.black54, width: 1),
                        right: BorderSide(color: Colors.transparent),
                        top: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            "Dates",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 26,
                          getTitlesWidget: (value, meta) {
                            const dates = [
                              "Jan",
                              "Feb",
                              "Mar",
                              "Apr",
                              "May",
                              "Jun",
                              "Jul",
                              "Aug",
                              "Sep",
                              "Oct",
                              "Nov",
                              "Dec",
                            ];

                            if (value.toInt() < 0 || value.toInt() >= dates.length) {
                              return const SizedBox();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                dates[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            "Number of Calls",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 25,
                          reservedSize: 20,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 11),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: provider.leadSpots.isNotEmpty
                            ? provider.leadSpots
                            : const [
                          FlSpot(0, 15),
                          FlSpot(1, 2),
                          FlSpot(2, 22),
                          FlSpot(3, 63),
                          FlSpot(4, 50),
                          FlSpot(5, 26),
                          FlSpot(6, 35),
                          FlSpot(7, 72),
                          FlSpot(8, 22),
                          FlSpot(9, 27),
                        ],
                        isCurved: false,
                        color: const Color(0xFFA023F3),
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor:
                              barData.color ?? const Color(0xFFA023F3),
                            );
                          },
                        ),
                        belowBarData: BarAreaData(show: false),
                      ),
                      LineChartBarData(
                        spots: provider.callSpots.isNotEmpty
                            ? provider.callSpots
                            : const [
                          FlSpot(0, 86),
                          FlSpot(1, 88),
                          FlSpot(2, 0),
                          FlSpot(3, 56),
                          FlSpot(4, 78),
                          FlSpot(5, 48),
                          FlSpot(6, 31),
                          FlSpot(7, 29),
                          FlSpot(8, 53),
                          FlSpot(9, 45),
                        ],
                        isCurved: false,
                        color: const Color(0xFFA17985),
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor:
                              barData.color ?? const Color(0xFFA17985),
                            );
                          },
                        ),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CallDistribution extends StatelessWidget {
  const CallDistribution({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
  builder: (context, provider, child) {

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final  callData = [
      {"label": "Incoming", "value": provider.incoming.toDouble(), "color": Colors.blue
      },
      {"label": "Outgoing", "value": provider.outgoing.toDouble(), "color": Colors.green},
      {
        "label": "Missed", "value": provider.missed.toDouble(), "color": Colors.red
      },
      {"label": "Voicemail", "value": provider.voicemail.toDouble(), "color": Colors.yellow},
    ];

    final double total = callData.fold(
      0,
          (sum, item) => sum + (item["value"] as double),
    );

    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Call Distribution",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  "Today's Calls: ${provider.todaysCalls}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ...callData.map((data) {
                  final percent =
                  total == 0 ? "0" : (((data["value"] as double)/ total) * 100).toStringAsFixed(0);
                  return LegendItem(
                    color: data["color"]as Color,
                    text: "${data["label"]} - $percent%",
                  );
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
                    sections: callData.map((data) {
                      return PieChartSectionData(
                        value: data["value"] as double?,
                        color: data["color"] as Color,
                        showTitle: false,
                      );
                    }).toList(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Today's Calls:",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${provider.todaysCalls}",
                      style: const TextStyle(
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
  });
  }
}


class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}