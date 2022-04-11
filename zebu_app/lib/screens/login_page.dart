import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:zebu_app/bloc/authentication/authentication_bloc.dart';
import 'package:zebu_app/bloc/authentication/authentication_event.dart';
import 'package:zebu_app/bloc/authentication/authentication_state.dart';
import 'package:zebu_app/bloc/login/login_bloc.dart';
import 'package:zebu_app/bloc/login/login_event.dart';
import 'package:zebu_app/bloc/login/login_state.dart';
import 'package:zebu_app/repository/user_repository.dart';

import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/screens/utils/EditTextUtils.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  late String message;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (context, loginState) {
        if (loginState is ExceptionState || loginState is OtpExceptionState) {
          if (loginState is ExceptionState) {
            message = loginState.message;
          } else if (loginState is OtpExceptionState) {
            message = loginState.message;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(body: getViewAsPerState(state));
        },
      ),
    );
  }

  getViewAsPerState(LoginState state) {
    print(state);
    if (state is Unauthenticated) {
      return CredentialInput();
    } else if (state is OtpSentState) {
      return OtpInput(phoneNo: state.getPhone());
    } else if (state is OtpExceptionState) {
      return OtpInput();
    } else if (state is LoadingState) {
      return LoadingIndicator();
    } else if (state is LoginCompleteState) {
      BlocProvider.of<AuthenticationBloc>(context)
          .add(LoggedIn(token: state.getUser().uid));
    } else {
      return CredentialInput();
    }
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: Color(0xff000000),
        ),
      );
}

class CredentialInput extends StatefulWidget {
  @override
  State<CredentialInput> createState() => _CredentialInputState();
}

class _CredentialInputState extends State<CredentialInput> {
  final _formKey = GlobalKey<FormState>();

  final _phoneTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  var _selectedIndex = 0;

  String _selectedCountryCode = "+251";

  List<String> _countryCodes = ['+251', '+254'];

  @override
  Widget build(BuildContext context) {
    Widget countryDropDown = Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(width: 0.5, color: Colors.grey),
        ),
      ),
      height: 45.0,
      margin: const EdgeInsets.all(3.0),
      //width: 300.0,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: _selectedCountryCode,
            items: _countryCodes.map((String value) {
              return new DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 12.0),
                  ));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCountryCode = value.toString();
              });
            },
          ),
        ),
      ),
    );

    return Padding(
      padding:
          const EdgeInsets.only(top: 48, bottom: 16.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 0,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30, left: 25),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Login Account',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 24,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w900,
                          )),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Text(
                      'Hello, welcome to zebu club. Please login to continue',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 13,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w700,
                      ),
                      softWrap: false,
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              )),
          Expanded(
            flex: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FlutterToggleTab(
                    // width in percent, to set full width just set to 100
                    width: 90,
                    borderRadius: 30,
                    height: 30,
                    // initialIndex: 0,
                    selectedBackgroundColors: [Colors.white],
                    selectedTextStyle: TextStyle(
                        color: Color(0xff7D7D7D),
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    unSelectedTextStyle: TextStyle(
                        color: Color(0xff7D7D7D),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    labels: ["E-mail", "Phone"],
                    selectedLabelIndex: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    selectedIndex: _selectedIndex,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.only(left: 25),
                    child: _selectedIndex != 0
                        ? Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Phone number',
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
                              Form(
                                key: _formKey,
                                child: EditTextUtils().getCustomEditTextArea(
                                    // labelValue: "Enter phone number",
                                    hintValue: "912345678",
                                    controller: _phoneTextController,
                                    keyboardType: TextInputType.number,
                                    icon: countryDropDown,
                                    validator: (value) {
                                      return validateMobile(value!);
                                    }),
                              ),
                              SizedBox(height: 30),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          BlocProvider.of<LoginBloc>(context)
                                              .add(VerifyPhoneEvent(
                                                  phoneNumber:
                                                      _selectedCountryCode
                                                              .toString() +
                                                          _phoneTextController
                                                              .value.text));
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xff404E65)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Request Code",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Raleway',
                                            fontSize: 20,
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
                          )
                        : Column(
                            children: [
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
                              Form(
                                key: _formKey,
                                child: EditTextUtils().getCustomEditTextArea(
                                    // labelValue: "Enter phone number",
                                    hintValue: "john@gmail.com",
                                    controller: _emailTextController,
                                    keyboardType: TextInputType.emailAddress,
                                    icon: Icon(Icons.email),
                                    validator: (value) {
                                      return validateEmail(value!);
                                    }),
                              ),
                              SizedBox(height: 30),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          BlocProvider.of<LoginBloc>(context)
                                              .add(SendOtpEvent(
                                                  phoneNumber:
                                                      _selectedCountryCode
                                                              .toString() +
                                                          _phoneTextController
                                                              .value.text));
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xff404E65)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Send Link",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Raleway',
                                            fontSize: 20,
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
                          ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? validateMobile(String value) {
    if (value.length != 9)
      return 'Mobile Number must be of 9 digits';
    else
      return null;
  }

  String? validateEmail(String email) {
    if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      return null;
    } else {
      return 'Enter valid Email Address';
    }
  }
}

class OtpInput extends StatefulWidget {
  late String? phoneNo;
  OtpInput({Key? key, this.phoneNo}) : super(key: key);
  @override
  State<OtpInput> createState() => _OtpInputState(phoneNo: phoneNo);
}

class _OtpInputState extends State<OtpInput> {
  late String? phoneNo;
  _OtpInputState({this.phoneNo});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DefaultTextStyle(
          style: TextStyle(decoration: TextDecoration.none),
          child: Container(
            width: double.infinity,
            color: Colors.white,
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
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Image.asset(
                              'assets/images/otp.png',
                              height: 300,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Verification Code',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 31,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            softWrap: false,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'We have sent a verification code to\n your number',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 15,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: false,
                          ),
                          SizedBox(height: 5),
                          Text(
                            phoneNo ?? '',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 18,
                              color: const Color(0xffFF9E16),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: false,
                          ),
                          SizedBox(height: 20),
                        ],
                      )),
                  PinEntryTextField(
                      fields: 6,
                      onSubmit: (String pin) {
                        BlocProvider.of<LoginBloc>(context)
                            .add(VerifyOtpEvent(otp: pin));
                      }),
                  SizedBox(height: 20),
                  Text(
                    'Didn\'t get code?',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                  GestureDetector(
                    child: Text("Resend Code",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700,
                            color: Color(0xffFF9E16))),
                    onTap: () {
                      BlocProvider.of<LoginBloc>(context).add(AppStartEvent());
                    },
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
