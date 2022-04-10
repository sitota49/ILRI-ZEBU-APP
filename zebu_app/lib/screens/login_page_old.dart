// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
// // import 'package:form_field_validator/form_field_validator.dart';
// // import 'package:zebu_app/bloc/login/login_bloc.dart';
// // import 'package:zebu_app/bloc/login/login_state.dart';
// // import 'package:zebu_app/repository/user_repository.dart';

// // import 'package:zebu_app/routeGenerator.dart';

// // class LoginPage extends StatefulWidget {
// //   LoginPage({Key? key, required UserRepository userRepository}) : super(key: key);

// //   @override
// //   State<LoginPage> createState() => _LoginPageState();
// // }

// // class _LoginPageState extends State<LoginPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   late String email;
// //   late String phoneNumber;

// //   final phoneValidator = MultiValidator([
// //     RequiredValidator(errorText: 'phone number is required'),
// //   ]);

// //   final emailValidator = MultiValidator([
// //     EmailValidator(errorText: 'Invalid email'),
// //     RequiredValidator(errorText: "Email is required")
// //   ]);

// //   bool isValidPhone = false;
// //   var _selectedIndex = 0;
// //   String _selectedCountryCode = "+251";
// //   List<String> _countryCodes = ['+251', '+254'];

// //   void requestCode() {}

// //   @override
// //   Widget build(BuildContext context) {
// //     Widget countryDropDown = Container(
// //       decoration: new BoxDecoration(
// //         color: Colors.white,
// //         border: Border(
// //           right: BorderSide(width: 0.5, color: Colors.grey),
// //         ),
// //       ),
// //       height: 45.0,
// //       margin: const EdgeInsets.all(3.0),
// //       //width: 300.0,
// //       child: DropdownButtonHideUnderline(
// //         child: ButtonTheme(
// //           alignedDropdown: true,
// //           child: DropdownButton(
// //             value: _selectedCountryCode,
// //             items: _countryCodes.map((String value) {
// //               return new DropdownMenuItem<String>(
// //                   value: value,
// //                   child: Text(
// //                     value,
// //                     style: TextStyle(fontSize: 12.0),
// //                   ));
// //             }).toList(),
// //             onChanged: (value) {
// //               setState(() {
// //                 _selectedCountryCode = value.toString();
// //               });
// //             },
// //           ),
// //         ),
// //       ),
// //     );

