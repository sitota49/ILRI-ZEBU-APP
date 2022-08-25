// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/bloc/menu/menu_bloc.dart';
import 'package:zebu_app/bloc/menu/menu_event.dart';
import 'package:zebu_app/bloc/menu/menu_state.dart';
import 'package:zebu_app/bloc/menu/recent_bloc.dart';
import 'package:zebu_app/bloc/menu/recent_state.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_bloc.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_event.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_state.dart';
import 'package:zebu_app/bloc/order/order_bloc.dart';
import 'package:zebu_app/bloc/order/order_event.dart';
import 'package:zebu_app/bloc/order/order_state.dart';
import 'package:zebu_app/models/order.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:intl/intl.dart';

double pgHeight = 0;
double pgWidth = 0;
var noPicker;
var qty = '1';
NetworkConnectivityBloc? _networkConnectivityBloc;

class MenuDetailPage extends StatefulWidget {
  final Map argObj;

  const MenuDetailPage({Key? key, required this.argObj}) : super(key: key);

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState(argObj: argObj);
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  final Map argObj;

  _MenuDetailPageState({required this.argObj});
  var id;
  var menuItem;
  @override
  void initState() {
    super.initState();
    _networkConnectivityBloc =
        BlocProvider.of<NetworkConnectivityBloc>(context);
    _networkConnectivityBloc!.add(InitNetworkConnectivity());
    _networkConnectivityBloc!.add(ListenNetworkConnectivity());

    id = argObj['id'];
    qty = '1';
    final menuBloc = BlocProvider.of<MenuBloc>(context);
    menuBloc.add(SingleMenuLoad(id));
    noPicker = CustomNumberPicker(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey),
      ),
      initialValue: 1,
      maxValue: 10,
      minValue: 1,
      step: 1,
      enable: true,
      onValue: (value) {
        setState(() {
          qty = value.toString();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;

    setState(() {
      pgHeight = pageHeight;
      pgWidth = pageWidth;
    });

    // late String qty = '1';

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(
          context,
          RouteGenerator.mainFlowName,
          arguments: ScreenArguments({'index': 0}),
        );
        return false;
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xff5D7498),
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
                      return Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.3,
                          width: pgWidth * 0.7,
                          child: Center(
                            child: Text(
                              "Please check your internet connection and try again.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff404E65),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    if (singleMenuState is SingleMenuLoadSuccess) {
                      var singleMenu = singleMenuState.singleMenu;
                      menuItem = singleMenu;
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: pgHeight * 0.33,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.only(
                                    //     topLeft: Radius.circular(15),
                                    //     topRight: Radius.circular(15)),
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
                                  padding: EdgeInsets.only(
                                      top: pageHeight * 0.03,
                                      left: pgWidth * 0.05),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: pgWidth * 0.57,
                                              child: Text(
                                                singleMenu.title,
                                                style: TextStyle(
                                                    color: Color(0xff404E65),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18),
                                                softWrap: true,
                                              ),
                                            ),
                                            SizedBox(height: pgHeight * 0.016),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: singleMenu.type
                                                            .contains(
                                                                "Spicy/hot")
                                                        ? Image.asset(
                                                            'assets/images/spicy.png',
                                                            width:
                                                                pgWidth * 0.04,
                                                          )
                                                        : Container(),
                                                  ),
                                                  singleMenu.type.contains(
                                                          "Vegetarian")
                                                      ? Image.asset(
                                                          'assets/images/vegeterian.png',
                                                          width: pgWidth * 0.04,
                                                        )
                                                      : Container(),
                                                  singleMenu.type.contains(
                                                          "Vegan/fasting")
                                                      ? Image.asset(
                                                          'assets/images/vegan.png',
                                                          width: pgWidth * 0.04,
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(
                                            // margin: EdgeInsets.only(right: 0),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    singleMenu.memberPrice,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFF9E16),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 24),
                                                  ),
                                                  Text(
                                                    'Birr',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFF9E16),
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
                                  padding: EdgeInsets.only(
                                      top: pgHeight * 0.04,
                                      left: pgWidth * 0.05,
                                      right: pgWidth * 0.1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Non-member prices will be increased by 20%.',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12),
                                        softWrap: true,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        singleMenu.description,
                                        style: TextStyle(
                                            color: Color(
                                              0xff404E65,
                                            ),
                                            fontSize: 14),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            BlocBuilder(
                              bloc: _networkConnectivityBloc,
                              builder: (BuildContext context,
                                  NetworkConnectivityState state) {
                                if (state is NetworkOnline) {
                                  return Container(
                                    child: (singleMenu.category
                                                .contains("Pizza")) ||
                                            (singleMenu.category
                                                .contains("Cake")) ||
                                            (singleMenu.category
                                                .contains("Bakery"))
                                        ? BlocConsumer<OrderBloc, OrderState>(
                                            listener: (ctx, orderState) {
                                            if (orderState is OrderSuccess) {
                                              print(orderState);
                                              showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            // title: const Text('Time Not Set'),
                                                            content: menuItem
                                                                    .category
                                                                    .contains(
                                                                        "Pizza")
                                                                ? Text(
                                                                    'Your order has been placed. It will be ready in 30 minutes!')
                                                                : Text(
                                                                    'Your has been placed. It will be ready tomorrow at noon!'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () =>
                                                                    {
                                                                  Navigator
                                                                      .pushNamed(
                                                                    context,
                                                                    RouteGenerator
                                                                        .homeScreenName,
                                                                  )
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                              ),
                                                            ],
                                                          ));
                                            }
                                            if (orderState is OrderFailure) {
                                              showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            // title: const Text('Time Not Set'),
                                                            content: const Text(
                                                                'Please check your internet connection and try again.'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () =>
                                                                    {
                                                                  Navigator
                                                                      .pushNamed(
                                                                    context,
                                                                    RouteGenerator
                                                                        .homeScreenName,
                                                                  )
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                              ),
                                                            ],
                                                          ));
                                            }
                                          }, builder: (_, orderState) {
                                            return Column(
                                              children: [
                                                SizedBox(
                                                  height: pageHeight * 0.04,
                                                ),
                                                noPicker,
                                                SizedBox(
                                                  height: pageHeight * 0.04,
                                                ),
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16.0),
                                                    child: SizedBox(
                                                      width: double.infinity *
                                                          0.75,
                                                      height: 50,
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          final prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          var fetchedUser =
                                                              json.decode(prefs
                                                                  .getString(
                                                                      'user')!);

                                                          final DateTime now =
                                                              DateTime.now();
                                                          final DateFormat
                                                              formatter1 =
                                                              DateFormat(
                                                                  'yyyy-MM-dd');
                                                          final String
                                                              formattedDate =
                                                              formatter1
                                                                  .format(now);

                                                          final DateFormat
                                                              formatter2 =
                                                              DateFormat('jms');
                                                          final String
                                                              formattedTime =
                                                              formatter2
                                                                  .format(now);

                                                          Order myOrder = Order(
                                                              title: fetchedUser[
                                                                  'name'],
                                                              email:
                                                                  fetchedUser[
                                                                      'email'],
                                                              phoneNo: fetchedUser[
                                                                  'phoneNumber'],
                                                              qty: qty,
                                                              item: id,
                                                              date:
                                                                  formattedDate,
                                                              time:
                                                                  formattedTime);

                                                          BlocProvider.of<
                                                                      OrderBloc>(
                                                                  context)
                                                              .add(PlaceOrder(
                                                                  myOrder));
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Color(
                                                                      0xff404E65)),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "Place Order",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Raleway',
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: pageHeight * 0.04,
                                                ),
                                              ],
                                            );
                                          })
                                        : Container(),
                                  );
                                }
                                if (state is NetworkOffline) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: pageHeight * 0.04,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: pgWidth * 0.03,
                                            right: pgWidth * 0.03),
                                        child: Text(
                                          "Please check your internet connection to place an order.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xffFF9E16),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: pageHeight * 0.04,
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              },
                            ),
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: pgHeight * 0.04),
                                    SizedBox(
                                        child: RecentlyViewed(
                                            parentId: singleMenu.id)),
                                    SizedBox(height: pgHeight * 0.04),
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
          )),
    );
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
          final list = recentlyViewedState.recentlyviewed;
          final recentlyViewed = list.reversed.toList();
          // if (recentlyViewed.isNotEmpty) {
          //   recentlyViewed.removeLast();
          // }
          if (recentlyViewed.length < 4) {
            return Container();
          }
          return Material(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: pgWidth * 0.04),
                    child: Text(
                      'Recently Viewed',
                      style: TextStyle(
                          color: Color(0xff404E65),
                          fontWeight: FontWeight.w900,
                          fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                  SizedBox(height: pgHeight * 0.02),
                  SizedBox(
                    height: pgHeight * 0.18,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: recentlyViewed.length,
                        itemBuilder: (BuildContext context, int index) {
                          var currentItem = recentlyViewed[index];
                          var decoded = jsonDecode(currentItem);
                          return decoded['id'] != parentId
                              ? Padding(
                                  padding: EdgeInsets.all(pgWidth * 0.013),
                                  child: SizedBox(
                                    width: pgWidth * 0.37,
                                    height: pgHeight * 0.12,
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
                                        height: pgHeight * 0.12,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
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
