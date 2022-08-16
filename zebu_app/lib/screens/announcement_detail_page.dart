import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/bloc/announcement/announcement_state.dart';
import 'package:zebu_app/bloc/announcementComment/announcement_comment_bloc.dart';
import 'package:zebu_app/bloc/announcementComment/announcement_comment_event.dart';
import 'package:zebu_app/bloc/announcementComment/announcement_comment_state.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_bloc.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_event.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_state.dart';
import 'package:zebu_app/models/announcementComment.dart';
import 'package:zebu_app/routeGenerator.dart';

double pgHeight = 0;
double pgWidth = 0;
var commentTextController;
NetworkConnectivityBloc? _networkConnectivityBloc;

class AnnouncementDetailPage extends StatefulWidget {
  final Map argObj;

  const AnnouncementDetailPage({Key? key, required this.argObj})
      : super(key: key);

  @override
  State<AnnouncementDetailPage> createState() =>
      _AnnouncementDetailPageState(argObj: argObj);
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
  final Map argObj;
  _AnnouncementDetailPageState({required this.argObj});

  var id;
  @override
  void initState() {
    _networkConnectivityBloc =
        BlocProvider.of<NetworkConnectivityBloc>(context);
    _networkConnectivityBloc!.add(InitNetworkConnectivity());
    _networkConnectivityBloc!.add(ListenNetworkConnectivity());
    super.initState();
    id = argObj['id'];
    commentTextController = TextEditingController();

    final announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    announcementBloc.add(AnnouncementLoad(id));
  }

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
          RouteGenerator.mainFlowName,
          arguments: ScreenArguments({'index': 3}),
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
                        RouteGenerator.mainFlowName,
                        arguments: ScreenArguments({'index': 3}),
                      ),
                    }),
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
              child: Column(
                children: [
                  BlocConsumer<AnnouncementBloc, AnnouncementState>(
                      listener: (ctx, announcementState) {},
                      builder: (_, announcementState) {
                        if (announcementState is LoadingAnnouncement) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height / 1.3,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff5D7498),
                              ),
                            ),
                          );
                        }

                        if (announcementState is AnnouncementLoadFailure) {
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

                        if (announcementState is AnnouncementLoadSuccess) {
                          var announcement = announcementState.announcement;
                          var date = announcement.date!.substring(0, 10);
                          var parsed = DateTime.parse(date);
                          var output = DateFormat.yMMMMd().format(parsed);
                          return Padding(
                            padding: EdgeInsets.only(
                                left: pgWidth * 0.08, right: pgWidth * 0.08),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: pgHeight * 0.02,
                                  ),
                                  Center(
                                    child: Container(
                                      child: announcement.image != null
                                          ? Container(
                                              height: pgHeight * 0.33,
                                              decoration: BoxDecoration(
                                                  // borderRadius: BorderRadius.only(
                                                  //     topLeft: Radius.circular(15),
                                                  //     topRight: Radius.circular(15)),
                                                  image: DecorationImage(
                                                image: NetworkImage(
                                                  "http://45.79.249.127" +
                                                      announcement.image!,
                                                ),
                                                fit: BoxFit.fitWidth,
                                                alignment: Alignment.topCenter,
                                              )),
                                            )
                                          : Container(),
                                    ),
                                  ),
                                  SizedBox(height: pgHeight * 0.08),
                                  Text(
                                    announcement.title,
                                    style: TextStyle(
                                        color: Color(0xff404E65),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                    softWrap: true,
                                  ),
                                  SizedBox(
                                    height: pgHeight * 0.02,
                                  ),
                                  Text(
                                    output.toString(),
                                    style: TextStyle(
                                        color: Color(0xffFF9E16),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: pgHeight * 0.02,
                                  ),
                                  Text(
                                    announcement.description!,
                                    style: TextStyle(color: Color(0xff404E65)),
                                  ),
                                  SizedBox(
                                    height: pgHeight * 0.04,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      }),
                  BlocConsumer<AnnouncementCommentBloc,
                          AnnouncementCommentState>(
                      listener: (ctx, announcementCommentState) {
                    if (announcementCommentState
                        is AnnouncementCommentSuccess) {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                // title: const Text('Time Not Set'),
                                content: const Text(
                                  'Thank you for your comment!',
                                  style: TextStyle(fontSize: 16),
                                ),
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
                  }, builder: (_, announcementcommentState) {
                    return Column(
                      children: [
                        BlocBuilder(
                          bloc: _networkConnectivityBloc,
                          builder: (BuildContext context,
                              NetworkConnectivityState state) {
                            if (state is NetworkOnline) {
                              return Container(
                                padding: EdgeInsets.only(
                                    left: pgWidth * 0.08,
                                    right: pgWidth * 0.08),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Please leave us a comment',
                                      style: TextStyle(
                                          color: Color(0xff404E65),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          fontFamily: 'Raleway'),
                                      softWrap: true,
                                    ),
                                    SizedBox(
                                      height: pgHeight * 0.02,
                                    ),
                                    TextFormField(
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
                                        controller: commentTextController),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if (commentTextController
                                                      .value.text ==
                                                  '') {
                                                showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                          // title: const Text('Time Not Set'),
                                                          content: const Text(
                                                              'Please write a comment.'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      'OK'),
                                                              child: const Text(
                                                                  'OK'),
                                                            ),
                                                          ],
                                                        ));
                                              } else {
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                var fetchedUser = json.decode(
                                                    prefs.getString('user')!);

                                                AnnouncementComment myComment =
                                                    AnnouncementComment(
                                                        title:
                                                            fetchedUser['name'],
                                                        email: fetchedUser[
                                                            'email'],
                                                        phoneNo: fetchedUser[
                                                            'phoneNumber'],
                                                        comment:
                                                            commentTextController
                                                                .value.text,
                                                        announcementId: id);

                                                BlocProvider.of<
                                                            AnnouncementCommentBloc>(
                                                        context)
                                                    .add(Post(myComment));
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Color(0xff404E65)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "Submit",
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
                                      height: 15,
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (state is NetworkOffline) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: pageHeight * 0.04,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: pgWidth * 0.03,
                                        right: pgWidth * 0.03),
                                    child: Text(
                                      "Please connect to the internet to comment.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xffFF9E16),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: pageHeight * 0.04,
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          )),
    );
  }
}
