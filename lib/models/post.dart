import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String username;
  final String uid;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Post({
    required this.description,
    required this.username,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.profImage,
    required this.postUrl,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'description': description,
        'postId': postId,
        'datePublished': datePublished,
        'profImage':  profImage,
        'postUrl': postUrl,
        'likes' : likes,
      };

  static Post fromsnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapShot['username'],
      uid: snapShot['uid'],
      description: snapShot['description'],
      postId: snapShot['postId'],
      datePublished: snapShot['datePublished'],
      profImage: snapShot['profImage'],
      postUrl: snapShot['postUrl'],
      likes: snapShot['likes'],
    );
  }
}
