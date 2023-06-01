// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
class UserLocation {
  final String username;
  final String photoUrl;
  final LatLng location;

  UserLocation({
    required this.username,
    required this.photoUrl,
    required this.location,
  });
}
