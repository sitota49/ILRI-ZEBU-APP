import 'package:zebu_app/screens/MainFlow.dart';
import 'package:zebu_app/screens/account_page.dart';
import 'package:zebu_app/screens/announcement_detail_page.dart';
import 'package:zebu_app/screens/announcement_page.dart';
import 'package:zebu_app/screens/booking_page.dart';
import 'package:zebu_app/screens/feedback_page.dart';
import 'package:zebu_app/screens/home_page.dart';

import 'package:flutter/material.dart';
import 'package:zebu_app/screens/login_page.dart';
import 'package:zebu_app/screens/membership_page.dart';
import 'package:zebu_app/screens/menu_detail_page.dart';
import 'package:zebu_app/screens/menu_page.dart';
import 'package:zebu_app/screens/onboarding_page.dart';
import 'package:zebu_app/screens/splash_page.dart';

class RouteGenerator {
  static const String homeScreenName = "/homeScreen";
  static const String accountScreenName = "/accountScreen";
  static const String onBoardingScreenName = "/onBoardingScreen";
  static const String registrationScreenName = "/registrationScreen";
  static const String loginScreenName = "/loginScreen";
  static const String splashScreenName = "/splashScreen";
  static const String menuScreenName = "/menuScreen";
  static const String feedbackScreenName = "/feedbackScreen";
  static const String membershipScreenName = "/membershipScreen";
  static const String bookingScreenName = "/bookingScreen";
  static const String announcementScreenName = "/announcementScreen";
  static const String announcementDetailScreenName = "/announcementDetailScreen";
  static const String menuDetailScreenName =
      "/menuDetailScreen";
  static const String mainFlowName = "/mainFlow";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreenName:
        return MaterialPageRoute(builder: (_) => HomePage());
      case splashScreenName:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case accountScreenName:
        return MaterialPageRoute(builder: (_) => AccountPage());
      case onBoardingScreenName:
        return MaterialPageRoute(builder: (_) => OnBoardingPage());
      case loginScreenName:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case menuScreenName:
        return MaterialPageRoute(builder: (_) => MenuPage());
      case feedbackScreenName:
        return MaterialPageRoute(builder: (_) => FeedbackPage());
      case membershipScreenName:
        return MaterialPageRoute(builder: (_) => MembershipPage());
      case bookingScreenName:
        return MaterialPageRoute(builder: (_) => BookingPage());
      case announcementScreenName:
        return MaterialPageRoute(builder: (_) => AnnouncementPage());
      case announcementDetailScreenName:
      final args = settings.arguments as ScreenArguments;
         return MaterialPageRoute(
            builder: (_) => AnnouncementDetailPage(
                  argObj: args.argObj,
                ));
      case menuDetailScreenName:
        final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(
            builder: (_) => MenuDetailPage(
                  argObj: args.argObj,
                ));
      case mainFlowName:
      final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(builder: (_) =>  MainFlow(
            argObj: args.argObj,
          ));

      // case detailScreenName:
      //   final args = settings.arguments as ScreenArguments;
      //   return MaterialPageRoute(builder: (context) {
      //     return DetailsPage(
      //       argObj: args.argObj,
      //     );
      //   });
      default:
        throw const FormatException("Route was not found");
    }
  }
}

class ScreenArguments {
  Map argObj;

  ScreenArguments(this.argObj);
}
