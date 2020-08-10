import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as dartConvert;

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  final String url =
      "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2020-08-08&minmagnitude=2";

  Future<List<DataClass>> helperNetwork() async {
    List<DataClass> dataClass = [];
    int count = 0;
    var response = await http.get(url);
    var jsonData = dartConvert.json.decode(response.body);

    for (int i = 0; i < jsonData["features"].length; i++) {
      if (jsonData["features"][i]["properties"]["mag"] > 2.0) {
        dataClass.add(DataClass(
            jsonData["features"][i]["properties"]["mag"] + 0.0,
            jsonData["features"][i]["properties"]["place"].toString()));
      }
    }

    return dataClass;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: helperNetwork(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            return ListView.builder(
                itemCount: asyncSnapshot.data.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Magnitude: " + asyncSnapshot.data[i].mag.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Place: " + asyncSnapshot.data[i].place,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Center(
              child: Text(
                "LOADING...",
                style: TextStyle(fontSize: 20),
              ),
            );
          }
        },
      ),
    );
  }
}

class DataClass {
  String place;
  double mag;
  DataClass(this.mag, this.place);
}
