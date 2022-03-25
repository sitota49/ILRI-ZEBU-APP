import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/bloc/announcement/announcement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zebu_app/routeGenerator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    announcementBloc.add(const AnnouncementsLoad());
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
          Icons.bookmark,
          color: Colors.black,
        ),
        title: const Text(
          'Daily Blog',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteGenerator.accountScreenName,
                );
              },
              child: CircleAvatar(),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomBarWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: const Color.fromARGB(255, 131, 19, 4),
          elevation: 0,
          onPressed: () {
            Navigator.pushNamed(
              context,
              RouteGenerator.addScreenName,
            );
          },
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: Column(
          children: [
            // TextField(
            //   decoration: InputDecoration(
            //     hintText: 'Search for articles, author, and tags',
            //     filled: true,
            //     fillColor: Colors.grey[200],
            //     border: const OutlineInputBorder(
            //       borderRadius: const BorderRadius.all(Radius.circular(10)),
            //       borderSide: BorderSide.none,
            //     ),
            //     prefixIcon: const Icon(Icons.search),
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                "Your daily read",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<AnnouncementBloc, AnnouncementState>(
              builder: (_, announcementState) {
                if (announcementState is Loading) {
                  return const CircularProgressIndicator(
                    color: Color.fromARGB(255, 131, 19, 4),
                  );
                }

                if (announcementState is AnnouncementsLoadFailure) {
                  return Text(announcementState.failureMessage);
                }

                if (announcementState is AnnouncementsEmpltyFailure) {
                  return Text(announcementState.message);
                }

                if (announcementState is AnnouncementsLoadSuccess) {
                  final announcements = announcementState.announcements;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: announcements.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final currentAnnouncement = announcements[index];

                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ListTile(
                            // leading: CircleAvatar(
                            //   backgroundImage:
                            //       AssetImage('assets/images/user.png'),
                            // ),
                            // trailing: Icon(Icons.keyboard_arrow_right),
                            title: Text(
                              currentAnnouncement.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // subtitle: Container(
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [

                            //       Row(
                            //         children: [
                            //           Icon(
                            //             Icons.calendar_month,
                            //             color: Colors.grey,
                            //             size: 16,
                            //           ),
                            //           Text(currentAnnouncement.provider.phone),
                            //         ],
                            //       ),
                            //       Row(
                            //         children: [
                            //           Icon(
                            //             Icons.date_range,
                            //             color: Colors.grey,
                            //             size: 16,
                            //           ),
                            //           Text(orderCreatedDate),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteGenerator.detailScreenName,
                                arguments: ScreenArguments(
                                    {'id': currentAnnouncement.id}),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
