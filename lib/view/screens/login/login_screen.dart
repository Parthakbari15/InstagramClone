import 'package:go_router/go_router.dart';
import '../../view.dart';
import '../../../core/core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static final LoginController _loginController = Get.put(LoginController());

  ///On Login Button Press
  void login(BuildContext context) async {
    _loginController.setLoadingValues(true);

    String result = await AuthMethods()
        .loginUser(email: _loginController.emailController.value.text, password: _loginController.passController.value.text);
    _loginController.setLoadingValues(false);

    if (result != 'Login Successfully') {
      // ignore: use_build_context_synchronously
      showSnackbar(result, context);
    } else {
      // ignore: use_build_context_synchronously
      context.go('/MainScreen');
      // ignore: use_build_context_synchronously
      showSnackbar('SignIn Successfully ', context);
    }
  }

  /// on signup button press
  void navigateToSignUp(BuildContext context) {
    context.go('/SignUpScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              ///svg image
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: mobileBackgroundColor,
                  height: 64,
                ),
              ),

              /// textField input for username
              TextFieldInput(
                  textEditingController: _loginController.emailController.value,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Enter Email',
                  isPass: false),

              /// textField input for password
              TextFieldInput(
                  textEditingController: _loginController.passController.value,
                  textInputType: TextInputType.visiblePassword,
                  hintText: 'Enter Password',
                  isPass: true),

              ///login button
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: InkWell(
                  onTap: () => login(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: senderMsgBubbleColor,
                    ),
                    child: _loginController.isLoading.value
                        ? const Center(
                            child: SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                )))
                        : const Text(
                            'Login',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
                          ),
                  ),
                ),
              ),
              const Spacer(),

              ///to show don't have an account
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () => navigateToSignUp(context),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold, color: senderMsgBubbleColor, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
