import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:zebu_app/bloc/booking/booking_bloc.dart';
import 'package:zebu_app/bloc/booking/booking_event.dart';
import 'package:zebu_app/bloc/booking/booking_state.dart';
import 'package:zebu_app/bloc/service/service_bloc.dart';
import 'package:zebu_app/bloc/service/service_event.dart';
import 'package:zebu_app/bloc/service/service_state.dart';
import 'package:zebu_app/models/booking.dart';
import 'package:zebu_app/routeGenerator.dart';

import 'package:zebu_app/screens/utils/CalendarUtils.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with TickerProviderStateMixin {
  late ServiceBloc servicebloc;
  late BookingBloc bookingbloc;
  late String serviceSelected;
  List<dynamic> serv = [];
  var _selectedIndex = 0;

  DateTime _focusedDay = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  DateTime _selectedDay = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  late String serviceSelectedDay =
      DateFormat('yyyy-MM-dd').format(_selectedDay);
  String selectedTime = '';
  @override
  void initState() {
    servicebloc = BlocProvider.of<ServiceBloc>(context);
    servicebloc.add(AllServiceLoad());
    serviceSelected = "Dining Lunch";
    bookingbloc = BlocProvider.of<BookingBloc>(context);
    bookingbloc.add(ServiceBookingLoad(
        serviceSelected, serviceSelectedDay, serviceSelected));
    super.initState();
  }

  GlobalKey<_BookingPageState> _sliderKey = GlobalKey();
  late String selectedServiceIndex = "Dining";
  ScrollController listScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'BOOKNG',
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
            child: Column(
              children: [
                BlocConsumer<ServiceBloc, ServiceState>(
                    listener: (ctx, serviceListState) {},
                    builder: (_, serviceListState) {
                      if (serviceListState is LoadingService) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xff5D7498),
                            ),
                          ),
                        );
                      }

                      if (serviceListState is AllServiceLoadFailure ||
                          serviceListState is AllServiceEmpltyFailure) {
                        return const Text(
                          "Failed Loading",
                          style: TextStyle(
                            color: Color(0xff404E65),
                            fontSize: 14,
                          ),
                        );
                      }

                      if (serviceListState is AllServiceLoadSuccess) {
                        final services = serviceListState.allServices;
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 180,
                                child: ListView.builder(
                                  controller: listScrollController,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: services.length,
                                  itemBuilder: (context, index) {
                                    var currentService = services[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedIndex = 0;
                                          selectedServiceIndex =
                                              services[index].title;
                                          serviceSelected =
                                              selectedServiceIndex +
                                                  ' ' +
                                                  currentService.options[0];

                                          // listScrollController.jumpTo(
                                          //     (index / services.length) *
                                          //         5 *
                                          //         MediaQuery.of(context)
                                          //             .size
                                          //             .width);

                                          var serviceDetailPhrase =
                                              serviceSelected ==
                                                          'Dining Lunch' ||
                                                      serviceSelected ==
                                                          'Dining Dinner' ||
                                                      serviceSelected ==
                                                          'Steam Sauna Men' ||
                                                      serviceSelected ==
                                                          'Steam Sauna Women'
                                                  ? serviceSelected
                                                  : selectedServiceIndex;

                                          bookingbloc.add(ServiceBookingLoad(
                                              serviceSelected,
                                              serviceSelectedDay,
                                              serviceDetailPhrase));
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          decoration: new BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: selectedServiceIndex ==
                                                    currentService.title
                                                ? [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.7),
                                                      blurRadius:
                                                          5.0, // soften the shadow
                                                      spreadRadius:
                                                          0.0, //extend the shadow
                                                      offset: Offset(
                                                        0.0, // Move to right 10  horizontally
                                                        5.0, // Move to bottom 10 Vertically
                                                      ),
                                                    )
                                                  ]
                                                : [],
                                          ),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            color: selectedServiceIndex ==
                                                    currentService.title
                                                ? Color(0xffFF9E16)
                                                : Color(0xff404E65),
                                            child: SafeArea(
                                              child: Column(children: <Widget>[
                                                SizedBox(height: 10),
                                                Image.network(
                                                  "http://45.79.249.127" +
                                                      currentService.image,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.1,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  currentService.title,
                                                  style: TextStyle(
                                                      color:
                                                          selectedServiceIndex ==
                                                                  currentService
                                                                      .title
                                                              ? Colors.black
                                                              : Color(
                                                                  0xffFF9E16),
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  currentService.description!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0),
                                                ),
                                                SizedBox(height: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: Container(
                                                    child:
                                                        currentService.options
                                                                    .length ==
                                                                2
                                                            ? FlutterToggleTab(
                                                                // width in percent, to set full width just set to 100
                                                                width: 50,
                                                                borderRadius:
                                                                    30,
                                                                height: 20,
                                                                // initialIndex: 0,
                                                                selectedBackgroundColors: [
                                                                  Colors.white
                                                                ],
                                                                selectedTextStyle: TextStyle(
                                                                    color: Color(
                                                                        0xff7D7D7D),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                                unSelectedTextStyle: TextStyle(
                                                                    color: Color(
                                                                        0xff7D7D7D),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                labels:
                                                                    currentService
                                                                        .options,
                                                                selectedLabelIndex:
                                                                    (labelIndex) {
                                                                  setState(() {
                                                                    _selectedIndex =
                                                                        labelIndex;
                                                                    selectedServiceIndex =
                                                                        services[index]
                                                                            .title;
                                                                    serviceSelected =
                                                                        selectedServiceIndex +
                                                                            ' ' +
                                                                            currentService.options[labelIndex];
                                                                    print(
                                                                        serviceSelected);

                                                                    var serviceDetailPhrase = serviceSelected == 'Dining Lunch' ||
                                                                            serviceSelected ==
                                                                                'Dining Dinner' ||
                                                                            serviceSelected ==
                                                                                'Steam Sauna Men' ||
                                                                            serviceSelected ==
                                                                                'Steam Sauna Women'
                                                                        ? serviceSelected
                                                                        : selectedServiceIndex;

                                                                    bookingbloc.add(ServiceBookingLoad(
                                                                        serviceSelected,
                                                                        serviceSelectedDay,
                                                                        serviceDetailPhrase));
                                                                  });
                                                                },
                                                                selectedIndex:
                                                                    _selectedIndex,
                                                              )
                                                            : Container(),
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    }),
                BlocConsumer<BookingBloc, BookingState>(
                    listener: (ctx, bookingState) {
                  if (bookingState is BookingSuccess) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              // title: const Text('Time Not Set'),
                              content: const Text('Booked Succefully'),
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
                }, builder: (_, bookingState) {
                  if (bookingState is LoadingBooking) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff5D7498),
                        ),
                      ),
                    );
                  }

                  if (bookingState is ServiceBookingLoadFailure) {
                    return const Text(
                      "Failed Loading",
                      style: TextStyle(
                        color: Color(0xff404E65),
                        fontSize: 14,
                      ),
                    );
                  }

                  if (bookingState is ServiceBookingLoadSuccess) {
                    final bookings = bookingState.serviceBookings;
                    final slots = bookingState.serviceDetail.slots;
                    final quota = int.parse(bookingState.serviceDetail.quota);

                    bookings.forEach((booking) {
                      slots[booking.time]++;
                    });

                    var availableSlots = [];
                    slots.forEach((k, v) => {
                          if (v < quota) {availableSlots.add(k)}
                        });

                    return Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TableCalendar(
                            rowHeight: 45.0,
                            sixWeekMonthsEnforced: false,
                            headerStyle: const HeaderStyle(
                              headerPadding:
                                  EdgeInsets.only(left: 16.0, bottom: 12.0),
                              leftChevronVisible: false,
                              rightChevronVisible: false,
                              formatButtonVisible: false,
                              titleCentered: false,
                              titleTextStyle:
                                  TextStyle(color: Colors.black, fontSize: 22),
                              formatButtonTextStyle:
                                  TextStyle(color: Colors.white),
                              formatButtonShowsNext: false,
                            ),
                            calendarStyle: const CalendarStyle(
                              cellMargin: EdgeInsets.all(0.0),
                              weekendTextStyle: TextStyle(
                                  color: Color(0xff3D3D3D),
                                  fontWeight: FontWeight.w700),
                              disabledTextStyle: TextStyle(
                                color: Color(0xffFFDEDE),
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                              defaultTextStyle: TextStyle(
                                  color: Color(0xff3D3D3D),
                                  fontWeight: FontWeight.w700),
                              cellPadding: EdgeInsets.all(0.0),
                              selectedDecoration: BoxDecoration(
                                  color: const Color(0xFFFF9E16),
                                  shape: BoxShape.rectangle),
                              selectedTextStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.0,
                              ),
                              todayDecoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle),
                              todayTextStyle: TextStyle(
                                color: Color(0xFFFF9E16),
                                fontWeight: FontWeight.w700,
                                fontSize: 14.0,
                              ),
                            ),
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            focusedDay: _focusedDay,
                            calendarFormat: CalendarFormat.month,
                            selectedDayPredicate: (day) {
                              // Use `selectedDayPredicate` to determine which day is currently selected.
                              // If this returns true, then `day` will be marked as selected.

                              // Using `isSameDay` is recommended to disregard
                              // the time-part of compared DateTime objects.
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              if (!isSameDay(_selectedDay, selectedDay)) {
                                // Call `setState()` when updating the selected day
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });

                                serviceSelectedDay = DateFormat('yyyy-MM-dd')
                                    .format(_selectedDay);

                                var serviceDetailPhrase = serviceSelected ==
                                            'Dining Lunch' ||
                                        serviceSelected == 'Dining Dinner' ||
                                        serviceSelected == 'Steam Sauna Men' ||
                                        serviceSelected == 'Steam Sauna Women'
                                    ? serviceSelected
                                    : selectedServiceIndex;

                                bookingbloc.add(ServiceBookingLoad(
                                    serviceSelected,
                                    serviceSelectedDay,
                                    serviceDetailPhrase));
                              }
                            },
                            onPageChanged: (focusedDay) {
                              // No need to call `setState()` here
                              _focusedDay = focusedDay;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.0),
                              availableSlots.length == 0
                                  ? Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        'No Data Available',
                                        style: TextStyle(
                                          color: Color(0xff5D7498),
                                          fontSize: 18,
                                        ),
                                      ),
                                    )
                                  : GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                        childAspectRatio: 0.90 / 0.35,
                                      ),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: availableSlots.length,
                                      itemBuilder: (context, index) {
                                        var timeslot = availableSlots[index];
                                        return Container(
                                          height: 20.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.5,
                                          decoration: BoxDecoration(
                                            color: selectedTime == timeslot
                                                ? Color(0xFFFF9E16)
                                                : Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedTime = timeslot;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  timeslot.toString(),
                                                  style: TextStyle(
                                                    color:
                                                        selectedTime == timeslot
                                                            ? Colors.white
                                                            : Color(0xff5D7498),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                }),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          var fetchedUser =
                              json.decode(prefs.getString('user')!);

                          if (selectedTime == '') {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Time Not Set'),
                                      content: const Text(
                                          'Please select prefered time.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ));
                          }

                          Booking myBooking = Booking(
                              title: fetchedUser['name'],
                              email: fetchedUser['email'],
                              phoneNo: fetchedUser['phoneNumber'],
                              time: selectedTime,
                              date: serviceSelectedDay,
                              serviceType: serviceSelected);

                          BlocProvider.of<BookingBloc>(context)
                              .add(Book(myBooking));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xff404E65)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: Text(
                          "Book",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
