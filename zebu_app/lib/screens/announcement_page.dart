import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/bloc/announcement/announcement_state.dart';
import 'package:zebu_app/bloc/authentication/authentication_state.dart';
import 'package:zebu_app/models/announcement.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/screens/booking_page.dart';

double pgHeight = 0;
double pgWidth = 0;
double textScale = 0;

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;

    double txtScale = MediaQuery.of(context).textScaleFactor;
    setState(() {
      pgHeight = pageHeight;
      pgWidth = pageWidth;
      textScale = txtScale;
    });
    final announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    announcementBloc.add(const AnnouncementsLoad());
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
              'ANNOUNCEMENTS',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18 * textScale,
                  color: Color(0xff404E65),
                  fontWeight: FontWeight.w500),
            ),
          ),
          body: DefaultTextStyle(
            style: TextStyle(decoration: TextDecoration.none),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocConsumer<AnnouncementBloc, AnnouncementState>(
                      listener: (ctx, announcementListState) {},
                      builder: (_, announcementListState) {
                        if (announcementListState is LoadingAnnouncement) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height / 1.3,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff5D7498),
                              ),
                            ),
                          );
                        }

                        if (announcementListState is AnnouncementsLoadFailure ||
                            announcementListState
                                is AnnouncementsEmpltyFailure) {
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
                                    fontSize: 16 * textScale,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        if (announcementListState is AnnouncementsLoadSuccess) {
                          final announcements =
                              announcementListState.announcements;
                          return SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: announcements.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final currentAnnouncement =
                                    announcements[index];
                                var date =
                                    currentAnnouncement.date.substring(0, 10);
                                var parsed = DateTime.parse(date);
                                var year = DateFormat.y().format(parsed);
                                var month = DateFormat.MMM().format(parsed);
                                var day = DateFormat.d().format(parsed);

                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteGenerator
                                            .announcementDetailScreenName,
                                        arguments: ScreenArguments(
                                            {'id': currentAnnouncement.id}),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          top: pgHeight * 0.01),
                                      child: Container(
                                        height: pgHeight * 0.15,
                                        decoration: new BoxDecoration(
                                            color: Color(0xff404E65),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(9))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: pgWidth * 0.53,
                                                  margin: EdgeInsets.only(
                                                      left: pgWidth * 0.03),
                                                  child: Text(
                                                    currentAnnouncement.title.length >
                                                            90
                                                        ? currentAnnouncement
                                                                .title
                                                                .substring(
                                                                    0, 90) +
                                                            '...'
                                                        : currentAnnouncement
                                                            .title,
                                                    style: TextStyle(
                                                        fontSize:
                                                            15 * textScale,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    softWrap: true,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: pgWidth * 0.1),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        month.toUpperCase(),
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFF9E16),
                                                            fontSize: 14 * textScale,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              pgHeight * 0.003),
                                                      Text(
                                                        day.length == 1
                                                            ? "0" + day
                                                            : day,
                                                        style: TextStyle(
                                                            fontSize: 22 * textScale),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              pgHeight * 0.003),
                                                      Text(
                                                        year,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFF9E16),
                                                            fontSize: 14 * textScale,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ]),
                                        ),
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
                ],
              ),
            ),
          )),
    );
  }
}
