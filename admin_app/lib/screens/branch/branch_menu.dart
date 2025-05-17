import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BranchMenu extends StatefulWidget {
  const BranchMenu({super.key});

  @override
  State<BranchMenu> createState() => _BranchMenuState();
}

class _BranchMenuState extends State<BranchMenu> {
  final List<FoodItem> _foodItems = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _vegOnly = false;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
    _listenToFoodItems();
    _foodItems.addAll([
      FoodItem(
        id: '1',
        name: 'Margherita Pizza',
        description: 'Classic pizza with tomato sauce and mozzarella',
        price: 150.0,
        category: 'Pizza',
        imageUrl:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
        isAvailable: true,
        isVeg: true,
        createdAt: DateTime.now(),
      ),
      FoodItem(
        id: '2',
        name: 'Caesar Salad',
        description: 'Fresh romaine lettuce with Caesar dressing',
        price: 100.0,
        category: 'Salad',
        imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1',
        isAvailable: true,
        isVeg: true,
        createdAt: DateTime.now(),
      ),
      FoodItem(
        id: '3',
        name: 'Chicken Burger',
        description: 'Juicy chicken patty with fresh vegetables',
        price: 80.0,
        category: 'Burger',
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
        isAvailable: true,
        isVeg: false,
        createdAt: DateTime.now(),
      ),
    ]);
  }

  void _fetchFoodItems() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('foodItems').get();
      setState(() {
        _foodItems.clear();
        _foodItems.addAll(
          snapshot.docs.map((doc) {
            return FoodItem(
              id: doc['id'],
              name: doc['name'],
              description: doc['description'],
              price: doc['price'],
              category: doc['category'],
              imageUrl: doc['imageUrl'],
              isAvailable: doc['isAvailable'],
              isVeg: doc['isVeg'],
              createdAt: DateTime.parse(doc['createdAt']),
            );
          }).toList(),
        );
      });
    } catch (error) {
      print("Error fetching food items: $error");
    }
  }

  void _listenToFoodItems() {
    FirebaseFirestore.instance.collection('foodItems').snapshots().listen((
      snapshot,
    ) {
      setState(() {
        _foodItems.clear();
        _foodItems.addAll(
          snapshot.docs.map((doc) {
            return FoodItem(
              id: doc['id'],
              name: doc['name'],
              description: doc['description'],
              price: doc['price'],
              category: doc['category'],
              imageUrl: doc['imageUrl'],
              isAvailable: doc['isAvailable'],
              isVeg: doc['isVeg'],
              createdAt: DateTime.parse(doc['createdAt']),
            );
          }).toList(),
        );
      });
    });
  }

  List<FoodItem> get _filteredItems {
    return _foodItems.where((item) {
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesVegFilter = !_vegOnly || item.isVeg;
      return matchesSearch && matchesCategory && matchesVegFilter;
    }).toList();
  }

  List<String> get _categories {
    final categories = _foodItems.map((e) => e.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  // Function to add a new food item
  void _addFoodItem(FoodItem newItem) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('foodItems')
          .doc(newItem.id);
      await docRef.set({
        'id': newItem.id,
        'name': newItem.name,
        'description': newItem.description,
        'price': newItem.price,
        'category': newItem.category,
        'imageUrl': newItem.imageUrl,
        'isAvailable': newItem.isAvailable,
        'isVeg': newItem.isVeg,
        'createdAt': newItem.createdAt.toIso8601String(),
      });
      setState(() {
        _foodItems.add(newItem);
      });
    } catch (error) {
      print("Error adding food item: $error");
    }
  }

  // Function to update an existing food item
  void _updateFoodItem(String id, FoodItem updatedItem) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('foodItems').doc(id);
      await docRef.update({
        'name': updatedItem.name,
        'description': updatedItem.description,
        'price': updatedItem.price,
        'category': updatedItem.category,
        'imageUrl': updatedItem.imageUrl,
        'isAvailable': updatedItem.isAvailable,
        'isVeg': updatedItem.isVeg,
        'createdAt': updatedItem.createdAt.toIso8601String(),
      });
      setState(() {
        final index = _foodItems.indexWhere((item) => item.id == id);
        if (index != -1) {
          _foodItems[index] = updatedItem;
        }
      });
    } catch (error) {
      print("Error updating food item: $error");
    }
  }

  // Function to delete a food item
  void _deleteFoodItem(String id) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('foodItems').doc(id);
      await docRef.delete();
      setState(() {
        _foodItems.removeWhere((item) => item.id == id);
      });
    } catch (error) {
      print("Error deleting food item: $error");
    }
  }

  // Function to show the dialog to add/edit a food item
  void _showFoodItemDialog({FoodItem? foodItem}) {
    final TextEditingController nameController = TextEditingController(
      text: foodItem?.name,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: foodItem?.description,
    );
    final TextEditingController priceController = TextEditingController(
      text: foodItem?.price.toString(),
    );
    final TextEditingController imageUrlController = TextEditingController(
      text: foodItem?.imageUrl,
    );
    final TextEditingController categoryController = TextEditingController(
      text: foodItem?.category,
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(foodItem == null ? 'Add New Item' : 'Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text;
                    final description = descriptionController.text;
                    final price = double.tryParse(priceController.text) ?? 0.0;
                    final imageUrl = imageUrlController.text;
                    final category = categoryController.text;

                    if (foodItem == null) {
                      final newItem = FoodItem(
                        id: DateTime.now().toString(),
                        name: name,
                        description: description,
                        price: price,
                        category: category,
                        imageUrl: imageUrl,
                        isAvailable: true,
                        isVeg: true, // Assume new item is veg for simplicity
                        createdAt: DateTime.now(),
                      );
                      _addFoodItem(newItem);
                    } else {
                      final updatedItem = FoodItem(
                        id: foodItem.id,
                        name: name,
                        description: description,
                        price: price,
                        category: category,
                        imageUrl: imageUrl,
                        isAvailable: foodItem.isAvailable,
                        isVeg: foodItem.isVeg,
                        createdAt: foodItem.createdAt,
                      );
                      _updateFoodItem(foodItem.id, updatedItem);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(foodItem == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0000FF),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Menu',
          style: TextStyle(
            fontFamily: 'InknutAntiqua',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search menu items...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(category),
                                selected: _selectedCategory == category,
                                onSelected:
                                    (selected) => setState(
                                      () =>
                                          _selectedCategory =
                                              selected ? category : 'All',
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Switch(
                      value: _vegOnly,
                      onChanged: (value) => setState(() => _vegOnly = value),
                      activeColor: Colors.green,
                    ),
                    const Text('Veg Only'),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _filteredItems.isEmpty
                    ? const Center(
                      child: Text(
                        'No items found',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.85, // Adjusted aspect ratio
                          ),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return _buildFoodCard(item);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFoodItemDialog(); // Show the dialog to add a new item
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFoodCard(FoodItem item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 350, // Increase the height of the card
        child: Stack(
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                item.imageUrl,
                width: double.infinity,
                height: 220, // Adjust the height of the image
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        const Center(child: Icon(Icons.fastfood, size: 60)),
              ),
            ),
            // Edit and Delete Icons over the image
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white, size: 24),
                    onPressed: () {
                      _showFoodItemDialog(foodItem: item); // Edit item
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.white, size: 24),
                    onPressed: () {
                      _deleteFoodItem(item.id); // Delete item
                    },
                  ),
                ],
              ),
            ),
            // Food Details Section (Text, Price, Category, etc.)
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.8,
                  ), // Semi-transparent background for text
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Veg/Non-Veg indicator
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: item.isVeg ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.category,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final bool isVeg;
  final DateTime createdAt;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.isAvailable,
    required this.isVeg,
    required this.createdAt,
  });
}
