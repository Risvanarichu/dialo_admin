import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
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
                maxY: 160,
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _barGroup(0, 150, 35),
                  _barGroup(1, 135, 30),
                  _barGroup(2, 130, 28),
                  _barGroup(3, 120, 25),
                ],
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

  final double maxValue = 500;

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Lead Conversion Funnel",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _funnelBar(context, "Leads", 500),
          _funnelBar(context, "Contacted", 350),
          _funnelBar(context, "Qualified", 200),
          _funnelBar(context, "Proposal", 100),
          _funnelBar(context, "Converted", 60),
        ],
      ),
    );
  }

  Widget _funnelBar(BuildContext context, String label, double value) {
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
              rows: const [
                DataRow(cells: [
                  DataCell(Text("RISWANA")),
                  DataCell(Text("145")),
                  DataCell(Text("138")),
                  DataCell(Text("32")),
                  DataCell(Text("22.1%")),
                ]),
                DataRow(cells: [
                  DataCell(Text("SHIBIN")),
                  DataCell(Text("132")),
                  DataCell(Text("125")),
                  DataCell(Text("26")),
                  DataCell(Text("21.2%")),
                ]),
                DataRow(cells: [
                  DataCell(Text("FINIYA")),
                  DataCell(Text("128")),
                  DataCell(Text("120")),
                  DataCell(Text("23")),
                  DataCell(Text("19.1%")),
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