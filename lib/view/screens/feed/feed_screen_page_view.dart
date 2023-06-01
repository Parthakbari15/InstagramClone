import '../../view.dart';
import 'package:flutter/material.dart';
class FeedScreenPageView extends StatelessWidget {
  const FeedScreenPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    int tabIndex = 0;
    return Scaffold(
      body: PageView(
          controller: pageController,
          children: const <Widget>[
            FeedScreen(),
            ChatScreen(),
          ],
          onPageChanged: (int index) => {
                tabIndex = index,
                pageController.animateToPage(tabIndex, duration: const Duration(milliseconds: 450), curve: Curves.easeIn),
              }),
    );
  }
}
