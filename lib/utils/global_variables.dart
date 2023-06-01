import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// for differentiating webView and mobileView
const webScreenSize = 600;

/// apps  constant
class AppConstants {
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoicGFydGhha2JhcmkiLCJhIjoiY2xodTMzdGh6MDJ1cDNrbWJuMHJma3JyciJ9.gySDtABkG-ohC-CkqFRy-Q';

  static const String mapBoxStyleId =
      'https://api.mapbox.com/styles/v1/parthakbari/clhu35gtg003001pig9cbfo66/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicGFydGhha2JhcmkiLCJhIjoiY2xodTMwaWJwMG5tNjNlcDVrMnM0ZmNyeiJ9.1hkpsINUNOi_KEbN2VUkGA';

  static final myLocation = LatLng(51.5090214, -0.1982948);
}

///for showing webView and MobileView based on webScreenSize

double calculateHorizontalPadding(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth > webScreenSize) {
    return screenWidth / 4;
  } else {
    return 0.0;
  }
}
