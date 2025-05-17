import 'package:flutter/material.dart';
import 'package:client_app/screens/Reservations/reservation.dart';
import 'package:client_app/screens/Settings/account.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    const ReservationScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EBFC),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  HomeContent({super.key});
  final List<Map<String, String>> cuisines = [
    {
      'name': 'Italian',
      'image':
          'https://images.pexels.com/photos/1435907/pexels-photo-1435907.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
    },
    {
      'name': 'Chinese',
      'image':
          'https://images.pexels.com/photos/290316/pexels-photo-290316.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
    },
    {
      'name': 'Indian',
      'image':
          'https://images.pexels.com/photos/1117864/pexels-photo-1117864.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
    },
    {
      'name': 'Mexican',
      'image':
          'https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
    },
    {
      'name': 'Thai',
      'image':
          'https://images.pexels.com/photos/1059905/pexels-photo-1059905.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
    },
    {
      'name': 'Japanese',
      'image':
          'https://images.pexels.com/photos/3577563/pexels-photo-3577563.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "TORTUGA",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'InknutAntiqua',
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 90.0,
        backgroundColor: const Color(0xFF44C5F4),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: cuisines.length,
        itemBuilder: (context, index) {
          final cuisine = cuisines[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: CuisineCard(
              name: cuisine['name']!,
              imageUrl: cuisine['image']!,
            ),
          );
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final double iconSize;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.iconSize = 29.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/h_out.png',
              width: iconSize,
              height: iconSize,
            ),
            activeIcon: Image.asset(
              'assets/images/icons/h_black.png',
              width: iconSize,
              height: iconSize,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/t_out.png',
              width: iconSize,
              height: iconSize,
            ),
            activeIcon: Image.asset(
              'assets/images/icons/t_black.png',
              width: iconSize,
              height: iconSize,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/p_out.png',
              width: iconSize,
              height: iconSize,
            ),
            activeIcon: Image.asset(
              'assets/images/icons/p_black.png',
              width: iconSize,
              height: iconSize,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

class CuisineCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const CuisineCard({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget:
                  (context, url, error) => Image.asset(
                    'assets/images/fallback.jpg',
                    fit: BoxFit.cover,
                  ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black45,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
