import 'package:flutter/cupertino.dart';
import '../model/model.dart';
import './resources.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///to upload post
  Future<String> uploadPost(String caption, String uid, String userName, Uint8List file, String profImage) async {
    String result = 'Can\'t post now ';
    try {
      String postUrl = await StorageMethods().uploadImageToStorage('post', file, true);
      String postId = const Uuid().v1();
      PostModel post = PostModel(
          caption: caption.trim(),
          postId: postId,
          userName: userName,
          uid: uid,
          postUrl: postUrl,
          profImage: profImage,
          datePublished: DateTime.now(),
          likes: []);
      await _firestore.collection('posts').doc(post.postId).set(post.toJason());
      result = 'Success';
      return result;
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  /// add likes on post
  Future<void> likePost(String postId, String uid, List likes, bool keepLike) async {
    try {
      if (likes.contains(uid) && !keepLike) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///to do comments on post
  Future<String> postComment(String postId, String text, String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// for deleting comments on post

  Future<String> deleteComments(String postId, String commentId, String uid) async {
    String res = "Some error occurred";
    try {
      DocumentSnapshot<Map<String, dynamic>> commentSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .get();

      if (commentSnapshot.exists && commentSnapshot.data()?['uid'] == uid) {
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).delete();
        res = 'success';
      } else {
        res = 'You are not authorized to delete this comment.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  ///delete chat
  Future<String> deleteChat(String chatId, String pChatId, String sendBy) async {
    String res = "Some error occurred";
    try {
      DocumentSnapshot<Map<String, dynamic>> commentSnapshot = await _firestore
          .collection('ChatRoom')
          .doc(chatId)
          .collection('chats')
          .doc(pChatId)
          .get();

      if (commentSnapshot.exists && commentSnapshot.data()?['sendBy'] == sendBy) {
        await _firestore.collection('ChatRoom').doc(chatId).collection('chats').doc(pChatId).delete();
        res = 'success';
      } else {
        res = 'You are not authorized to delete this comment.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  ///to delete the post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  ///to manage followers
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// for creating chatRoom For Every Users conversation
  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomMap) {
    _firestore.collection('ChatRoom').doc(chatRoomId).set(chatRoomMap).catchError((e) {
      debugPrint(e.toString());
    });
  }

  ///add all the chats into our chat room
  addConversationsMessages(String chatRoomId, Map<String, dynamic> messageMap, String pChatId) {
    _firestore.collection('ChatRoom').doc(chatRoomId).collection('chats').doc(pChatId).set(messageMap).catchError((e)
    // ignore: body_might_complete_normally_catch_error
    {
      debugPrint(e.toString());
    });
  }

  ///get all chats from chatRoom
  getConversationsMessages(String chatRoomId) {
    _firestore.collection('ChatRoom').doc(chatRoomId).collection('chats').snapshots();
  }


}
