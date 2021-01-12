import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/helpers/feedHelpers.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<FeedHelpers>(context,listen: false).feedAppBar(context),

      drawer: Drawer(),

      body:Provider.of<FeedHelpers>(context,listen: false).feedBody(context),

    );
  }
}
