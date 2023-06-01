import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TaggedMeTab extends StatelessWidget {
  const TaggedMeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
    ));
  }
}
