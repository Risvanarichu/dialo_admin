import 'package:fl_chart_flutter/fl_chart_flutter.dart';
import 'package:flutter/material.dart';
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime? fromDate;
  DateTime? toDate;

  Future<void> pickDate(bool isFrom) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        isFrom ? fromDate = date : toDate = date;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "dd-mm-yyyy";
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        title: const Text("Reports"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// DATE FILTER CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: cardDecoration(),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => pickDate(true),
                      child: dateField("From Date", formatDate(fromDate)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => pickDate(false),
                      child: dateField("To Date", formatDate(toDate)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Apply filter logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3B82F6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Apply"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// CHART CARD
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Agent Performance",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    Expanded(child: agentChart()),
                    const SizedBox(height: 10),
                    legend(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
             decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text("Lead conversion funnel",style:  TextStyle(
                    fontSize: 16,fontWeight:FontWeight.w600,color: Colors.black,
                   ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: agentChart()),
                  const SizedBox(height: 10),
                  legend(),
                 ],
              ),
             )
          ],
        ),
      ),
    );
  }

  /// BAR CHART
  Widget agentChart() {
    return BarChart(
      BarChartData(
        maxY: 160,
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          rightTitles:
          AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
          AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const names = [
                  "John Smith",
                  "Emily Davis",
                  "Sarah Miller",
                  "Michael Brown"
                ];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    names[value.toInt()],
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          groupData(0, 140, 35),
          groupData(1, 130, 30),
          groupData(2, 125, 28),
          groupData(3, 115, 25),
        ],
      ),
    );
  }

  BarChartGroupData groupData(int x, double calls, double conversions) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: calls,
          width: 14,
          color: const Color(0xff3B82F6),
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: conversions,
          width: 14,
          color: const Color(0xff10B981),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
      barsSpace: 6,
    );
  }

  /// LEGEND
  Widget legend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        legendItem(const Color(0xff3B82F6), "Total Calls"),
        const SizedBox(width: 16),
        legendItem(const Color(0xff10B981), "Conversions"),
      ],
    );
  }

  Widget legendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  /// UI HELPERS
  Widget dateField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
        )
      ],
    );
  }
}
Widget agentChart() {
  return BarChart(
    BarChartData(
      maxY: 160,
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        rightTitles:
        AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles:
        AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const names = [
                "John Smith",
                "Emily Davis",
                "Sarah Miller",
                "Michael Brown"
              ];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  names[value.toInt()],
                  style: const TextStyle(fontSize: 10),
                ),
              );
            },
          ),
        ),
      ),
      barGroups: [
        groupData(0, 140, 35),
        groupData(1, 130, 30),
        groupData(2, 125, 28),
        groupData(3, 115, 25),
      ],
    ),
  );
}

BarChartGroupData groupData(int x, double calls, double conversions) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: calls,
        width: 14,
        color: const Color(0xff3B82F6),
        borderRadius: BorderRadius.circular(4),
      ),
      BarChartRodData(
        toY: conversions,
        width: 14,
        color: const Color(0xff10B981),
        borderRadius: BorderRadius.circular(4),
      ),
    ],
    barsSpace: 6,
  );
}

/// LEGEND
Widget legend() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      legendItem(const Color(0xff3B82F6), "Total Calls"),
      const SizedBox(width: 16),
      legendItem(const Color(0xff10B981), "Conversions"),
    ],
  );
}

Widget legendItem(Color color, String text) {
  return Row(
    children: [
      Container(width: 12, height: 12, color: color),
      const SizedBox(width: 6),
      Text(text),
    ],
  );
}

/// UI HELPERS
Widget dateField(String label, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    ),
  );
}

BoxDecoration cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
      )
    ],
  );
}


