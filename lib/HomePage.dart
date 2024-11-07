import 'package:flutter/material.dart';
import 'AccountPages.dart';
import 'SavedPlaces.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    AccountPage(),
    SavedPlacesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved Places'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Search Destination',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
