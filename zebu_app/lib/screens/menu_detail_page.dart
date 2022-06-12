// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/bloc/menu/menu_bloc.dart';
import 'package:zebu_app/bloc/menu/menu_event.dart';
import 'package:zebu_app/bloc/menu/menu_state.dart';
import 'package:zebu_app/bloc/menu/recent_bloc.dart';
import 'package:zebu_app/bloc/menu/recent_state.dart';
import 'package:zebu_app/routeGenerator.dart';

class MenuDetailPage extends StatefulWidget {
  final Map argObj;

  const MenuDetailPage({Key? key, required this.argObj}) : super(key: key);

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState(argObj: argObj);
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  final Map argObj;

  _MenuDetailPageState({required this.argObj});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var id = argObj['id'];
    final menuBloc = BlocProvider.of<MenuBloc>(context);
    menuBloc.add(SingleMenuLoad(id));
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.pushNamed(
              context,
              RouteGenerator.mainFlowName,
              arguments: ScreenArguments({'index': 0}),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: DefaultTextStyle(
          style: TextStyle(decoration: TextDecoration.none),
          child: SingleChildScrollView(
            child: BlocConsumer<MenuBloc, MenuState>(
                listener: (ctx, singleMenuState) {},
                builder: (_, singleMenuState) {
                  if (singleMenuState is LoadingMenu) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff5D7498),
                        ),
                      ),
                    );
                  }

                  if (singleMenuState is SingleMenuLoadFailure) {
                    return const Text("Loading Failed");
                  }

                  if (singleMenuState is SingleMenuLoadSuccess) {
                    var singleMenu = singleMenuState.singleMenu;
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  image: singleMenu.image != null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            "http://45.79.249.127" +
                                                singleMenu.image,
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
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            singleMenu.title,
                                            style: TextStyle(
                                                color: Color(0xff404E65),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20),
                                            softWrap: true,
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: singleMenu.type
                                                          .contains("Spicy/hot")
                                                      ? Image.asset(
                                                          'assets/images/spicy.png',
                                                          width: 20,
                                                        )
                                                      : Container(),
                                                ),
                                                singleMenu.type
                                                        .contains("Vegetarian")
                                                    ? Image.asset(
                                                        'assets/images/vegeterian.png',
                                                        width: 20,
                                                      )
                                                    : Container(),
                                                singleMenu.type.contains(
                                                        "Vegan/fasting")
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
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(right: 15),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  singleMenu.memberPrice,
                                                  style: TextStyle(
                                                      color: Color(0xffFF9E16),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 24),
                                                ),
                                                Text(
                                                  'Birr',
                                                  style: TextStyle(
                                                      color: Color(0xffFF9E16),
                                                      fontSize: 14),
                                                ),
                                              ]),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  singleMenu.description,
                                  style: TextStyle(color: Color(0xff404E65)),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  SizedBox(
                                      child: RecentlyViewed(
                                          parentId: singleMenu.id)),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Container();
                }),
          ),
        ));
  }
}

class RecentlyViewed extends StatefulWidget {
  final String parentId;
  const RecentlyViewed({Key? key, required this.parentId}) : super(key: key);

  @override
  State<RecentlyViewed> createState() =>
      _RecentlyViewedState(parentId: parentId);
}

class _RecentlyViewedState extends State<RecentlyViewed> {
  final String parentId;
  _RecentlyViewedState({required this.parentId});
  @override
  Widget build(BuildContext context) {
    final recentBloc = BlocProvider.of<RecentMenuBloc>(context);
    recentBloc.add(RecentlyViewedLoad());
    return BlocBuilder<RecentMenuBloc, RecentMenuState>(
      builder: (_, recentlyViewedState) {
        print("rState::::::::::::::::");
        print(recentlyViewedState);
        if (recentlyViewedState is LoadingRecentMenu) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }

        if (recentlyViewedState is RecentlyViewedLoadFailure) {
          return Container();
        }

        if (recentlyViewedState is RecentlyViewedLoadSuccess) {
          final recentlyViewed = recentlyViewedState.recentlyviewed;
          // if (recentlyViewed.isNotEmpty) {
          //   recentlyViewed.removeLast();
          // }
          if (recentlyViewed.length < 3) {
            return Container();
          }
          return Material(
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recently Viewed',
                    style: TextStyle(
                        color: Color(0xff404E65),
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                    softWrap: true,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: recentlyViewed.length,
                        itemBuilder: (BuildContext context, int index) {
                          var currentItem = recentlyViewed[index];
                          var decoded = jsonDecode(currentItem);
                          return decoded['id'] != parentId
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 210,
                                    height: 50,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        var prefObj = {
                                          'id': decoded['id'],
                                          'image': decoded['image']
                                        };
                                        var prefObjEncoded =
                                            jsonEncode(prefObj);

                                        var recentlyViewedList =
                                            prefs.getStringList(
                                                    'recentlyViewed') ??
                                                [];
                                        if (!recentlyViewedList
                                            .contains(prefObjEncoded)) {
                                          if (recentlyViewedList.length > 5) {
                                            recentlyViewedList
                                                .remove(recentlyViewedList[4]);
                                            recentlyViewedList.insert(
                                                0, prefObjEncoded);
                                          } else {
                                            recentlyViewedList
                                                .add(prefObjEncoded);
                                          }
                                        }

                                        prefs.setStringList(('recentlyViewed'),
                                            recentlyViewedList);

                                        Navigator.pushNamed(
                                          context,
                                          RouteGenerator.menuDetailScreenName,
                                          arguments: ScreenArguments(
                                              {'id': decoded['id']}),
                                        );
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "http://45.79.249.127" +
                                                    decoded['image']),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container();
                        }),
                  ),
                ],
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}
