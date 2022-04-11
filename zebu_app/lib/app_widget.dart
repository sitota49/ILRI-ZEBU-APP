import 'dart:convert';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/bloc/authentication/authentication_bloc.dart';
import 'package:zebu_app/bloc/authentication/authentication_event.dart';
import 'package:zebu_app/bloc/authentication/authentication_state.dart';
import 'package:zebu_app/bloc/login/login_bloc.dart';
import 'package:zebu_app/data_provider/announcement_data.dart';
import 'package:zebu_app/data_provider/login_data.dart';
import 'package:zebu_app/repository/announcement_repositiory.dart';
import 'package:zebu_app/repository/login_repository.dart';
import 'package:zebu_app/repository/user_repository.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/screens/detail_page.dart';
import 'package:zebu_app/screens/edit_number.dart';
import 'package:zebu_app/screens/home_page.dart';
import 'package:zebu_app/screens/login_page.dart';
import 'package:zebu_app/screens/login_page_old.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:zebu_app/screens/onboarding_page.dart';
import 'package:zebu_app/screens/splash_page.dart';

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

  final loginRepository = LoginRepository(
      dataProvider: LoginDataProvider(
    httpClient: AppWidget.httpClient,
  ));

  UserRepository userRepository = UserRepository();
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
        BlocProvider(
          create: (context) => AuthenticationBloc(
            userRepository: userRepository,
          )..add(
              AppStarted(),
            ),
        ),
        BlocProvider(
          create: (context) =>
              LoginBloc(loginRepository, userRepository: userRepository),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.ralewayTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
          print("listener");
          print(state);
          if (state is Unauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SplashPage()),
                (Route<dynamic> route) => false);
          } else if (state is Authenticated) {
            Navigator.pushNamed(
              context,
              RouteGenerator.onBoardingScreenName,
            );
          } else if (state is Initialized) {
            Navigator.pushNamed(
              context,
              RouteGenerator.homeScreenName,
            );
          }
        }, buildWhen: ((previous, current) {
          if (current is Unauthenticated) {
            return false;
          }
          return true;
        }), builder: (context, state) {
          print("builder");
          print(state);
          if (state is Unauthenticated) {
            return SplashPage();
          } else if (state is Authenticated) {
            return OnBoardingPage();
          } else if (state is Initialized) {
            return HomePage();
          } else {
            return SplashPage();
          }
        }),
        // home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        //   builder: (context, state) {
        //     print("APP");

        //     print(state);
        //     if (state is Uninitialized) {
        //       return SplashPage();
        //     } else if (state is Unauthenticated) {
        //       return LoginPage();
        //     } else if (state is Authenticated) {
        //       print("authenicted");
        //       return OnBoardingPage();
        //     } else {
        //       return SplashPage();
        //     }
        //   },
        // ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }

  Future<void> initPlatformState() async {
    const String oneSignalAppId = "078a24f1-8cf4-4a5d-850e-faa51aaa4c4f";
    OneSignal.shared.setAppId(oneSignalAppId);
  }

  static void handleClickNotification(BuildContext context) {
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      try {
        print("here");

        var id = await result.notification.additionalData?['id'];

        Navigator.pushNamed(
          context,
          RouteGenerator.detailScreenName,
          arguments: ScreenArguments({'id': id}),
        );
      } catch (e) {
        print(e);
      }
    });
  }
}
