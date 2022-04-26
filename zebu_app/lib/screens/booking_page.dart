

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:simple_coverflow/simple_coverflow.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zebu_app/bloc/service/service_bloc.dart';
import 'package:zebu_app/bloc/service/service_event.dart';
import 'package:zebu_app/bloc/service/service_state.dart';
import 'package:zebu_app/screens/utils/CalendarUtils.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late ServiceBloc servicebloc;

  @override
  void initState() {
    servicebloc = BlocProvider.of<ServiceBloc>(context);
    servicebloc.add(AllServiceLoad());
    super.initState();
  }

  GlobalKey<_BookingPageState> _sliderKey = GlobalKey();

  int curerntIndex = 0;

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
          child: BlocConsumer<ServiceBloc, ServiceState>(
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

                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: CoverFlow(
                      height: 700,
                      // dismissedCallback: disposeDismissed,
                      currentItemChangedCallback: (int index) {
                        print(services[index]);
                        setState(() {
                          curerntIndex = index;
                        });
                      },

                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Item(index, curerntIndex, services[index]);
                      },
                    ),
                  );
                }
                return Container();
              }),
        ));
  }
}

class Item extends StatefulWidget {
  final int index;
  final int curerntIndex;
  final service;
  Item(this.index, this.curerntIndex, this.service);
  @override
  _ItemState createState() => _ItemState(index, curerntIndex, service);
}

class _ItemState extends State<Item> {
  final int index;
  final int curerntIndex;
  final service;
  var _selectedIndex = 0;

  _ItemState(this.index, this.curerntIndex, this.service);

  @override
  Widget build(BuildContext context) {
    var currentService = service;
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.265,
          width: double.infinity,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            color: index % 2 == 0 ? Color(0xffFF9E16) : Color(0xff404E65),
            child: SafeArea(
              child: Column(children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Image.network(
                  "http://45.79.249.127" + currentService.image,
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                SizedBox(height: 5),
                Text(
                  currentService.title,
                  style: TextStyle(
                      color: index % 2 == 0 ? Colors.black : Color(0xffFF9E16),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  currentService.description!,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                    child: currentService.options.length == 2
                        ? FlutterToggleTab(
                            // width in percent, to set full width just set to 100
                            width: 50,
                            borderRadius: 30,
                            height: 25,
                            // initialIndex: 0,
                            selectedBackgroundColors: [Colors.white],
                            selectedTextStyle: TextStyle(
                                color: Color(0xff7D7D7D),
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                            unSelectedTextStyle: TextStyle(
                                color: Color(0xff7D7D7D),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            labels: currentService.options,
                            selectedLabelIndex: (labelIndex) {
                              print(currentService.options[labelIndex]);
                              setState(() {
                                _selectedIndex = labelIndex;
                              });
                            },
                            selectedIndex: _selectedIndex,
                          )
                        : Container(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ]),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.38,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Calendar(),
        ),
      ],
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Event>(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
          ),
          onDaySelected: _onDaySelected,
          onRangeSelected: _onRangeSelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => print('${value[index]}'),
                      title: Text('${value[index]}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
