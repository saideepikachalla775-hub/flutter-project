import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'add_plastic_page.dart';
import 'usage_history_page.dart';
import 'statistics_page.dart';
import 'reduction_goals_page.dart';
import 'alternatives_page.dart';
import 'api_config.dart';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({
    super.key,
    required this.userId,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --------------------------------------------------
  // DASHBOARD DATA
  // --------------------------------------------------

  int totalItems = 0;
  double totalWeight = 0;
  int daysTracked = 0;
  int ecoScore= 100;
  int recycled = 0;

  bool isLoading = true;

  // --------------------------------------------------
  // LOAD DASHBOARD DATA
  // --------------------------------------------------

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        Uri.parse("$apiBaseUrl/dashboard.php"),
        body: {
          "user_id": widget.userId.toString(),
        },
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        if (!mounted) return;

        setState(() {
          totalItems = (data["total_items"] ?? 0) as int;
          totalWeight = (data["total_weight"] ?? 0).toDouble();
          daysTracked = (data["days_tracked"] ?? 0) as int;
          ecoScore = (data["eco_score"] ?? 100) as int;
          recycled = (data["recycled"] ?? 0) as int;
          isLoading = false;
        });
      } else {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["message"] ?? "Unable to load dashboard",
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
            "Dashboard connection error: $e",
          ),
        ),
      );
    }
  }

  // --------------------------------------------------
  // OPEN ADD PLASTIC PAGE
  // --------------------------------------------------

  Future<void> openAddPlasticPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPlasticPage(
          userId: widget.userId,
        ),
      ),
    );

    // If plastic was successfully added,
    // reload dashboard data.
    if (result == true) {
      loadDashboard();
    }
  }

  Future<void> openUsageHistoryPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UsageHistoryPage(
          userId: widget.userId,
        ),
      ),
    );

    if (result == true) {
      loadDashboard();
    }
  }

  // --------------------------------------------------
  // LOGOUT
  // --------------------------------------------------

  void logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/portfolio',
      (route) => false,
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF5),

      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------

      appBar: AppBar(
        title: const Text(
          "Plastic Usage Tracker",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: logout,
          ),
        ],
      ),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------

      body: RefreshIndicator(
        onRefresh: loadDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // --------------------------------------------------
              // WELCOME SECTION
              // --------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2E7D32),
                      Color(0xFF66BB6A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Icon(
                      Icons.eco,
                      color: Colors.white,
                      size: 45,
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Welcome Back! 🌱",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Track your plastic usage and build a greener future.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --------------------------------------------------
              // DASHBOARD TITLE
              // --------------------------------------------------

              const Text(
                "Your Plastic Dashboard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),

              const SizedBox(height: 15),

              // --------------------------------------------------
              // LOADING INDICATOR
              // --------------------------------------------------

              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                ),

              // --------------------------------------------------
              // STATISTICS CARDS
              // --------------------------------------------------

              if (!isLoading) ...[

                Row(
                  children: [

                    Expanded(
                      child: statisticCard(
                        Icons.shopping_bag,
                        totalItems.toString(),
                        "Plastic Items",
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: statisticCard(
                        Icons.scale,
                        formatWeight(totalWeight),
                        "Total Weight",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [

                    Expanded(
                      child: statisticCard(
                        Icons.calendar_today,
                        daysTracked.toString(),
                        "Days Tracked",
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: statisticCard(
                        Icons.recycling,
                        recycled.toString(),
                        "Recycled",
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 30),

              // --------------------------------------------------
              // FEATURES
              // --------------------------------------------------

              const Text(
                "Manage Your Plastic Usage",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),

              const SizedBox(height: 15),

              // ADD PLASTIC

              featureCard(
                context,
                Icons.add_circle,
                "Add Plastic",
                "Record a new plastic item and its weight.",
                openAddPlasticPage,
              ),

              // USAGE HISTORY

              featureCard(
                context,
                Icons.history,
                "Usage History",
                "View your previously recorded plastic usage.",
                (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsageHistoryPage(
                        userId: widget.userId,
                      ),
                    ),
                  );
                }
              ),

              // STATISTICS

              featureCard(
                context,
                Icons.bar_chart,
                "Statistics",
                "Analyze your plastic consumption.",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatisticsPage(
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
              ),

              // REDUCTION GOALS

              featureCard(
                context,
                Icons.flag,
                "Reduction Goals",
                "Set goals to reduce your plastic usage.",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReductionGoalsPage(
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
              ),

              // ALTERNATIVES

              featureCard(
                context,
                Icons.eco,
                "Eco-Friendly Alternatives",
                "Discover alternatives to plastic products.",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlternativesPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // ECO SCORE
              // --------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),

                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black12,
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    const Text(
                      "Your Eco Score",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "$ecoScore%",
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      getEcoMessage(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --------------------------------------------------
              // FOOTER
              // --------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: const Column(
                  children: [

                    Icon(
                      Icons.eco,
                      color: Colors.white,
                      size: 35,
                    ),

                    SizedBox(height: 8),

                    Text(
                      "BUILD A GREENER FUTURE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Track your plastic. Reduce your impact.",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // ECO MESSAGE
  // --------------------------------------------------

  String getEcoMessage() {
    if (ecoScore >= 80) {
      return "Excellent! Your habits are helping reduce plastic waste.";
    }
    if (ecoScore >= 60) {
      return "Great progress! You’re on track to reduce plastic waste.";
    }
    if (ecoScore >= 40) {
      return "You are making progress. Small changes can make a big difference.";
    }
    return "There is room to improve. Start by reducing single-use plastic.";
  }

  // --------------------------------------------------
  // FORMAT WEIGHT
  // --------------------------------------------------

  String formatWeight(double weight) {
    if (weight >= 1000) {
      return "${(weight / 1000).toStringAsFixed(2)} kg";
    }

    return "${weight.toStringAsFixed(1)} g";
  }

  // --------------------------------------------------
  // STATISTIC CARD
  // --------------------------------------------------

  Widget statisticCard(
    IconData icon,
    String value,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black12,
          ),
        ],
      ),

      child: Column(
        children: [

          Icon(
            icon,
            color: Colors.green,
            size: 35,
          ),

          const SizedBox(height: 8),

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
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // FEATURE CARD
  // --------------------------------------------------

  Widget featureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    VoidCallback onPressed,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,

          child: Icon(
            icon,
            color: Colors.green,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        subtitle: Text(description),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.green,
        ),

        onTap: onPressed,
      ),
    );
  }

  // --------------------------------------------------
  // MESSAGE
  // --------------------------------------------------

  void showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}