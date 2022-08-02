import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/retry.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/bloc/authentication/authentication_bloc.dart';
import 'package:zebu_app/bloc/authentication/authentication_event.dart';
import 'package:zebu_app/bloc/authentication/authentication_state.dart';
import 'package:zebu_app/models/zebuUser.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/screens/splash_page.dart';
import 'package:zebu_app/screens/utils/EditTextUtils.dart';

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  String? validateEmail(String email) {
    if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      return null;
    } else {
      return 'Enter valid Email Address';
    }
  }

  void _onIntroEnd(context) {
    Navigator.pushNamed(
      context,
      RouteGenerator.homeScreenName,
    );
  }

  // Widget _buildImage(String assetName, [double width = 350, doubl]) {
  //   return Image.asset(
  //     'assets/images/$assetName',
  //     width: width,
  //     height: height,
  //   );
  // }

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;
    const bodyStyle = TextStyle(
      fontFamily: 'Raleway',
      fontSize: 15,
      color: const Color(0xff000000),
      fontWeight: FontWeight.w600,
    );

    const titleStyle = TextStyle(
      fontFamily: 'Raleway',
      fontSize: 26,
      color: const Color(0xff000000),
      fontWeight: FontWeight.w800,
    );

    const pageDecoration = const PageDecoration(
        titleTextStyle: titleStyle,
        bodyTextStyle: bodyStyle,
        // bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: Colors.white,
        // imagePadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        imageAlignment: Alignment.bottomCenter,
        // imagePadding: EdgeInsets.only(top: 100.0),
        bodyAlignment: Alignment.center);
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
      if (state is Initialized) {
        Navigator.pushNamed(
          context,
          RouteGenerator.homeScreenName,
        );
      }
      if (state is Unauthenticated) {
        Navigator.pushNamed(
          context,
          RouteGenerator.splashScreenName,
        );
      }
    }, builder: (_, authentiationState) {
      print("boardingScreenBuilder");
      print(authentiationState);
      if (authentiationState is Authenticated) {
        authenticationBloc.add(StartRegistering());
      }

      if (authentiationState is Registering) {
        return Material(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 48, bottom: 16.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: pageHeight * 0.07),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Personal Information',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 24,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                ),
                SizedBox(height: pageHeight * 0.017),
                Container(
                  child: Text(
                    'Please register to continue',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 13,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w700,
                    ),
                    softWrap: false,
                  ),
                ),
                SizedBox(height: pageHeight * 0.04),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Name',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff000000),
                            ),
                            softWrap: false,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      EditTextUtils().getCustomEditTextArea(
                        // labelValue: "Enter phone number",
                        hintValue: "John",
                        controller: _nameTextController,
                        keyboardType: TextInputType.name,
                        icon: Icon(Icons.account_circle,
                            color: Color(0xff404E65)),
                      ),
                      SizedBox(height: pageHeight * 0.02),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'E-mail',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff000000),
                            ),
                            softWrap: false,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      EditTextUtils().getCustomEditTextArea(
                          // labelValue: "Enter phone number",
                          hintValue: "john@gmail.com",
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          icon: Icon(Icons.email, color: Color(0xff404E65)),
                          validator: (value) {
                            return validateEmail(value!);
                          }),
                      SizedBox(height: pageHeight * 0.02),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Address',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff000000),
                            ),
                            softWrap: false,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      EditTextUtils().getCustomEditTextArea(
                        // labelValue: "Enter phone number",
                        // hintValue: "John",
                        controller: _addressTextController,
                        keyboardType: TextInputType.streetAddress,
                        icon:
                            Icon(Icons.location_city, color: Color(0xff404E65)),
                      ),
                      SizedBox(height: pageHeight * 0.02),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: SizedBox(
                      width: pageWidth * 0.8,
                      height: pageHeight * 0.062,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ZebuUser zebuUser = ZebuUser(
                                name: _nameTextController.value.text,
                                email: _emailTextController.value.text,
                                phoneNumber: user.phoneNumber);

                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString(
                                'user', json.encode(zebuUser.toJson()));

                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(FinishRegistering());
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xff404E65)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: Text(
                          "Register",
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
                  height: 20,
                ),
              ],
            ),
          ),
        );
      }
      if (authentiationState is Initializing) {
        return SafeArea(
          child: IntroductionScreen(
            overrideDone: GestureDetector(
              child: Text("Done",
                  style: TextStyle(
                      fontFamily: 'Raleway', fontWeight: FontWeight.w700)),
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(FinishInitializing());
              },
            ),
            isTopSafeArea: true,
            isBottomSafeArea: true,
            key: introKey,
            globalBackgroundColor: Colors.white,
            // globalHeader: Padding(
            //   padding: EdgeInsets.only(top: pageHeight * 0.08),
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: Text(
            //       'Welcome',
            //       style: TextStyle(
            //         fontFamily: 'Raleway',
            //         fontSize: 26,
            //         color: const Color(0xff000000),
            //         fontWeight: FontWeight.w900,
            //       ),
            //     ),
            //   ),
            // ),

            pages: [
              PageViewModel(
                title: "Welcome",
                bodyWidget: Column(
                  children: [
                    // SizedBox(
                    //   height: pageHeight * 0.22,
                    // ),
                    Image.asset('assets/images/membership.png',
                        width: pageWidth * 0.519, height: pageHeight * 0.325),
                    SizedBox(
                      height: pageHeight * 0.064,
                    ),
                    Text(
                      'Membership Management',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 26,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    Container(
                      width: pageWidth * 0.74,
                      child: Text(
                        "We have sent a verification code verification code to your number We have sent a verification code verification code to your number membership managment",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 15,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Welcome",
                bodyWidget: Column(
                  children: [
                    // SizedBox(
                    //   height: pageHeight * 0.22,
                    // ),
                    Image.asset('assets/images/menu.png',
                        width: pageWidth * 0.519, height: pageHeight * 0.325),
                    SizedBox(
                      height: pageHeight * 0.064,
                    ),
                    Text(
                      'Menu at your hand',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 26,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    Container(
                      width: pageWidth * 0.74,
                      child: Text(
                        "We have sent a verification code verification code to your number We have sent a verification code verification code to your number membership managment",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 15,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Welcome",
                bodyWidget: Column(
                  children: [
                    // SizedBox(
                    //   height: pageHeight * 0.22,
                    // ),
                    Image.asset('assets/images/booking.png',
                        width: pageWidth * 0.519, height: pageHeight * 0.325),
                    SizedBox(
                      height: pageHeight * 0.064,
                    ),
                    Text(
                      'Book your stay ahead',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 26,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    Container(
                      width: pageWidth * 0.74,
                      child: Text(
                        "We have sent a verification code verification code to your number We have sent a verification code verification code to your number membership managment",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 15,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Welcome",
                bodyWidget: Column(
                  children: [
                    // SizedBox(
                    //   height: pageHeight * 0.22,
                    // ),
                    Image.asset('assets/images/feedback.png',
                        width: pageWidth * 0.519, height: pageHeight * 0.325),
                    SizedBox(
                      height: pageHeight * 0.064,
                    ),
                    Text(
                      'Let us know what you think',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 26,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: pageHeight * 0.03,
                    ),
                    Container(
                      width: pageWidth * 0.74,
                      child: Text(
                        "We have sent a verification code verification code to your number We have sent a verification code verification code to your number membership managment",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 15,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                decoration: pageDecoration,
              ),
            ],
            onDone: () => {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(FinishInitializing())
            },
            //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
            showSkipButton: false,
            skipOrBackFlex: 0,
            nextFlex: 0,
            showBackButton: false,
            showNextButton: false,

            //rtl: true, // Display as right-to-left
            // back: const Icon(Icons.arrow_back),
            // skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
            // next: const Icon(Icons.arrow_forward),
            done: const Text('Done',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Color(0xFF404E65))),
            curve: Curves.fastLinearToSlowEaseIn,
            controlsMargin: const EdgeInsets.all(16),
            controlsPadding: kIsWeb
                ? const EdgeInsets.all(12.0)
                : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              activeColor: Color(0xFF404E65),
              color: Color(0xFFBDBDBD),
              activeSize: Size(10.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
            ),
            // dotsContainerDecorator: const ShapeDecoration(
            //   color: Colors.black87,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
            //   ),
            // ),
          ),
        );
      }
      return Container();
    });
  }
}
