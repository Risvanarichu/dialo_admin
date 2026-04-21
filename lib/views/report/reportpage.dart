import 'package:dialo_admin/providers/reportProvider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "REPORTS",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),
              Divider(),

              DateFilterSection(),

              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: AgentPerformanceCard()),
                  const SizedBox(width: 20),
                  Expanded(child: LeadFunnelCard()),
                ],
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: AgentTableCard()),
                  SizedBox(width: 20),

                  Expanded(child: LeadsReportCard()),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// DATE FILTER
////////////////////////////////////////////////////////////

class DateFilterSection extends StatelessWidget {
  const DateFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _dateField(context, "From Date", true),
        const SizedBox(width: 20),
        _dateField(context, "To Date", false),
        const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.only(top: 25),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2f6fed),
              padding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              final provider = context.read<ReportProvider>();
              await provider.fetchReports();
            },
            child: const Text("Apply"),
          ),
        )
      ],
    );
  }

  Widget _dateField(BuildContext context, String label, bool isFrom) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          InkWell(
            onTap: () async {
              final provider = context.read<ReportProvider>();

              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );

              if (picked != null) {
                if (isFrom) {
                  provider.fromDate = picked;
                } else {
                  provider.toDate = picked;
                }
                provider.notifyListeners(); // 🔥 IMPORTANT
              }
            },
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              alignment: Alignment.centerLeft,
              child: Consumer<ReportProvider>(
                builder: (_, provider, __) {
                  DateTime? date =
                  isFrom ? provider.fromDate : provider.toDate;

                  return Text(
                    date == null
                        ? "dd-mm-yyyy"
                        : "${date.day}-${date.month}-${date.year}",
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// BAR CHART
////////////////////////////////////////////////////////////

class AgentPerformanceCard extends StatelessWidget {
  const AgentPerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Agent Performance",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Expanded( // ✅ FIXED
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: provider.agentPerformance.isEmpty
                    ? 10
                    : provider.agentPerformance
                    .map((e) => (e['total'] ?? 0))
                    .reduce((a, b) => a > b ? a : b)
                    .toDouble() +
                    10,
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();

                        if (index >= provider.agentPerformance.length) {
                          return const SizedBox();
                        }

                        String agentName =
                        provider.agentPerformance[index]['agent'];

                        agentName = agentName.length > 6
                            ? agentName.substring(0, 6) + "..."
                            : agentName;

                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            agentName,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),

                barGroups: List.generate(
                  provider.agentPerformance.length,
                      (index) {
                    final data = provider.agentPerformance[index];
                    return _barGroup(
                      index,
                      (data["total"] ?? 0).toDouble(),
                      (data['converted'] ?? 0).toDouble(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double total, double conversion) {
    return BarChartGroupData(
      x: x,
      barsSpace: 10,
      barRods: [
        BarChartRodData(
          toY: total,
          width: 30,
          color: const Color(0xff2f6fed),
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: conversion,
          width: 30,
          color: const Color(0xff2ecc71),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// FUNNEL CHART
////////////////////////////////////////////////////////////

class LeadFunnelCard extends StatelessWidget {
  const LeadFunnelCard({super.key});


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();
    final funnel = provider.funnelData;
    double maxValue = (funnel['total'] ?? 1).toDouble();
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Lead Conversion Funnel",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
         _funnelBar(context,"Total",(funnel['total']??0).toDouble(),maxValue),
         _funnelBar(context,"Pending",(funnel['pending']??0).toDouble(),maxValue),
          _funnelBar(context,"Contacted",(funnel['contacted']??0).toDouble(),maxValue),
         _funnelBar(context,"Converted",(funnel['converted']??0).toDouble(),maxValue),
        ],
      ),
    );
  }

  Widget _funnelBar(
      BuildContext context,
      String label,
      double value,
      double maxValue,
      ) {
    double percent = maxValue == 0 ? 0 : value / maxValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),

          /// ✅ FIXED WIDTH (VERY IMPORTANT)
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: 35,
                width: constraints.maxWidth, // ✅ gives proper width
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    /// BAR
                    Container(
                      width: constraints.maxWidth * percent,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff2f6fed), Color(0xff4f8cff)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    /// TEXT
                    Center(
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// AGENT TABLE
////////////////////////////////////////////////////////////

class AgentTableCard extends StatelessWidget {
  const AgentTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("AGENT PERFORMANCE TABLE",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 50,
              border: TableBorder(
                verticalInside: BorderSide(color: Colors.grey.shade300),
                horizontalInside: BorderSide(color: Colors.grey.shade300),
              ),
              columns: const [
                DataColumn(label: Text("Agent Name")),
                DataColumn(label: Text("Total Calls")),
                DataColumn(label: Text("Answered")),
                DataColumn(label: Text("Conversions")),
                DataColumn(label: Text("Conversion Rate")),
              ],
              rows: provider.agentPerformance.map((e){
                int total = e['total']??0;
                int converted = e['converted']?? 0;
                double rate=total == 0?0:(converted / total)*100;
                 return DataRow(cells: [
                   DataCell(Text(e['agent'].toString().toUpperCase())),
                   DataCell(Text(total.toString())),
                   DataCell(Text("_")),
                   DataCell(Text(converted.toString())),
                   DataCell(Text("${rate.toStringAsFixed(1)}%")),
                 ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// LEADS REPORT TABLE
////////////////////////////////////////////////////////////

class LeadsReportCard extends StatelessWidget {
  const LeadsReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("LEADS REPORT",
              style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 15),

          /// FILTERS
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _dropdown(
                value: provider.selectedAgent,
                items: ["All Agents"],
                onChanged: provider.updateAgent,
              ),
              _dropdown(
                value: provider.selectedStatus,
                items: ["All Status", "New", "Converted"],
                onChanged: provider.updateStatusFilter,
              ),
              // _dropdown(
              //   value: provider.selectedSource,
              //   items: ["All Sources"],
              //   onChanged: provider.updateSource,
              // ),
              SizedBox(
                width: 200,
                child: TextField(
                  onChanged: provider.searchLeads,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Search leads...",
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// 🔥 FIXED AREA + SCROLL
          Expanded(
            child: provider.leadsReport.isEmpty
                ? const Center(child: Text("No Data Available"))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 80,
                  columns: const [
                    // DataColumn(label: Text("Lead ID")),
                    DataColumn(label: Text("Lead Name")),
                    DataColumn(label: Text("Phone")),
                    DataColumn(label: Text("Source")),
                    DataColumn(label: Text("Agent")),
                    DataColumn(label: Text("Status")),
                  ],
                  rows: provider.leadsReport.map((e) {
                    return DataRow(cells: [
                      // DataCell(Text(e["id"])),
                      DataCell(Text(e["name"])),
                      DataCell(Text(e["phone"])),
                      DataCell(Text(e["source"])),
                      DataCell(Text(e["agent"])),
                      DataCell(Text(e["status"])),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) => onChanged(val!),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// FILTERS
////////////////////////////////////////////////////////////

class LeadsFilterSection extends StatelessWidget {
  const LeadsFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: 160,
          child: _dropdown(["All Agents", "RISWANA", "SHIBIN", "FINIYA"]),
        ),
        SizedBox(
          width: 160,
          child: _dropdown(["All Status", "New", "Contacted", "Converted"]),
        ),
        SizedBox(
          width: 160,
          child: _dropdown(["All Sources", "Website", "Facebook", "Referral"]),
        ),
        SizedBox(
          width: 200,
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Search leads...",
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(List<String> items) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.first,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {},
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// CARD UI
////////////////////////////////////////////////////////////

Widget _card({required Widget child}) {
  return Container(
    height: 420, // ✅ SAME HEIGHT FOR ALL
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8)
      ],
    ),
    child: child,
  );
}