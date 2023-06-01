import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/view/view.dart';
import 'package:flutter/material.dart';
class PostDetailedView extends StatelessWidget {
  const PostDetailedView({Key? key, required this.postId}) : super(key: key);
  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
          width: double.infinity,
          child: AppBar(
            backgroundColor: scaffoldBackgroundColor,
            elevation: 0,
            title: Text(
              'Posts',
              style: TextStyles.h2Bold.copyWith(color: mobileBackgroundColor),
            ),
            centerTitle: false,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                CupertinoIcons.left_chevron,
                color: mobileBackgroundColor,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: StreamBuilder<List<QueryDocumentSnapshot>>(
                  stream: getPostAsStream(postId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    List<QueryDocumentSnapshot> postDocs = snapshot.data!;
                    QueryDocumentSnapshot postDoc = postDocs[0]; // Get the first document in the list
                    Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>; // Get the data as a Map
                    return PostCard(snap: postData);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// get all post as a stream that match postId
Stream<List<QueryDocumentSnapshot>> getPostAsStream(String postId) {
  return FirebaseFirestore.instance
      .collection('posts')
      .where('postId', isEqualTo: postId)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs);
}
