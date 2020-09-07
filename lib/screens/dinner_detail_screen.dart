import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/dinners.dart';
import 'package:flutter_complete_guide/services/user.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final int itemCount;

  const ColumnBuilder({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.mainAxisAlignment: MainAxisAlignment.start,
    this.mainAxisSize: MainAxisSize.max,
    this.crossAxisAlignment: CrossAxisAlignment.start,
    this.textDirection,
    this.verticalDirection: VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: new List.generate(
          this.itemCount, (index) => this.itemBuilder(context, index)).toList(),
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class DinnerDetailScreen extends StatefulWidget {
  final String id;
  DinnerDetailScreen(this.id);

  @override
  _DinnerDetailScreenState createState() => _DinnerDetailScreenState();
}

class _DinnerDetailScreenState extends State<DinnerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final dinner = Provider.of<Dinners>(context).findDinnerById(widget.id);
    final uid = Provider.of<FirebaseUser>(context).uid;
    final user = Provider.of<User>(context);

    return new StreamBuilder(
        stream: Firestore.instance
            .collection("dinner")
            .document(dinner.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              'No Data...',
            );
          } else {
            var data = snapshot.data;
            var date = DateTime.parse(data['date'].toDate().toString());
            return Scaffold(
              appBar: AppBar(
                actions: [
                  if (data['creatorId'] != uid &&
                      data['max_num'] - data['participants'].length > 0)
                    RaisedButton.icon(
                      onPressed: () async {
                        await dinner.addremovePartecipant(uid);
                        await user.addRemoveDinner(uid, dinner.id);
                        setState(() {});
                      },
                      icon: Icon(
                        data['participants'].contains(uid)
                            ? Icons.done
                            : Icons.add,
                      ),
                      label: data['participants'].contains(uid)
                          ? Text('Booked')
                          : Text('Not Booked'),
                      color: Colors.orange,
                    ),
                  if (data['max_num'] - data['participants'].length == 0)
                    RaisedButton.icon(
                        onPressed: null,
                        icon: Icon(Icons.delete),
                        label: Text('Not available'))
                ],
              ),
              body: SafeArea(
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0.0, 2.0),
                                      blurRadius: 6.0)
                                ]),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image: NetworkImage(dinner.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      dinner.title,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer,
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            '${DateFormat('dd-MM-yyyy – kk:mm').format(date)}',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.map,
                                size: 30,
                              ),
                              Text(
                                '${dinner.dist.toString()} km',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on,
                                size: 30,
                              ),
                              Text(
                                '${dinner.price}',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Current number of guests ${data['participants'].length}',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Card(
                        elevation: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                Text('Description',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  dinner.description,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ))),
                    SizedBox(
                      height: 30,
                    ),
                    Card(
                      elevation: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "What you are going to eat:",
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            ColumnBuilder(
                                itemCount: data['dishes'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  String step = data['dishes'][index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        '$step',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      elevation: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Text(
                                'Where are you invited?',
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              height: 400,
                              child: FlutterMap(
                                options: new MapOptions(
                                  center: new LatLng(double.parse(dinner.lat),
                                      double.parse(dinner.lon)),
                                  zoom: 15.0,
                                ),
                                layers: [
                                  new TileLayerOptions(
                                      urlTemplate:
                                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                      subdomains: ['a', 'b', 'c']),
                                  new MarkerLayerOptions(
                                    markers: [
                                      new Marker(
                                        width: 80.0,
                                        height: 80.0,
                                        point: new LatLng(
                                            double.parse(dinner.lat),
                                            double.parse(dinner.lon)),
                                        builder: (ctx) => new Container(
                                          child: Icon(Icons.my_location),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: RaisedButton(
                                  color: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Text('Get indications'),
                                  onPressed: () {
                                    MapsLauncher.launchCoordinates(
                                        double.parse(dinner.lat),
                                        double.parse(dinner.lon),
                                        'Prova');
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
