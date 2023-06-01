import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../view.dart';
import '../../../core/core.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  ///fetch current user's photo to show in bottomNavigationBar
  Future<void> fetchData(BuildContext context) async {
    try {
      // Fetch the current user's data from Firebase Auth and FireStore
      Future.delayed(const Duration(seconds: 3), () {
        AuthMethods().getUserDetail();
        FirebaseAuth.instance.authStateChanges();
        // Navigate to the next screen
        MediaQuery.of(context).size.width > webScreenSize ? context.go('/MainScreen') : context.go('/ConnectivityCheck');
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData(context);
    });
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
                child: Image.asset(
              'assets/images/instalogo-removebg-preview.png',
              alignment: Alignment.center,
              height: 200,
            )),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [purpleLinear1, purpleLinear2, purpleLinear3],
                  ).createShader(bounds);
                },
                child: SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: Colors.pink,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
