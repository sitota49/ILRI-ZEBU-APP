import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/bloc/authentication/authentication_bloc.dart';
import 'package:zebu_app/bloc/navigation_drawer/nav_drawer_bloc.dart';
import 'package:zebu_app/bloc/navigation_drawer/nav_drawer_event.dart';
import 'package:zebu_app/bloc/navigation_drawer/nav_drawer_state.dart';
import 'package:zebu_app/bloc/authentication/authentication_bloc.dart';
import 'package:zebu_app/bloc/authentication/authentication_event.dart';
import 'package:zebu_app/bloc/authentication/authentication_state.dart';

import 'package:zebu_app/bloc/user/user_bloc.dart';
import 'package:zebu_app/bloc/user/user_event.dart';
import 'package:zebu_app/bloc/user/user_state.dart';
import 'package:zebu_app/screens/announcement_page.dart';
import 'package:zebu_app/screens/booking_page.dart';
import 'package:zebu_app/screens/feedback_page.dart';

import 'package:zebu_app/screens/menu_page.dart';
import 'package:zebu_app/screens/my_booking_page.dart';
import 'package:zebu_app/screens/my_order_page.dart';

double pgHeight = 0;
double pgWidth = 0;

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;

    setState(() {
      pgHeight = pageHeight;
      pgWidth = pageWidth;
    });
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.add(UserInfoLoad());
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            Container(
                color: Color(0xff404E65),
                height: pgHeight * 0.25,
                padding: EdgeInsets.only(top: pgHeight * 0.05),
                // margin: EdgeInsets.only(bottom:350),
                child: BlocConsumer<UserBloc, UserState>(
                  listener: (context, userState) {},
                  builder: (context, userState) {
                    if (userState is UserLoadSuccess) {
                      var user = userState.userInfo;
                      return Column(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/avatar.png"),
                            radius: 35,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            user['name'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                            softWrap: true,
                          ),
                          Text(
                            user['email'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                            softWrap: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                )),
            const SizedBox(height: 24),
            BlocProvider(
                create: (context) => NavDrawerBloc(),
                child: BlocConsumer<NavDrawerBloc, NavDrawerState>(
                  listener: (context, navState) {
                    if (navState is Menu) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MenuPage()));
                    } else if (navState is Booking) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingPage()));
                    } else if (navState is FeedbackState) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedbackPage()));
                    } else if (navState is Announcement) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnnouncementPage()));
                    } else if (navState is LoggedOutNavState) {
                      authBloc.add(LoggedOut());
                    } else if (navState is MyBooking) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyBookingPage()));
                    } else if (navState is MyOrder) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyOrderPage()));
                    }
                  },
                  builder: (context, navState) {
                    return Column(
                      children: [
                        SizedBox(height: pgHeight * 0.04),
                        ListTile(
                          leading: Icon(Icons.calendar_month),
                          title: Text("My Bookings"),
                          onTap: () {
                            final navBloc =
                                BlocProvider.of<NavDrawerBloc>(context);
                            navBloc.add(MyBookingPageEvent());
                          },
                        ),
                        SizedBox(height: pgHeight * 0.04),
                        ListTile(
                          leading: Icon(Icons.restaurant_menu),
                          title: Text("My Orders"),
                          onTap: () {
                            final navBloc =
                                BlocProvider.of<NavDrawerBloc>(context);
                            navBloc.add(MyOrderPageEvent());
                          },
                        ),
                        SizedBox(height: pgHeight * 0.04),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text("Logout"),
                          onTap: () {
                            authBloc.add(LoggedOut());
                          },
                        ),
                      ],
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
