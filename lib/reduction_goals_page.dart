import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class ReductionGoalsPage extends StatefulWidget {
  final int userId;

  const ReductionGoalsPage({super.key, required this.userId});

  @override
  State<ReductionGoalsPage> createState() => _ReductionGoalsPageState();
}

class _ReductionGoalsPageState extends State<ReductionGoalsPage> {
  final targetController = TextEditingController();

  double currentUsage = 0;
  double targetUsage = 0;

  bool loading = true;
  bool saving = false;

  final String apiUrl = "$apiBaseUrl/reduction_goal.php";

  @override
  void initState() {
    super.initState();
    loadGoalData();
  }

  // ============================================================
  // LOAD CURRENT USAGE + GOAL
  // ============================================================

  Future<void> loadGoalData() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"user_id": widget.userId.toString()},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw http.ClientException(
          "Server returned HTTP ${response.statusCode}",
          Uri.parse(apiUrl),
        );
      }

      final data = _decodeResponse(response.body);
      if (data["success"] != true) {
        showMessage(data["message"]?.toString() ?? "Failed to load data");
        return;
      }

      if (!mounted) return;
      setState(() {
        currentUsage =
            double.tryParse(data["current_usage"].toString()) ?? 0;
        targetUsage = double.tryParse(data["target_usage"].toString()) ?? 0;

        if (targetUsage > 0) {
          targetController.text = targetUsage.toStringAsFixed(0);
        }
      });
    } on TimeoutException {
      showMessage("Server did not respond within 15 seconds.");
    } on http.ClientException catch (error) {
      showMessage("Could not reach the server: ${error.message}");
    } on FormatException {
      showMessage(
        "The server returned an invalid response. Check the PHP endpoint and database.",
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // ============================================================
  // SAVE GOAL
  // ============================================================

  Future<void> setGoal() async {
    if (targetController.text.trim().isEmpty) {
      showMessage("Please enter your target");
      return;
    }

    final target = double.tryParse(targetController.text.trim());

    if (target == null || target <= 0) {
      showMessage("Please enter a valid target");
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "user_id": widget.userId.toString(),
          "target_usage": target.toString(),
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw http.ClientException(
          "Server returned HTTP ${response.statusCode}",
          Uri.parse(apiUrl),
        );
      }

      final data = _decodeResponse(response.body);
      if (data["success"] != true) {
        showMessage(data["message"]?.toString() ?? "Failed to save goal");
        return;
      }

      if (!mounted) return;
      setState(() {
        targetUsage = target;
      });
      showMessage("Reduction goal saved successfully!");
    } on TimeoutException {
      showMessage("Server did not respond within 15 seconds.");
    } on http.ClientException catch (error) {
      showMessage("Could not reach the server: ${error.message}");
    } on FormatException {
      showMessage(
        "The server returned an invalid response. Check the PHP endpoint and database.",
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  Map<String, dynamic> _decodeResponse(String responseBody) {
    final decoded = jsonDecode(responseBody);
    if (decoded is Map<String, dynamic>) return decoded;
    throw const FormatException("Expected a JSON object");
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  double get progress {
    if (targetUsage <= 0) {
      return 0;
    }

    double value = currentUsage / targetUsage;

    if (value > 1) {
      return 1;
    }

    return value;
  }

  String get progressText {
    if (targetUsage <= 0) {
      return "Set a reduction goal to start tracking.";
    }

    if (currentUsage <= targetUsage) {
      return "Great! You are within your target.";
    }

    final excess = currentUsage - targetUsage;

    return "You are ${excess.toStringAsFixed(0)} items above your target.";
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    targetController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),

      appBar: AppBar(
        title: const Text("Reduction Goals"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            onPressed: loading ? null : loadGoalData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : RefreshIndicator(
              onRefresh: loadGoalData,

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                padding: const EdgeInsets.all(20),

                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,

                      children: [
                        // ==================================================
                        // HEADER
                        // ==================================================

                        Card(
                          elevation: 5,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(25),

                            child: Column(
                              children: const [
                                Icon(Icons.eco, size: 70, color: Colors.green),

                                SizedBox(height: 15),

                                Text(
                                  "Reduce Your Plastic Usage",
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),

                                SizedBox(height: 10),

                                Text(
                                  "Set a personal target and "
                                  "track your plastic usage.",
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // USAGE CARDS
                        // ==================================================
                        Row(
                          children: [
                            Expanded(
                              child: _infoCard(
                                "Current Usage",
                                "${currentUsage.toStringAsFixed(0)} items",
                                Icons.delete_outline,
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: _infoCard(
                                "Target",
                                targetUsage > 0
                                    ? "${targetUsage.toStringAsFixed(0)} items"
                                    : "Not Set",
                                Icons.flag,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // SET GOAL
                        // ==================================================
                        Card(
                          elevation: 5,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(20),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                const Text(
                                  "Set Your Reduction Goal",

                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                TextField(
                                  controller: targetController,

                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),

                                  decoration: const InputDecoration(
                                    labelText: "Target Plastic Items",
                                    hintText: "Example: 20",
                                    prefixIcon: Icon(Icons.flag),
                                    border: OutlineInputBorder(),
                                  ),
                                ),

                                const SizedBox(height: 15),

                                SizedBox(
                                  width: double.infinity,
                                  height: 50,

                                  child: ElevatedButton.icon(
                                    onPressed: saving ? null : setGoal,

                                    icon: saving
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Icon(Icons.save),

                                    label: Text(
                                      saving
                                          ? "SAVING..."
                                          : targetUsage > 0
                                          ? "UPDATE GOAL"
                                          : "SET GOAL",

                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,

                                      foregroundColor: Colors.white,

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // PROGRESS
                        // ==================================================
                        Card(
                          elevation: 5,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(20),

                            child: Column(
                              children: [
                                const Text(
                                  "Goal Progress",

                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Stack(
                                  alignment: Alignment.center,

                                  children: [
                                    SizedBox(
                                      width: 180,
                                      height: 180,

                                      child: CircularProgressIndicator(
                                        value: progress,

                                        strokeWidth: 16,

                                        backgroundColor: Colors.grey.shade300,

                                        color: progress >= 1
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),

                                    Column(
                                      children: [
                                        Text(
                                          "${(progress * 100).toStringAsFixed(0)}%",

                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: progress >= 1
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Text(
                                          targetUsage > 0
                                              ? "${currentUsage.toStringAsFixed(0)} / ${targetUsage.toStringAsFixed(0)}"
                                              : "No target",

                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                Text(
                                  progressText,

                                  textAlign: TextAlign.center,

                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ==================================================
                        // REDUCTION TIPS
                        // ==================================================
                        Card(
                          elevation: 4,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(20),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                const Text(
                                  "💡 Tips to Reduce Plastic",

                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                _tip("Use reusable water bottles"),

                                _tip("Carry reusable shopping bags"),

                                _tip("Avoid unnecessary plastic packaging"),

                                _tip("Reuse plastic containers when possible"),

                                _tip("Choose reusable alternatives"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _infoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [
            Icon(icon, size: 35, color: Colors.green),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,

              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 5),

            Text(
              value,
              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TIP
  // ============================================================

  Widget _tip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),

      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),

          const SizedBox(width: 10),

          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
