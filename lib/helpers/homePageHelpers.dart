import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/Constantcolors.dart';
import 'package:social_app/services/firebaseOperations.dart';

class HomePageHelpers with ChangeNotifier{
  ConstantColors constantColors = ConstantColors();

  Widget bottomNavBar(int index, PageController pageController,  BuildContext context){
    return CustomNavigationBar(
      currentIndex: index,
        bubbleCurve: Curves.bounceIn,
        scaleCurve:Curves.decelerate ,
        selectedColor: constantColors.blueColor,
        unSelectedColor: constantColors.whiteColor,
        strokeColor: constantColors.blueColor,
        scaleFactor: 0.5,
        iconSize: 30,
        onTap: (val){
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
        },
        backgroundColor: Color(0xFF040307),
        items: [
          CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
          CustomNavigationBarItem(icon: Icon(EvaIcons.messageCircle)),
          CustomNavigationBarItem(icon: CircleAvatar(
            radius: 35,
            backgroundColor: constantColors.blueGreyColor,
            backgroundImage: NetworkImage(
                Provider.of<FirebaseOperations>(context,listen: false).getInitUserImage
            ),
          )),
        ]
    );
  }
}