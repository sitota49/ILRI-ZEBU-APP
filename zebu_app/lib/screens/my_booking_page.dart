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
            onPressed: () => Navigator.of(context).pop(),
          ),
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
                listener: (ctx, myBookingsListState) {},
                builder: (_, myBookingsListState) {
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
                    return const Text(
                      "Failed Loading",
                      style: TextStyle(
                        color: Color(0xff404E65),
                        fontSize: 14,
                      ),
                    );
                  }

                  if (myBookingsListState is MyBookingsEmpltyFailure) {
                    return const Text(
                      "No Booking Items Found",
                      style: TextStyle(
                        color: Color(0xff404E65),
                        fontSize: 14,
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Container(
                                height: 100,
                                decoration: new BoxDecoration(
                                    color: Color(0xff404E65),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 230,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                currentBooking.serviceType,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                                softWrap: true,
                                              ),
                                              Text(
                                                currentBooking.time,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                month.toUpperCase(),
                                                style: TextStyle(
                                                    color: Color(0xffFF9E16),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                day.length == 1
                                                    ? "0" + day
                                                    : day,
                                                style: TextStyle(fontSize: 22),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                year,
                                                style: TextStyle(
                                                    color: Color(0xffFF9E16),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => {
                                            BlocProvider.of<BookingBloc>(
                                                    context)
                                                .add(DeleteBooking(
                                                    currentBooking.id)),
                                            BlocProvider.of<BookingBloc>(
                                                    context)
                                                .add(MyBookingsLoad())
                                          },
                                          child: Container(
                                            child: Column(children: [
                                              Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )
                                            ]),
                                          ),
                                        ),
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
