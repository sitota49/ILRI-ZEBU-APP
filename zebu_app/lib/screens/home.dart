import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/bloc/announcement/announcement_state.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_bloc.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_event.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_state.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/screens/utils/NavigationDrawer.dart';
import 'dart:math' as math;

bool networkCheck = true;

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AnnouncementBloc announcementBloc;

  NetworkConnectivityBloc? _networkConnectivityBloc;
  @override
  void initState() {
    _networkConnectivityBloc =
        BlocProvider.of<NetworkConnectivityBloc>(context);
    _networkConnectivityBloc!.add(InitNetworkConnectivity());
    _networkConnectivityBloc!.add(ListenNetworkConnectivity());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    BlocProvider.of<NetworkConnectivityBloc>(context).dispose();
  }

  double pgHeight = 0;
  double pgWidth = 0;

  @override
  Widget build(BuildContext context) {
    announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    announcementBloc.add(NewAnnouncementLoad());
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;

    setState(() {
      pgHeight = pageHeight;
      pgWidth = pageWidth;
    });
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color(0xff404E65)),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          drawer: NavigationDrawer(),
          body: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                    child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BlocBuilder<AnnouncementBloc, AnnouncementState>(
                        builder: (_, homePageState) {
                          if (homePageState is LoadingAnnouncement) {
                            return Container(
                              height: 180,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }

                          if (homePageState is NewAnnouncementLoadFailure) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome',
                                  style: TextStyle(
                                      color: Color(0xffff9e16),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: pageHeight * 0.011,
                                ),
                                Container(
                                  width: pageWidth * 0.52,
                                  child: Text(
                                    'Zebu Club Mobile App',
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 15,
                                        color: Color(0xff404E65),
                                        fontWeight: FontWeight.w700),
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(
                                  height: pageHeight * 0.011,
                                ),
                                Container(
                                  width: pageWidth * 0.52,
                                  child: Text(
                                    'Feel free to browse through our different services and book your stay!',
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(
                                  height: pageHeight * 0.011,
                                ),
                              ],
                            );
                          }

                          if (homePageState is NewAnnouncementLoadSuccess) {
                            final newAnnouncement =
                                homePageState.newAnnouncement;

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'What\'s new',
                                  style: TextStyle(
                                      color: Color(0xffff9e16),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: pageHeight * 0.011,
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: pageWidth * 0.52,
                                    child: Text(
                                      newAnnouncement.title.length > 45
                                          ? newAnnouncement.title
                                                  .substring(0, 45) +
                                              '...'
                                          : newAnnouncement.title,
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontSize: 15,
                                          color: Color(0xff404E65),
                                          fontWeight: FontWeight.w700),
                                      softWrap: true,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteGenerator
                                          .announcementDetailScreenName,
                                      arguments: ScreenArguments(
                                          {'id': newAnnouncement.id}),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: pageHeight * 0.011,
                                ),
                                Container(
                                  width: pageWidth * 0.52,
                                  child: Text(
                                    newAnnouncement.description.length > 100
                                        ? newAnnouncement.description
                                                .substring(0, 100) +
                                            '...'
                                        : newAnnouncement.description,
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(
                                  height: pageHeight * 0.011,
                                ),
                                GestureDetector(
                                  child: Text("Learn More >>",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Raleway',
                                          color: Color(0xffff9e16),
                                          fontWeight: FontWeight.w700)),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteGenerator
                                          .announcementDetailScreenName,
                                      arguments: ScreenArguments(
                                          {'id': newAnnouncement.id}),
                                    );
                                  },
                                ),
                              ],
                            );
                          }

                          return Container();
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Icon(
                            Icons.notifications_active,
                            color: Color(0xff404E65),
                            size: 80,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                BlocBuilder(
                  bloc: _networkConnectivityBloc,
                  builder:
                      (BuildContext context, NetworkConnectivityState state) {
                    if (state is NetworkOnline) {
                      return Expanded(
                          child: Stack(
                        children: [
                          Stack(children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                // height: 150,
                                child: Stack(children: [
                                  Container(
                                      color: Colors.transparent,
                                      child: _Triangle(color: Colors.black)),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                              child: Text(
                                            " ",
                                            style: TextStyle(
                                              color: Color(0xff641E0D),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )),
                                          SizedBox(
                                            height: pageHeight * 0.04,
                                          ),
                                          Container(
                                            // margin: EdgeInsets.only(top: 100),
                                            child: Image.asset(
                                              'assets/images/zebuFaded.png',
                                              width: pageWidth * 0.235,
                                              height: pageHeight * 0.07,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 20),
                                              child: Image.asset(
                                                'assets/images/Ilri_cgiar_logo.png',
                                                width: pageWidth * 0.245,
                                                height: pageHeight * 0.03,
                                              )),
                                        ]),
                                  ),
                                ]),
                              ),
                            ),
                          ]),
                          Container(
                            // color: Colors.red,
                            // height: pageHeight * 0.4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.count(
                                primary: false,
                                padding: EdgeInsets.all(pgHeight * 0.02),
                                crossAxisSpacing: pgWidth * 0.039,
                                mainAxisSpacing: pgHeight * 0.039,
                                crossAxisCount: 2,
                                childAspectRatio: (pgWidth / (pgHeight / 2.48)),
                                children: <Widget>[
                                  HomeButtons("bookinghome", "Booking", () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteGenerator.mainFlowName,
                                      arguments: ScreenArguments({'index': 1}),
                                    );
                                  }, Colors.white, Color(0xff404E65),
                                      Color(0xffFF9E16), true),
                                  HomeButtons("Menu_ichome", "Menu", () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteGenerator.mainFlowName,
                                      arguments: ScreenArguments({'index': 0}),
                                    );
                                  }, Color(0xffFF9E16), Colors.white,
                                      Color(0xff404E65), true),
                                  HomeButtons("announcehome", "Announcement",
                                      () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteGenerator.mainFlowName,
                                      arguments: ScreenArguments({'index': 3}),
                                    );
                                  }, Color(0xffFF9E16), Colors.white,
                                      Color(0xff404E65), true),
                                  HomeButtons("feedhome", "Feedback", () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteGenerator.mainFlowName,
                                      arguments: ScreenArguments({'index': 2}),
                                    );
                                  }, Colors.white, Color(0xff404E65),
                                      Color.fromARGB(218, 255, 158, 22), true),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ));
                    }
                    if (state is NetworkOffline) {
                      return Expanded(
                          child: Stack(
                        children: [
                          Stack(children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                // height: 150,
                                child: Stack(children: [
                                  Container(
                                      color: Colors.transparent,
                                      child: _Triangle(color: Colors.black)),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                              child: Text(
                                            "Please check your internet connection and try again.",
                                            style: TextStyle(
                                              color: Color(0xff641E0D),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )),
                                          SizedBox(
                                            height: pageHeight * 0.04,
                                          ),
                                          Container(
                                            // margin: EdgeInsets.only(top: 100),
                                            child: Image.asset(
                                              'assets/images/zebuFaded.png',
                                              width: pageWidth * 0.235,
                                              height: pageHeight * 0.07,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 20),
                                              child: Image.asset(
                                                'assets/images/Ilri_cgiar_logo.png',
                                                width: pageWidth * 0.245,
                                                height: pageHeight * 0.03,
                                              )),
                                        ]),
                                  ),
                                ]),
                              ),
                            ),
                          ]),
                          Container(
                            // color: Colors.red,
                            // height: pageHeight * 0.4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.count(
                                primary: false,
                                padding: EdgeInsets.all(pgHeight * 0.02),
                                crossAxisSpacing: pgWidth * 0.039,
                                mainAxisSpacing: pgHeight * 0.039,
                                crossAxisCount: 2,
                                childAspectRatio: (pgWidth / (pgHeight / 2.48)),
                                children: <Widget>[
                                  HomeButtons("bookinghome", "Booking", () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteGenerator.mainFlowName,
                                      arguments: ScreenArguments({'index': 1}),
                                    );
                                  }, Colors.white, Color(0xff404E65),
                                      Color(0xffFF9E16), false),
                                  HomeButtons("Menu_ichome", "Menu", () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteGenerator.mainFlowName,
                                      arguments: ScreenArguments({'index': 0}),
                                    );
                                  }, Color(0xffFF9E16), Colors.white,
                                      Color(0xff404E65), false),
                                  HomeButtons("announcehome", "Announcement",
                                      () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteGenerator.mainFlowName,
                                      arguments: ScreenArguments({'index': 3}),
                                    );
                                  }, Color(0xffFF9E16), Colors.white,
                                      Color(0xff404E65), false),
                                  HomeButtons("feedhome", "Feedback", () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteGenerator.mainFlowName,
                                      arguments: ScreenArguments({'index': 2}),
                                    );
                                  }, Colors.white, Color(0xff404E65),
                                      Color.fromARGB(218, 255, 158, 22), false),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ));
                    }
                    return Container();
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget HomeButtons(
      icon, text, onPressed, iconColor, textColor, bgColor, hasConnection) {
    return GestureDetector(
      onTap: hasConnection ? onPressed : null,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child: Image.asset(
                  'assets/images/$icon.png',
                  width: pgWidth * 0.179,
                  height: pgHeight * 0.09,
                ),
              ),
            ),
            SizedBox(
              height: pgHeight * 0.006,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 12,
                  color: textColor,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _Triangle extends StatelessWidget {
  const _Triangle({
    Key? key,
    required this.color,
  }) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: _ShapesPainter(color),
        child: Container(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 16),
                    child: Transform.rotate(
                      // angle: math.pi / 4,
                      angle: 0,
                    )))));
  }
}

