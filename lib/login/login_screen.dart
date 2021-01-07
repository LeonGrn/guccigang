import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guccigang/config/palette.dart';
import 'package:guccigang/login/signup_screen.dart';
import 'package:guccigang/screens/navigation_screens.dart';
import 'package:guccigang/widgets/rounded_button.dart';
import 'package:guccigang/widgets/rounded_input_field.dart';
import 'package:guccigang/widgets/rounded_password.dart';
import 'package:http/http.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  String _email = "";
  final bool login = true;

  final String url = "http://10.0.2.2:8084";
  final String spaceName = "2021a.eden.lev";

  Future<void> _login(context) async {
    final Dio dio = new Dio();
    try {
      var response = await dio.get("$url/dts/users/login/$spaceName/$_email");
      print(response.statusCode);
      print(response.data);
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Size size = MediaQuery.of(context).size;

    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "SIGN IN",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          // Image.asset(
          //   'assets/sun2.png',
          //   height: size.height * 0.35,
          // ),
          SizedBox(height: size.height * 0.03),
          RoundedInputField(
            hintText: "Your Email",
            onChanged: (value) {
              _email = value;
            },
          ),
          RoundedButton(
            text: "LOGIN",
            press: () {
              // _login(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BottomNavBar();
                  },
                ),
              );
            },
          ),
          SizedBox(height: size.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                login
                    ? "Don’t have an Account ? "
                    : "Already have an Account ? ",
                style: TextStyle(color: Palette.kPrimaryColor),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
                child: Text(
                  login ? "Sign Up" : "Sign In",
                  style: TextStyle(
                    color: Palette.kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   child: Image.asset('assets/main_top.png', width: size.width * 0.35),
          // ),
          // Positioned(
          //   right: 0,
          //   bottom: 0,
          //   child:
          //       Image.asset('assets/login_bottom.png', width: size.width * 0.4),
          // ),
          child,
        ],
      ),
    );
  }
}
