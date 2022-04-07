import 'package:zebu_app/screens/account_page.dart';
import 'package:zebu_app/screens/detail_page.dart';
import 'package:zebu_app/screens/home_page.dart';

import 'package:flutter/material.dart';
import 'package:zebu_app/screens/onboarding_page.dart';

class RouteGenerator {
  static const String homeScreenName = "/homeScreen";
  static const String detailScreenName = "/detailScreen";
  static const String addScreenName = "/addScreen";
  static const String accountScreenName = "/accountScreen";
  static const String onBoardingScreenName = "/onBoardingScreen";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreenName:
        return MaterialPageRoute(builder: (_) => HomePage());
      
      case onBoardingScreenName:
        return MaterialPageRoute(builder: (_) => OnBoardingPage());

   
      case accountScreenName:
        return MaterialPageRoute(builder: (_) => AccountPage());

      case detailScreenName:
         final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(builder: (context) {
          return DetailsPage(
            argObj: args.argObj,
          );
        });
      default:
        throw const FormatException("Route was not found");
    }
  }
}

class ScreenArguments {
  Map argObj;

  ScreenArguments(this.argObj);
}
