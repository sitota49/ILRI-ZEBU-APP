import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:zebu_app/routeGenerator.dart';

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pushNamed(
      context,
      RouteGenerator.homeScreenName,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontFamily: 'Raleway',
      fontSize: 15,
      color: const Color(0xff000000),
      fontWeight: FontWeight.w500,
    );

    const pageDecoration = const PageDecoration(
        titleTextStyle: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 26,
          color: const Color(0xff000000),
          fontWeight: FontWeight.w700,
        ),
        bodyTextStyle: bodyStyle,
        bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: Colors.white,
        imagePadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        imageAlignment: Alignment.bottomCenter,
        // imagePadding: EdgeInsets.only(top: 100.0),
        bodyAlignment: Alignment.center);

    return SafeArea(
      child: IntroductionScreen(
        overrideDone: GestureDetector(
          child: Text("Done"),
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteGenerator.homeScreenName,
            );
          },
        ),
        isTopSafeArea: true,
        isBottomSafeArea: true,
        key: introKey,
        globalBackgroundColor: Colors.white,
        globalHeader: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Welcome',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 26,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        pages: [
          PageViewModel(
            title: "Membership Managment",
            body:
                "We have sent a verification code verification code to your number We have sent a verification code verification code to your number membership managment",
            image: _buildImage('membership_icon.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Menu at your hand",
            body:
                "We have sent a verification code verification code to your number We have sent a verification code verification code to your number membership managment",
            image: _buildImage('menu.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Book your stay ahead",
            body:
                "We have sent a verification code verification code to your number We have sent a verification code verification code to your number membership managment",
            image: _buildImage('booking.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Let us know what you think",
            body:
                "We have sent a verification code verification code to your number We have sent a verification code verification code to your number membership managment",
            image: _buildImage('feedback.png'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => {_onIntroEnd(context)},
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
}
