import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_state.dart';
import 'package:zebu_app/bloc/authentication/authentication_bloc.dart';
import 'package:zebu_app/bloc/authentication/authentication_event.dart';
import 'package:zebu_app/bloc/authentication/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/screens/home.dart';
import 'package:zebu_app/screens/onboarding_page.dart';
import 'package:zebu_app/screens/splash_page.dart';
import 'package:zebu_app/screens/utils/NavigationDrawer.dart';

import 'login_page.dart';

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
    return Scaffold(
      backgroundColor: Color(0xff404E65),
      body: Home(),

      //     BlocConsumer<AuthenticationBloc, AuthenticationState>(
      //         listener: (context, state) {
      //   if (state is UninitializedAuth) {
      //     Navigator.pushNamed(
      //       context,
      //       RouteGenerator.splashScreenName,
      //     );
      //   } else if (state is Inside) {
      //     Navigator.pushNamed(
      //       context,
      //       RouteGenerator.homeScreenName,
      //     );
      //   }
      // }, builder: (_, authentiationState) {
      //   if (authentiationState is Loading) {
      //     return const CircularProgressIndicator(color: Color(0xff404E65));
      //   }
      //   if (authentiationState is Inside) {
      //     //main home page goes here
      //     return Home();
      //   }

      //   return Container();
      // })
    );
  }
}
