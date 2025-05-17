import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: StaffMenu());
  }
}

class StaffMenu extends StatefulWidget {
  const StaffMenu({super.key});

  @override
  State<StaffMenu> createState() => _StaffMenuState();
}

class _StaffMenuState extends State<StaffMenu> {
  final List<FoodItem> _foodItems = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _vegOnly = false;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                            childAspectRatio: 0.75, // Adjusted aspect ratio
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
    );
  }

  Widget _buildFoodCard(FoodItem item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3, // Adjusted image space
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        const Center(child: Icon(Icons.fastfood, size: 60)),
              ),
            ),
          ),
          Expanded(
            flex: 2, // Adjusted space for text
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 4),
                  Text(
                    'Rs. ${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        item.isAvailable ? Icons.check_circle : Icons.cancel,
                        color: item.isAvailable ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
