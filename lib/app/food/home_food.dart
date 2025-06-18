import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/food/add_food.dart';
import 'package:flutter_application_1/app/food/detailed.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map> thaiFoods = [];

  String name = '';

  // collection foods
  final foods = FirebaseFirestore.instance.collection('foods');

  // อ่านข้อมูล
  Stream<QuerySnapshot> getFoods() {
    if (name.isEmpty) return foods.snapshots();
    return foods.where("menu_name", isEqualTo: name).snapshots();
  }

  void getFoodsByName(String newName) {
    name = newName;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  cursorColor: Colors.black,
                  onChanged: getFoodsByName,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade500),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    hintText: 'ค้นหาอาหาร',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder(
                    stream: getFoods(),
                    builder: (context, asyncSnapshot) {
                      if (!asyncSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final docs = asyncSnapshot.data!.docs;

                      return ListView.separated(
                        itemCount: docs.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemBuilder: (context, index) {
                          Map thaiFood =
                              docs[index].data() as Map<String, dynamic>;
                          Map chef = thaiFood['chef'];
                          String chefName = chef['name'];
                          String imageUrl = thaiFood['image_url'];
                          String menuName = thaiFood['menu_name'];
                          String ingredients = thaiFood['ingredients'];
                          return InkWell(
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => Detailed(thaiFood: thaiFood),
                                ),
                              );
                            },
                            child: Container(
                              height: 220,
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chefName,
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: Colors.grey),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            menuName,
                                            maxLines: 2,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.headlineMedium,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            ingredients,
                                            maxLines: 3,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Hero(
                                      tag: imageUrl,
                                      child: Image.network(
                                        imageUrl,
                                        height: 220,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                height: 220,
                                                color: Colors.grey.shade500,
                                                child: const Icon(
                                                  Icons.photo_outlined,
                                                  color: Colors.white,
                                                  size: 50,
                                                ),
                                              );
                                            },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                height: 220,
                                                color: Colors.grey.shade500,
                                                child: const Icon(
                                                  Icons.error_outline,
                                                  color: Colors.white,
                                                  size: 50,
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddFoodScreen(foods: foods)),
            );
          },
        ),
      ),
    );
  }
}
