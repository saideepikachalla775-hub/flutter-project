import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class AddPlasticPage extends StatefulWidget {
  final int userId;

  const AddPlasticPage({
    super.key,
    required this.userId,
  });

  @override
  State<AddPlasticPage> createState() => _AddPlasticPageState();
}

class _AddPlasticPageState extends State<AddPlasticPage> {
  final itemNameController = TextEditingController();
  final weightController = TextEditingController();
  final quantityController = TextEditingController();

  String selectedCategory = "Bottle";
  bool recycled = false;
  bool isLoading = false;

  final List<String> categories = [
    "Bottle",
    "Bag",
    "Food Packaging",
    "Container",
    "Cup",
    "Straw",
    "Utensil",
    "wrap",
    "spoon",
    "chair",
    "slippers",
    "toothbrush",
    "comb",
    "plate",
    "bangles",
    "toys",
    "Other",
  ];

  Future<void> addPlastic() async {
    String itemName = itemNameController.text.trim();
    String weight = weightController.text.trim();
    String quantity = quantityController.text.trim();

    if (itemName.isEmpty || weight.isEmpty || quantity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("$apiBaseUrl/add_plastic.php"),
        body: {
          "user_id": widget.userId.toString(),
          "category": selectedCategory,
          "item_name": itemNameController.text.trim(),
          "weight": weightController.text.trim(),
          "quantity": quantityController.text.trim(),
          "recycled": recycled ? "1" : "0",
        },
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Plastic added successfully!"),
          ),
        );
        Navigator.pop(context, true);
       }else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["message"] ?? "Failed to add plastic",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connection error: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    itemNameController.dispose();
    weightController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),

      appBar: AppBar(
        title: const Text("Add Plastic"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),

          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: Padding(
              padding: const EdgeInsets.all(25),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Icon(
                    Icons.recycling,
                    size: 70,
                    color: Colors.green,
                  ),
                
                  const SizedBox(height: 15),

                  const Text(
                    "Add Plastic Usage",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 25),

                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,

                    decoration: const InputDecoration(
                      labelText: "Category",
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),

                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: itemNameController,

                    decoration: const InputDecoration(
                      labelText: "Item Name",
                      hintText: "Example: Water Bottle",
                      prefixIcon: Icon(Icons.inventory_2),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: weightController,

                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      labelText: "Weight (grams)",
                      prefixIcon: Icon(Icons.scale),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: quantityController,

                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                const SizedBox(height: 18),
                  
                  DropdownButtonFormField<bool>(
                    initialValue: recycled,

                    decoration: const InputDecoration(
                      labelText: "Recycled?",
                      prefixIcon: Icon(Icons.recycling),
                      border: OutlineInputBorder(),
                    ),

                    items: const [
                      DropdownMenuItem<bool>(
                        value: true,
                        child: Text("Yes"),
                      ),
                      DropdownMenuItem<bool>(
                        value: false,
                        child: Text("No"),
                      ),
                    ],

                    onChanged: (value) {
                      setState(() {
                        recycled = value ?? false;
                      });
                    },
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : addPlastic,

                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.add),

                      label: Text(
                        isLoading
                            ? "ADDING..."
                            : "ADD PLASTIC",
                        style: const TextStyle(
                          fontSize: 16,
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
        ),
      ),
    );
  }
}