// //     final loginBlocProvider = BlocProvider.of<LoginBloc>(context);
// //     return Scaffold(
// //         body: BlocConsumer<LoginBloc, LoginState>(listener: (_, state) {
// //       if (state is LoginFailure) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(state.error),
// //             duration: Duration(seconds: 3),
// //           ),
// //         );
// //         print(state.error);
// //       } else if (state is LoginSuccess) {
// //         //navigate
// //       }
// //     }, builder: (context, state) {
// //       return SingleChildScrollView(
// //           child: DefaultTextStyle(
// //         style: TextStyle(decoration: TextDecoration.none),
// //         child: Container(
// //           width: double.infinity,
// //           color: Colors.white,
// //           child: Container(
// //             padding: EdgeInsets.only(right: 20, left: 20),
// //             margin: EdgeInsets.only(top: 30),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               children: [
// //                 Expanded(
// //                     flex: 0,
// //                     child: Column(
// //                       children: [
// //                         Container(
// //                           margin: EdgeInsets.only(top: 30, left: 25),
// //                           child: Align(
// //                             alignment: Alignment.topLeft,
// //                             child: Text('Login Account',
// //                                 style: TextStyle(
// //                                   fontFamily: 'Raleway',
// //                                   fontSize: 24,
// //                                   color: const Color(0xff000000),
// //                                   fontWeight: FontWeight.w900,
// //                                 )),
// //                           ),
// //                         ),
// //                         SizedBox(height: 10),
// //                         Container(
// //                           child: Text(
// //                             'Hello, welcome to zebu club. Please login to continue',
// //                             style: TextStyle(
// //                               fontFamily: 'Raleway',
// //                               fontSize: 13,
// //                               color: const Color(0xff000000),
// //                               fontWeight: FontWeight.w700,
// //                             ),
// //                             softWrap: false,
// //                           ),
// //                         ),
// //                         SizedBox(height: 15),
// //                       ],
// //                     )),
// //                 Expanded(
// //                   flex: 0,
// //                   child: Column(
// //                     children: [
// //                       Padding(
// //                         padding: const EdgeInsets.all(16.0),
// //                         child: FlutterToggleTab(
// //                           // width in percent, to set full width just set to 100
// //                           width: 90,
// //                           borderRadius: 30,
// //                           height: 30,
// //                           // initialIndex: 0,
// //                           selectedBackgroundColors: [Colors.white],
// //                           selectedTextStyle: TextStyle(
// //                               color: Color(0xff7D7D7D),
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.w700),
// //                           unSelectedTextStyle: TextStyle(
// //                               color: Color(0xff7D7D7D),
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.w500),
// //                           labels: ["E-mail", "Phone"],
// //                           selectedLabelIndex: (index) {
// //                             setState(() {
// //                               _selectedIndex = index;
// //                               print("Selected Index $index");
// //                             });
// //                           },
// //                           selectedIndex: _selectedIndex,
// //                         ),
// //                       ),
// //                       SizedBox(height: 20),
// //                       Container(
// //                           margin: EdgeInsets.only(left: 25),
// //                           child: _selectedIndex != 0
// //                               ? Column(
// //                                   children: [
// //                                     Align(
// //                                       alignment: Alignment.centerLeft,
// //                                       child: Text(
// //                                         'Phone number',
// //                                         style: TextStyle(
// //                                           fontFamily: 'Raleway',
// //                                           fontSize: 14,
// //                                           fontWeight: FontWeight.w600,
// //                                           color: const Color(0xff000000),
// //                                         ),
// //                                         softWrap: false,
// //                                       ),
// //                                     ),
// //                                     SizedBox(height: 10),
// //                                     Container(
// //                                       width: double.infinity,
// //                                       margin: EdgeInsets.only(
// //                                           top: 10.0, bottom: 10.0, right: 3.0),
// //                                       color: Colors.white,
// //                                       child: Material(
// //                                         child: TextFormField(
// //                                           validator: (value) {
// //                                             if (value == null) {
// //                                               return 'Please enter phone number';
// //                                             }
// //                                             if (value.length < 9) {
// //                                               return 'Please enter valid phone number';
// //                                             }
// //                                           },
// //                                           keyboardType: TextInputType.number,
// //                                           decoration: InputDecoration(
// //                                             focusedBorder: OutlineInputBorder(
// //                                               borderSide: const BorderSide(
// //                                                   color: Color(0xFF707070),
// //                                                   width: 2.0),
// //                                               borderRadius:
// //                                                   BorderRadius.circular(25.0),
// //                                             ),
// //                                             contentPadding:
// //                                                 const EdgeInsets.all(12.0),
// //                                             border: new OutlineInputBorder(
// //                                               borderSide: new BorderSide(
// //                                                   color:
// //                                                       const Color(0xFF707070),
// //                                                   width: 0.1),
// //                                               borderRadius:
// //                                                   BorderRadius.circular(25.0),
// //                                             ),
// //                                             fillColor: Colors.white,
// //                                             prefixIcon: countryDropDown,
// //                                             hintText: '922123456',
// //                                             // labelText: 'Phone Number'
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     SizedBox(height: 30),
// //                                     Container(
// //                                       child: Padding(
// //                                         padding: const EdgeInsets.only(
// //                                             left: 16.0, right: 16.0),
// //                                         child: SizedBox(
// //                                           width: double.infinity,
// //                                           height: 50,
// //                                           child: ElevatedButton(
// //                                             onPressed: isValidPhone
// //                                                 ? requestCode
// //                                                 : null,
// //                                             style: ButtonStyle(
// //                                               backgroundColor:
// //                                                   MaterialStateProperty.all<
// //                                                       Color>(Color(0xff404E65)),
// //                                               shape: MaterialStateProperty.all<
// //                                                   RoundedRectangleBorder>(
// //                                                 RoundedRectangleBorder(
// //                                                   borderRadius:
// //                                                       BorderRadius.circular(20),
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                             child: Text(
// //                                               "Request Code",
// //                                               textAlign: TextAlign.center,
// //                                               style: TextStyle(
// //                                                   fontFamily: 'Raleway',
// //                                                   fontSize: 20,
// //                                                   fontWeight: FontWeight.bold,
// //                                                   color: Colors.white),
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     SizedBox(
// //                                       height: 20,
// //                                     ),
// //                                   ],
// //                                 )
// //                               : Container(
// //                                   color: Colors.amber,
// //                                   child: Text("0"),
// //                                 ))
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ));import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
// import 'package:zebu_app/bloc/announcement/announcement_event.dart';
// import 'package:zebu_app/bloc/announcement/announcement_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:zebu_app/routeGenerator.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
//     announcementBloc.add(const AnnouncementsLoad());
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       // resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         centerTitle: false,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const Icon(
//           Icons.bookmark,
//           color: Colors.black,
//         ),
//         title: const Text(
//           'Daily Blog',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: InkWell(
//               onTap: () {
//                 Navigator.pushNamed(
//                   context,
//                   RouteGenerator.accountScreenName,
//                 );
//               },
//               child: CircleAvatar(),
//             ),
//           ),
//         ],
//       ),
//       // bottomNavigationBar: BottomBarWidget(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: FloatingActionButton(
//           child: const Icon(Icons.add),
//           backgroundColor: const Color.fromARGB(255, 131, 19, 4),
//           elevation: 0,
//           onPressed: () {
//             Navigator.pushNamed(
//               context,
//               RouteGenerator.addScreenName,
//             );
//           },
//         ),
//       ),
//       body: SafeArea(
//         minimum: const EdgeInsets.all(8),
//         child: Column(
//           children: [
//             // TextField(
//             //   decoration: InputDecoration(
//             //     hintText: 'Search for articles, author, and tags',
//             //     filled: true,
//             //     fillColor: Colors.grey[200],
//             //     border: const OutlineInputBorder(
//             //       borderRadius: const BorderRadius.all(Radius.circular(10)),
//             //       borderSide: BorderSide.none,
//             //     ),
//             //     prefixIcon: const Icon(Icons.search),
//             //   ),
//             // ),
//             const SizedBox(
//               height: 20,
//             ),
//             const Center(
//               child: Text(
//                 "Your daily read",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//                 textAlign: TextAlign.left,
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             BlocBuilder<AnnouncementBloc, AnnouncementState>(
//               builder: (_, announcementState) {
//                 if (announcementState is Loading) {
//                   return const CircularProgressIndicator(
//                     color: Color.fromARGB(255, 131, 19, 4),
//                   );
//                 }

//                 if (announcementState is AnnouncementsLoadFailure) {
//                   return Text(announcementState.failureMessage);
//                 }

//                 if (announcementState is AnnouncementsEmpltyFailure) {
//                   return Text(announcementState.message);
//                 }

//                 if (announcementState is AnnouncementsLoadSuccess) {
//                   final announcements = announcementState.announcements;

//                   return Expanded(
//                     child: ListView.builder(
//                       itemCount: announcements.length,
//                       scrollDirection: Axis.vertical,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         final currentAnnouncement = announcements[index];

//                         return Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: ListTile(
//                             // leading: CircleAvatar(
//                             //   backgroundImage:
//                             //       AssetImage('assets/images/user.png'),
//                             // ),
//                             // trailing: Icon(Icons.keyboard_arrow_right),
//                             title: Text(
//                               currentAnnouncement.title,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             // subtitle: Container(
//                             //   child: Column(
//                             //     crossAxisAlignment: CrossAxisAlignment.start,
//                             //     children: [

//                             //       Row(
//                             //         children: [
//                             //           Icon(
//                             //             Icons.calendar_month,
//                             //             color: Colors.grey,
//                             //             size: 16,
//                             //           ),
//                             //           Text(currentAnnouncement.provider.phone),
//                             //         ],
//                             //       ),
//                             //       Row(
//                             //         children: [
//                             //           Icon(
//                             //             Icons.date_range,
//                             //             color: Colors.grey,
//                             //             size: 16,
//                             //           ),
//                             //           Text(orderCreatedDate),
//                             //         ],
//                             //       ),
//                             //     ],
//                             //   ),
//                             // ),
//                             onTap: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 RouteGenerator.detailScreenName,
//                                 arguments: ScreenArguments(
//                                     {'id': currentAnnouncement.id}),
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }

//                 return Container();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //     }));
// //   }
// // }
