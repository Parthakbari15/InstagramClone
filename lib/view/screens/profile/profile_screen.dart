import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../view.dart';
import '../../../core/core.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  final String uid;

  ProfileScreen({Key? key, required this.uid}) : super(key: key) {
    getData();
  }

  final ProfileController _profileController = Get.put(ProfileController());

  ///fetch the userdata to show in profile based on particular uid
  getData() async {
    _profileController.setLoadingValues(false);

    try {
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      // get post length
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: uid).get();

      _profileController.updatePostLen(postSnap.docs.length);
      _profileController.updateUserData(userSnap.data()!);
      _profileController.updateFollowers(userSnap.data()!['followers'].length);
      _profileController.updateFollowing(userSnap.data()!['following'].length);
      _profileController.checkWhetherIsFollowing(userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid));
    } catch (e) {
      debugPrint(e.toString());
    }
    _profileController.setLoadingValues(true);
  }

  /// when menu button  press then this method will be call
  onMenuPress(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
            width: double.infinity,
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 2,
                      width: 50,
                      decoration:
                          const BoxDecoration(color: mobileBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
                    ),
                    const Divider(
                      color: mobileBackgroundColor,
                    ),
                    ListTile(
                      onTap: () {
                        showMyDialog(context);
                      },
                      leading: const Icon(
                        Icons.logout,
                        color: mobileBackgroundColor,
                      ),
                      title: const Text('SignOut'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  ///to show bottomSheet that include option to upload socialMedia  activities
  showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Container(
          padding:EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
          width: double.infinity,
          child: SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 2,
                    width: 50,
                    decoration:
                        const BoxDecoration(color: mobileBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
                    child: Text(
                      'Create',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(color: mobileBackgroundColor),
                  ListTile(
                    onTap: () {},
                    leading: Image.asset('assets/images/reel.png', height: 30, color: mobileBackgroundColor),
                    title: const Text('Reel'),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Image.asset('assets/images/post.png', height: 30, color: mobileBackgroundColor),
                    title: const Text('Post'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
      width: double.infinity,
      child: _profileController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              body: SafeArea(
                child: NestedScrollView(
                  physics: const BouncingScrollPhysics(),
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        backgroundColor: scaffoldBackgroundColor,
                        expandedHeight: 325,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Padding(
                            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// appbar with username and some other options
                                Row(
                                  children: [
                                    Text(
                                      _profileController.userData['userName'],
                                      style: const TextStyle(
                                          color: mobileBackgroundColor, fontWeight: FontWeight.bold, fontSize: 25),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () => showBottomSheet(context), icon: const Icon(Icons.add_box_outlined)),
                                    IconButton(onPressed: () => onMenuPress(context), icon: const Icon(Icons.menu)),
                                  ],
                                ),
                                const Divider(color: secondaryColor),

                                ///Post, followers, following count
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    CircleAvatar(
                                        backgroundImage: NetworkImage(_profileController.userData['photoUrl']), maxRadius: 40),
                                    PostFollowerFollowingStatus(
                                        title: 'Posts', values: _profileController.postLen.value, onPressed: () => () {}),
                                    PostFollowerFollowingStatus(
                                      title: 'Followers',
                                      values: _profileController.followers.value,
                                      onPressed: () => context.pushNamed('FollowersAndFollowingList', queryParameters: {
                                        'userName': _profileController.userData['userName'],
                                        'uid': uid,
                                        'currentTabIndex': '0'
                                      }),
                                    ),
                                    PostFollowerFollowingStatus(
                                      title: 'Following',
                                      values: _profileController.following.value,
                                      onPressed: () => context.pushNamed('FollowersAndFollowingList', queryParameters: {
                                        'userName': _profileController.userData['userName'],
                                        'uid': uid,
                                        'currentTabIndex': '1'
                                      }),
                                    ),
                                  ]),
                                ),

                                ///Bio
                                Text(
                                  '${_profileController.userData['bio']}  \n........\n.......\n........\n........\n........',
                                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                                ),

                                ///edit profile or share profile

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    EditShareProfileButton(
                                      onPressed: () => context.pushNamed('UpdateProfile', queryParameters: {
                                        'photoUrl': _profileController.userData['photoUrl'],
                                        'uid': _profileController.userData['uid'],
                                        'userName': _profileController.userData['userName'],
                                        'bio': _profileController.userData['bio']
                                      }),
                                      btnTitle: 'Edit Profile',
                                    ),
                                    EditShareProfileButton(
                                      onPressed: () {},
                                      btnTitle: 'Share Profile',
                                    ),
                                    Container(
                                        height:MediaQuery.of(context).size.height * 0.05,
                                        decoration: BoxDecoration(
                                          color: darkGray,
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.add_reaction_outlined,
                                            color: primaryColor,
                                            size: 20,
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  scrollDirection: Axis.vertical,

                  /// tab controller to show post, reels and tagged post
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
                              PersonalPostTab(
                                uid: uid,
                                postLen: _profileController.postLen.value,
                              ),
                              const MyReelsTab(),
                              const TaggedMeTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
