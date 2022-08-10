import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/bloc/booking/booking_bloc.dart';
import 'package:zebu_app/bloc/booking/booking_event.dart';
import 'package:zebu_app/bloc/booking/booking_state.dart';
import 'package:zebu_app/bloc/order/order_bloc.dart';
import 'package:zebu_app/bloc/order/order_event.dart';
import 'package:zebu_app/bloc/order/order_state.dart';
import 'package:zebu_app/models/order.dart';

import 'package:zebu_app/routeGenerator.dart';

double pgHeight = 0;
double pgWidth = 0;

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({Key? key}) : super(key: key);

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  late OrderBloc orderBloc;

  @override
  void initState() {
    super.initState();
  }

  Future<String> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    var fetchedUser = json.decode(prefs.getString('user')!);
    return fetchedUser['phoneNumber'];
  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;

    setState(() {
      pgHeight = pageHeight;
      pgWidth = pageWidth;
    });
    var fetched = loadUser();

    orderBloc = BlocProvider.of<OrderBloc>(context);
    orderBloc.add(MyOrdersLoad());
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
                onPressed: () => {
                      Navigator.pushNamed(
                        context,
                        RouteGenerator.homeScreenName,
                      ),
                    }),
            backgroundColor: Colors.white,
            title: Text(
              'BOOKINGS',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  color: Color(0xff404E65),
                  fontWeight: FontWeight.w500),
            ),
          ),
          body: DefaultTextStyle(
            style: TextStyle(decoration: TextDecoration.none),
            child: SingleChildScrollView(
              child: BlocConsumer<OrderBloc, OrderState>(
                  listener: (ctx, myOrdersListState) {
                if (myOrdersListState is DeleteOrderSuccess) {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            // title: const Text('Time Not Set'),
                            content: const Text('Order Deleted Succefully'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => {
                                  Navigator.pushNamed(
                                    context,
                                    RouteGenerator.homeScreenName,
                                  )
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ));
                }
              }, builder: (_, myOrdersListState) {
                if (myOrdersListState is LoadingOrder) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff5D7498),
                      ),
                    ),
                  );
                }

                if (myOrdersListState is MyOrdersLoadFailure) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Center(
                      child: Text(
                        "Failed Loading",
                        style: TextStyle(
                          color: Color(0xff404E65),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                if (myOrdersListState is MyOrdersEmpltyFailure) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Center(
                      child: Text(
                        "No Orders yet",
                        style: TextStyle(
                          color: Color(0xff404E65),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                if (myOrdersListState is MyOrdersLoadSuccess) {
                  final myOrders = myOrdersListState.myOrders;
                  return SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: myOrders.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final currentOrder = myOrders[index];

                        var date = currentOrder.date;
                        var parsed = DateTime.parse(date);

                        var year = DateFormat.y().format(parsed);
                        var month = DateFormat.MMM().format(parsed);
                        var day = DateFormat.d().format(parsed);

                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              height: pgHeight * 0.18,
                              decoration: new BoxDecoration(
                                  color: (currentOrder.isDelivered ==
                                          'Undelivered')
                                      ? Color(0xff404E65)
                                      : Color(0xff808080),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9))),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: pgWidth * 0.53,
                                        margin: EdgeInsets.only(
                                            left: pgWidth * 0.03),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              currentOrder.item,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                              softWrap: true,
                                            ),
                                            SizedBox(
                                              height: pgHeight * 0.003,
                                            ),
                                            Text(
                                              month +
                                                  ' ' +
                                                  (day.length == 1
                                                      ? "0" + day
                                                      : day) +
                                                  ' ' +
                                                  year +
                                                  ' - ' +
                                                  currentOrder.time,
                                              style: TextStyle(
                                                  color: Color(0xffFF9E16),
                                                  fontWeight: FontWeight.w500),
                                              softWrap: true,
                                            ),
                                            SizedBox(
                                              height: pgHeight * 0.003,
                                            ),
                                            Text(
                                              'Qty -' + currentOrder.qty,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                              softWrap: true,
                                            ),
                                            SizedBox(
                                              height: pgHeight * 0.003,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              right: pgWidth * 0.1),
                                          child: (currentOrder.isDelivered ==
                                                  'Undelivered')
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        height:
                                                            pgHeight * 0.02),
                                                    GestureDetector(
                                                      onTap: () => {
                                                        BlocProvider.of<
                                                                    OrderBloc>(
                                                                context)
                                                            .add(DeleteOrder(
                                                                currentOrder
                                                                    .id)),
                                                        // BlocProvider.of<
                                                        //             BookingBloc>(
                                                        //         context)
                                                        //     .add(
                                                        //         MyBookingsLoad())
                                                      },
                                                      child: Container(
                                                        child: Container(
                                                          child: Image.asset(
                                                            'assets/images/delete.png',
                                                            width:
                                                                pgWidth * 0.04,
                                                            height:
                                                                pgWidth * 0.04,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(
                                                  // child: Icon(
                                                  //   Icons.schedule,
                                                  //   color: Colors.white,
                                                  //   size: pgWidth * 0.06,
                                                  // ),
                                                  )),
                                    ]),
                              ),
                            ),
                          ),
                        );
                      },
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
