import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class UsageHistoryPage extends StatefulWidget {
  final int userId;

  const UsageHistoryPage({
    super.key,
    required this.userId,
  });

  @override
  State<UsageHistoryPage> createState() => _UsageHistoryPageState();
}

class _UsageHistoryPageState extends State<UsageHistoryPage> {
  List<dynamic> records = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        Uri.parse(
          "$apiBaseUrl/usage_history.php",
        ),
        body: {
          "user_id": widget.userId.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data["success"] == true) {
        setState(() {
          records = data["records"] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          records = [];
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["message"] ?? "Unable to load history",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Connection error: $e",
          ),
        ),
      );
    }
  }

  String formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);

      return "${dateTime.day.toString().padLeft(2, '0')}/"
          "${dateTime.month.toString().padLeft(2, '0')}/"
          "${dateTime.year}";
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF5),

      appBar: AppBar(
        title: const Text(
          "Usage History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.green,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: loadHistory,
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: loadHistory,

        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )

            : records.isEmpty
                ? ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),

                    children: const [
                      SizedBox(height: 150),

                      Icon(
                        Icons.history,
                        size: 80,
                        color: Colors.green,
                      ),

                      SizedBox(height: 20),

                      Center(
                        child: Text(
                          "No Usage History",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      Center(
                        child: Text(
                          "Add plastic items to see them here.",
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  )

                : ListView.builder(
                    padding: const EdgeInsets.all(16),

                    itemCount: records.length,

                    itemBuilder: (context, index) {

                      final record = records[index];

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 15,
                        ),

                        elevation: 4,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(18),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              // ITEM NAME
                              Row(
                                children: [

                                  CircleAvatar(
                                    radius: 25,

                                    backgroundColor:
                                        Colors.green.shade100,

                                    child: const Icon(
                                      Icons.recycling,
                                      color: Colors.green,
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  Expanded(
                                    child: Text(
                                      record["item_name"]
                                          .toString(),

                                      style:
                                          const TextStyle(
                                        fontSize: 19,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              // CATEGORY
                              historyRow(
                                Icons.category,
                                "Category",
                                record["category"]
                                    .toString(),
                              ),

                              // WEIGHT
                              historyRow(
                                Icons.scale,
                                "Weight",
                                "${record["weight"]} g",
                              ),

                              // QUANTITY
                              historyRow(
                                Icons.numbers,
                                "Quantity",
                                record["quantity"]
                                    .toString(),
                              ),

                              // DATE
                              historyRow(
                                Icons.calendar_today,
                                "Date",
                                formatDate(
                                  record["usage_date"]
                                      .toString(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget historyRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [

          Icon(
            icon,
            size: 20,
            color: Colors.green,
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 85,

            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}