import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// import 'package:zebu_app/bloc/booking/booking_bloc.dart';
// import 'package:zebu_app/bloc/booking/booking_event.dart';
// import 'package:zebu_app/bloc/booking/booking_state.dart';
import 'package:zebu_app/bloc/dining_booking/dining_booking_bloc.dart';
import 'package:zebu_app/bloc/dining_booking/dining_booking_event.dart';
import 'package:zebu_app/bloc/dining_booking/dining_booking_state.dart';
import 'package:zebu_app/models/booking.dart';
import 'package:zebu_app/routeGenerator.dart';

import 'package:zebu_app/screens/utils/CalendarUtils.dart';

double pgHeight = 0;
double pgWidth = 0;
var guestNamesTextController;
var _selectedDay;
var _focusedDay;
var serviceSelectedDay;
var selectedTime;
var newDate;
var newTime;
var mydate;
var booking;
var serviceSelected;
var guestNo;
var guestNames;

class EditBookingPage extends StatefulWidget {
  final Map argObj;

  const EditBookingPage({Key? key, required this.argObj}) : super(key: key);

  @override
  State<EditBookingPage> createState() => _EditBookingPageState(argObj: argObj);
}

class _EditBookingPageState extends State<EditBookingPage> {
  final Map argObj;
  var _CalendarBloc;

  _EditBookingPageState({required this.argObj});

  static final _formKeyEdit = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print("iniy");
    booking = argObj['booking'];
    _selectedDay = DateTime.parse(booking.date);
    _focusedDay = DateTime.parse(booking.date);
    serviceSelectedDay = booking.date;
    selectedTime = booking.time;
    serviceSelected = booking.serviceType;
    guestNo = booking.noOfGuests;
    guestNames = booking.guestNames != null ? booking.guestNames : '';

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

