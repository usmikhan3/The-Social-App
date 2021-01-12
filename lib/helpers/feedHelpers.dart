import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/Constantcolors.dart';
import 'package:social_app/utils/uploadPost.dart';

class FeedHelpers with ChangeNotifier{

  final ConstantColors constantColors = ConstantColors();

  Widget feedAppBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.camera_enhance_rounded),color: constantColors.greenColor, onPressed: (){
            Provider.of<UploadPost>(context, listen: false).selectPostImageType(context);
          })
        ],
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        title: RichText(
          text: TextSpan(
              text: "Social ",
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
              children: <TextSpan>[
                TextSpan(
                    text: "Feed",
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    )
                )
              ]
          ),
        ),
      );
  }


  Widget feedBody(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color:constantColors.darkColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight:Radius.circular(18) )
          ),
        ),
      ),
    );
  }

}