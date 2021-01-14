import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/Constantcolors.dart';
import 'package:social_app/helpers/homePageHelpers.dart';
import 'package:social_app/screens/chatRoom.dart';
import 'package:social_app/screens/feed.dart';
import 'package:social_app/screens/profile.dart';
import 'package:social_app/services/firebaseOperations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homePageController = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homePageController,
        children: [Feed(), ChatRoom(), Profile()],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomePageHelpers>(context, listen: false)
          .bottomNavBar( context, pageIndex, homePageController),
    );
  }
}