class _ShapesPainter extends CustomPainter {
  final Color color;
  _ShapesPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    // final paint = Paint();
    // paint.color = color;
    // var path = Path();
    // path.lineTo(size.width, 0);
    // path.lineTo(size.height, size.width);
    // path.close();
    // canvas.drawPath(path, paint);

    final paintBlue = Paint()..color = Color.fromARGB(255, 171, 192, 224);
    final paintYellow = Paint()..color = Color.fromARGB(255, 248, 199, 162);
    final paintRed = Paint()..color = Color.fromARGB(200, 232, 163, 146);

    final pathYellow = Path();
    pathYellow.moveTo(0, size.height);
    pathYellow.lineTo(size.width, size.height);
    pathYellow.lineTo(0, size.height / 2.5);
    pathYellow.close();

    final pathBlue = Path();
    pathBlue.moveTo(size.width, size.height);
    pathBlue.lineTo(0, size.height);
    pathBlue.lineTo(size.width, size.height / 2.5);
    pathBlue.close();

    final pathRed = Path();
    pathRed.moveTo(size.width / 1.2, size.height / 2);
    pathRed.lineTo(size.width, size.height / 1.65);
    pathRed.lineTo(size.width, size.height / 2.5);
    pathRed.close();

    canvas.drawPath(pathYellow, paintYellow);
    canvas.drawPath(pathBlue, paintBlue);
    canvas.drawPath(pathRed, paintRed);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
