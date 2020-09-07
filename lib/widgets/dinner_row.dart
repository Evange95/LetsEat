import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/dinner_detail_screen.dart';
import 'package:flutter_complete_guide/services/dinners.dart';
import 'package:provider/provider.dart';

class DinnerRow extends StatelessWidget {
  final String id;
  DinnerRow(this.id);

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<FirebaseUser>(context).uid;
    final dinner =
        Provider.of<Dinners>(context, listen: false).findDinnerById(id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DinnerDetailScreen(dinner.id)));
        },
        child: Container(
          height: 120,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image(
                    height: 90.0,
                    width: 90.0,
                    image: NetworkImage(dinner.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dinner.title.toString(),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    // Text(dinner.address),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${dinner.dist.toString()} km',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (dinner.participants.contains(uid))
                      Text(
                        'Booked!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text("\$${dinner.price}",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
