import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hopitalmap/map_hopital.dart';
import 'package:hopitalmap/pages/geo/google_places_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CentresListPage_map extends StatefulWidget {
  @override
  _CentresListPageState createState() => _CentresListPageState();
}

class _CentresListPageState extends State<CentresListPage_map> {
  final GooglePlacesService _placesService = GooglePlacesService();
  List<Map<String, dynamic>> places = [];
  Position? currentPosition;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentPosition = position;
        print("Current Position: $currentPosition");
      });
      _getNearbyPlaces(position.latitude, position.longitude);
    }).catchError((e) {
      print("Error getting current location: $e");
    });
  }

  Future<void> _getNearbyPlaces(double latitude, double longitude) async {
    try {
      final results =
          await _placesService.getNearbyPlaces(latitude, longitude, 'hospital');
      print('API Results: $results');
      setState(() {
        places = results;
        isLoading = false;
      });
    } catch (e) {
      print("Error getting nearby places: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centres de Santé'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : places.isEmpty
              ? Center(child: Text('Aucun centre de santé trouvé'))
              : ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    double distance = currentPosition != null
                        ? Geolocator.distanceBetween(
                            currentPosition!.latitude,
                            currentPosition!.longitude,
                            place['geometry']['location']['lat'],
                            place['geometry']['location']['lng'],
                          )
                        : 0.0;

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(place['name']),
                        subtitle:
                            Text('Distance: ${distance.toStringAsFixed(2)} m'),
                        trailing: IconButton(
                          icon: Icon(Icons.map),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapHopital(
                                  initialPosition: LatLng(
                                    place['geometry']['location']['lat'],
                                    place['geometry']['location']['lng'],
                                  ),
                                  places: places,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
