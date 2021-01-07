import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guccigang/config/palette.dart';
import 'package:guccigang/widgets/circle_button.dart';
import 'package:guccigang/widgets/profile_avatar.dart';
import 'package:image_picker/image_picker.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  File _image;
  TextEditingController captionController = new TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 25,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Palette.kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Create Trip"),
            CircleButton(icon: Icons.add, iconSize: 25.0, onPressed: () {})
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: ProfileAvatar(
                          imageFile: _image, width: 120, height: 120),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Container(
                      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            hintText: "Enter Title",
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.title,
                              color: Colors.white,
                            ),
                            labelText: "Title"),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Container(
                      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            hintText: "Enter Phone Number",
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.title,
                              color: Colors.white,
                            ),
                            labelText: "Enter Phone Number"),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Container(
                      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextField(
                        controller: captionController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration.collapsed(
                            hintText: "Describe your trip"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
