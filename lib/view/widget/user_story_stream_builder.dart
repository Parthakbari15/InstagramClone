import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/view/view.dart';
import 'package:flutter/material.dart';

class UserStoryStreamBuilder extends StatelessWidget {
  const UserStoryStreamBuilder({
    super.key,
  });

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String _user = _auth.currentUser!.uid;
  static List<QueryDocumentSnapshot<Map<String, dynamic>>>? userStories;
  static int? currentUserIndex;

  static Map<String, dynamic>? currentUserStory;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            // check for null here
            return const Center(
              child: Text('No data available.'),
            );
          } else {
            userStories = snapshot.data!.docs;
            currentUserIndex = userStories!.indexWhere((doc) => doc.id == _user);
            currentUserStory = userStories![currentUserIndex!].data();
            userStories!.removeAt(currentUserIndex!);
            userStories!.insert(0, snapshot.data!.docs[currentUserIndex!]);


            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: userStories!.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return UserStory(snap: currentUserStory);
                } else {
                  return UserStory(snap: userStories![index].data());
                }
              },
            );
          }
        },
      ),
    );
  }
}
