import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/bloc/feedback/feedback_bloc.dart';
import 'package:zebu_app/bloc/feedback/feedback_event.dart';
import 'package:zebu_app/bloc/feedback/feedback_state.dart';
import 'package:zebu_app/models/feedback.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  var _FoodIndex = -1;
  var _FacilityIndex = -1;
  var _ServiceIndex = -1;
  final improoveTextController = TextEditingController();
  final specificCommentTextController = TextEditingController();
  final describeMenuTextController = TextEditingController();
  final addedMenuTextController = TextEditingController();
  final serviceOutstandingTextController = TextEditingController();
  final otherCommentTextController = TextEditingController();
  String _pickedDine = '';
  String _pickedLanguage = '';

  @override
  Widget build(BuildContext context) {
    var ratings = ['1', '2', '3', '4'];
    var ratingDescription = ['Poor', 'Fair', 'Good', 'Excellent'];
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(
          context,
          RouteGenerator.homeScreenName,
        );
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xff404E65),
              onPressed: () => Navigator.pushNamed(
                context,
                RouteGenerator.homeScreenName,
              ),
            ),
            backgroundColor: Colors.white,
            title: Text(
              'FEEDBACK',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  color: Color(0xff404E65),
                  fontWeight: FontWeight.w500),
            ),
          ),
          body: DefaultTextStyle(
            style: TextStyle(decoration: TextDecoration.none),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocConsumer<FeedbackBloc, FeedbackState>(
                    listener: (ctx, feedbackState) {
                 
                  if (feedbackState is FeedbackSuccess) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              // title: const Text('Time Not Set'),
                              content: const Text('Thank you for your feedback!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => {
                                    Navigator.pushNamed(
                                      context,
                                      RouteGenerator.homeScreenName,
                                    )
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ));
                  }
                }, builder: (_, feedbackState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'What do you think of our services?',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Food',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 500,
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            var currentRating = ratings[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _FoodIndex = ratings.indexOf(currentRating);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Card(
    
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius: BorderRadius.circular(25)),
                                          color: _FoodIndex ==
                                                  ratings.indexOf(currentRating)
                                              ? Color(0xffFF9E16)
                                              : Color(0xff404E65),
                                          child: Container(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  currentRating,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          )),
                                      Text(
                                        ratingDescription[
                                            ratings.indexOf(currentRating)],
                                        style: TextStyle(
                                          color: Color(
                                            0xff404E65,
                                          ),
                                          fontSize: 10,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Services',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 500,
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            var currentRating = ratings[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _ServiceIndex = ratings.indexOf(currentRating);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Card(
    
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius: BorderRadius.circular(25)),
                                          color: _ServiceIndex ==
                                                  ratings.indexOf(currentRating)
                                              ? Color(0xffFF9E16)
                                              : Color(0xff404E65),
                                          child: Container(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  currentRating,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          )),
                                      Text(
                                        ratingDescription[
                                            ratings.indexOf(currentRating)],
                                        style: TextStyle(
                                          color: Color(
                                            0xff404E65,
                                          ),
                                          fontSize: 10,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Facility',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 500,
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            var currentRating = ratings[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _FacilityIndex = ratings.indexOf(currentRating);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Card(
    
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius: BorderRadius.circular(25)),
                                          color: _FacilityIndex ==
                                                  ratings.indexOf(currentRating)
                                              ? Color(0xffFF9E16)
                                              : Color(0xff404E65),
                                          child: Container(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  currentRating,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          )),
                                      Text(
                                        ratingDescription[
                                            ratings.indexOf(currentRating)],
                                        style: TextStyle(
                                          color: Color(
                                            0xff404E65,
                                          ),
                                          fontSize: 10,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'What can be done to improve the comfort at the Zebu Club?',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        minLines: 4,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          // hintText: "Input your opinion",
                          // hintStyle: TextStyle(color: Colors.white30),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(10.0))),
                          // labelStyle: TextStyle(color: Colors.white)
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        controller: improoveTextController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'How often do you dine with us?',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RadioButtonGroup(
                        orientation: GroupedButtonsOrientation.HORIZONTAL,
                        margin: const EdgeInsets.only(left: 12.0),
                        onSelected: (String selected) => setState(() {
                          _pickedDine = selected;
                        }),
                        labelStyle: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            fontFamily: 'Raleway'),
                        labels: <String>[
                          "Daily",
                          "Weekly",
                          "Once in a while",
                          "First time"
                        ],
                        activeColor: Color(0xff404E65),
                        picked: _pickedDine,
                        itemBuilder: (Radio rb, Text txt, int i) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              children: <Widget>[
                                rb,
                                txt,
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'If you don\'t speak Amharic, where you able to communicate with the staff sufficiently in English?',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RadioButtonGroup(
                        orientation: GroupedButtonsOrientation.HORIZONTAL,
                        margin: const EdgeInsets.only(left: 12.0),
                        onSelected: (String selected) => setState(() {
                          _pickedLanguage = selected;
                        }),
                        labelStyle: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            fontFamily: 'Raleway'),
                        labels: <String>["Yes", "No"],
                        activeColor: Color(0xff404E65),
                        picked: _pickedLanguage,
                        itemBuilder: (Radio rb, Text txt, int i) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              children: <Widget>[
                                rb,
                                txt,
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Do you have any comment on a specific food item?',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        minLines: 4,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          // hintText: "Input your opinion",
                          // hintStyle: TextStyle(color: Colors.white30),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(10.0))),
                          // labelStyle: TextStyle(color: Colors.white)
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        controller: specificCommentTextController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Was there any description on the menu that didn’t match what you received? If so, please explain',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        minLines: 4,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          // hintText: "Input your opinion",
                          // hintStyle: TextStyle(color: Colors.white30),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(10.0))),
                          // labelStyle: TextStyle(color: Colors.white)
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        controller: describeMenuTextController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'What food or beverage would you like to see added to the menu?',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        minLines: 4,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          // hintText: "Input your opinion",
                          // hintStyle: TextStyle(color: Colors.white30),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(10.0))),
                          // labelStyle: TextStyle(color: Colors.white)
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        controller: addedMenuTextController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Did any Zebu club staff provide you with outstanding service? Please comment:',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        minLines: 4,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          // hintText: "Input your opinion",
                          // hintStyle: TextStyle(color: Colors.white30),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(10.0))),
                          // labelStyle: TextStyle(color: Colors.white)
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        controller: serviceOutstandingTextController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Other comments',
                        style: TextStyle(
                            color: Color(0xff404E65),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        minLines: 4,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          // hintText: "Input your opinion",
                          // hintStyle: TextStyle(color: Colors.white30),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(10.0))),
                          // labelStyle: TextStyle(color: Colors.white)
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        controller: otherCommentTextController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_FoodIndex < 0 ||
                                    _FacilityIndex < 0 ||
                                    _ServiceIndex < 0) {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            // title: const Text('Time Not Set'),
                                            content: const Text(
                                                'Please give your rating.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ));
                                } else {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  var fetchedUser =
                                      json.decode(prefs.getString('user')!);
    
                                  MyFeedBack myFeedback = MyFeedBack(
                                      title: fetchedUser['name'],
                                      email: fetchedUser['email'],
                                      phoneNo: fetchedUser['phoneNumber'],
                                      dineOften: _pickedDine,
                                      englishCommuincation: _pickedLanguage,
                                      faciltiyRating: _FacilityIndex + 1,
                                      foodItemComment:
                                          specificCommentTextController
                                              .value.text,
                                      foodRating: _FoodIndex + 1,
                                      improoveWhat:
                                          improoveTextController.value.text,
                                      menuAdded:
                                          addedMenuTextController.value.text,
                                      menudidntMatch:
                                          describeMenuTextController.value.text,
                                      outStandingService:
                                          serviceOutstandingTextController
                                              .value.text,
                                      serviceRating: _ServiceIndex + 1,
                                      otherComment:
                                          otherCommentTextController.value.text);
                                
                                  BlocProvider.of<FeedbackBloc>(context)
                                      .add(Post(myFeedback));
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Color(0xff404E65)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              child: Text(
                                "Submit",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFF9E16)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          )),
    );
  }
}
