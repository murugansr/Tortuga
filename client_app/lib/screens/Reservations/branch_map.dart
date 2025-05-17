import 'package:client_app/screens/Reservations/dticket.dart';
import 'package:client_app/screens/Reservations/menu.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TableSelectionScreen(),
    );
  }
}

DateTime _focusedDay = DateTime.now();
DateTime? _selectedDay;

enum TableType { round, square, rectangle }

enum TableStatus { available, reserved, selected }

class RestaurantTable {
  final String id;
  final int number;
  final TableType type;
  final int capacity;
  TableStatus status;
  final double x;
  final double y;
  final double width;
  final double height;

  RestaurantTable({
    required this.id,
    required this.number,
    required this.type,
    required this.capacity,
    required this.status,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

class RestaurantArea {
  final String id;
  final String name;
  final List<RestaurantTable> tables;

  RestaurantArea({required this.id, required this.name, required this.tables});
}

class TableSelectionScreen extends StatefulWidget {
  @override
  _TableSelectionScreenState createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<RestaurantArea> areas = [];
  List<RestaurantTable> selectedTables = [];
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    areas = [
      RestaurantArea(
        id: '1',
        name: 'Non-AC Hall',
        tables: [
          RestaurantTable(
            id: '1',
            number: 1,
            type: TableType.rectangle,
            capacity: 8,
            status: TableStatus.available,
            x: 25,
            y: 20,
            width: 150,
            height: 80,
          ),
          RestaurantTable(
            id: '2',
            number: 2,
            type: TableType.rectangle,
            capacity: 8,
            status: TableStatus.available,
            x: 235,
            y: 20,
            width: 150,
            height: 80,
          ),
          RestaurantTable(
            id: '3',
            number: 4,
            type: TableType.square,
            capacity: 6,
            status: TableStatus.available,
            x: 10,
            y: 130,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '4',
            number: 4,
            type: TableType.square,
            capacity: 6,
            status: TableStatus.available,
            x: 320,
            y: 130,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '5',
            number: 5,
            type: TableType.square,
            capacity: 4,
            status: TableStatus.available,
            x: 10,
            y: 280,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '6',
            number: 6,
            type: TableType.square,
            capacity: 4,
            status: TableStatus.available,
            x: 320,
            y: 280,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '7',
            number: 7,
            type: TableType.square,
            capacity: 6,
            status: TableStatus.available,
            x: 10,
            y: 430,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '8',
            number: 8,
            type: TableType.square,
            capacity: 6,
            status: TableStatus.available,
            x: 320,
            y: 430,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '9',
            number: 9,
            type: TableType.rectangle,
            capacity: 8,
            status: TableStatus.available,
            x: 25,
            y: 580,
            width: 150,
            height: 80,
          ),
          RestaurantTable(
            id: '10',
            number: 10,
            type: TableType.rectangle,
            capacity: 8,
            status: TableStatus.available,
            x: 235,
            y: 580,
            width: 150,
            height: 80,
          ),
          RestaurantTable(
            id: '11',
            number: 11,
            type: TableType.round,
            capacity: 3,
            status: TableStatus.available,
            x: 170,
            y: 120,
            width: 70,
            height: 70,
          ),
          RestaurantTable(
            id: '12',
            number: 12,
            type: TableType.round,
            capacity: 2,
            status: TableStatus.available,
            x: 105,
            y: 210,
            width: 60,
            height: 60,
          ),
          RestaurantTable(
            id: '13',
            number: 13,
            type: TableType.round,
            capacity: 2,
            status: TableStatus.available,
            x: 240,
            y: 210,
            width: 60,
            height: 60,
          ),
          RestaurantTable(
            id: '14',
            number: 14,
            type: TableType.round,
            capacity: 4,
            status: TableStatus.available,
            x: 155,
            y: 290,
            width: 100,
            height: 100,
          ),
          RestaurantTable(
            id: '16',
            number: 16,
            type: TableType.round,
            capacity: 2,
            status: TableStatus.available,
            x: 240,
            y: 400,
            width: 60,
            height: 60,
          ),
          RestaurantTable(
            id: '15',
            number: 15,
            type: TableType.round,
            capacity: 2,
            status: TableStatus.available,
            x: 105,
            y: 400,
            width: 60,
            height: 60,
          ),
          RestaurantTable(
            id: '17',
            number: 17,
            type: TableType.round,
            capacity: 3,
            status: TableStatus.available,
            x: 175,
            y: 490,
            width: 70,
            height: 70,
          ),
        ],
      ),
      RestaurantArea(
        id: '2',
        name: 'AC Hall',
        tables: [
          RestaurantTable(
            id: '18',
            number: 18,
            type: TableType.rectangle,
            capacity: 8,
            status: TableStatus.available,
            x: 25,
            y: 20,
            width: 150,
            height: 80,
          ),
          RestaurantTable(
            id: '19',
            number: 19,
            type: TableType.rectangle,
            capacity: 8,
            status: TableStatus.available,
            x: 235,
            y: 20,
            width: 150,
            height: 80,
          ),
          RestaurantTable(
            id: '20',
            number: 20,
            type: TableType.square,
            capacity: 6,
            status: TableStatus.available,
            x: 10,
            y: 130,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '21',
            number: 21,
            type: TableType.square,
            capacity: 6,
            status: TableStatus.available,
            x: 320,
            y: 130,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '22',
            number: 22,
            type: TableType.square,
            capacity: 4,
            status: TableStatus.available,
            x: 10,
            y: 280,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '23',
            number: 23,
            type: TableType.square,
            capacity: 4,
            status: TableStatus.available,
            x: 320,
            y: 280,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '24',
            number: 24,
            type: TableType.square,
            capacity: 6,
            status: TableStatus.available,
            x: 10,
            y: 430,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '25',
            number: 25,
            type: TableType.square,
            capacity: 6,
            status: TableStatus.available,
            x: 320,
            y: 430,
            width: 80,
            height: 120,
          ),
          RestaurantTable(
            id: '26',
            number: 26,
            type: TableType.rectangle,
            capacity: 8,
            status: TableStatus.available,
            x: 25,
            y: 580,
            width: 150,
            height: 80,
          ),
          RestaurantTable(
            id: '27',
            number: 27,
            type: TableType.rectangle,
            capacity: 8,
            status: TableStatus.available,
            x: 235,
            y: 580,
            width: 150,
            height: 80,
          ),
          RestaurantTable(
            id: '28',
            number: 28,
            type: TableType.round,
            capacity: 3,
            status: TableStatus.available,
            x: 170,
            y: 120,
            width: 70,
            height: 70,
          ),
          RestaurantTable(
            id: '29',
            number: 29,
            type: TableType.round,
            capacity: 2,
            status: TableStatus.available,
            x: 105,
            y: 210,
            width: 60,
            height: 60,
          ),
          RestaurantTable(
            id: '30',
            number: 30,
            type: TableType.round,
            capacity: 2,
            status: TableStatus.available,
            x: 240,
            y: 210,
            width: 60,
            height: 60,
          ),
          RestaurantTable(
            id: '31',
            number: 31,
            type: TableType.round,
            capacity: 4,
            status: TableStatus.available,
            x: 155,
            y: 290,
            width: 100,
            height: 100,
          ),
          RestaurantTable(
            id: '32',
            number: 32,
            type: TableType.round,
            capacity: 2,
            status: TableStatus.available,
            x: 240,
            y: 400,
            width: 60,
            height: 60,
          ),
          RestaurantTable(
            id: '33',
            number: 33,
            type: TableType.round,
            capacity: 2,
            status: TableStatus.available,
            x: 105,
            y: 400,
            width: 60,
            height: 60,
          ),
          RestaurantTable(
            id: '34',
            number: 34,
            type: TableType.round,
            capacity: 3,
            status: TableStatus.available,
            x: 175,
            y: 490,
            width: 70,
            height: 70,
          ),
        ],
      ),
    ];
    _tabController = TabController(length: areas.length, vsync: this);
  }

  void toggleTableSelection(RestaurantTable table) {
    if (table.status == TableStatus.reserved) return;

    setState(() {
      for (var t in selectedTables) {
        t.status = TableStatus.available;
      }
      selectedTables.clear();

      table.status = TableStatus.selected;
      selectedTables.add(table);
    });
  }

  void showTableBottomSheet(BuildContext context, RestaurantTable table) {
    if (table.status == TableStatus.reserved) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: StatefulBuilder(
                builder:
                    (context, setState) => SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          Text(
                            "Select your Preference",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 20),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Select date"),
                          ),
                          SizedBox(height: 10),
                          TableCalendar(
                            firstDay: DateTime.now(),
                            lastDay: DateTime.now().add(Duration(days: 365)),
                            focusedDay: _focusedDay,
                            selectedDayPredicate:
                                (day) => isSameDay(_selectedDay, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                color: Colors.lightBlue,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Select time"),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                [
                                  "12–2pm",
                                  "2–4pm",
                                  "4–6pm",
                                  "6–8pm",
                                  "8–10pm",
                                  "10–12pm",
                                ].map((time) {
                                  return ChoiceChip(
                                    label: Text(time),
                                    selected: _selectedTime == time,
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedTime = selected ? time : null;
                                      });
                                    },
                                    selectedColor: Colors.lightBlue,
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color:
                                            _selectedTime == time
                                                ? Colors.lightBlue
                                                : Colors.lightBlue,
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color:
                                          _selectedTime == time
                                              ? Colors.white
                                              : Colors.lightBlue,
                                    ),
                                  );
                                }).toList(),
                          ),

                          SizedBox(height: 20),

                          // Name Field
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Reservation on Name"),
                          ),
                          SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                showOrderPreferenceSheet(
                                  context,
                                  table,
                                  _selectedTime,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.green,
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.green),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(
                                "Continue",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),
              ),
            );
          },
        );
      },
    );
  }

  void confirmReservation() {
    if (selectedTables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one table')),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Confirm Reservation'),
            content: Text(
              'You selected ${selectedTables.length} table(s) with a total of ${selectedTables.fold(0, (sum, t) => sum + t.capacity)} seats.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reservation confirmed!')),
                  );
                  setState(() {
                    for (var table in selectedTables) {
                      table.status = TableStatus.reserved;
                    }
                    selectedTables.clear();
                  });
                },
                child: Text('Confirm'),
              ),
            ],
          ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget _buildTable(RestaurantTable table) {
    Color tableColor;
    switch (table.status) {
      case TableStatus.available:
        tableColor = Colors.green.shade400;
        break;
      case TableStatus.reserved:
        tableColor = Colors.grey.shade500;
        break;
      case TableStatus.selected:
        tableColor = Colors.blue.shade400;
        break;
    }

    BorderRadius borderRadius;
    switch (table.type) {
      case TableType.round:
        borderRadius = BorderRadius.circular(100);
        break;
      case TableType.square:
      case TableType.rectangle:
        borderRadius = BorderRadius.circular(8);
        break;
    }

    return Positioned(
      left: table.x,
      top: table.y,
      child: GestureDetector(
        onTap: () {
          toggleTableSelection(table);
          showTableBottomSheet(context, table);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: table.width,
          height: table.height,
          decoration: BoxDecoration(
            color: tableColor,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'T${table.number}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${table.capacity} seats',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableMap(RestaurantArea area) {
    return Stack(children: area.tables.map(_buildTable).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EBFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF44C5F4),
        title: Text(
          'Table Selection',
          style: TextStyle(
            fontFamily: 'InknutAntiqua',
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: areas.map((area) => Tab(text: area.name)).toList(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(Colors.green.shade400, 'Available'),
                _buildLegendItem(Colors.grey.shade500, 'Reserved'),
                _buildLegendItem(Colors.blue.shade400, 'Selected'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:
                  areas.map((area) {
                    return SingleChildScrollView(
                      child: SizedBox(
                        height:
                            MediaQuery.of(context).size.height -
                            kToolbarHeight -
                            kTextTabBarHeight -
                            100,
                        child: _buildTableMap(area),
                      ),
                    );
                  }).toList(),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

void showOrderPreferenceSheet(
  BuildContext context,
  RestaurantTable table,
  selectedTime,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select your Preference',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'InknutAntiqua',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            _gradientButton('Pre-Order', () async {
              Map<String, dynamic> reservationData = {
                'table_number': table.number,
                'capacity': table.capacity,
                'timestamp': FieldValue.serverTimestamp(), // useful for sorting
                'date':
                    _selectedDay?.toIso8601String() ??
                    DateTime.now().toIso8601String(),
                'time': selectedTime, // Replace with actual selected time
              };

              try {
                // Insert the document into 'reserve_table' collection
                await FirebaseFirestore.instance
                    .collection('reserve_table')
                    .add(reservationData);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MenuScreen(
                          tableNumber: table.number,
                          capacity: table.capacity,
                          reservationDate: _selectedDay ?? DateTime.now(),
                          reservationTime: selectedTime ?? "Not specified",
                        ),
                  ),
                );
              } catch (e) {
                // Handle errors here if needed
                print("Error adding reservation: $e");
              }
            }),

            const SizedBox(height: 15),
            const Text('or'),
            const SizedBox(height: 15),
            _gradientButton('Dine-in Order', () async {
              // Example data to insert
              Map<String, dynamic> reservationData = {
                'table_number': table.number,
                'capacity': table.capacity,
                'timestamp': FieldValue.serverTimestamp(), // useful for sorting
                'date':
                    _selectedDay?.toIso8601String() ??
                    DateTime.now().toIso8601String(),
                'time': selectedTime, // Replace with actual selected time
              };

              try {
                // Insert the document into 'reserve_table' collection
                await FirebaseFirestore.instance
                    .collection('reserve_table')
                    .add(reservationData);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DineInPage(
                          tableNumber: table.number,
                          reservationDate: _selectedDay ?? DateTime.now(),
                          reservationTime: selectedTime ?? "Not specified",
                        ),
                  ),
                );
              } catch (e) {
                // Handle errors here if needed
                print("Error adding Dine-in reservation: $e");

                // Show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to make Dine-in reservation.'),
                  ),
                );
              }
            }),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

Widget _gradientButton(String text, VoidCallback onPressed) {
  return Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: const LinearGradient(
        colors: [Colors.blueAccent, Colors.lightBlueAccent],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade400,
          offset: const Offset(2, 3),
          blurRadius: 6,
        ),
      ],
    ),
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
