import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/bloc/booking/booking_bloc.dart';
import 'package:zebu_app/bloc/booking/booking_event.dart';
import 'package:zebu_app/bloc/booking/booking_state.dart';

import 'package:zebu_app/routeGenerator.dart';

double pgHeight = 0;
double pgWidth = 0;

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({Key? key}) : super(key: key);

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  late BookingBloc bookingBloc;

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

    bookingBloc = BlocProvider.of<BookingBloc>(context);
    bookingBloc.add(MyBookingsLoad());
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
              child: BlocConsumer<BookingBloc, BookingState>(
                  listener: (ctx, myBookingsListState) {
                if (myBookingsListState is DeleteBookingSuccess) {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            // title: const Text('Time Not Set'),
                            content: const Text('Booking Deleted Succefully'),
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
              }, builder: (_, myBookingsListState) {
               
                if (myBookingsListState is LoadingBooking) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff5D7498),
                      ),
                    ),
                  );
                }

                if (myBookingsListState is MyBookingsLoadFailure) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Center(
                      child: Text(
                        "Please check your internet connection and try again.",
                        style: TextStyle(
                          color: Color(0xff404E65),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                if (myBookingsListState is MyBookingsEmpltyFailure) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Center(
                      child: Text(
                        "No items yet",
                        style: TextStyle(
                          color: Color(0xff404E65),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                if (myBookingsListState is MyBookingsLoadSuccess) {
                  final myBookings = myBookingsListState.myBookings;
                  return SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: myBookings.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final currentBooking = myBookings[index];

                        var date = currentBooking.date.substring(0, 10);
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
                              height: pgHeight * 0.2,
                              decoration: new BoxDecoration(
                                  color: (parsed.isAfter(DateTime.now()))
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
                                              currentBooking.serviceType,
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
                                                  year,
                                              style: TextStyle(
                                                  color: Color(0xffFF9E16),
                                                  fontWeight: FontWeight.w500),
                                              softWrap: true,
                                            ),
                                            SizedBox(
                                              height: pgHeight * 0.003,
                                            ),
                                            Text(
                                              currentBooking.time,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                              softWrap: true,
                                            ),
                                            SizedBox(
                                              height: pgHeight * 0.003,
                                            ),
                                            Container(
                                              child: currentBooking
                                                          .staffComment !=
                                                      null
                                                  ? Text(
                                                      currentBooking
                                                          .staffComment,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.red),
                                                      softWrap: true,
                                                    )
                                                  : Container(),
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
                                          child: (parsed
                                                  .isAfter(DateTime.now()))
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: currentBooking
                                                                  .staffComment ==
                                                              null
                                                          ? GestureDetector(
                                                              onTap: () => {
                                                                Navigator
                                                                    .pushNamed(
                                                                  context,
                                                                  RouteGenerator
                                                                      .editBookingScreenName,
                                                                  arguments:
                                                                      ScreenArguments({
                                                                    'booking':
                                                                        currentBooking
                                                                  }),
                                                                ),
                                                              },
                                                              child: Container(
                                                                child:
                                                                    Container(
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/edit.png',
                                                                    width:
                                                                        pgWidth *
                                                                            0.04,
                                                                    height:
                                                                        pgWidth *
                                                                            0.04,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            pgHeight * 0.02),
                                                    GestureDetector(
                                                      onTap: () => {
                                                        BlocProvider.of<
                                                                    BookingBloc>(
                                                                context)
                                                            .add(DeleteBooking(
                                                                currentBooking
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
