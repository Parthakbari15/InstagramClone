import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String userName;
  final String bio;
  final String uid;
  final String photoUrl;
  final List followers;
  final List following;

  const User(
      {required this.email,
      required this.userName,
      required this.bio,
      required this.uid,
      required this.photoUrl,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJason() => {
        'email': email,
        'userName': userName,
        'bio': bio,
        'uid': uid,
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return User(
      email: snap['email'],
      userName: snap['userName'],
      bio: snap['bio'],
      uid: snap['uid'],
      photoUrl: snap['photoUrl'],
      followers: snap['followers'],
      following: snap['following'],
    );
  }
}
