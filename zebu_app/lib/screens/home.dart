import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/bloc/announcement/announcement_state.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/screens/utils/NavigationDrawer.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    announcementBloc.add(NewAnnouncementLoad());

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Color(0xff404E65),
          appBar: AppBar(
            backgroundColor: Color(0xff404E65),
          ),
          drawer: NavigationDrawer(),
          body: Center(
            child: Column(
              children: [
                Container(
                    child: Container(
                  margin: EdgeInsets.only(left: 15, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BlocBuilder<AnnouncementBloc, AnnouncementState>(
                        builder: (_, homePageState) {
                          print(homePageState);
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
                                  height: 15,
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    'Zebu Club Mobile App',
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    'Feel free to browse through our different services and book your stay!',
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
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
                                  height: 15,
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    newAnnouncement.title!,
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    newAnnouncement.description.length > 100
                                        ? newAnnouncement.description
                                                .substring(0, 100) +
                                            ' ...'
                                        : newAnnouncement.description,
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  child: Text("Learn More >>",
                                      style: TextStyle(
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
                        child: GestureDetector(
                          child: Center(
                            child: Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteGenerator.announcementScreenName,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),
        ));
  }
}
