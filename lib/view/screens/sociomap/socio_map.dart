import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../../../core/model/user.dart' as model;
import '../../../utils/global_variables.dart';
import '../../../core/core.dart';

// ignore: must_be_immutable
class SocioMap extends StatelessWidget {
  SocioMap({Key? key, required this.uid}) : super(key: key);

  final String uid;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  final SocioMapController _socioMapController = Get.put(SocioMapController());

  LocationData? _currentLocation;

  double? latitude;

  double? longitude;

  /// for getting the users current location to show in map
  Future<void> getLocation() async {
    _socioMapController.setIsLoading(true);

    Location location = Location();
    _currentLocation = await location.getLocation();

    final userLocationData = {
      'latitude': _currentLocation!.latitude,
      'longitude': _currentLocation!.longitude,
    };
    await _fireStore.collection('users').doc(uid).set(userLocationData, SetOptions(merge: true));
    _socioMapController.setIsLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLocation();
    });
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              return Obx(() {
                if (_socioMapController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final userLocations = snapshot.data!.docs.map((doc) {
                      final data = doc.data();
                      final username = data['userName'] ?? user!.userName;
                      final double latitude = data['latitude'] ?? 37.33180957;
                      final double longitude = data['longitude'] ?? -122.03053391;
                      final location = LatLng(latitude, longitude);
                      final photoUrl = data['photoUrl'] ?? user!.photoUrl;
                      return UserLocation(
                        username: username as String,
                        location: location,
                        photoUrl: photoUrl as String,
                      );
                    }).toList();
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: calculateHorizontalPadding(context)),
                      width: double.infinity,
                      child: FlutterMap(
                        options: MapOptions(
                            minZoom: 5,
                            maxZoom: 18,
                            zoom: 13,
                            center: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!)),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://api.mapbox.com/styles/v1/parthakbari/clhudsgzo003p01pibu0r55cy/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicGFydGhha2JhcmkiLCJhIjoiY2xodTMwaWJwMG5tNjNlcDVrMnM0ZmNyeiJ9.1hkpsINUNOi_KEbN2VUkGA",
                            additionalOptions: const {
                              'mapStyleId': AppConstants.mapBoxStyleId,
                              'accessToken': AppConstants.mapBoxAccessToken,
                            },
                          ),
                          MarkerLayer(
                            markers: userLocations.map((userLocation) {
                              return Marker(
                                width: Get.width,
                                height: 60,
                                point: userLocation.location,
                                builder: (context) {
                                  return Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(userLocation.photoUrl),
                                      ),
                                      Text(
                                        userLocation.username,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }
                }
              });
            }),
      ),
    );
  }
}
