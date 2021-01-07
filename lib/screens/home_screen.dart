import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guccigang/config/palette.dart';
import 'package:guccigang/models/trip.dart';
import 'package:guccigang/screens/trip_details.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:flutter_paginator/enums.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List<MyTrip> items = new List<MyTrip>();
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  // _HomeScreenState() {
  //   items.add(new MyTrip("assets/iron_man.png", "Iron Man",
  //       "Genius. Billionaire. Playboy. Philanthropist. Tony Stark's confidence is only matched by his high-flying abilities as the hero called Iron Man."));
  //   items.add(new MyTrip("assets/captain_america.png", "Captain America",
  //       "Recipient of the Super-Soldier serum, World War II hero Steve Rogers fights for American ideals as one of the world’s mightiest heroes and the leader of the Avengers."));
  //   items.add(new MyTrip("assets/thor.png", "Thor",
  //       "The son of Odin uses his mighty abilities as the God of Thunder to protect his home Asgard and planet Earth alike."));
  //   items.add(new MyTrip("assets/hulk.png", "Hulk",
  //       "Dr. Bruce Banner lives a life caught between the soft-spoken scientist he’s always been and the uncontrollable green monster powered by his rage."));
  //   items.add(new MyTrip("assets/black_widow.png", "Black Widow",
  //       "Despite super spy Natasha Romanoff’s checkered past, she’s become one of S.H.I.E.L.D.’s most deadly assassins and a frequent member of the Avengers."));
  // }

  // Widget tripCell(BuildContext ctx, int index) {
  //   return GestureDetector(
  //     onTap: () {
  //       //final snackBar = SnackBar(content: Text("Tap"));
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => MyDetailPage(items[index])));
  //     },
  //     child: Card(
  //         margin: EdgeInsets.all(8),
  //         elevation: 4.0,
  //         child: Container(
  //           padding: EdgeInsets.all(16),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Row(
  //                 children: <Widget>[
  //                   Hero(
  //                     tag: items[index],
  //                     child: Image.asset(items[index].img),
  //                   ),
  //                   SizedBox(
  //                     width: 16,
  //                   ),
  //                   Text(
  //                     items[index].title,
  //                     style:
  //                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                   ),
  //                 ],
  //               ),
  //               Icon(Icons.navigate_next, color: Colors.black38),
  //             ],
  //           ),
  //         )),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Palette.scaffold,
          centerTitle: true,
          title: Text(
            "Trips",
            style: TextStyle(
                color: Palette.appName,
                fontFamily: 'IndieFlower',
                fontSize: 35.0),
          )),
      // body: Center(
      //   child: Stack(
      //     children: <Widget>[
      //       ListView.builder(
      //         itemCount: items.length,
      //         itemBuilder: (context, index) => tripCell(context, index),
      //       ),
      //     ],
      //   ),
      // ), //
//     );
//   }
// }
      body: Paginator.listView(
        key: paginatorGlobalKey,
        pageLoadFuture: sendTripsDataRequest,
        pageItemsGetter: listItemsGetter,
        listItemBuilder: listItemBuilder,
        loadingWidgetBuilder: loadingWidgetMaker,
        errorWidgetBuilder: errorWidgetMaker,
        emptyListWidgetBuilder: emptyListWidgetMaker,
        totalItemsGetter: totalPagesGetter,
        pageErrorChecker: pageErrorChecker,
        scrollPhysics: BouncingScrollPhysics(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          paginatorGlobalKey.currentState.changeState(
              pageLoadFuture: sendTripsDataRequest, resetState: true);
        },
        backgroundColor: Palette.kPrimaryColor,
        child: Icon(Icons.refresh),
      ),
    );
  }

  Future<TripsData> sendTripsDataRequest(int page) async {
    print('page ${page}');
    try {
      String url = Uri.encodeFull(
          'http://api.worldbank.org/v2/country?page=$page&format=json');
      http.Response response = await http.get(url);
      print('body ${response.body}');
      return TripsData.fromResponse(response);
    } catch (e) {
      if (e is IOException) {
        return TripsData.withError('Please check your internet connection.');
      } else {
        print(e.toString());
        return TripsData.withError('Something went wrong.');
      }
    }
  }

  List<dynamic> listItemsGetter(TripsData countriesData) {
    List<String> list = [];
    countriesData.countries.forEach((value) {
      list.add(value['name']);
    });
    return list;
  }

  Widget listItemBuilder(value, int index) {
    return ListTile(
      leading: Text(index.toString()),
      title: Text(value),
    );
  }

  Widget loadingWidgetMaker() {
    return Container(
      alignment: Alignment.center,
      height: 160.0,
      child: CircularProgressIndicator(),
    );
  }

  Widget errorWidgetMaker(TripsData countriesData, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(countriesData.errorMessage),
        ),
        FlatButton(
          onPressed: retryListener,
          child: Text('Retry'),
        )
      ],
    );
  }

  Widget emptyListWidgetMaker(TripsData countriesData) {
    return Center(
      child: Text('No countries in the list'),
    );
  }

  int totalPagesGetter(TripsData countriesData) {
    return countriesData.total;
  }

  bool pageErrorChecker(TripsData countriesData) {
    return countriesData.statusCode != 200;
  }
}

class TripsData {
  List<dynamic> countries;
  int statusCode;
  String errorMessage;
  int total;
  int nItems;

  TripsData.fromResponse(http.Response response) {
    this.statusCode = response.statusCode;
    List jsonData = json.decode(response.body);
    countries = jsonData[1];
    total = jsonData[0]['total'];
    nItems = countries.length;
  }

  TripsData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}
