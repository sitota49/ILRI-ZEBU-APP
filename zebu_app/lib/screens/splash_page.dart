import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/screens/utils/fadeAnimation.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(decoration: TextDecoration.none),
      child: Container(
        width: double.infinity,
        color: Color(0xff404e65),
        child: Container(
          padding: EdgeInsets.only(right: 20, left: 20),
          margin: EdgeInsets.only(top: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      FadeAnimation(
                        2,
                        true,
                        false,
                        Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Image.asset(
                            'assets/images/zebu.png',
                            width: 300,
                            height: 180,
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 5),
              FadeAnimation(
                2,
                false,
                false,
                Text(
                  'for exercising the body & mind',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    color: const Color(0xffff9e16),
                  ),
                  softWrap: false,
                ),
              ),
              SizedBox(height: 15),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 0,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    FadeAnimation(
                      3,
                      false,
                      true,
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RouteGenerator.loginScreenName);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xffFF9E16)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              child: Text(
                                "Get Started",
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                      3,
                      true,
                      true,
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Image.asset(
                          'assets/images/ilri.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
