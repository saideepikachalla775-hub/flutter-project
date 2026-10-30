import 'package:flutter/material.dart';
import 'login_page.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF5),

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
    Padding(
      padding: const EdgeInsets.only(right: 12),
      child: TextButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        },

        icon: const Icon(
          Icons.login,
          color: Colors.white,
        ),

        label: const Text(
          "LOGIN",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ],
),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2E7D32),
                    Color(0xFF66BB6A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              child: Column(
                children: [
                  const Icon(
                    Icons.eco,
                    size: 70,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "PLASTIC USAGE TRACKER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Track Your Plastic. Protect Our Planet.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Explore Project"),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),

                 // About Project
            sectionTitle("About the Project"),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),

              child: const Text(
                "Plastic Usage Tracker is a Flutter-based mobile application "
                "designed to help users monitor and reduce their daily plastic "
                "consumption. Users can record plastic items, track quantity "
                "and weight, view usage history, monitor statistics, and set "
                "plastic reduction goals.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),

            // Objective
            sectionTitle("Project Objective"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.public,
                        size: 45,
                        color: Colors.green,
                      ),

                      SizedBox(height: 12),

                      Text(
                        "The main objective is to create awareness about "
                        "plastic consumption and encourage users to adopt "
                        "more sustainable habits.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Technology
            sectionTitle("Technologies Used"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      technologyRow(
                        Icons.phone_android,
                        "Flutter",
                        "Mobile application development",
                      ),

                      Divider(),

                      technologyRow(
                        Icons.code,
                        "Dart",
                        "Application programming language",
                      ),

                      Divider(),

                      technologyRow(
                        Icons.storage,
                        "Database",
                        "Store user and plastic usage data",
                      ),

                      Divider(),

                      technologyRow(
                        Icons.computer,
                        "VS Code",
                        "Development environment",
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Workflow
            sectionTitle("How the App Works"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Column(
                children: [
                  workflowStep(
                    "1",
                    "Login",
                    "User logs into the Plastic Usage Tracker.",
                  ),

                  workflowStep(
                    "2",
                    "Add Plastic",
                    "User enters plastic category, quantity and weight.",
                  ),

                  workflowStep(
                    "3",
                    "Track Usage",
                    "The application stores and displays plastic usage.",
                  ),

                  workflowStep(
                    "4",
                    "View Statistics",
                    "User can analyze their plastic consumption.",
                  ),

                  workflowStep(
                    "5",
                    "Reduce Usage",
                    "User sets reduction goals and explores alternatives.",
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 30),

              padding: const EdgeInsets.all(25),

              color: Colors.green.shade800,

              child: const Column(
                children: [
                  Icon(
                    Icons.eco,
                    color: Colors.white,
                    size: 35,
                  ),

                  SizedBox(height: 10),

                  Text(
                    "BUILD A GREENER FUTURE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Track your plastic. Reduce your impact.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30,
        bottom: 15,
      ),

      child: Text(
        title,
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }

  static Widget featureCard(
    IconData icon,
    String title,
    String description,
  ) {
    return Card(
      elevation: 3,

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              icon,
              size: 38,
              color: Colors.green,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget technologyRow(
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.green,
          size: 30,
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                description,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget workflowStep(
    String number,
    String title,
    String description,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(description),
      ),
    );
  }
}