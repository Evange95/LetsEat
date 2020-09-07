import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/faq_screen.dart';

import 'package:flutter_complete_guide/widgets/carousel.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Container(
                    width: 180,
                    child: Text(
                      'Welcome in LetsEat !',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange, // button color
                      child: InkWell(
                        child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.help,
                              color: Colors.white,
                            )),
                        onTap: () {
                          Navigator.of(context).pushNamed(FaqScreen.routeName);
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Carousel(type: 'top'),
            Carousel(type: 'suggested'),
          ],
        ),
      ),
    );
  }
}
