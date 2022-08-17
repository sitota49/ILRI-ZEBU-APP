import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_bloc.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_event.dart';
import 'package:zebu_app/bloc/network_connectivity/network_connectivity_state.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/screens/utils/fadeAnimation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  NetworkConnectivityBloc? _networkConnectivityBloc;
  @override
  void initState() {
    _networkConnectivityBloc =
        BlocProvider.of<NetworkConnectivityBloc>(context);
    _networkConnectivityBloc!.add(InitNetworkConnectivity());
    _networkConnectivityBloc!.add(ListenNetworkConnectivity());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    BlocProvider.of<NetworkConnectivityBloc>(context).dispose();
  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;
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
                            width: pageWidth * 0.7,
                            height: pageHeight * 0.22,
                          ),
                        ),
                      ),
                    ],
                  )),

              FadeAnimation(
                2,
                false,
                false,
                Text(
                  'for exercising the body & mind',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  softWrap: false,
                ),
              ),
              // SizedBox(height: 15),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 0,
                child: BlocBuilder(
                  bloc: _networkConnectivityBloc,
                  builder:
                      (BuildContext context, NetworkConnectivityState state) {
                    if (state is NetworkOnline) {
                      return Container(
                        child: Column(
                          children: [
                            // SizedBox(height: 30),
                            FadeAnimation(
                              3,
                              false,
                              true,
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: SizedBox(
                                    width: pageWidth * 0.8,
                                    height: pageHeight * 0.06,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            RouteGenerator.loginScreenName);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xff641E0D)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                              height: pageHeight * 0.04,
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is NetworkOffline) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Please check your internet connection and try again.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffFF9E16),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: pageHeight * 0.04,
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
              FadeAnimation(
                3,
                true,
                true,
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    'assets/images/Ilri_cgiar_logo.png',
                    width: pageWidth * 0.24,
                    height: pageHeight * 0.03,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
