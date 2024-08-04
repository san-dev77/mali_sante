import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hopitalmap/map_hopital.dart';
import 'package:hopitalmap/pages/geo/nominatim_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CentresListPage_map extends StatefulWidget {
  @override
  _CentresListPageState createState() => _CentresListPageState();
}

class _CentresListPageState extends State<CentresListPage_map> {
  final NominatimService _placesService = NominatimService();
  List<Map<String, dynamic>> places = [];
  late Position currentPosition;
  bool isLoading = true;
  String selectedType = 'hospital';

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
      });
      _getNearbyPlaces(position.latitude, position.longitude);
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _getNearbyPlaces(double latitude, double longitude) async {
    try {
      final results = await _placesService.getNearbyPlaces(
          latitude, longitude, selectedType);
      setState(() {
        places = results.map((place) {
          double distance = Geolocator.distanceBetween(
            latitude,
            longitude,
            double.parse(place['lat']),
            double.parse(place['lon']),
          );
          place['distance'] = (distance / 1000).toStringAsFixed(2) + ' km';
          return place;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showContactOptions(Map<String, dynamic> place) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.phone, color: Colors.green),
                title: Text('Appeler'),
                onTap: () {
                  // Replace with the actual phone number from your data
                  final phone = place['phone'] ?? '123456789';
                  launch('tel:$phone');
                },
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text('Envoyer un email'),
                onTap: () {
                  // Replace with the actual email from your data
                  final email = place['email'] ?? 'example@example.com';
                  launch('mailto:$email');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    return GestureDetector(
      onTap: () => _showContactOptions(place),
      child: Card(
        color: Colors.white,
        elevation: 5,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place['display_name'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Distance: ${place['distance']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.map, color: Colors.white),
                    label: Text(
                      'Voir sur la carte',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapHopital(
                            initialPosition: LatLng(
                              double.parse(place['lat']),
                              double.parse(place['lon']),
                            ),
                            places: places,
                            currentLocation: LatLng(
                              currentPosition.latitude,
                              currentPosition.longitude,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.directions, color: Colors.white),
                    label: Text(
                      'Se rendre',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _launchMapsUrl(
                        double.parse(place['lat']),
                        double.parse(place['lon']),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTypeChanged(String? type) {
    if (type != null) {
      setState(() {
        selectedType = type;
        isLoading = true;
      });
      _getNearbyPlaces(currentPosition.latitude, currentPosition.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/bg1.jpg', // Image de fond
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3), // Overlay
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      DropdownButton<String>(
                        dropdownColor: Colors.black,
                        value: selectedType,
                        items: [
                          DropdownMenuItem(
                            child: Text('Hôpitaux',
                                style: TextStyle(color: Colors.white)),
                            value: 'hospital',
                          ),
                          DropdownMenuItem(
                            child: Text('Pharmacies',
                                style: TextStyle(color: Colors.white)),
                            value: 'pharmacy',
                          ),
                          DropdownMenuItem(
                            child: Text('Cliniques',
                                style: TextStyle(color: Colors.white)),
                            value: 'clinic',
                          ),
                          DropdownMenuItem(
                            child: Text('CSCOM',
                                style: TextStyle(color: Colors.white)),
                            value: 'cscom',
                          ),
                        ],
                        onChanged: _onTypeChanged,
                        underline: Container(),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.map, color: Colors.white),
                        label: Text(
                          'Mode Carte',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapHopital(
                                initialPosition: LatLng(
                                  currentPosition.latitude,
                                  currentPosition.longitude,
                                ),
                                places: places,
                                currentLocation: LatLng(
                                  currentPosition.latitude,
                                  currentPosition.longitude,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : places.isEmpty
                          ? Center(
                              child: Text('Aucun centre de santé trouvé',
                                  style: TextStyle(color: Colors.white)))
                          : ListView.builder(
                              itemCount: places.length,
                              itemBuilder: (context, index) {
                                final place = places[index];
                                return _buildPlaceCard(place);
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
