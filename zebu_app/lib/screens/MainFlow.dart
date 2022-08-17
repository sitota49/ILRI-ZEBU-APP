import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:zebu_app/screens/announcement_page.dart';
import 'package:zebu_app/screens/booking_page.dart';
import 'package:zebu_app/screens/feedback_page.dart';
import 'package:zebu_app/screens/home_page.dart';

import 'package:zebu_app/screens/menu_page.dart';
import 'package:zebu_app/screens/utils/NavigationDrawer.dart';

class MainFlow extends StatefulWidget {
  final Map argObj;
  MainFlow({Key? key, required this.argObj}) : super(key: key);

  @override
  State<MainFlow> createState() => _MainFlowState(argObj: argObj);
}

class _MainFlowState extends State<MainFlow> {
  final Map argObj;
  late int _currentIndex = 0;

  late PageController _pageController;
  _MainFlowState({required this.argObj});

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> pages = [
    MenuPage(
      key: PageStorageKey('Page1'),
    ),
    BookingPage(
      key: PageStorageKey('Page2'),
    ),
    FeedbackPage(
      key: PageStorageKey('Page3'),
    ),
    AnnouncementPage(
      key: PageStorageKey('Page4'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  late int _selectedIndex = argObj['index'];

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        selectedItemColor: Color(0xff404E65),
        unselectedItemColor: Colors.grey,
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.local_dining), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Booking'),
          BottomNavigationBarItem(
              icon: Icon(Icons.question_mark), label: 'Feedback'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active), label: 'Announcement'),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}
