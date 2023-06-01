import 'package:flutter/cupertino.dart';
import '../model/user.dart';
import '../resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
   User? _user;

  User? get getUser => _user;

  Future<void> fetchUserData() async {
    try {
      _user = await _authMethods.getUserDetail();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
