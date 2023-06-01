import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/core/controller/search_user_controller.dart';
import '../../../core/resources/auth_methods.dart';
import '../../../core/resources/firestore_methods.dart';
import '../../../view/view.dart';

class SearchedUserProfileScreen extends StatelessWidget {
  final String uid;

  SearchedUserProfileScreen({Key? key, required this.uid}) : super(key: key) {
    getData();
  }

  final SearchUserController _searchUserController = Get.put(SearchUserController());

  getData() async {
    _searchUserController.setLoadingValues(false);
    try {
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // get post length
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: uid).get();

      _searchUserController.updatePostLen(postSnap.docs.length);
      _searchUserController.updateUserData(userSnap.data()!);
      _searchUserController.updateFollowers(userSnap.data()!['followers'].length);
      _searchUserController.updateFollowing(userSnap.data()!['following'].length);
      _searchUserController
          .checkWhetherIsFollowing(userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid));
    } catch (e) {
      debugPrint(e.toString());
    }
    _searchUserController.setLoadingValues(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
      width: double.infinity,
      child: (_searchUserController.isLoading.value)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(body: Obx(
              () {
                return (_searchUserController.userData['userName'] == null)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SafeArea(
                        child: NestedScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          headerSliverBuilder: (context, innerBoxIsScrolled) {
                            return [
                              SliverAppBar(
                                  backgroundColor: scaffoldBackgroundColor,
                                  elevation: 0,
                                  expandedHeight: 352,
                                  centerTitle: false,
                                  leading: IconButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      icon: const Icon(
                                        CupertinoIcons.left_chevron,
                                        color: mobileBackgroundColor,
                                      )),
                                  title: Text(
                                    _searchUserController.userData['userName'],
                                    style: TextStyles.h2Bold.copyWith(color: mobileBackgroundColor),
                                  ),
                                  actions: [
                                    IconButton(onPressed: () => () {}, icon: const Icon(Icons.menu)),
                                  ],
                                  flexibleSpace: Obx(
                                    () => FlexibleSpaceBar(
                                      background: Padding(
                                        padding: const EdgeInsets.only(top: 55.0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Divider(color: secondaryColor),

                                              ///Post, followers, following count
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0),
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  CircleAvatar(
                                                      backgroundImage: NetworkImage(_searchUserController.userData['photoUrl']),
                                                      maxRadius: 40),
                                                  PostFollowerFollowingStatus(
                                                      title: 'Posts',
                                                      values: _searchUserController.postLen.value,
                                                      onPressed: () => () {}),
                                                  PostFollowerFollowingStatus(
                                                    title: 'Followers',
                                                    values: _searchUserController.followers.value,
                                                    onPressed: () => context.pushNamed('FollowersAndFollowingList',
                                                        queryParameters: {
                                                          'userName': _searchUserController.userData['userName'],
                                                          'uid': uid,
                                                          'currentTabIndex': '0'
                                                        }),
                                                  ),
                                                  PostFollowerFollowingStatus(
                                                    title: 'Following',
                                                    values: _searchUserController.following.value,
                                                    onPressed: () => context.pushNamed('FollowersAndFollowingList',
                                                        queryParameters: {
                                                          'userName': _searchUserController.userData['userName'],
                                                          'uid': uid,
                                                          'currentTabIndex': '1'
                                                        }),
                                                  ),
                                                ]),
                                              ),

                                              ///Bio
                                              Text(
                                                '${_searchUserController.userData['bio']}  \n........\n.......\n........\n........\n........',
                                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  FirebaseAuth.instance.currentUser!.uid == uid
                                                      ? FollowButton(
                                                          text: 'Sign Out',
                                                          backgroundColor: mobileBackgroundColor,
                                                          textColor: primaryColor,
                                                          borderColor: mobileBackgroundColor,
                                                          function: () async {
                                                            context.go('/LoginScreen');
                                                            await AuthMethods().signOut();
                                                          },
                                                        )
                                                      : _searchUserController.isFollowing.value
                                                          ? FollowButton(
                                                              text: 'Unfollow',
                                                              backgroundColor: Colors.white,
                                                              textColor: Colors.black,
                                                              borderColor: mobileBackgroundColor,
                                                              function: () async {
                                                                await FireStoreMethods().followUser(
                                                                  FirebaseAuth.instance.currentUser!.uid,
                                                                  _searchUserController.userData['uid'],
                                                                );
                                                                _searchUserController.isFollowing(false);
                                                                _searchUserController.followers.value--;
                                                              },
                                                            )
                                                          : FollowButton(
                                                              text: 'Follow',
                                                              backgroundColor: Colors.blue,
                                                              textColor: Colors.white,
                                                              borderColor: Colors.blue,
                                                              function: () async {
                                                                await FireStoreMethods().followUser(
                                                                  FirebaseAuth.instance.currentUser!.uid,
                                                                  _searchUserController.userData['uid'],
                                                                );
                                                                _searchUserController.isFollowing(true);
                                                                _searchUserController.followers.value++;
                                                              },
                                                            ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ];
                          },
                          body: DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                TabBar(
                                  indicatorColor: mobileBackgroundColor,
                                  tabs: [
                                    Tab(
                                      icon: Image.asset('assets/images/post.png', color: mobileBackgroundColor, width: 24),
                                    ),
                                    Tab(
                                      icon: Image.asset('assets/images/reel.png', color: mobileBackgroundColor, width: 24),
                                    ),
                                    Tab(
                                      icon: Image.asset('assets/images/tagpeople.png', color: mobileBackgroundColor, width: 24),
                                    ),
                                  ],
                                  indicatorSize: TabBarIndicatorSize.tab,
                                ),
                                Expanded(
                                  child: TabBarView(
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      PersonalPostTab(uid: uid, postLen: _searchUserController.postLen.value),
                                      const MyReelsTab(),
                                      const TaggedMeTab(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
              },
            )),
    );
  }
}
