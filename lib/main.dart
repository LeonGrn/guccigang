import 'package:flutter/material.dart';
import 'package:guccigang/config/palette.dart';
import 'package:guccigang/login/login_screen.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpashScreen(),
    );
  }
}

class SpashScreen extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<SpashScreen> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 8,
        navigateAfterSeconds: new LoginScreen(),
        title: new Text(
          'Welcome to GucciGang',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        //image: new Image.asset('assets/sailing.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Integration FTW"),
        loaderColor: Palette.kPrimaryColor);
  }
}

// class LandingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       //future: _initialization,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Scaffold(
//             body: Center(
//               child: Text("Error : ${snapshot.error}"),
//             ),
//           );
//         }
//         if (snapshot.connectionState == ConnectionState.done) {
//           return StreamBuilder(
//             stream: FirebaseAuth.instance.authStateChanges(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.active) {
//                 User user = snapshot.data;

//                 if (user == null) {
//                   return WelcomeScreen();
//                 } else {
//                   return BottomNavBar();
//                 }
//               }
//               return Scaffold(
//                 body: Center(
//                   child: Text("Checking Authintication"), // loading
//                 ),
//               );
//             },
//           );
//         }
//         return Scaffold(
//           body: Center(
//             child: Text("Connection to the app"), // loading
//           ),
//         );
//       },
//     );
//   }
// }
