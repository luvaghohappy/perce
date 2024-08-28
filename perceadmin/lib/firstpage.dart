import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'mespages/select.dart';

class Myfirstpage extends StatefulWidget {
  const Myfirstpage({Key? key}) : super(key: key);

  @override
  State<Myfirstpage> createState() => _MyfirstpageState();
}

class _MyfirstpageState extends State<Myfirstpage> {
  List<Map<String, dynamic>> items = [];
  List<TableInfo> tableInfoList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.43.149:81/MRG/state.php"),
      );
      setState(() {
        items = List<Map<String, dynamic>>.from(json.decode(response.body));
        tableInfoList = items
            .map((item) => TableInfo(
                  tableName: capitalize(item['table_names']),
                  recordCount: int.parse(item['record_count']),
                ))
            .toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load items'),
        ),
      );
    }
  }

  String capitalize(String s) {
    return s.isNotEmpty
        ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}'
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Statistiques des activites',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const InsertAdmin(),
              ));
            },
            icon: const Icon(Icons.person_2_outlined),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Column for Cards at the beginning
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  for (var tableInfo in tableInfoList)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildStatisticsCard(
                          tableInfo.tableName, tableInfo.recordCount),
                    ),
                ],
              ),

              // Centered PieChart
              Container(
                height: 400,
                width: 600,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.shade200),
                child: PieChart(
                  PieChartData(
                    sections: showingSections(),
                    centerSpaceRadius: 40,
                    sectionsSpace: 0,
                  ),
                ),
              ),

              // Column for Indicators at the end
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tableInfoList.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final TableInfo tableInfo = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Indicator(
                          color:
                              Colors.primaries[index % Colors.primaries.length],
                          text: tableInfo.tableName,
                          isSquare: true,
                          size: 18,
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return tableInfoList.asMap().entries.map((entry) {
      final int index = entry.key;
      final TableInfo tableInfo = entry.value;
      final isTouched = index == -1;
      final double fontSize = isTouched ? 25.0 : 16.0;
      final double radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: Colors.primaries[index % Colors.primaries.length],
        value: tableInfo.recordCount.toDouble(),
        title: '${tableInfo.recordCount}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildStatisticsCard(String title, int count) {
    return Container(
      height: 100,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Text(
              count.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class TableInfo {
  final String tableName;
  final int recordCount;

  TableInfo({
    required this.tableName,
    required this.recordCount,
  });
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = false,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