    guestNamesTextController = TextEditingController();
    guestNamesTextController.text =
        guestNames.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
    _CalendarBloc = CalendarBloc();
  }

  @override
  Widget build(BuildContext context) {
    print("building");
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;
    // print(pageWidth);
    // print(pageHeight);
    setState(() {
      pgHeight = pageHeight;
      pgWidth = pageWidth;
    });
    // DateTime _focusedDay = new DateTime(
    //     DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

    // DateTime _selectedDay = new DateTime(
    //     DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

    // _selectedDay = new DateTime(mydate.year, mydate.month, mydate.day);
    // _focusedDay = new DateTime(mydate.year, mydate.month, mydate.day);

    var date = booking.date!.substring(0, 10);
    var parsed = DateTime.parse(date);
    var output = DateFormat.yMMMMd().format(_selectedDay);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(
          context,
          RouteGenerator.mybookingScreenName,
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
                    child: Center(
                      child: Text(
                        booking.serviceType + ' ' + 'Reservation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                        softWrap: true,
                      ),
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
                  _CalendarBloc,
                  SizedBox(
                    height: pgHeight * 0.03,
                  ),
                  Center(
                    child: serviceSelected == 'Group Dining Lunch' ||
                            serviceSelected == 'Group Dining Dinner'
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: pgHeight * 0.03,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Number of Guests",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        width: pgWidth * 0.05,
                                      ),
                                      CustomNumberPicker(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: BorderSide(color: Colors.grey),
                                        ),
                                        initialValue: int.parse(guestNo),
                                        maxValue: 5,
                                        minValue: 2,
                                        step: 1,
                                        enable: true,
                                        onValue: (value) {
                                          setState(() {
                                            guestNo = value.toString();
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
                                      color: Color(0xff404E65),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      fontFamily: 'Raleway'),
                                  softWrap: true,
                                ),
                                SizedBox(
                                  height: pgHeight * 0.01,
                                ),
                                TextFormField(
                                  autofocus: false,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  // initialValue: guestNames,
                                  minLines: 4,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    // hintText: "Input your opinion",
                                    // hintStyle: TextStyle(color: Colors.white30),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            new Radius.circular(10.0))),
                                    // labelStyle: TextStyle(color: Colors.white)
                                  ),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                  ),
                                  controller: guestNamesTextController,
                                ),
                                SizedBox(
                                  height: pgHeight * 0.02,
                                ),
                                SizedBox(
                                  height: pgHeight * 0.06,
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: pgHeight * 0.06,
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
                                serviceType: serviceSelected,
                                guestNames: guestNamesTextController.value.text,
                                noOfGuests: guestNo);

                            BlocProvider.of<DiningBookingBloc>(context)
                                .add(UpdateBooking(myBooking));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
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
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class CalendarBloc extends StatefulWidget {
  const CalendarBloc({
    Key? key,
  }) : super(key: key);

  @override
  State<CalendarBloc> createState() => _CalendarBlocState();
}

class _CalendarBlocState extends State<CalendarBloc> {
  @override
  Widget build(BuildContext context) {
    final bookingbloc = BlocProvider.of<DiningBookingBloc>(context);
    bookingbloc.add(ServiceBookingLoad(
        serviceSelected, serviceSelectedDay, serviceSelected));

    return BlocConsumer<DiningBookingBloc, DiningBookingState>(
        listener: (ctx, bookingState) {
      if (bookingState is UpdateBookingSuccess) {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  // title: const Text('Time Not Set'),
                  content: const Text('Booking Rescheduled Succefully'),
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
      print("____________________________");
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
          "Please check your internet connection and try again.",
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
        slots.forEach((k, v) => {slots[k] = 0});

        bookings.forEach((booking) {
          slots[booking.time]++;
        });

        var availableSlots = [];
        slots.forEach((k, v) => {
              if (v < quota) {availableSlots.add(k)}
            });

        return SingleChildScrollView(
          child: Container(
            padding:
                EdgeInsets.only(left: pgWidth * 0.08, right: pgWidth * 0.08),
            child: CalendarWidget(
              availableSlots: availableSlots,
            ),
          ),
        );
      }
      return Container();
    });
  }
}

class CalendarWidget extends StatefulWidget {
  final availableSlots;
  const CalendarWidget({Key? key, required this.availableSlots})
      : super(key: key);
  @override
  State<CalendarWidget> createState() =>
      _CalendarWidgetState(availableSlots: availableSlots);
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final availableSlots;
  _CalendarWidgetState({required this.availableSlots});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        TableCalendar(
          rowHeight: pgHeight * 0.05,
          sixWeekMonthsEnforced: false,
          headerStyle: HeaderStyle(
            headerPadding: EdgeInsets.only(
                top: pgHeight * 0.06,
                left: pgWidth * 0.03,
                bottom: pgHeight * 0.02),
            leftChevronVisible: false,
            rightChevronVisible: false,
            formatButtonVisible: false,
            titleCentered: false,
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 28),
            formatButtonTextStyle: TextStyle(color: Colors.white),
            formatButtonShowsNext: false,
          ),
          calendarStyle: CalendarStyle(
            cellMargin: EdgeInsets.only(top: pgHeight * 0.005),
            cellPadding: EdgeInsets.symmetric(
                vertical: pgHeight * 0.01, horizontal: pgWidth * 0.02),
            weekendTextStyle: TextStyle(
                color: Color(0xff3D3D3D), fontWeight: FontWeight.w700),
            disabledTextStyle: TextStyle(
              color: Color(0xffFFDEDE),
              fontWeight: FontWeight.w500,
              fontSize: 13.0,
            ),
            defaultTextStyle: TextStyle(
                color: Color(0xff3D3D3D), fontWeight: FontWeight.w700),
            selectedDecoration: BoxDecoration(
                color: const Color(0xFFFF9E16), shape: BoxShape.rectangle),
            selectedTextStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.0,
            ),
            todayDecoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.rectangle),
            todayTextStyle: TextStyle(
              color: Color(0xFFFF9E16),
              fontWeight: FontWeight.w700,
              fontSize: 13.0,
            ),
          ),
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: newDate != null ? newDate : _focusedDay,
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
                  .format(newDate != null ? newDate : _selectedDay);

              var serviceDetailPhrase = serviceSelected;
              //         'Dining Lunch' ||
              //     serviceSelected == 'Dining Dinner' ||
              //     serviceSelected ==
              //         'Steam Sauna Men' ||
              //     serviceSelected == 'Steam Sauna Women'
              // ? serviceSelected
              // : selectedServiceIndex;
              final bookingBloc = BlocProvider.of<DiningBookingBloc>(context);
              bookingBloc.add(ServiceBookingLoad(
                  serviceSelected, serviceSelectedDay, serviceDetailPhrase));
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },
        ),
        SizedBox(
          height: 10,
        ),
        Column(
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        width: MediaQuery.of(context).size.width / 3.5,
                        decoration: BoxDecoration(
                          color: selectedTime == timeslot
                              ? Color(0xFFFF9E16)
                              : Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(17.0),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTime = timeslot;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                timeslot.toString(),
                                style: TextStyle(
                                    color: selectedTime == timeslot
                                        ? Colors.white
                                        : Color(0xff5D7498),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ],
    );
  }
}
