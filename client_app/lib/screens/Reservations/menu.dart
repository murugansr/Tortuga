import 'package:client_app/screens/Reservations/pticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuScreen(
        tableNumber: 1,
        capacity: 4,
        reservationDate: DateTime.now(),
        reservationTime: '7:00 PM',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuScreen extends StatefulWidget {
  final int tableNumber;
  final int capacity;
  final DateTime reservationDate;
  final String reservationTime;

  const MenuScreen({
    super.key,
    required this.tableNumber,
    required this.capacity,
    required this.reservationDate,
    required this.reservationTime,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<FoodItem> _foodItems = [];
  final Map<FoodItem, int> _cartItems = {};
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

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final cartItems = _cartItems.entries.toList();
        double total = 0;
        for (var entry in cartItems) {
          total += entry.key.price * entry.value;
        }
        return Container(
          padding: const EdgeInsets.all(16),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Cart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child:
                    cartItems.isEmpty
                        ? const Center(child: Text('Cart is empty'))
                        : ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index].key;
                            final qty = cartItems[index].value;
                            return ListTile(
                              title: Text(item.name),
                              subtitle: Text(
                                '₹${item.price.toStringAsFixed(2)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (_cartItems[item]! > 1) {
                                          _cartItems[item] =
                                              _cartItems[item]! - 1;
                                        } else {
                                          _cartItems.remove(item);
                                        }
                                      });
                                      Navigator.pop(context);
                                      _showCartBottomSheet();
                                    },
                                  ),
                                  Text('$qty'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _cartItems[item] =
                                            _cartItems[item]! + 1;
                                      });
                                      Navigator.pop(context);
                                      _showCartBottomSheet();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
              const Divider(),
              Text(
                'Total: ₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_cartItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Your cart is empty!')),
                    );
                    return;
                  }

                  try {
                    // Calculate total
                    double total = 0;
                    final List<Map<String, dynamic>> foodItems = [];

                    _cartItems.forEach((item, quantity) {
                      total += item.price * quantity;
                      foodItems.add({
                        'name': item.name,
                        'price': item.price,
                        'quantity': quantity,
                      });
                    });

                    // Save to Firestore
                    await FirebaseFirestore.instance.collection('ticket').add({
                      'tableNumber': widget.tableNumber,
                      'reservationDate':
                          widget.reservationDate.toIso8601String(),
                      'reservationTime': widget.reservationTime,
                      'foodItems': foodItems,
                      'totalAmount': total,
                    });

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order confirmed successfully!'),
                      ),
                    );

                    // Navigate to ticket screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => TableTicket(
                              orderData: {
                                'tableNumber': widget.tableNumber,
                                'reservationDate':
                                    widget.reservationDate.toIso8601String(),
                                'reservationTime': widget.reservationTime,
                                'foodItems': foodItems,
                                'totalAmount': total,
                              },
                            ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Confirm Order',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addToCart(FoodItem item) {
    setState(() {
      _cartItems[item] = (_cartItems[item] ?? 0) + 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: _showCartBottomSheet,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF44C5F4),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Menu',
          style: TextStyle(
            fontFamily: 'InknutAntiqua',
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: _showCartBottomSheet,
          ),
        ],
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
                                    (_) => setState(
                                      () => _selectedCategory = category,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        Switch(
                          value: _vegOnly,
                          onChanged:
                              (value) => setState(() => _vegOnly = value),
                          activeColor: Colors.green,
                        ),
                        const Text('Veg Only'),
                      ],
                    ),
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
                            childAspectRatio: 0.6,
                          ),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return _buildSimpleFoodCard(item);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleFoodCard(FoodItem item) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder:
                    (_, __, ___) =>
                        const Center(child: Icon(Icons.fastfood, size: 50)),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '₹${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: item.isAvailable ? () => _addToCart(item) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size.fromHeight(30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add', style: TextStyle(fontSize: 12)),
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
