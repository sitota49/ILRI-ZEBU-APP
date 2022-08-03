import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/bloc/announcement/announcement_state.dart';
import 'package:zebu_app/bloc/authentication/authentication_state.dart';
import 'package:zebu_app/models/announcement.dart';
import 'package:zebu_app/routeGenerator.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  late AnnouncementBloc announcementBloc;
  @override
  void initState() {
    announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    announcementBloc.add(AnnouncementsLoad());
    super.initState();
  }

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
            'ANNOUNCEMENTS',
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
            child: Center(
              child: BlocConsumer<AnnouncementBloc, AnnouncementState>(
                  listener: (ctx, announcementListState) {},
                  builder: (_, announcementListState) {
                    print(announcementListState);
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
                        announcementListState is AnnouncementsEmpltyFailure) {
                      return const Text(
                        "Failed Loading",
                        style: TextStyle(
                          color: Color(0xff404E65),
                          fontSize: 14,
                        ),
                      );
                    }

                    if (announcementListState is AnnouncementsLoadSuccess) {
                      final announcements = announcementListState.announcements;
                      return Expanded(
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: announcements.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final currentAnnouncement = announcements[index];
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
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Container(
                                      height: 100,
                                      decoration: new BoxDecoration(
                                          color: Color(0xff404E65),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
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
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(
                                                  currentAnnouncement
                                                              .title.length >
                                                          90
                                                      ? currentAnnouncement
                                                              .title
                                                              .substring(
                                                                  0, 90) +
                                                          '...'
                                                      : currentAnnouncement
                                                          .title,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 40),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      month.toUpperCase(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffFF9E16),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Text(
                                                      day.length == 1
                                                          ? "0" + day
                                                          : day,
                                                      style: TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Text(
                                                      year,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffFF9E16),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
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
                        ),
                      );
                    }
                    return Container();
                  }),
            ),
          ),
        ));
  }
}
