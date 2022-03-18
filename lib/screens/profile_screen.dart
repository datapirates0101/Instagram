import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post length

      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      setState(() {
        userData = userSnap.data()!;
        postLength = postSnap.docs.length;
        followers = userData['followers'].length;
        following = userData['following'].length;
        isFollowing = userData['following']
            .contains(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (e) {
      showSnakBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(
        color: primaryColor,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['name']),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        userData['photoUrl'],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              buildStatColumn(postLength, 'posts'),
                              buildStatColumn(followers, 'followers'),
                              buildStatColumn(following, 'following'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid ==
                                      widget.uid
                                  ? FollowButton(
                                      backgroundColor: mobileBackgroundColor,
                                      borderColor: Colors.grey,
                                      text: 'Edit Profile',
                                      textColor: primaryColor,
                                      function: () {},
                                    )
                                  : isFollowing
                                      ? FollowButton(
                                          backgroundColor: blueColor,
                                          borderColor: Colors.grey,
                                          text: 'Unfollow',
                                          textColor: Colors.white,
                                          function: () {},
                                        )
                                      : FollowButton(
                                          text: 'Follow',
                                          backgroundColor: Colors.blue,
                                          textColor: Colors.white,
                                          borderColor: Colors.blue,
                                          function: () {},
                                        )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      userData['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(userData['bio']),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('post')
                .where('uid', isEqualTo: widget.uid)
                .get(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapShot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap = snapShot.data!.docs[index];
                    return Container(
                      child: Image(
                        image: NetworkImage(
                          snap['postUrl'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String lable) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            lable,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
