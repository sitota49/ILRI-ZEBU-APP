import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/bloc/announcement/announcement_state.dart';
import 'package:zebu_app/routeGenerator.dart';

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
  @override
  Widget build(BuildContext context) {
    var id = argObj['id'];
    final announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    announcementBloc.add(AnnouncementLoad(id));
    return Scaffold(
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
            child: BlocConsumer<AnnouncementBloc, AnnouncementState>(
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
                    return const Text("Loading Failed",
                        style: TextStyle(
                          color: Color(0xff404E65),
                        ));
                  }

                  if (announcementState is AnnouncementLoadSuccess) {
                    var announcement = announcementState.announcement;
                    var date = announcement.date!.substring(0, 10);
                    var parsed = DateTime.parse(date);
                    var output = DateFormat.yMMMMd().format(parsed);
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40),
                            Text(
                              announcement.title,
                              style: TextStyle(
                                  color: Color(0xff404E65),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                              softWrap: true,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              output.toString(),
                              style: TextStyle(
                                  color: Color(0xffFF9E16),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              announcement.description!,
                              style: TextStyle(color: Color(0xff404E65)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                }),
          ),
        ));
  }
}
