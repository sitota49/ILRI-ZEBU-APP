import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/bloc/navigation_drawer/nav_drawer_bloc.dart';
import 'package:zebu_app/bloc/navigation_drawer/nav_drawer_event.dart';
import 'package:zebu_app/bloc/navigation_drawer/nav_drawer_state.dart';
import 'package:zebu_app/screens/announcement_page.dart';
import 'package:zebu_app/screens/booking_page.dart';
import 'package:zebu_app/screens/membership_page.dart';
import 'package:zebu_app/screens/menu_page.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new MenuPage()));
                    } else if (navState is Booking) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new BookingPage()));
                    } else if (navState is Membership) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new MembershipPage()));
                    } else if (navState is Announcement) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new AnnouncementPage()));
                    }

                    // else if(navState is LoggedOut){
                    //   Navigator.of(context).pushNamed(LogoutPage.routeName);
                    // }
                  },
                  builder: (context, navState) {
                    return Column(
                      children: [
                        const SizedBox(height: 24),
                        ListTile(
                          leading: Icon(Icons.man),
                          title: Text("Account"),
                          onTap: () {
                            final navBloc =
                                BlocProvider.of<NavDrawerBloc>(context);
                            navBloc.add(AccountPageEvent());
                          },
                        ),
                        const SizedBox(height: 24),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text("Logout"),
                          onTap: () {
                            final navBloc =
                                BlocProvider.of<NavDrawerBloc>(context);
                            navBloc.add(LogoutPageEvent());
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
