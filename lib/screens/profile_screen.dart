import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guccigang/config/prefs.dart';
import 'package:guccigang/models/userBoundary.dart';
import 'package:guccigang/widgets/profile_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;

  String name;
  String role;
  String email;

  bool isLoading = false;

  SharedPref sharedPref;
  UserBoundary userBoundary;

  loadSharedPrefs() async {
    try {
      sharedPref = SharedPref();
      userBoundary =
          UserBoundary.fromJson(await sharedPref.read("USER_BOUNDARY"));
      setState(() {
        email = userBoundary.userId.email;
        role = userBoundary.role;
        name = userBoundary.username;
        isLoading = true;
      });
    } catch (Excepetion) {
      // do something
    }
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        //myChoosenImage = _image;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 20.0),
            child: Column(
              children: [
                ProfileAvatar(imageFile: _image, width: 120, height: 120),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ListTile(
                  enabled: false,
                  leading: Icon(Icons.email),
                  title: !isLoading
                      ? Text(
                          "Loading",
                        )
                      : Text(email),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: !isLoading ? Text("Loading") : Text(name),
                  onTap: () async {
                    final String newText = await _asyncInputDialog(context);

                    setState(() {
                      name = newText;
                      userBoundary.username = name;
                      _updateUser(context);
                    });
                  },
                ),
                ListTile(
                  enabled: false,
                  title: !isLoading ? Text("Loading") : Text(role),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateUser(context) async {
    final String spaceName = userBoundary.userId.space;
    final String email = userBoundary.userId.email;

    print(userBoundary.userId.space + userBoundary.userId.email);
    final String url = "http://10.0.2.2:8084/dts/users/$spaceName/$email";

    http.put(Uri.encodeFull(url),
        body: jsonEncode(userBoundary.toJson()),
        headers: {"Content-Type": "application/json"}).then((result) {
      print(result.statusCode);
      print(result.body);
    });
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String sampleText = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Name'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Please enter a new username',
                    hintText: 'eg. ABCD'),
                onChanged: (value) {
                  sampleText = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(sampleText);
              },
            ),
          ],
        );
      },
    );
  }
}
