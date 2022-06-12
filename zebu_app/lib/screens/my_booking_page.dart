import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/bloc/booking/booking_bloc.dart';
import 'package:zebu_app/bloc/booking/booking_event.dart';
import 'package:zebu_app/bloc/booking/booking_state.dart';

import 'package:zebu_app/routeGenerator.dart';

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
    var fetched = loadUser();

    bookingBloc = BlocProvider.of<BookingBloc>(context);
    bookingBloc.add(MyBookingsLoad());
    return Scaffold(
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
                          content: const Text('Booked Deleted Succefully'),
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
                      "Failed Loading",
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
                      "No Booking Items yet",
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
                        padding: const EdgeInsets.all(2.0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Container(
                            height: 105,
                            decoration: new BoxDecoration(
                                color: Color(0xff404E65),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 230,
                                      margin: EdgeInsets.only(left: 10),
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
                                            height: 3,
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
                                            height: 3,
                                          ),
                                          Text(
                                            currentBooking.time,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(right: 40),
                                        child: (parsed.isAfter(DateTime.now()))
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => {
                                                      Navigator.pushNamed(
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
                                                      child: Container(
                                                        child: Image.asset(
                                                          'assets/images/edit.png',
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
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
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                child: Icon(
                                                  Icons.schedule,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
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
        ));
  }
}
