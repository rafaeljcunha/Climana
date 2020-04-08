import "dart:async";
import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

const request =
    "http://apiadvisor.climatempo.com.br/api/v1/weather/locale/8280/current?token=your_token_access";

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> fetch() async {
  var response = await http.get(request);
  return convert.jsonDecode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int temperature;
  int sensation;
  String condition;
  int humidity;
  String icons;
  String city;
  String state;
  String date;
  dynamic data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("CLIMANA"),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: FutureBuilder<Map>(
            future: fetch(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                        strokeWidth: 5,
                      ),
                    ),
                  );
                default:
                  condition = snapshot.data["data"]["condition"];
                  temperature = snapshot.data["data"]["temperature"];
                  sensation = snapshot.data["data"]["sensation"];
                  humidity = snapshot.data["data"]["humidity"];
                  icons = snapshot.data["data"]["icon"];
                  city = snapshot.data["name"];
                  state = snapshot.data["state"];
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Problemas ao carregar os dados",
                        style:
                            TextStyle(color: Colors.lightBlue, fontSize: 24.0),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(7.0, 10.0, 7.0, 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "$city/$state",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                              child: Image.asset(
                                "images/$icons.jpg",
                                width: 120.0,
                              )),
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "images/thermometer.png",
                                    height: 50.0,
                                    color: temperature > 25
                                        ? Colors.redAccent
                                        : Colors.blueAccent,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "$temperature ºC",
                                      style: TextStyle(
                                        fontSize: 60.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              )),
                          Card(
                            borderOnForeground: true,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(
                                    sensation > 25
                                        ? Icons.wb_sunny
                                        : Icons.ac_unit,
                                    size: 60.0,
                                    color: sensation > 25
                                        ? Colors.yellow
                                        : Colors.cyan,
                                  ),
                                  title: Padding(
                                    padding: EdgeInsets.only(left: 17.0),
                                    child: Text(
                                      "$sensation ºC",
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(left: 17.0),
                                    child: Text(
                                      "Sensação Térmica",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(20.0),
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.opacity,
                                    size: 60.0,
                                    color: Colors.blue,
                                  ),
                                  title: Padding(
                                    padding: EdgeInsets.only(left: 17.0),
                                    child: Text(
                                      "$humidity%",
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(left: 17.0),
                                    child: Text(
                                      "Umidade do ar",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(20.0),
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.filter_drama,
                                    size: 60.0,
                                    color: Colors.cyan,
                                  ),
                                  title: Padding(
                                    padding: EdgeInsets.only(left: 17.0),
                                    child: Text(
                                      "$condition.",
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(left: 17.0),
                                    child: Text(
                                      "Condição do céu",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(20.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}
