import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/search_screen.dart';

const webScreenSize = 600;

var homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('notification'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
