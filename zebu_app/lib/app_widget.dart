import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/bloc/announcementComment/announcement_comment_bloc.dart';
import 'package:zebu_app/bloc/authentication/authentication_bloc.dart';
import 'package:zebu_app/bloc/authentication/authentication_event.dart';
import 'package:zebu_app/bloc/authentication/authentication_state.dart';
import 'package:zebu_app/bloc/booking/booking_bloc.dart';
import 'package:zebu_app/bloc/dining_booking/dining_booking_bloc.dart';
import 'package:zebu_app/bloc/feedback/feedback_bloc.dart';
import 'package:zebu_app/bloc/login/login_bloc.dart';
import 'package:zebu_app/bloc/menu/menu_bloc.dart';
import 'package:zebu_app/bloc/menu/menu_event.dart';
import 'package:zebu_app/bloc/menu/recent_bloc.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_bloc.dart';
import 'package:zebu_app/bloc/order/order_bloc.dart';
import 'package:zebu_app/bloc/service/service_bloc.dart';
import 'package:zebu_app/bloc/service/service_event.dart';
import 'package:zebu_app/bloc/user/user_bloc.dart';
import 'package:zebu_app/data_provider/announcement_comment_data.dart';

import 'package:zebu_app/data_provider/announcement_data.dart';
import 'package:zebu_app/data_provider/booking_data.dart';
import 'package:zebu_app/data_provider/feedback_data.dart';
import 'package:zebu_app/data_provider/login_data.dart';
import 'package:zebu_app/data_provider/menu_data.dart';
import 'package:zebu_app/data_provider/order_data.dart';
import 'package:zebu_app/data_provider/service_data.dart';
import 'package:zebu_app/repository/announcement_comment_repository.dart';
import 'package:zebu_app/repository/announcement_repositiory.dart';
import 'package:zebu_app/repository/booking_repository.dart';
import 'package:zebu_app/repository/feedback_repository.dart';
import 'package:zebu_app/repository/login_repository.dart';
import 'package:zebu_app/repository/menu_repository.dart';
import 'package:zebu_app/repository/order_repository.dart';
import 'package:zebu_app/repository/service_repository.dart';
import 'package:zebu_app/repository/user_repository.dart';
import 'package:zebu_app/routeGenerator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:zebu_app/screens/home_page.dart';
import 'package:zebu_app/screens/onboarding_page.dart';

import 'package:zebu_app/screens/splash_page.dart';

class AppWidget extends StatefulWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  static final httpClient = http.Client();

  AppWidget({Key? key}) : super(key: key);
  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  int currentIndex = 0;

  final announcementRepository = AnnouncementRepository(
      dataProvider: AnnouncementDataProvider(
    httpClient: AppWidget.httpClient,
  ));

  final menuRepository = MenuRepository(
      dataProvider: MenuDataProvider(
    httpClient: AppWidget.httpClient,
  ));
  final serviceRepository = ServiceRepository(
      dataProvider: ServiceDataProvider(
    httpClient: AppWidget.httpClient,
  ));
  final bookingRepository = BookingRepository(
      dataProvider: BookingDataProvider(
    httpClient: AppWidget.httpClient,
  ));
  final orderRepository = OrderRepository(
      dataProvider: OrderDataProvider(
    httpClient: AppWidget.httpClient,
  ));
  final feedbackRepository = FeedbackRepository(
      dataProvider: FeedbackDataProvider(
    httpClient: AppWidget.httpClient,
  ));
  final announcementCommentRepository = AnnouncementCommentRepository(
      dataProvider: AnnouncementCommentDataProvider(
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
          create: (context) => MenuBloc(menuRepository: menuRepository)
            ..add(
              const AllMenuLoad(''),
            ),
        ),
        BlocProvider(
          create: (context) => ServiceBloc(serviceRepository: serviceRepository)
            ..add(
              const AllServiceLoad(),
            ),
        ),
        BlocProvider(
          create: (context) =>
              BookingBloc(bookingRepository: bookingRepository),
        ),
        BlocProvider(
          create: (context) => NetworkConnectivityBloc(),
        ),
        BlocProvider(
          create: (context) =>
              DiningBookingBloc(bookingRepository: bookingRepository),
        ),
        BlocProvider(
          create: (context) => OrderBloc(orderRepository: orderRepository),
        ),
        BlocProvider(
          create: (context) => AnnouncementCommentBloc(
              announcementCommentRepository: announcementCommentRepository),
        ),
        BlocProvider(
          create: (context) =>
              FeedbackBloc(feedbackRepository: feedbackRepository),
        ),
        BlocProvider(
          create: (context) => RecentMenuBloc(menuRepository: menuRepository)
            ..add(
              const RecentlyViewedLoad(),
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
          create: (context) => UserBloc(userInfoRepository: userRepository),
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
            colorScheme: ThemeData().colorScheme.copyWith(
                  primary: const Color(0xff404E65),
                ),
            scaffoldBackgroundColor: Colors.white),
        home:
            // Home(),
            BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SplashPage()),
                (Route<dynamic> route) => false);
          } else if (state is Initializing || state is Registering) {
            Navigator.pushNamed(
              context,
              RouteGenerator.onBoardingScreenName,
            );
          } else if (state is Inside) {
            Navigator.pushNamed(
              context,
              RouteGenerator.homeScreenName,
            );
          } else if (state is LoggedOutState) {
            Phoenix.rebirth(context);
          }
        }, builder: (context, state) {
          handleClickNotification(context);
          // return HomePage();

          if (state is Unauthenticated) {
            return SplashPage();
          } else if (state is Initializing || state is Registering) {
            return OnBoardingPage();
          } else if (state is Inside) {
            return HomePage();
          } else {
            return const SplashPage();
          }
        }),
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
        var id = await result.notification.additionalData?['id'];

        Navigator.pushNamed(
          context,
          RouteGenerator.announcementDetailScreenName,
          arguments: ScreenArguments({'id': id}),
        );
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    });
  }
}
