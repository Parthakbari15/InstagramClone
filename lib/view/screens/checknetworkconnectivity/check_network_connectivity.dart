import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:instagram_clone/view/view.dart';
import 'package:flutter/material.dart';

class ConnectivityCheck extends StatefulWidget {
  const ConnectivityCheck({super.key});

  @override
  State<ConnectivityCheck> createState() => _ConnectivityCheckState();
}

class _ConnectivityCheckState extends State<ConnectivityCheck> {
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  bool hasInternet = false;

  @override
  void initState() {
    super.initState();
    startMonitoringConnectivity();
  }

  @override
  void dispose() {
    stopMonitoringConnectivity();
    super.dispose();
  }

  void startMonitoringConnectivity() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((connectivityResult) {
      setState(() {
        hasInternet = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);
      });
    });
  }

  void stopMonitoringConnectivity() {
    connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final connectivityResult = snapshot.data!;
          hasInternet = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);
        }

        return hasInternet ? const MainScreen() : _buildNoInternetScreen();
      },
    );
  }

  Widget _buildNoInternetScreen() {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/animation/nointernet.json'),
      ),
    );
  }
}
