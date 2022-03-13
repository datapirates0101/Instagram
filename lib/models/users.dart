import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String uid;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;

  User({
    required this.email,
    required this.username,
    required this.uid,
    required this.bio,
    required this.followers,
    required this.following,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        'name': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'followers': followers,
        'following': following,
        'photoUrl': photoUrl,
      };

  static User fromsnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapShot['name'],
      uid: snapShot['uid'],
      email: snapShot['email'],
      photoUrl: snapShot['photoUrl'],
      bio: snapShot['bio'],
      followers: snapShot['followers'],
      following: snapShot['following'],
    );
  }
}
