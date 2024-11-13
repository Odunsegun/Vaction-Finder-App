import 'package:flutter/material.dart';
import 'Account.dart';
import 'AccountPages.dart';
import 'SavedPlaces.dart';
import 'package:final_project/post/PostPage.dart';
import 'package:final_project/map/MapPage.dart';

class HomeScreen extends StatefulWidget {
  Account user;
  HomeScreen(this.user, {super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  @override
  void initState(){
    super.initState();
    _pages = [
      MapPage(widget.user),
      PostPage(),
      SavedPlacesPage(widget.user.username),
      AccountPage(),
    ];
  }

  final List<String> pageName = [
    'Home',
    'Posts',
    'Saved',
    'Account',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? null : AppBar(title: Text(pageName[_selectedIndex])) ,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.red,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search,color: Colors.black,), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search,color: Colors.black,), label: 'Posts'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark,color: Colors.black,), label: 'Saved Places'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle,color: Colors.black,), label: 'Account'),
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
