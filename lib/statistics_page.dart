import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class StatisticsPage extends StatefulWidget {
  final int userId;

  const StatisticsPage({super.key, required this.userId});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool isLoading = true;

  int totalItems = 0;
  double totalWeight = 0;
  int daysTracked = 0;
  int recycledItems = 0;
  int notRecycledItems = 0;

  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("$apiBaseUrl/statistics.php"),
        body: {"user_id": widget.userId.toString()},
      );

      print("STATISTICS STATUS: ${response.statusCode}");
      print("STATISTICS RESPONSE: ${response.body}");

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        setState(() {
          totalItems = int.tryParse(data["total_items"].toString()) ?? 0;

          totalWeight = double.tryParse(data["total_weight"].toString()) ?? 0;

          daysTracked = int.tryParse(data["days_tracked"].toString()) ?? 0;

          recycledItems = int.tryParse(data["recycled_items"].toString()) ?? 0;

          notRecycledItems = int.tryParse(data["not_recycled"].toString()) ?? 0;

          categories = data["categories"] ?? [];

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });

        showMessage(data["message"] ?? "Failed to load statistics");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print("STATISTICS ERROR: $e");

      showMessage("Connection error: $e");
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),

      appBar: AppBar(
        title: const Text("Statistics"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadStatistics,
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : RefreshIndicator(
              onRefresh: loadStatistics,

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    // -------------------------
                    // TITLE
                    // -------------------------

                    const Text(
                      "Your Plastic Statistics",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // -------------------------
                    // SUMMARY CARDS
                    // -------------------------
                    Row(
                      children: [
                        Expanded(
                          child: summaryCard(
                            "Total Items",
                            totalItems.toString(),
                            Icons.inventory_2,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: summaryCard(
                            "Weight",
                            "${totalWeight.toStringAsFixed(1)} g",
                            Icons.scale,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: summaryCard(
                            "Days Tracked",
                            daysTracked.toString(),
                            Icons.calendar_month,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: summaryCard(
                            "Recycled",
                            recycledItems.toString(),
                            Icons.recycling,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // -------------------------
                    // BAR CHART
                    // -------------------------
                    sectionTitle("Plastic Usage by Category"),

                    const SizedBox(height: 15),

                    Container(
                      height: 350,
                      padding: const EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(blurRadius: 8, color: Colors.black12),
                        ],
                      ),

                      child: categories.isEmpty
                          ? const Center(
                              child: Text("No category data available"),
                            )
                          : BarChart(buildBarChart()),
                    ),

                    const SizedBox(height: 30),

                    // -------------------------
                    // PIE CHART
                    // -------------------------
                    sectionTitle("Recycling Status"),

                    const SizedBox(height: 15),

                    Container(
                      height: 360,
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(blurRadius: 8, color: Colors.black12),
                        ],
                      ),

                      child: buildPieChart(),
                    ),

                    const SizedBox(height: 30),

                    // -------------------------
                    // RECYCLING DETAILS
                    // -------------------------
                    sectionTitle("Recycling Details"),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: detailCard(
                            "Recycled",
                            recycledItems,
                            Icons.recycling,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: detailCard(
                            "Not Recycled",
                            notRecycledItems,
                            Icons.delete_outline,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  // =========================================================
  // SUMMARY CARD
  // =========================================================

  Widget summaryCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),

      child: Column(
        children: [
          Icon(icon, size: 35, color: Colors.green),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,

      child: Text(
        title,
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  // =========================================================
  // BAR CHART
  // =========================================================

  BarChartData buildBarChart() {
    double maxValue = 10;

    if (categories.isNotEmpty) {
      maxValue = categories
          .map((item) => double.tryParse(item["quantity"].toString()) ?? 0)
          .fold(0.0, (a, b) => a > b ? a : b);

      maxValue = maxValue + 5;

      if (maxValue < 10) {
        maxValue = 10;
      }
    }

    return BarChartData(
      maxY: maxValue,

      alignment: BarChartAlignment.spaceAround,

      gridData: FlGridData(show: true),

      borderData: FlBorderData(show: false),

      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),

        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 35),
        ),

        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,

            reservedSize: 55,

            getTitlesWidget: (value, meta) {
              int index = value.toInt();

              if (index < 0 || index >= categories.length) {
                return const SizedBox();
              }

              String category = categories[index]["category"].toString();

              return SideTitleWidget(
                axisSide: meta.axisSide,

                child: Text(
                  category,
                  style: const TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),

      barGroups: List.generate(categories.length, (index) {
        double quantity =
            double.tryParse(categories[index]["quantity"].toString()) ?? 0;

        return BarChartGroupData(
          x: index,

          barRods: [
            BarChartRodData(
              toY: quantity,
              width: 25,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        );
      }),
    );
  }

  // =========================================================
  // PIE CHART
  // =========================================================

  Widget buildPieChart() {
    int total = recycledItems + notRecycledItems;

    if (total == 0) {
      return const Center(child: Text("No recycling data available"));
    }

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,

              centerSpaceRadius: 45,

              sections: [
                PieChartSectionData(
                  value: recycledItems.toDouble(),
                  title: "${recycledPercentage()}%",
                  radius: 90,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                PieChartSectionData(
                  value: notRecycledItems.toDouble(),
                  title: "${notRecycledPercentage()}%",
                  radius: 90,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 15),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            legendItem("Recycled", recycledItems),

            const SizedBox(width: 25),

            legendItem("Not Recycled", notRecycledItems),
          ],
        ),
      ],
    );
  }

  // =========================================================
  // PERCENTAGES
  // =========================================================

  int recycledPercentage() {
    int total = recycledItems + notRecycledItems;

    if (total == 0) {
      return 0;
    }

    return ((recycledItems / total) * 100).round();
  }

  int notRecycledPercentage() {
    int total = recycledItems + notRecycledItems;

    if (total == 0) {
      return 0;
    }

    return ((notRecycledItems / total) * 100).round();
  }

  // =========================================================
  // LEGEND
  // =========================================================

  Widget legendItem(String title, int value) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: title == "Recycled" ? Colors.green : Colors.red,
          ),
        ),

        const SizedBox(width: 7),

        Text(
          "$title: $value",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // =========================================================
  // DETAIL CARD
  // =========================================================

  Widget detailCard(String title, int value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),

      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.green),

          const SizedBox(height: 10),

          Text(
            value.toString(),
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
