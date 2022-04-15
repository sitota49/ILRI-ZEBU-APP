import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:zebu_app/screens/announcement_page.dart';
import 'package:zebu_app/screens/booking_page.dart';
import 'package:zebu_app/screens/feedback_page.dart';
import 'package:zebu_app/screens/home_page.dart';
import 'package:zebu_app/screens/membership_page.dart';
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
    MembershipPage(
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
              icon: Icon(Icons.wallet_membership), label: 'Membership'),
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

  // @override
  // Widget build(BuildContext context) {
  //   if (argObj['index'] != null) {
  //     setState(() {
  //       print("eziga");
  //       _currentIndex = argObj['index'];
  //     });
  //   } else {
  //     setState(() {
  //       _currentIndex = 0;
  //     });
  //   }
  //   return WillPopScope(
  //     onWillPop: () async => false,
  //     child: Scaffold(
  //         drawer: NavigationDrawer(),
  //         body: SizedBox.expand(
  //           child: PageView(
  //             controller: _pageController,
  //             onPageChanged: (index) {
  //               setState(() => _currentIndex = index);
  //             },
  //             children: <Widget>[
  //               MenuPage(),
  //               BookingPage(),
  //               MembershipPage(),
  //               AnnouncementPage()
  //             ],
  //           ),
  //         ),
  //         bottomNavigationBar: BottomNavyBar(
  //           selectedIndex: _currentIndex,
  //           showElevation: true, // use this to remove appBar's elevation
  //           onItemSelected: (index) => setState(() {
  //             _currentIndex = index;
  //             _pageController.animateToPage(index,
  //                 duration: Duration(milliseconds: 300), curve: Curves.ease);
  //           }),
  //           items: [
  //             BottomNavyBarItem(
  //               icon: Icon(Icons.home),
  //               title: Text('Home'),
  //               activeColor: Colors.red,
  //             ),
  //             BottomNavyBarItem(
  //                 icon: Icon(Icons.category),
  //                 title: Text('Categories'),
  //                 activeColor: Colors.purpleAccent),
  //             BottomNavyBarItem(
  //                 icon: Icon(Icons.assignment),
  //                 title: Text('Orders'),
  //                 activeColor: Colors.pink),
  //             BottomNavyBarItem(
  //                 icon: Icon(Icons.account_circle),
  //                 title: Text('Account'),
  //                 activeColor: Colors.blue),
  //           ],
  //         )),
  //   );
  // }
}

// class BottomNavigationBarController extends StatefulWidget {
//   @override
//   _BottomNavigationBarControllerState createState() =>
//       _BottomNavigationBarControllerState();
// }

// class _BottomNavigationBarControllerState
//     extends State<BottomNavigationBarController> {
//   final List<Widget> pages = [
//     MenuPage(
//       key: PageStorageKey('Page1'),
//     ),
//     BookingPage(
//       key: PageStorageKey('Page2'),
//     ),
//   ];

//   final PageStorageBucket bucket = PageStorageBucket();

//   int _selectedIndex = 0;

//   Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
//         onTap: (int index) => setState(() => _selectedIndex = index),
//         currentIndex: selectedIndex,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.add), label: 'First Page'),
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Second Page'),
//         ],
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
//       body: PageStorage(
//         child: pages[_selectedIndex],
//         bucket: bucket,
//       ),
//     );
//   }
// }
