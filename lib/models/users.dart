import 'dart:typed_data';

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
}
