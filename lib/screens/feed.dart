import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/Constantcolors.dart';
import 'package:social_app/helpers/feedHelpers.dart';

class Feed extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: Provider.of<FeedHelpers>(context,listen: false).feedAppBar(context),

      drawer: Drawer(),

      body:Provider.of<FeedHelpers>(context,listen: false).feedBody(context),

    );
  }
}
