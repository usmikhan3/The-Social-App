import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/Constantcolors.dart';
import 'package:social_app/services/authentication.dart';
import 'package:social_app/services/firebaseOperations.dart';

class PostFunctions with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  TextEditingController commentController = TextEditingController();
  Future addLike(BuildContext context, String postId, String subDocId) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'userName': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userId': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userImage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'userEmail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'userName': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userId': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userImage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'userEmail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  showCommentSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.whiteColor),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                        child: Text(
                      'Comments',
                      style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .11,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("posts")
                          .doc(docId)
                          .collection("comments")
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Container(
                                color:constantColors.redColor ,
                                height: MediaQuery.of(context).size.height * 0.11,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, left: 8),
                                          child: GestureDetector(
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  constantColors.darkColor,
                                              radius: 15,
                                              backgroundImage: NetworkImage(
                                                  documentSnapshot
                                                      .data()['userImage']),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                documentSnapshot
                                                    .data()['UserName'],
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 14.0),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(

                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                    FontAwesomeIcons.arrowUp),
                                                onPressed: () {},
                                                color: constantColors.blueColor,
                                                iconSize: 12,
                                              ),
                                              Text(
                                                "0",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              IconButton(
                                                icon:
                                                    Icon(FontAwesomeIcons.reply),
                                                onPressed: () {},
                                                color: constantColors.yellowColor,
                                              ),
                                              IconButton(
                                                icon:
                                                    Icon(FontAwesomeIcons.trash),
                                                onPressed: () {},
                                                color: constantColors.redColor,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.arrow_forward_ios),
                                            onPressed: () {},
                                            color: constantColors.blueColor,
                                            iconSize: 12,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Text("${documentSnapshot.data()['comment']}",
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 16.0
                                            ),),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(color: constantColors.darkColor.withOpacity(0.2),),

                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          //color:constantColors.redColor ,
                          width: 300,
                          height: 50,
                          child: TextField(
                            controller: commentController,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(

                            hintText: "Add Comment",
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,

                              ),

                            ),

                          ),
                        ),

                        FloatingActionButton(
                          backgroundColor: constantColors.greenColor,
                          onPressed: (){
                            print("adding comment");
                            addComment(context, snapshot.data()['caption'], commentController.text);
                          },
                          child: Icon(FontAwesomeIcons.comment,color: constantColors.whiteColor,),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }



  showLikesSheet(BuildContext context, String postId){
    return showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(topRight:Radius.circular(12), topLeft: Radius.circular(12.0))
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                      child: Text(
                        'Likes',
                        style: TextStyle(
                            color: constantColors.blueColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  height:MediaQuery.of(context).size.height *.2 ,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("posts").doc(postId).collection("likes").snapshots(),
                    builder: (context,snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }else{
                        return ListView(
                          children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading:GestureDetector(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    documentSnapshot.data()['userImage']
                                  ),
                                ),
                              ) ,
                              title: Text(documentSnapshot.data()['userName'], style: TextStyle(
                                color: constantColors.blueColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                              ),),
                              subtitle:Text(documentSnapshot.data()['userEmail'], style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold
                              ),),
                              trailing: Provider.of<Authentication>(context,listen: false).getUserUid == documentSnapshot.data()['userId'] ?
                              Container(width:0 ,height: 0,) : MaterialButton(
                                color: constantColors.blueColor,
                                child: Text(
                                  "Follow",style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                                onPressed: (){},
                              )
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
    }
    );
  }

}
