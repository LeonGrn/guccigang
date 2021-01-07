import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guccigang/config/prefs.dart';
import 'package:guccigang/models/new_user_details.dart';
import 'package:guccigang/models/userBoundary.dart';
import 'package:guccigang/models/user_id.dart';
import 'package:guccigang/screens/navigation_screens.dart';
import 'package:guccigang/widgets/profile_avatar.dart';
import 'package:guccigang/widgets/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<SignUpScreen> {
  bool _passwordVisible;
  String birthDate = "";
  int age = -1;

  String _email = "";
  String _password = "";
  String _fullName = "";
  String gender = "";

  File _image;
  final String url = "http://10.0.2.2:8084";

  //UserBoundary userBoundary = new UserBoundary();

  TextEditingController nameController = TextEditingController();
  //int _radioValue = 0;
  AssetImage myChoosenImage = new AssetImage('assets/user.png');

  @override
  void initState() {
    _passwordVisible = false;
    //_dbRef = FirebaseDatabase.instance.reference().child('myUsers');
    super.initState();
    //initPlatformState();
  }

  // Future getImage() async {
  //   final pickedFile =
  //       await ImagePicker().getImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //       //myChoosenImage = _image;
  //       uploadPic();
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  // Future uploadPic() async {
  //   // firebase_storage.FirebaseStorage storage =
  //   //     firebase_storage.FirebaseStorage.instance;
  //   try {
  //     await firebase_storage.FirebaseStorage.instance
  //         .ref('profile/myProfile.png')
  //         .putFile(_image);
  //   } on FirebaseException catch (e) {
  //     // e.g, e.code == 'canceled'
  //     print(e);
  //   }
  // }

  Future<void> _createUser() async {
    final newUserDetails = new NewUserDetails(
        email: _email,
        role: "PLAYER",
        username: _fullName,
        avatar: "someAvatar");

    Dio dio = new Dio();

    Response response = await dio.post("$url/dts/users", data: newUserDetails);
    print(response.data.toString());

    UserBoundary userBoundary = new UserBoundary.fromJson(response.data);
    // print(inspect(userBoundary));
    SharedPref sharedPref = SharedPref();
    await sharedPref.remove("USER_BOUNDARY");
    await sharedPref.save("USER_BOUNDARY", userBoundary);
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString("USER_BOUNDARY", response.data.toString());
    //loadSharedPrefs();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => new BottomNavBar()),
        (e) => false);
  }

  // loadSharedPrefs() async {
  //   try {
  //     SharedPref sharedPref = SharedPref();

  //     UserBoundary userBoundary =
  //         UserBoundary.fromJson(await sharedPref.read("USER_BOUNDARY"));
  //     print(inspect(userBoundary));
  //   } catch (Excepetion) {
  //     // do something
  //   }
  // }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  selectDate(BuildContext context, DateTime initialDateTime,
      {DateTime lastDate}) async {
    Completer completer = Completer();
    if (Platform.isAndroid)
      showDatePicker(
              context: context,
              initialDate: initialDateTime,
              firstDate: DateTime(1970),
              lastDate: lastDate == null
                  ? DateTime(initialDateTime.year + 10)
                  : lastDate)
          .then((temp) {
        if (temp == null) return null;
//        _selectedDateInString = df.format(temp);
        completer.complete(temp);
        setState(() {});
      });
    else
      DatePicker.showDatePicker(
        context,
        dateFormat: 'yyyy-mmm-dd',
        locale: 'en',
        onConfirm2: (temp, selectedIndex) {
          if (temp == null) return null;
//          final df = new DateFormat('dd-MMM-yyyy');
//          _selectedDateInString = df.format(temp);
          completer.complete(temp);
          setState(() {});
        },
      );
    return completer.future;
  }

  bool maleIsSelected = false;
  bool femaleIsSelected = false;
  bool otherIsSelected = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    TextStyle valueTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    TextStyle textTextStyle = TextStyle(
      fontSize: 15,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                // GestureDetector(
                //   onTap: () {
                //     //getImage();
                //   },
                //   //child:
                //   //ProfileAvatar(imageFile: _image, width: 120, height: 120),
                // ),
                Text(
                  "Register Details",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 25.0,
                      fontStyle: FontStyle.normal),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.2,
                ),
                TextField(
                  onChanged: (value) {
                    _fullName = value;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "Enter Full Name",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.tag_faces,
                        color: Colors.white,
                      ),
                      labelText: "Full Name"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  onChanged: (value) {
                    _email = value;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "Enter Email",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.tag_faces,
                        color: Colors.white,
                      ),
                      labelText: "Email"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilterChip(
                      labelPadding: EdgeInsets.all(5),
                      label: Text('Male'),
                      labelStyle: TextStyle(
                          color: maleIsSelected ? Colors.black : Colors.white),
                      selected: maleIsSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          femaleIsSelected = false;
                          otherIsSelected = false;
                          maleIsSelected = !maleIsSelected;
                        });
                      },
                      selectedColor: Theme.of(context).accentColor,
                      checkmarkColor: Colors.black,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FilterChip(
                      labelPadding: EdgeInsets.all(5),
                      label: Text('Female'),
                      labelStyle: TextStyle(
                          color:
                              femaleIsSelected ? Colors.black : Colors.white),
                      selected: femaleIsSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          maleIsSelected = false;
                          otherIsSelected = false;
                          femaleIsSelected = !femaleIsSelected;
                        });
                      },
                      selectedColor: Theme.of(context).accentColor,
                      checkmarkColor: Colors.black,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FilterChip(
                      labelPadding: EdgeInsets.all(5),
                      label: Text('Other'),
                      labelStyle: TextStyle(
                          color: otherIsSelected ? Colors.black : Colors.white),
                      selected: otherIsSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          maleIsSelected = false;
                          femaleIsSelected = false;
                          otherIsSelected = !otherIsSelected;
                        });
                      },
                      selectedColor: Theme.of(context).accentColor,
                      checkmarkColor: Colors.black,
                    ),
                  ],
                ),

                SizedBox(
                  height: 20.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    //mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                border: Border.all(color: Colors.grey)),
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "BirthDate: ",
                                  style: textTextStyle,
                                ),
                                Text(
                                  "$birthDate",
                                  style: valueTextStyle,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 32,
                      // ),
                      GestureDetector(
                        child: new Icon(
                          Icons.calendar_today,
                          size: 50,
                        ),
                        onTap: () async {
                          DateTime birthDate = await selectDate(
                              context, DateTime.now(),
                              lastDate: DateTime.now());
                          final df = new DateFormat('dd-MMM-yyyy');
                          this.birthDate = df.format(birthDate);
                          this.age = calculateAge(birthDate);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10.0,
                ),
                RoundedButton(
                  text: "Submit",
                  press: () {
                    _createUser();
                  },
                ),
                // RaisedButton(
                //     child: Text("Submit"),
                //     textColor: Colors.white,
                //     color: Colors.blueAccent,
                //     onPressed: () {
                //       //_createUser();
                //     }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
