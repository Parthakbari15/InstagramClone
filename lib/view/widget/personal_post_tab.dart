import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/view/view.dart';
import 'package:flutter/material.dart';

class PersonalPostTab extends StatelessWidget {
  final String uid;
  final int postLen;

  const PersonalPostTab({Key? key, required this.uid, required this.postLen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (postLen > 0)
        ? FutureBuilder(
            future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                  return GestureDetector(
                    onTap: () => context.push('/PostDetailedView/${snap['postId']}'),
                    child: Image(
                      image: NetworkImage(snap['photoUrl']),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animation/nophotosuploaded.json',
                  repeat: false,
                ),
                const Text(
                  'No post yet',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )
              ],
            ),
          );
  }
}
