import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zebu_app/bloc/booking/booking_bloc.dart';
import 'package:zebu_app/bloc/booking/booking_event.dart';
import 'package:zebu_app/bloc/booking/booking_state.dart';
import 'package:zebu_app/models/booking.dart';
import 'package:zebu_app/routeGenerator.dart';

import 'package:zebu_app/screens/utils/CalendarUtils.dart';

class EditBookingPage extends StatefulWidget {
  final Map argObj;

  const EditBookingPage({Key? key, required this.argObj}) : super(key: key);

  @override
  State<EditBookingPage> createState() => _EditBookingPageState(argObj: argObj);
}

class _EditBookingPageState extends State<EditBookingPage> {
  final Map argObj;
  _EditBookingPageState({required this.argObj});

  var _selectedDay;
  var _focusedDay;
  var serviceSelectedDay;
  var selectedTime;
  var newDate;
  var newTime;
  var mydate;
  var booking;
  var serviceSelected;
  late BookingBloc bookingbloc;
  @override
  void initState() {
    booking = argObj['booking'];
    _selectedDay = DateTime.parse(booking.date);
    _focusedDay = DateTime.parse(booking.date);
    serviceSelectedDay = booking.date;
    selectedTime = booking.time;
    serviceSelected = booking.serviceType;
    if (booking.serviceType == 'Football/Basketball/Playground With Coach' ||
        booking.serviceType == 'Football/Basketball/Playground Without Coach') {
      serviceSelected = 'Football/Basketball/Playground';
    }
    if (booking.serviceType == 'Squash With Coach' ||
        booking.serviceType == 'Squash Without Coach') {
      serviceSelected = 'Squash';
    }

    if (booking.serviceType == 'Ground Tennis With Coach' ||
        booking.serviceType == 'Ground Tennis Without Coach') {
      serviceSelected = 'Ground Tennis';
    }
    if (booking.serviceType == 'Jogging Path Individual' ||
        booking.serviceType == 'Jogging Path Family') {
      serviceSelected = 'Jogging Path';
    }
    if (booking.serviceType == 'Swimming Individual' ||
        booking.serviceType == 'Swimming Family') {
      serviceSelected = 'Swimming';
    }
    if (booking.serviceType == 'Gym ') {
      serviceSelected = 'Gym';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // DateTime _focusedDay = new DateTime(
    //     DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

    // DateTime _selectedDay = new DateTime(
    //     DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

    // _selectedDay = new DateTime(mydate.year, mydate.month, mydate.day);
    // _focusedDay = new DateTime(mydate.year, mydate.month, mydate.day);

    bookingbloc = BlocProvider.of<BookingBloc>(context);
    bookingbloc.add(ServiceBookingLoad(
        serviceSelected, serviceSelectedDay, serviceSelected));

    var date = booking.date!.substring(0, 10);
    var parsed = DateTime.parse(date);
    var output = DateFormat.yMMMMd().format(_selectedDay);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xff404E65),
              onPressed: () => {
                    Navigator.pushNamed(
                      context,
                      RouteGenerator.mybookingScreenName,
                    ),
                  }),
          backgroundColor: Colors.white,
          title: Text(
            'BOOKING',
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    booking.serviceType + ' ' + 'Reservation',
                    style: TextStyle(
                        color: Color(0xff404E65),
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  output + ' - ' + selectedTime,
                  style: TextStyle(
                      color: Color(0xff404E65),
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                  softWrap: true,
                ),
                BlocConsumer<BookingBloc, BookingState>(
                    listener: (ctx, bookingState) {
                  if (bookingState is UpdateBookingSuccess) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              // title: const Text('Time Not Set'),
                              content:
                                  const Text('Booking Rescheduled Succefully'),
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
                    final slots = bookingState.serviceDetail.slots;
                    final quota = int.parse(bookingState.serviceDetail.quota);

                    bookings.forEach((booking) {
                      slots[booking.time]++;
                    });

                    var availableSlots = [];
                    slots.forEach((k, v) => {
                          if (v < quota) {availableSlots.add(k)}
                        });

                    return SingleChildScrollView(
                      child: Column(
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
                              focusedDay:
                                  newDate != null ? newDate : _focusedDay,
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
                                      .format(newDate != null
                                          ? newDate
                                          : _selectedDay);

                                  var serviceDetailPhrase = serviceSelected;
                                  //         'Dining Lunch' ||
                                  //     serviceSelected == 'Dining Dinner' ||
                                  //     serviceSelected ==
                                  //         'Steam Sauna Men' ||
                                  //     serviceSelected == 'Steam Sauna Women'
                                  // ? serviceSelected
                                  // : selectedServiceIndex;

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
                                                      color: selectedTime ==
                                                              timeslot
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
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // final prefs = await SharedPreferences.getInstance();
                                    // var fetchedUser =
                                    //     json.decode(prefs.getString('user')!);

                                    Booking myBooking = Booking(
                                        title: '',
                                        id: booking.id,
                                        time: selectedTime,
                                        date: serviceSelectedDay,
                                        serviceType: serviceSelected);
                                    print(myBooking);
                                    BlocProvider.of<BookingBloc>(context)
                                        .add(UpdateBooking(myBooking));

                                    print("Added");
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xff404E65)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Update Booking",
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
                    );
                  }
                  return Container();
                }),
                
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
  }
}
