import 'package:flutter/material.dart';

class AlternativesPage extends StatelessWidget {
  const AlternativesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eco-Friendly Alternatives"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            const Text(
              "Choose a Greener Alternative",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Replace everyday plastic products with reusable "
              "and eco-friendly options.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            alternativeCard(
              Icons.water_drop,
              "Plastic Bottle",
              "Reusable Steel Bottle",
              "Carry a reusable bottle instead of buying "
              "single-use plastic bottles.",
            ),

            alternativeCard(
              Icons.shopping_bag,
              "Plastic Bag",
              "Cloth Bag",
              "Use a reusable cloth bag while shopping.",
            ),

            alternativeCard(
              Icons.local_drink,
              "Plastic Cup",
              "Reusable Cup",
              "Choose a reusable cup for daily beverages.",
            ),

            alternativeCard(
              Icons.inventory_2,
              "Plastic Container",
              "Glass Container",
              "Store food in reusable glass containers.",
            ),

            alternativeCard(
              Icons.restaurant,
              "Plastic Straw",
              "Steel or Bamboo Straw",
              "Use reusable straws instead of disposable "
              "plastic straws.",
            ),
             
            alternativeCard(
              Icons.fastfood,
              "Plastic Cutlery",
              "Metal Cutlery",
              "Carry metal cutlery for takeout meals.",
            ),

            alternativeCard(
              Icons.cake,
              "Plastic Wrap",
              "Beeswax Wrap",
              "Use beeswax wraps instead of plastic wrap "
              "for food storage.",
            ),
            alternativeCard(
              Icons.chair,
              "Plastic Chair",
              "Wooden or Bamboo Chair",
              "Choose sustainable seating options.",
            ),

            alternativeCard(
              Icons.toys,
              "Plastic Toys",
              "Wooden or Fabric Toys",
              "Opt for toys made from natural materials.",
            ),

            alternativeCard(
              Icons.cleaning_services,
              "Plastic Toothbrush",
              "Bamboo Toothbrush",
              "Switch to a bamboo toothbrush for oral care.",
            ),
            alternativeCard(
              Icons.content_cut,
              "Plastic Comb",
              "Wooden Comb",
              "Use a wooden comb instead of a plastic one.",
            ),
             alternativeCard(
              Icons.directions_walk,
              "Plastic Slippers",
              "Bamboo or Leather Slippers",
              "Choose sustainable footwear options.",
            ),
          ],
        ),
      ),
    );
  }

  Widget alternativeCard(
    IconData icon,
    String plasticItem,
    String alternative,
    String description,
  ) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.green.shade100,

              child: Icon(
                icon,
                size: 30,
                color: Colors.green,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    plasticItem,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "🌱 $alternative",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
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
}