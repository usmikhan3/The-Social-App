import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/Constantcolors.dart';
import 'package:social_app/services/authentication.dart';
import 'package:social_app/utils/postOptions.dart';
import 'package:social_app/utils/uploadPost.dart';

class FeedHelpers with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  Widget feedAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      actions: [
        IconButton(
            icon: Icon(Icons.camera_enhance_rounded),
            color: constantColors.greenColor,
            onPressed: () {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImageType(context);
            })
      ],
      backgroundColor: constantColors.darkColor.withOpacity(0.6),
      title: RichText(
        text: TextSpan(
            text: "Social ",
            style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            children: <TextSpan>[
              TextSpan(
                  text: "Feed",
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18))
            ]),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.darkColor.withOpacity(0.6),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18))),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("posts").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    height: 500,
                    width: 400,
                    child: Lottie.asset("assets/animations/loading.json"),
                  ),
                );
              } else {
                return loadPosts(context, snapshot);
              }
            },
          ),
        ),
      ),
    );
  }

  loadPosts(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
        return Container(
          height: MediaQuery.of(context).size.height * .45,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                          backgroundColor: constantColors.blueGreyColor,
                          radius: 20,
                          backgroundImage: AssetImage("assets/images/login.png")
                          //NetworkImage(documentSnapshot.data()['userImage']),
                          ),
                      onTap: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                documentSnapshot.data()['caption'],
                                style: TextStyle(
                                    color: constantColors.greenColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                    text: documentSnapshot.data()['userName'],
                                    style: TextStyle(
                                        color: constantColors.greenColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ', 12 hours ago',
                                          style: TextStyle(
                                              color: constantColors.lightColor
                                                  .withOpacity(0.8)))
                                    ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: //Image.asset("assets/images/login.png")
                        Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Image.network(
                        documentSnapshot.data()['postImage'],
                        scale: 2,
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 80.0,
                      child: Row(
                        children: [
                          GestureDetector(
                            onLongPress:(){
                              Provider
                                  .of<PostFunctions>(context, listen: false)
                              .showLikesSheet(context,documentSnapshot.data()['caption']);
                },
                            onTap:(){
                              print("Adding Like....");
                              Provider
                                  .of<PostFunctions>(context, listen: false)
                                  .addLike(
                                context,
                                documentSnapshot.data()['caption'],
                                Provider.of<Authentication>(context,listen: false).getUserUid
                              );
                            },
                            child: Icon(
                              FontAwesomeIcons.heart,
                              color: constantColors.redColor,
                              size: 22,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection("posts").doc(documentSnapshot.data()['caption']).collection('likes').snapshots(),
                              builder: (context,snapshot){
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }else{
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      snapshot.data.docs.length.toString(),
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                    Container(
                      width: 80.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showCommentSheet(context, documentSnapshot, documentSnapshot.data()['caption']);
                            },
                            child: Icon(
                              FontAwesomeIcons.comment,
                              color: constantColors.blueColor,
                              size: 22,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              "0",
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 80.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Icon(
                              FontAwesomeIcons.award,
                              color: constantColors.yellowColor,
                              size: 22,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              "0",
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Provider.of<Authentication>(context, listen: false)
                                .getUserUid ==
                            documentSnapshot.data()['userUid']
                        ? IconButton(
                            icon: Icon(
                              EvaIcons.moreVertical,
                              color: constantColors.whiteColor,
                            ),
                            onPressed: () {})
                        : Container(
                            width: 0,
                            height: 0,
                          )
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }



}
