import 'package:flutter/material.dart';
import 'package:guccigang/models/trip.dart';

class MyDetailPage extends StatefulWidget {
  MyTrip _myTrip;

  MyDetailPage(MyTrip myTrip) {
    _myTrip = myTrip;
  }

  @override
  _MyDetailPageState createState() => _MyDetailPageState(_myTrip);
}

class _MyDetailPageState extends State<MyDetailPage> {
  MyTrip myTrip;

  _MyDetailPageState(MyTrip myTrip) {
    this.myTrip = myTrip;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(myTrip.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Hero(
            transitionOnUserGestures: true,
            tag: myTrip,
            child: Transform.scale(
              scale: 2.0,
              child: Image.asset(myTrip.img),
            ),
          ),
          Card(
              elevation: 8,
              margin: EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(myTrip.body),
              )),
        ],
      )),
    );
  }
}
