import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';

import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:zebu_app/bloc/dining_booking/dining_booking_bloc.dart';
import 'package:zebu_app/bloc/dining_booking/dining_booking_event.dart';
import 'package:zebu_app/bloc/dining_booking/dining_booking_state.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_bloc.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_event.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_state.dart';
import 'package:zebu_app/bloc/service/service_bloc.dart';
import 'package:zebu_app/bloc/service/service_event.dart';
import 'package:zebu_app/bloc/service/service_state.dart';
import 'package:zebu_app/models/booking.dart';
import 'package:zebu_app/routeGenerator.dart';

import 'package:zebu_app/screens/utils/CalendarUtils.dart';

double pgHeight = 0;
double pgWidth = 0;
NetworkConnectivityBloc? _networkConnectivityBloc;

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage>
    with TickerProviderStateMixin {
  late ServiceBloc servicebloc;
  late DiningBookingBloc bookingbloc;
  late String serviceSelected;
  late String guestNo = '2';
  final guestNamesTextController = TextEditingController();

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
    _networkConnectivityBloc =
        BlocProvider.of<NetworkConnectivityBloc>(context);
    _networkConnectivityBloc!.add(InitNetworkConnectivity());
    _networkConnectivityBloc!.add(ListenNetworkConnectivity());

    servicebloc = BlocProvider.of<ServiceBloc>(context);
    servicebloc.add(AllServiceLoad());
    serviceSelected = "Group Dining Lunch";
    bookingbloc = BlocProvider.of<DiningBookingBloc>(context);
    bookingbloc.add(ServiceBookingLoad(
        serviceSelected, serviceSelectedDay, serviceSelected));
    super.initState();
  }

  GlobalKey<_BookingPageState> _sliderKey = GlobalKey();
  // static final _formKey = new GlobalKey<FormState>();
  late String selectedServiceIndex = "Group Dining";
  ScrollController listScrollController = ScrollController();
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
              child: BlocBuilder(
                bloc: _networkConnectivityBloc,
                builder:
                    (BuildContext context, NetworkConnectivityState state) {
                  if (state is NetworkOnline) {
                    return Column(
                      children: [
                        BlocConsumer<ServiceBloc, ServiceState>(
                            listener: (ctx, serviceListState) {},
                            builder: (_, serviceListState) {
                              if (serviceListState is LoadingService) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height /
                                          1.3,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xff5D7498),
                                    ),
                                  ),
                                );
                              }

                              if (serviceListState
                                      is AllServiceLoadFailure ||
                                  serviceListState
                                      is AllServiceEmpltyFailure) {
                                return Center(
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height /
                                            1.3,
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

                              if (serviceListState
                                  is AllServiceLoadSuccess) {
                                final services =
                                    serviceListState.allServices;
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: pgHeight * 0.24,
                                        child: ListView.builder(
                                          controller: listScrollController,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: services.length,
                                          itemBuilder: (context, index) {
                                            var currentService =
                                                services[index];
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedIndex = 0;
                                                  selectedServiceIndex =
                                                      services[index].title;
                                                  serviceSelected =
                                                      selectedServiceIndex +
                                                          ' ' +
                                                          currentService
                                                              .options[0];

                                                  // listScrollController.jumpTo(
                                                  //     (index / services.length) *
                                                  //         5 *
                                                  //         MediaQuery.of(context)
                                                  //             .size
                                                  //             .width);

                                                  var serviceDetailPhrase =
                                                      serviceSelected ==
                                                                  'Group Dining Lunch' ||
                                                              serviceSelected ==
                                                                  'Group Dining Dinner' ||
                                                              serviceSelected ==
                                                                  'Steam Sauna Men' ||
                                                              serviceSelected ==
                                                                  'Steam Sauna Women'
                                                          ? serviceSelected
                                                          : selectedServiceIndex;

                                                  _focusedDay =
                                                      new DateTime(
                                                          DateTime.now()
                                                              .year,
                                                          DateTime.now()
                                                              .month,
                                                          DateTime.now()
                                                                  .day +
                                                              1);
                                                  _selectedDay =
                                                      new DateTime(
                                                          DateTime.now()
                                                              .year,
                                                          DateTime.now()
                                                              .month,
                                                          DateTime.now()
                                                                  .day +
                                                              1);
                                                  serviceSelectedDay =
                                                      DateFormat(
                                                              'yyyy-MM-dd')
                                                          .format(
                                                              _selectedDay);
                                                  selectedTime = '';
                                                  guestNamesTextController
                                                      .text = '';

                                                  bookingbloc.add(
                                                      ServiceBookingLoad(
                                                          serviceSelected,
                                                          serviceSelectedDay,
                                                          serviceDetailPhrase));
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: pgWidth * 0.03,
                                                  // right: pgWidth * 0.03
                                                ),
                                                child: Container(
                                                  height: pgHeight * 0.2625,
                                                  width: pgWidth * 0.45,
                                                  decoration:
                                                      new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(25),
                                                    boxShadow:
                                                        selectedServiceIndex ==
                                                                currentService
                                                                    .title
                                                            ? [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.7),
                                                                  blurRadius:
                                                                      5.0, // soften the shadow
                                                                  spreadRadius:
                                                                      0.0, //extend the shadow
                                                                  offset:
                                                                      Offset(
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
                                                            BorderRadius
                                                                .circular(
                                                                    17)),
                                                    color:
                                                        selectedServiceIndex ==
                                                                currentService
                                                                    .title
                                                            ? Color(
                                                                0xffFF9E16)
                                                            : Color(
                                                                0xff404E65),
                                                    child: SafeArea(
                                                      child: Column(
                                                          children: <
                                                              Widget>[
                                                            SizedBox(
                                                                height:
                                                                    pgHeight *
                                                                        0.03),
                                                            Image.network(
                                                              "http://45.79.249.127" +
                                                                  currentService
                                                                      .image,
                                                              height:
                                                                  pgHeight *
                                                                      0.07,
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    pgHeight *
                                                                        0.003),
                                                            Text(
                                                              currentService
                                                                  .title,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: selectedServiceIndex ==
                                                                          currentService
                                                                              .title
                                                                      ? Colors
                                                                          .black
                                                                      : Color(
                                                                          0xffFF9E16),
                                                                  fontSize: currentService.title.length >
                                                                          20
                                                                      ? 12.0
                                                                      : 14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    pgHeight *
                                                                        0.003),
                                                            Text(
                                                              currentService
                                                                  .description!,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      11.0),
                                                            ),
                                                            SizedBox(
                                                                height: currentService.title.length >
                                                                        20
                                                                    ? pgHeight *
                                                                        0.003
                                                                    : pgHeight *
                                                                        0.02),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  right:
                                                                      8.0),
                                                              child:
                                                                  Container(
                                                                child: currentService.options.length ==
                                                                        2
                                                                    ? FlutterToggleTab(
                                                                        // width in percent, to set full width just set to 100
                                                                        width:
                                                                            40,
                                                                        borderRadius:
                                                                            16,
                                                                        height:
                                                                            pgHeight * 0.02,
                                                                        // initialIndex: 0,
                                                                        selectedBackgroundColors: [
                                                                          Colors.white
                                                                        ],
                                                                        selectedTextStyle: TextStyle(
                                                                            color: Color(0xff7D7D7D),
                                                                            fontSize: 8,
                                                                            fontWeight: FontWeight.w700),
                                                                        unSelectedTextStyle: TextStyle(
                                                                            color: Color(0xff7D7D7D),
                                                                            fontSize: 8,
                                                                            fontWeight: FontWeight.w500),
                                                                        labels:
                                                                            currentService.options,
                                                                        selectedLabelIndex:
                                                                            (labelIndex) {
                                                                          setState(() {
                                                                            _selectedIndex = labelIndex;
                                                                            selectedServiceIndex = services[index].title;
                                                                            serviceSelected = selectedServiceIndex + ' ' + currentService.options[labelIndex];

                                                                            var serviceDetailPhrase = serviceSelected == 'Group Dining Lunch' || serviceSelected == 'Group Dining Dinner' || serviceSelected == 'Steam Sauna Men' || serviceSelected == 'Steam Sauna Women' ? serviceSelected : selectedServiceIndex;

                                                                            bookingbloc.add(ServiceBookingLoad(serviceSelected, serviceSelectedDay, serviceDetailPhrase));
                                                                          });
                                                                        },
                                                                        selectedIndex:
                                                                            _selectedIndex,
                                                                      )
                                                                    : Container(),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    pgHeight *
                                                                        0.01),
                                                          ]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            }),
                        BlocConsumer<DiningBookingBloc, DiningBookingState>(
                            listener: (ctx, bookingState) {
                          if (bookingState is BookingSuccess) {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialog(
                                      // title: const Text('Time Not Set'),
                                      content:
                                          const Text('Booked Succefully'),
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
                          if (bookingState is BookingFailure) {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialog(
                                      // title: const Text('Time Not Set'),
                                      content: const Text(
                                          'Sorry, please try again.'),
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
                              height:
                                  MediaQuery.of(context).size.height / 1.3,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff5D7498),
                                ),
                              ),
                            );
                          }

                          if (bookingState is ServiceBookingLoadFailure) {
                            return Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height /
                                    1.3,
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

                          if (bookingState is ServiceBookingLoadSuccess) {
                            final bookings = bookingState.serviceBookings;
                            final slots = bookingState.serviceDetail.slots;
                            final quota =
                                int.parse(bookingState.serviceDetail.quota);
                            final specDesc =
                                bookingState.serviceDetail.specDesc;

                            slots.forEach((k, v) => {slots[k] = 0});

                            bookings.forEach((booking) {
                              slots[booking.time]++;
                            });

                            var availableSlots = [];
                            slots.forEach((k, v) => {
                                  if (v < quota) {availableSlots.add(k)}
                                });

                            return Container(
                              padding: EdgeInsets.only(
                                  left: pgWidth * 0.08,
                                  right: pgWidth * 0.08),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  TableCalendar(
                                    rowHeight: pgHeight * 0.05,
                                    sixWeekMonthsEnforced: false,
                                    headerStyle: HeaderStyle(
                                      headerPadding: EdgeInsets.only(
                                          top: pgHeight * 0.05,
                                          left: pgWidth * 0.03,
                                          bottom: pgHeight * 0.02),
                                      leftChevronVisible: false,
                                      rightChevronVisible: false,
                                      formatButtonVisible: false,
                                      titleCentered: false,
                                      titleTextStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 28),
                                      formatButtonTextStyle:
                                          TextStyle(color: Colors.white),
                                      formatButtonShowsNext: false,
                                    ),
                                    calendarStyle: CalendarStyle(
                                      cellMargin: EdgeInsets.only(
                                          top: pgHeight * 0.005),
                                      cellPadding: EdgeInsets.symmetric(
                                          vertical: pgHeight * 0.01,
                                          horizontal: pgWidth * 0.02),
                                      weekendTextStyle: TextStyle(
                                          color: Color(0xff3D3D3D),
                                          fontWeight: FontWeight.w700),
                                      disabledTextStyle: TextStyle(
                                        color: Color(0xffFFDEDE),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0,
                                      ),
                                      defaultTextStyle: TextStyle(
                                          color: Color(0xff3D3D3D),
                                          fontWeight: FontWeight.w700),
                                      selectedDecoration: BoxDecoration(
                                          color: const Color(0xFFFF9E16),
                                          shape: BoxShape.rectangle),
                                      selectedTextStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.0,
                                      ),
                                      todayDecoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle),
                                      todayTextStyle: TextStyle(
                                        color: Color(0xFFFF9E16),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.0,
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
                                    onDaySelected:
                                        (selectedDay, focusedDay) {
                                      if (!isSameDay(
                                          _selectedDay, selectedDay)) {
                                        // Call `setState()` when updating the selected day
                                        setState(() {
                                          _selectedDay = selectedDay;
                                          _focusedDay = focusedDay;
                                        });

                                        serviceSelectedDay =
                                            DateFormat('yyyy-MM-dd')
                                                .format(_selectedDay);

                                        var serviceDetailPhrase =
                                            serviceSelected ==
                                                        'Group Dining Lunch' ||
                                                    serviceSelected ==
                                                        'Group Dining Dinner' ||
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
                                      }
                                    },
                                    onPageChanged: (focusedDay) {
                                      // No need to call `setState()` here
                                      _focusedDay = focusedDay;
                                    },
                                  ),
                                  SizedBox(
                                    height: pgHeight * 0.06,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: pgWidth * 0.03,
                                        right: pgWidth * 0.03),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10.0),
                                        availableSlots.length == 0
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(
                                                        15.0),
                                                child: Text(
                                                  'No Data Available',
                                                  textAlign:
                                                      TextAlign.center,
                                                  style: TextStyle(
                                                    color:
                                                        Color(0xff5D7498),
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
                                                  childAspectRatio:
                                                      0.90 / 0.35,
                                                ),
                                                scrollDirection:
                                                    Axis.vertical,
                                                shrinkWrap: true,
                                                physics:
                                                    ClampingScrollPhysics(),
                                                itemCount:
                                                    availableSlots.length,
                                                itemBuilder:
                                                    (context, index) {
                                                  var timeslot =
                                                      availableSlots[index];
                                                  return Container(
                                                    height: 20.0,
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width /
                                                        3.5,
                                                    decoration:
                                                        BoxDecoration(
                                                      color: selectedTime ==
                                                              timeslot
                                                          ? Color(
                                                              0xFFFF9E16)
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(
                                                            17.0),
                                                      ),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedTime =
                                                              timeslot;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: Text(
                                                            timeslot
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: selectedTime ==
                                                                        timeslot
                                                                    ? Colors
                                                                        .white
                                                                    : Color(
                                                                        0xff5D7498),
                                                                fontSize:
                                                                    14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
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
                                  SizedBox(
                                    height: pgHeight * 0.03,
                                  ),
                                  Center(
                                    child: serviceSelected ==
                                                'Group Dining Lunch' ||
                                            serviceSelected ==
                                                'Group Dining Dinner'
                                        ? Form(
                                            // key: _formKey,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: pgWidth * 0.03,
                                                  right: pgWidth * 0.03),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.only(
                                                            top: pgHeight *
                                                                0.01),
                                                    child: Text(
                                                      specDesc,
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xff641E0D)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: pgHeight * 0.03,
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Number of Guests",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        SizedBox(
                                                          width: pgWidth *
                                                              0.05,
                                                        ),
                                                        CustomNumberPicker(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          initialValue: 2,
                                                          maxValue: 5,
                                                          minValue: 2,
                                                          step: 1,
                                                          enable: true,
                                                          onValue: (value) {
                                                            setState(() {
                                                              guestNo = value
                                                                  .toString();
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: pgHeight * 0.02,
                                                  ),
                                                  Text(
                                                    'Guest Names',
                                                    style: TextStyle(
                                                        color: Color(
                                                            0xff404E65),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Raleway'),
                                                    softWrap: true,
                                                  ),
                                                  SizedBox(
                                                    height: pgHeight * 0.01,
                                                  ),
                                                  TextFormField(
                                                    minLines: 4,
                                                    maxLines: null,
                                                    keyboardType:
                                                        TextInputType
                                                            .multiline,
                                                    decoration:
                                                        InputDecoration(
                                                      // hintText: "Input your opinion",
                                                      // hintStyle: TextStyle(color: Colors.white30),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  new Radius
                                                                          .circular(
                                                                      10.0))),
                                                      // labelStyle: TextStyle(color: Colors.white)
                                                    ),
                                                    textAlign:
                                                        TextAlign.start,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                    ),
                                                    controller:
                                                        guestNamesTextController,
                                                  ),
                                                  SizedBox(
                                                    height: pgHeight * 0.02,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        }),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: pgWidth * 0.11,
                                right: pgWidth * 0.11),
                            child: SizedBox(
                              width: double.infinity,
                              height: pgHeight * 0.06,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  var fetchedUser =
                                      json.decode(prefs.getString('user')!);

                                  if (selectedTime == '') {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: Text('Time Not Set',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                              content: Text(
                                                  'Please select prefered time.',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  )),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ));
                                  } else if ((serviceSelected ==
                                              'Group Dining Lunch' ||
                                          serviceSelected ==
                                              'Group Dining Dinner') &&
                                      guestNamesTextController.value.text ==
                                          '') {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: Text(
                                                  'Guest names required',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                              content: const Text(
                                                  'Please enter guest names.',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  )),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ));
                                  } else {
                                    Booking myBooking = Booking(
                                        title: fetchedUser['name'],
                                        email: fetchedUser['email'],
                                        phoneNo: fetchedUser['phoneNumber'],
                                        time: selectedTime,
                                        date: serviceSelectedDay,
                                        serviceType: serviceSelected,
                                        noOfGuests: (serviceSelected ==
                                                    'Group Dining Lunch' ||
                                                serviceSelected ==
                                                    'Group Dining Dinner')
                                            ? guestNo
                                            : null,
                                        guestNames: guestNamesTextController
                                            .value.text);

                                    BlocProvider.of<DiningBookingBloc>(
                                            context)
                                        .add(Book(myBooking));
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff404E65)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20),
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
                    );
                  }
                  if (state is NetworkOffline) {
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
                  return Container();
                },
              ),
            ),
          )),
    );
  }
}
