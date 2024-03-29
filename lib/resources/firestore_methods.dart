import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post

  Future<String> uploadPost(
    String description,
    String uid,
    Uint8List file,
    String username,
    String profImage,
  ) async {
    String res = 'Some error Occured';
    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        username: username,
        uid: uid,
        postId: postId,
        datePublished: DateTime.now(),
        profImage: profImage,
        postUrl: postUrl,
        likes: [],
      );

      await _firestore.collection('post').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('post')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'text': text,
          'uid': uid,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //delete post
  Future<void> DeletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('post').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}

// updating followers

Future<void> FollowUser(String uid, String followId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
        
    List following = snap.data()!['following'];
    
    if (following.contains(followId)) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(followId)
          .update({
        'followers': FieldValue.arrayRemove([uid]),
      });

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'following': FieldValue.arrayRemove([followId]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(followId)
          .update({
        'followers': FieldValue.arrayUnion([uid]),
      });

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'following': FieldValue.arrayUnion([followId]),
      });
    }
  } catch (e) {
    print(e.toString());
  }
}
