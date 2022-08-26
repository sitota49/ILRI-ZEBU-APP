import 'dart:async';
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

double pgHeight = 0;
double pgWidth = 0;

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();
  String queryParam = '';
  bool isSearchPage = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

    searchController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    setState(() {
      queryParam = searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;

    setState(() {
      pgHeight = pageHeight;
      pgWidth = pageWidth;
    });
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(
          context,
          RouteGenerator.homeScreenName,
        );
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xff404E65),
              onPressed: () => Navigator.pushNamed(
                context,
                RouteGenerator.homeScreenName,
              ),
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
                  padding: EdgeInsets.only(
                      left: pgWidth * 0.05, right: pgWidth * 0.05),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        final menuBloc = BlocProvider.of<MenuBloc>(context);
                        queryParam = value;
                        isSearchPage = true;
                        // if (_tabController.index == 0) {
                        //   menuBloc.add(AllMenuLoad(queryParam));
                        // } else {
                        //   _tabController.index = 0;
                        // }
                        Timer(const Duration(milliseconds: 1000), () {
                          _tabController.index = 0;
                          menuBloc.add(AllMenuLoad(queryParam));
                        });
                      });
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
                                AllMenu(
                                  queryParam: queryParam,
                                  isSearch: isSearchPage,
                                ),
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
          )),
    );
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
            if (currentMenu.image != null) {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              var prefObj = {'id': currentMenu.id, 'image': currentMenu.image};
              var prefObjEncoded = jsonEncode(prefObj);

              var recentlyViewedList =
                  prefs.getStringList('recentlyViewed') ?? [];

              if (!recentlyViewedList.contains(prefObjEncoded)) {
                if (recentlyViewedList.length > 5) {
                  recentlyViewedList.remove(recentlyViewedList[4]);
                  recentlyViewedList.add(prefObjEncoded);
                } else {
                  recentlyViewedList.add(prefObjEncoded);
                }
              }

              prefs.setStringList(('recentlyViewed'), recentlyViewedList);
            }
            Navigator.pushNamed(
              context,
              RouteGenerator.menuDetailScreenName,
              arguments: ScreenArguments({'id': currentMenu.id}),
            );
          },
          child: Container(
            // width: pgWidth * 0.43,
            // height: pgHeight * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // height: pgHeight * 0.16,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    image: menu.image != null
                        ? DecorationImage(
                            image: NetworkImage(
                              "https://zebuapp.ilri.org" + menu.image,
                            ),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          )
                        : DecorationImage(
                            image: AssetImage(
                                'assets/images/menu_placeholder.png'),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                  ),
                ),
                // SizedBox(height: pgHeight * 0.003),
                Padding(
                  padding: EdgeInsets.only(left: pgWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: pgHeight * 0.008),
                            Text(
                              menu.title.length > 15
                                  ? menu.title.substring(0, 14) + '...'
                                  : menu.title,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff404E65),
                                fontWeight: FontWeight.w700,
                              ),
                              softWrap: true,
                            ),
                            SizedBox(height: pgHeight * 0.008),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: menu.type.contains("Spicy/hot")
                                        ? Image.asset(
                                            'assets/images/spicy.png',
                                            width: pgWidth * 0.03,
                                          )
                                        : Container(),
                                  ),
                                  menu.type.contains("Vegetarian")
                                      ? Image.asset(
                                          'assets/images/vegeterian.png',
                                          width: pgWidth * 0.03,
                                        )
                                      : Container(),
                                  menu.type.contains("Vegan/fasting")
                                      ? Image.asset(
                                          'assets/images/vegan.png',
                                          width: pgWidth * 0.03,
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
                          // margin: EdgeInsets.only(right: 10),
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

class AllMenu extends StatefulWidget {
  final String queryParam;

  final bool isSearch;
  const AllMenu({Key? key, required this.queryParam, required this.isSearch})
      : super(key: key);

  @override
  State<AllMenu> createState() =>
      _AllMenuState(queryParam: queryParam, isSearch: isSearch);
}

class _AllMenuState extends State<AllMenu> {
  final String queryParam;
  final bool isSearch;
  _AllMenuState({required this.queryParam, required this.isSearch});
  @override
  Widget build(BuildContext context) {
    final menuBloc = BlocProvider.of<MenuBloc>(context);

    menuBloc.add(AllMenuLoad(queryParam));

    return BlocConsumer<MenuBloc, MenuState>(
      listener: (_, menuState) {},
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
          return Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              width: pgWidth * 0.7,
              child: Center(
                child: Text(
                  menuState.failureMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }

        if (menuState is AllMenuEmpltyFailure) {
          return Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              width: pgWidth * 0.7,
              child: Center(
                child: Text(
                  menuState.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }

        if (menuState is AllMenuLoadSuccess) {
          final allMenus = menuState.allMenus;

          return Material(
            child: Container(
              color: Color(0xff5D7498),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
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
          return Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              width: pgWidth * 0.7,
              child: Center(
                child: Text(
                  menuState.failureMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }

        if (menuState is CategoryMenuEmpltyFailure) {
          return Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              width: pgWidth * 0.7,
              child: Center(
                child: Text(
                  menuState.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }

        if (menuState is CategoryMenuLoadSuccess) {
          final categoryMenus = menuState.categoryMenus;

          return Material(
            child: Container(
              color: Color(0xff5D7498),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
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
