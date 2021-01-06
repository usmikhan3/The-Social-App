import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/Constantcolors.dart';
import 'package:social_app/helpers/landingHelpers.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
 final  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [
          bodyColor(),
          Provider.of<LandingHelpers>(context, listen: false).bodyImage(context),
          Provider.of<LandingHelpers>(context, listen: false).tagLineText(context),
          Provider.of<LandingHelpers>(context, listen: false).mainButtons(context),
          Provider.of<LandingHelpers>(context, listen: false).privacyText(context),

        ],
      ),

    );
  }

  bodyColor(){
    return Container(
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.5,
            0.9
          ],
          colors: [
            constantColors.darkColor,
            constantColors.blueGreyColor,
          ]
        )
      ),
    );
  }
}
