import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:zebu_app/bloc/booking/booking_bloc.dart';
import 'package:zebu_app/bloc/booking/booking_event.dart';
import 'package:zebu_app/bloc/booking/booking_state.dart';
import 'package:zebu_app/bloc/service/service_bloc.dart';
import 'package:zebu_app/bloc/service/service_event.dart';
import 'package:zebu_app/bloc/service/service_state.dart';

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

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  DateTime _selectedDay = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  late String serviceSelectedDay =
      DateFormat('yyyy-MM-dd').format(_selectedDay);

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
            onPressed: () => Navigator.of(context).pop(),
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

                                          listScrollController.jumpTo(
                                              (index / services.length) *
                                                  5 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width);

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
                    listener: (ctx, bookingState) {},
                    builder: (_, bookingState) {
                      print(bookingState);
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
                        final serviceDetail = bookingState.serviceDetail;
                        print(serviceDetail);
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                child: ListView.builder(
                                  controller: listScrollController,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: bookings.length,
                                  itemBuilder: (context, index) {
                                    var currentBooking = bookings[index];
                                    return Text(
                                      currentBooking.title,
                                      style: TextStyle(color: Colors.black),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TableCalendar(
                                  rowHeight: 45.0,
                                  sixWeekMonthsEnforced: true,
                                  headerStyle: const HeaderStyle(
                                    headerPadding: EdgeInsets.only(
                                        left: 16.0, bottom: 12.0),
                                    leftChevronVisible: false,
                                    rightChevronVisible: false,
                                    formatButtonVisible: false,
                                    titleCentered: false,
                                    titleTextStyle: TextStyle(
                                        color: Colors.black, fontSize: 22),
                                    formatButtonTextStyle:
                                        TextStyle(color: Colors.white),
                                    formatButtonShowsNext: false,
                                  ),
                                  calendarStyle: const CalendarStyle(
                                    cellMargin: EdgeInsets.all(0.0),
                                    weekendTextStyle: TextStyle(
                                        color: Color(0xff3D3D3D),
                                        fontWeight: FontWeight.w700),
                                    outsideTextStyle: TextStyle(
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
                                      print("selected");
                                      print(_selectedDay);
                                      serviceSelectedDay =
                                          DateFormat('yyyy-MM-dd')
                                              .format(_selectedDay);
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
                              Container(
                                child: Text(
                                  serviceSelectedDay,
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ),
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
                        onPressed: () {
                          print("book");
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
