import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/data_provider/announcement_data.dart';
import 'package:zebu_app/repository/announcement_repositiory.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/screens/detail_page.dart';
import 'package:zebu_app/screens/home_page.dart';
import 'package:zebu_app/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AppWidget extends StatefulWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  final navigatorKey = GlobalKey<NavigatorState>();
  static final httpClient = http.Client();
  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  int _currentIndex = 0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    initPlatformState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int currentIndex = 0;

  final announcementRepository = AnnouncementRepository(
      dataProvider: AnnouncementDataProvider(
    httpClient: AppWidget.httpClient,
  ));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AnnouncementBloc(announcementRepository: announcementRepository)
                ..add(
                  const AnnouncementsLoad(),
                ),
        ),
      ],
      child: MaterialApp(
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  // drawer: NavigationDrawer(),
                  body: SizedBox.expand(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentIndex = index);
                      },
                      children: const <Widget>[
                        //Add Home Page Here
                        HomePage(),
                      ],
                    ),
                  ),
                );
              } else {
                return const Scaffold(body: LoginPage());
              }
            })),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }

  Future<void> initPlatformState() async {
    const String oneSignalAppId = "078a24f1-8cf4-4a5d-850e-faa51aaa4c4f";
    OneSignal.shared.setAppId(oneSignalAppId);
  }
}
