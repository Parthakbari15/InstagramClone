import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../view.dart';
import '../../core/core.dart';
import 'package:flutter/material.dart';
import '../../core/model/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    model.User? user = userProvider.getUser;

    return (user == null)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: (value) => onPageChanged(value),
              children: [
                const FeedScreenPageView(),
                SearchScreen(),
                AddPostScreen(),
                SocioMap(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                ),
                ReelsScreen(),
                ProfileScreen(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                ),
              ],
            ),
            bottomNavigationBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: _page == 0 ? purpleLinear3 : mobileBackgroundColor,
                  ),
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: _page == 1 ? purpleLinear3 : mobileBackgroundColor,
                  ),
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle, color: _page == 2 ? purpleLinear3 : mobileBackgroundColor),
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/sociomap.png',
                      color: _page == 3 ? purpleLinear3 : mobileBackgroundColor, width: 24),
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon:
                      Image.asset('assets/images/reel.png', color: _page == 4 ? purpleLinear3 : mobileBackgroundColor, width: 24),
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: CircleAvatar(backgroundImage: NetworkImage(user.photoUrl), radius: 16),
                  backgroundColor: primaryColor,
                ),
              ],
              backgroundColor: Colors.transparent,
              onTap: navigationTapped,
              height: 60,
            ),
          );
  }
}
