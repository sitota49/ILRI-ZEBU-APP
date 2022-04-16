import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/bloc/menu/menu_bloc.dart';
import 'package:zebu_app/bloc/menu/menu_event.dart';
import 'package:zebu_app/bloc/menu/menu_state.dart';
import 'package:zebu_app/routeGenerator.dart';

import 'package:zebu_app/screens/utils/EditTextUtils.dart';
import 'package:zebu_app/screens/utils/NavigationDrawer.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late PageController _pageController;
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _pageController = PageController();
    searchController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("Textfield value: ${searchController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color(0xff404E65),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'MENU',
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                color: Color(0xff404E65),
                fontWeight: FontWeight.w500),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _tabController.index = 0;
                    });
                    print(value);
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    focusColor: Color(0xff404E65),
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff404E65),
                        width: 1.0,
                      ),
                    ),
                    hintText: 'Search',
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      width: double.infinity,
                      decoration: new BoxDecoration(
                        color: Color(0xff5D7498),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                      ),
                      margin: EdgeInsets.only(top: 10),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TabBar(
                            indicatorColor: Colors.transparent,
                            unselectedLabelColor: Colors.white,
                            unselectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 14),
                            isScrollable: true,
                            labelColor: Colors.white,
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 19),
                            tabs: [
                              Tab(
                                text: 'All',
                              ),
                              Tab(
                                text: 'Breakfast',
                              ),
                              Tab(
                                text: 'Lunch & Dinner',
                              ),
                              Tab(
                                text: 'Pizza',
                              ),
                              Tab(
                                text: 'Snack',
                              ),
                              Tab(
                                text: 'Cake',
                              ),
                              Tab(
                                text: 'Bakery',
                              ),
                            ],
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              AllMenu(),
                              CategoryMenu(category: 'breakfast'),
                              CategoryMenu(category: 'lunch&dinner'),
                              CategoryMenu(category: 'pizza'),
                              CategoryMenu(category: 'snack'),
                              CategoryMenu(category: 'cake'),
                              CategoryMenu(category: 'bakery'),
                            ],
                            controller: _tabController,
                          ),
                        ),
                      ]))),
            ],
          ),
        ));
  }
}


class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.menu,
  }) : super(key: key);

  final menu;

  @override
  Widget build(BuildContext context) {
    var currentMenu = menu;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            var prefObj = {'id': currentMenu.id, 'image': currentMenu.image};
            var prefObjEncoded = jsonEncode(prefObj);

            var recentlyViewedList =
                prefs.getStringList('recentlyViewed') ?? [];
            if (!recentlyViewedList.contains(prefObjEncoded)) {
              if (recentlyViewedList.length > 5) {
                recentlyViewedList.remove(recentlyViewedList[4]);
                recentlyViewedList.insert(0, prefObjEncoded);
              } else {
                recentlyViewedList.add(prefObjEncoded);
              }
            }

            prefs.setStringList(('recentlyViewed'), recentlyViewedList);

            Navigator.pushNamed(
              context,
              RouteGenerator.menuDetailScreenName,
              arguments: ScreenArguments({'id': currentMenu.id}),
            );
          },
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    image: DecorationImage(
                      image: NetworkImage(
                        "http://45.79.249.127" + menu.image,
                      ),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.title,
                              style: TextStyle(
                                color: Color(0xff404E65),
                                fontWeight: FontWeight.w700,
                              ),
                              softWrap: true,
                            ),
                            SizedBox(height: 3),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: menu.type.contains("Spicy/hot")
                                        ? Image.asset(
                                            'assets/images/spicy.png',
                                            width: 20,
                                          )
                                        : Container(),
                                  ),
                                  menu.type.contains("Vegetarian")
                                      ? Image.asset(
                                          'assets/images/vegeterian.png',
                                          width: 20,
                                        )
                                      : Container(),
                                  menu.type.contains("Vegan/fasting")
                                      ? Image.asset(
                                          'assets/images/vegan.png',
                                          width: 20,
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  menu.memberPrice,
                                  style: TextStyle(
                                      color: Color(0xffFF9E16),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                Text(
                                  'Birr',
                                  style: TextStyle(
                                      color: Color(0xffFF9E16), fontSize: 12),
                                ),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class AllMenu extends StatelessWidget {
  const AllMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuBloc = BlocProvider.of<MenuBloc>(context);
    menuBloc.add(AllMenuLoad());
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (_, menuState) {
        if (menuState is LoadingMenu) {
           return SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }

        if (menuState is AllMenuLoadFailure) {
          return Text(menuState.failureMessage);
        }

        if (menuState is AllMenuEmpltyFailure) {
          return Text(menuState.message);
        }

        if (menuState is AllMenuLoadSuccess) {
          final allMenus = menuState.allMenus;

          return Material(
            child: Container(
              color: Color(0xff5D7498),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.25 / 2,
                  ),
                  itemCount: allMenus.length,
                  itemBuilder: (BuildContext ctx, index) {
                    final currentItem = allMenus[index];
                    return MenuItem(menu: currentItem);
                  }),
            ),
          );
        }

        return Container();
      },
    );
  }
}

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({Key? key, required this.category}) : super(key: key);
  final category;
  @override
  Widget build(BuildContext context) {
    String currentCategory = category;
    final menuBloc = BlocProvider.of<MenuBloc>(context);
    menuBloc.add(CategoryMenuLoad(currentCategory));

    return BlocBuilder<MenuBloc, MenuState>(
      builder: (_, menuState) {
        if (menuState is LoadingMenu) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }

        if (menuState is CategoryMenuLoadFailure) {
          return Text(menuState.failureMessage);
        }

        if (menuState is CategoryMenuEmpltyFailure) {
          return Text(menuState.message);
        }

        if (menuState is CategoryMenuLoadSuccess) {
          final categoryMenus = menuState.categoryMenus;

          return Material(
            child: Container(
              color: Color(0xff5D7498),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.25 / 2,
                  ),
                  itemCount: categoryMenus.length,
                  itemBuilder: (BuildContext ctx, index) {
                    final currentItem = categoryMenus[index];
                    return MenuItem(menu: currentItem);
                  }),
            ),
          );
        }

        return Container();
      },
    );
  }
}
