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
import 'package:country_icons/country_icons.dart';
import 'package:zebu_app/routeGenerator.dart';
import 'package:zebu_app/screens/utils/EditTextUtils.dart';
import 'package:zebu_app/screens/utils/fadeAnimation.dart';

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
        } else if (loginState is OtpSentState) {
          Navigator.pushNamed(
            context,
            RouteGenerator.loginScreenName,
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

    if (state is Unauthenticated) {
      return CredentialInput();
    } else if (state is OtpSentState) {
      return OtpInput(phoneNo: state.getPhone());
    } else if (state is OtpExceptionState) {
      return OtpInput();
    } else if (state is LoadingState) {
      return LoadingIndicator(message: state.message);
    } else if (state is LoginCompleteState) {
      BlocProvider.of<AuthenticationBloc>(context)
          .add(LoggedIn(token: state.getUser().uid));

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushNamed(
          context,
          RouteGenerator.onBoardingScreenName,
        );
      });
    } else {
      return CredentialInput();
    }
  }
}

class LoadingIndicator extends StatefulWidget {
  late String? message;
  LoadingIndicator({Key? key, this.message}) : super(key: key);
  @override
  State<LoadingIndicator> createState() =>
      _LoadingIndicatorState(message: message);
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  late String? message;
  _LoadingIndicatorState({this.message});
  @override
  Widget build(BuildContext context) => Center(
        child: Expanded(
          flex: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message!,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 15,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                softWrap: false,
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(
                color: Color(0xff404E65),
              ),
            ],
          ),
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

  var _selectedIndex = 1;

  String _selectedCountryCode = "+251";

  List<String> _countryCodes = ['+251', '+254'];

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;
    Widget countryDropDown = Container(
      decoration: new BoxDecoration(
        // color: Colors.white,
        border: Border(
          right: BorderSide(width: 0.5, color: Color(0xff404E65)),
        ),
      ),
      height: pageHeight * 0.04,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          child: value == '+251'
                              ? Image.asset(
                                  'icons/flags/png/et.png',
                                  package: 'country_icons',
                                  height: pageHeight * 0.03,
                                  width: pageWidth * 0.07,
                                )
                              : Image.asset(
                                  'icons/flags/png/ke.png',
                                  package: 'country_icons',
                                  height: pageHeight * 0.03,
                                  width: pageWidth * 0.07,
                                )),
                      SizedBox(width: pageWidth * 0.01),
                      Text(
                        value,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
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
                    margin: EdgeInsets.only(
                        top: pageHeight * 0.07, left: pageWidth * 0.06),
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
                  SizedBox(height: pageHeight * 0.017),
                  Container(
                    child: Text(
                      'Hello, welcome to Zebu Club. Please login to continue',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 13,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w700,
                      ),
                      softWrap: false,
                    ),
                  ),
                  SizedBox(height: pageHeight * 0.02),
                ],
              )),
          Expanded(
            flex: 0,
            child: Column(
              children: [
                SizedBox(height: pageHeight * 0.025),
                Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Column(
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
                        SizedBox(height: pageHeight * 0.015),
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
                        SizedBox(height: pageHeight * 0.035),
                        Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: SizedBox(
                              width: pageWidth * 0.8,
                              height: pageHeight * 0.062,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<LoginBloc>(context).add(
                                        SendOtpEvent(
                                            phoneNumber: _selectedCountryCode
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Request Code",
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
                          height: pageHeight * 0.025,
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
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;
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
                            margin: EdgeInsets.only(top: pageHeight * 0.094),
                            child: Image.asset(
                              'assets/images/otp.png',
                              height: pageHeight * 0.278,
                              width: pageWidth * 0.485,
                            ),
                          ),
                          SizedBox(height: pageHeight * 0.04),
                          Text(
                            'Verification Code',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                            softWrap: false,
                          ),
                          SizedBox(height: pageHeight * 0.03),
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
                          SizedBox(height: pageHeight * 0.03),
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
                          SizedBox(height: pageHeight * 0.03),
                        ],
                      )),
                  PinEntryTextField(
                      fields: 6,
                      onSubmit: (String pin) {
                        BlocProvider.of<LoginBloc>(context)
                            .add(VerifyOtpEvent(otp: pin));
                      }),
                  SizedBox(height: pageHeight * 0.03),
                  FadeAnimation(
                    30,
                    true,
                    true,
                    Column(
                      children: [
                        Text(
                          'Didn\'t get code?',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 12,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: false,
                        ),
                        GestureDetector(
                          child: Text("Resend Code",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xffFF9E16))),
                          onTap: () {
                            BlocProvider.of<LoginBloc>(context)
                                .add(AppStartEvent());
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: pageHeight * 0.03),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: SizedBox(
                        width: pageWidth * 0.8,
                        height: pageHeight * 0.062,
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
                                fontSize: 17,
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
