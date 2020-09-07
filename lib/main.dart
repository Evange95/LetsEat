import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_complete_guide/screens/add_dinner_screen.dart';
import 'package:flutter_complete_guide/screens/add_recipe_screen.dart';
import 'package:flutter_complete_guide/screens/comment_screen.dart';
import 'package:flutter_complete_guide/screens/complete_profile_screen.dart';
import 'package:flutter_complete_guide/screens/edit_dinner_screen.dart';
import 'package:flutter_complete_guide/screens/edit_recipe_screen.dart';
import 'package:flutter_complete_guide/screens/faq_screen.dart';
import 'package:flutter_complete_guide/screens/home/home.dart';
import 'package:flutter_complete_guide/screens/view_all_recip.dart';
import 'package:flutter_complete_guide/services/dinners.dart';
import 'package:flutter_complete_guide/services/user.dart';

import './screens/wrapper.dart';
import './services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/recipes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(value: AuthService().user),
        ChangeNotifierProvider<User>(create: (_) => User()),
        ChangeNotifierProvider<Recipes>(create: (_) => Recipes()),
        ChangeNotifierProvider<Dinners>(create: (_) => Dinners()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        theme: ThemeData(
            primarySwatch: Colors.orange,
            accentColor: Colors.deepOrangeAccent,
            scaffoldBackgroundColor: Color.fromRGBO(187, 220, 200, 1)),
        routes: {
          ViewAllScreen.routeName: (ctx) => ViewAllScreen(),
          CompleteProfileScreen.routeName: (ctx) => CompleteProfileScreen(),
          Home.routeName: (ctx) => Home(),
          Wrapper.routeName: (ctx) => Wrapper(),
          AddRecipeScreen.routeName: (ctx) => AddRecipeScreen(),
          AddDinnerScreen.routeName: (ctx) => AddDinnerScreen(),
          CommentScreen.routeName: (ctx) => CommentScreen(),
          FaqScreen.routeName: (ctx) => FaqScreen(),
          EditDinnerScreen.routeName: (ctx) => EditDinnerScreen(),
          EditRecipeScreen.routeName: (ctx) => EditRecipeScreen(),
        },
      ),
    );
  }
}
