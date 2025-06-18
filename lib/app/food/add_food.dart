import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddFoodScreen extends StatefulWidget {
  final CollectionReference<Map<String, dynamic>> foods;
  const AddFoodScreen({super.key, required this.foods});

  @override
  State<AddFoodScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddFoodScreen> {
  final chefNameController = TextEditingController();
  final menuNameController = TextEditingController();
  final ingredientsController = TextEditingController();
  final imageUrlController = TextEditingController();

  Future<void> addFood() async {
    final String chefName = chefNameController.text;
    final String menuName = menuNameController.text;
    final String ingredients = ingredientsController.text;
    final String imageUrl = imageUrlController.text;

    if (chefName.isNotEmpty &&
        menuName.isNotEmpty &&
        ingredients.isNotEmpty &&
        imageUrl.isNotEmpty) {
      chefNameController.clear();
      menuNameController.clear();
      ingredientsController.clear();
      imageUrlController.clear();

      // เพิ่มข้อมูล
      await widget.foods.add({
        "chef": {"name": chefName},
        "menu_name": menuName,
        "ingredients": ingredients,
        "image_url": imageUrl,
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มรายการอาหาร')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: chefNameController,
              decoration: InputDecoration(labelText: 'ชื่อ - เชฟ'),
            ),
            TextField(
              controller: menuNameController,
              decoration: InputDecoration(labelText: 'เมนู'),
            ),
            TextField(
              controller: ingredientsController,
              decoration: InputDecoration(labelText: 'ส่วนผสม'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'รูปอาหาร'),
            ),

            SizedBox(height: 20),
            ElevatedButton(onPressed: addFood, child: Text('เพิ่มรายการอาหาร')),
          ],
        ),
      ),
    );
  }
}
