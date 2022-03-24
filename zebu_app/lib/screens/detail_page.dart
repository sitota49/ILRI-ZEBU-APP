import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/bloc/announcement/announcement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsPage extends StatefulWidget {
  final Map argObj;
  DetailsPage({Key? key, required this.argObj}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState(argObj: argObj);
}

class _DetailsPageState extends State<DetailsPage> {
  late final Map argObj;

  _DetailsPageState({required this.argObj});

  @override
  Widget build(BuildContext context) {
    final announcementId = argObj['id'];

    final announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    announcementBloc.add(AnnouncementLoad(announcementId));
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteGenerator.homeScreenName,
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.grey[200],
                child: IconButton(
                  icon: Icon(
                    Icons.bookmark_outline,
                    size: 20,
                  ),
                  color: Colors.grey,
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.grey[200],
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_outline,
                    size: 20,
                  ),
                  color: Colors.grey,
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.grey[200],
                child: IconButton(
                  icon: Icon(
                    Icons.share_outlined,
                    size: 20,
                  ),
                  color: Colors.grey,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: BottomAppBar(
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.headset,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(
                      Icons.nights_stay_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(
                      Icons.format_size_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: BlocConsumer<AnnouncementBloc, AnnouncementState>(
              listener: (ctx, announcementState) {},
              builder: (_, announcementState) {
                if (announcementState is Loading) {
                  return const CircularProgressIndicator(
                    color: Color.fromARGB(255, 131, 19, 4),
                  );
                }

                if (announcementState is AnnouncementLoadFailure) {
                  return const Text("Loading Failed");
                }

                if (announcementState is AnnouncementLoadSuccess) {
                  var announcement = announcementState.announcement;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
          
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              announcement.date.substring(0, 10),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 16,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                Text(
                                  '6.5K Views',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w100,
                                  ),
                                )
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                Text(
                                  '106 Likes',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w100,
                                  ),
                                )
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.bookmark,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                Text(
                                  '55 Saves',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w100,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          // child: Image.asset(widget.image),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                       
                        RichText(
                          text: TextSpan(
                            children: [
                              // TextSpan(
                              //     text: 'A',
                              //     style: GoogleFonts.notoSerif(
                              //         color: Colors.black, fontSize: 32)),
                              TextSpan(
                                text: announcement.body
                                    .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''),
                                style: GoogleFonts.notoSerif(
                                  color: Colors.black,
                                  fontSize: 18,
                                  height: 1.7,
                                  wordSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
