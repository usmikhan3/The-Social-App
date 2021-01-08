import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/Constantcolors.dart';
import 'package:social_app/helpers/landingHelpers.dart';
import 'package:social_app/helpers/landingUtils.dart';
import 'package:social_app/screens/landingPage.dart';
import 'package:social_app/screens/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:social_app/services/authentication.dart';
import 'package:social_app/services/firebaseOperations.dart';
import 'package:social_app/services/landingServices.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>LandingHelpers()),
        ChangeNotifierProvider(create: (_)=>Authentication()),
        ChangeNotifierProvider(create: (_)=>LandingService()),
        ChangeNotifierProvider(create: (_)=>FirebaseOperations()),
        ChangeNotifierProvider(create: (_)=>LandingUtils()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          accentColor:constantColors.blueColor,
          fontFamily: "Poppins",
          canvasColor: Colors.transparent,

        ),
      home:SplashScreen() ,
      ),
    );
  }
}


