import 'package:flutter/material.dart';
import 'package:instagram/models/users.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          color: primaryColor,
        )),
      );
    } else {
      return Scaffold(
        body: Center(child: Text(user.email)),
      );
    }
  }
}
