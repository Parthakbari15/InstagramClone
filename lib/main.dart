import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/routes/routes.dart';
import './view/view.dart';
import './core/core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAwgLy72bfxyOAtPQSomBJi_z0coDhBha4",
            appId: "1:115403219546:web:c9eebe75863d9127f96e63",
            messagingSenderId: "115403219546",
            storageBucket: "instagram-clone-2701d.appspot.com",
            projectId: "instagram-clone-2701d"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Instagram',
        theme: ThemeData.light().copyWith(scaffoldBackgroundColor:primaryColor),

      ),
    );
  }
}

