import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/bloc/authentication/authentication_bloc.dart';
import 'package:zebu_app/bloc/navigation_drawer/nav_drawer_bloc.dart';
import 'package:zebu_app/bloc/navigation_drawer/nav_drawer_event.dart';
import 'package:zebu_app/bloc/navigation_drawer/nav_drawer_state.dart';
import 'package:zebu_app/bloc/authentication/authentication_bloc.dart';
import 'package:zebu_app/bloc/authentication/authentication_event.dart';
import 'package:zebu_app/bloc/authentication/authentication_state.dart';
import 'package:zebu_app/screens/announcement_page.dart';
import 'package:zebu_app/screens/booking_page.dart';
import 'package:zebu_app/screens/feedback_page.dart';
import 'package:zebu_app/screens/membership_page.dart';
import 'package:zebu_app/screens/menu_page.dart';
import 'package:zebu_app/screens/my_booking_page.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            Container(
              color: Color(0xff404E65),
              height: 170,
              padding: EdgeInsets.only(top: 50),
              // margin: EdgeInsets.only(bottom:350),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      radius: 35,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
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
                    }
                  },
                  builder: (context, navState) {
                    return Column(
                      children: [
                        const SizedBox(height: 24),
                        ListTile(
                          leading: Icon(Icons.calendar_month),
                          title: Text("My Bookings"),
                          onTap: () {
                            final navBloc =
                                BlocProvider.of<NavDrawerBloc>(context);
                            navBloc.add(MyBookingPageEvent());
                          },
                        ),
                        const SizedBox(height: 24),
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
