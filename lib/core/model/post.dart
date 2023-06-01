import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String caption;
  final String postId;
  final String userName;
  final String uid;
  final String postUrl;
  final String profImage;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished;
  // ignore: prefer_typing_uninitialized_variables
  final likes;

  const PostModel(
      {required this.caption,
      required this.postId,
      required this.userName,
      required this.uid,
      required this.postUrl,
      required this.profImage,
      required this.datePublished,
      required this.likes});

  Map<String, dynamic> toJason() => {
        'caption': caption,
        'postId': postId,
        'userName': userName,
        'uid': uid,
        'photoUrl': postUrl,
        'profImage': profImage,
        'datePublished': datePublished,
        'likes': likes,
      };

  static PostModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return PostModel(
      caption: snap['caption'],
      postId: snap['postId'],
      userName: snap['userName'],
      uid: snap['uid'],
      postUrl: snap['photoUrl'],
      profImage: snap['profImage'],
      datePublished: snap['datePublished'],
      likes: snap['likes'],
    );
  }
}
