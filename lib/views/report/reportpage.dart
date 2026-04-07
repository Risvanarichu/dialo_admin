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
                  SizedBox(width: 20),
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
        _dateField("From Date"),
        const SizedBox(width: 20),
        _dateField("To Date"),
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

  Widget _dateField(String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text("dd-mm-yyyy"),
            ),
          )
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
          const Text("Agent Performance",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 380,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: provider.agentPerformance.isEmpty
                  ?10
                  :provider.agentPerformance
                  .map((e)=>(e['total']??0))
                  .reduce((a,b)=> a>b ? a:b)
                  .toDouble()+10,
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
               barGroups: List.generate(
                  provider.agentPerformance.length,
                   (index){
                    final data = provider.agentPerformance[index];
                    return _barGroup(index,
                        (data["total"]??0).toDouble(),
                        (data['converted']?? 0).toDouble(),
                    );
                   })
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
         _funnelBar(context,"Converted",(funnel['converted']??0).toDouble(),maxValue),
        ],
      ),
    );
  }

  Widget _funnelBar(BuildContext context, String label, double value,double maxValue) {
    double percent = value / maxValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 5),
          Center(
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width * 0.35 * percent,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff2f6fed), Color(0xff4f8cff)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                value.toInt().toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
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
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("LEADS REPORT",
              style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),

          const LeadsFilterSection(),

          const SizedBox(height: 20),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 120,
              border: TableBorder(
                verticalInside: BorderSide(color: Colors.grey.shade300),
                horizontalInside: BorderSide(color: Colors.grey.shade300),
              ),
              columns: const [
                DataColumn(label: Text("Lead ID")),
                DataColumn(label: Text("Lead Name")),
                DataColumn(label: Text("Phone")),
                DataColumn(label: Text("Source")),
                DataColumn(label: Text("Agent")),
                DataColumn(label: Text("Stage")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("Value")),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text("L001")),
                  DataCell(Text("John")),
                  DataCell(Text("9876543210")),
                  DataCell(Text("Website")),
                  DataCell(Text("RISWANA")),
                  DataCell(Text("Qualified")),
                  DataCell(Text("Follow-up")),
                  DataCell(Text("₹50000")),
                ]),
                DataRow(cells: [
                  DataCell(Text("L002")),
                  DataCell(Text("Sarah")),
                  DataCell(Text("9123456780")),
                  DataCell(Text("Facebook")),
                  DataCell(Text("SHIBIN")),
                  DataCell(Text("Proposal")),
                  DataCell(Text("Contacted")),
                  DataCell(Text("₹35000")),
                ]),
              ],
            ),
          ),
        ],
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
    return Row(
      children: [
        _dropdown(["All Agents", "RISWANA", "SHIBIN", "FINIYA"]),
        const SizedBox(width: 10),
        _dropdown(["All Status", "New", "Contacted", "Converted"]),
        const SizedBox(width: 10),
        _dropdown(["All Sources", "Website", "Facebook", "Referral"]),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search leads...",
              ),
            ),
          ),
        )
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