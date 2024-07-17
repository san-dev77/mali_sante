import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hopitalmap/detail_hopital.dart';
import 'package:hopitalmap/models/data.dart';

class MapHopital extends StatefulWidget {
  const MapHopital({super.key});

  @override
  State<MapHopital> createState() => _MapHopitalState();
}

class _MapHopitalState extends State<MapHopital> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;

  double zoomVal = 5.0;
  String title = "";
  bool isLoad = false;
  bool search = false;
  bool isDeviceConnected = false;
  var long = "";
  var lat = "";
  String dropdownValue = 'Filtrer par type';
  bool isCliked = false;
  int selectedCard = -1;
  Set<Marker> markers = {};
  String prestatireName = "";
  late Position currentPosition;

  TextEditingController SearchController = TextEditingController();
  bool isLoading = true;

  void viewAllHopital(List<Map<String, dynamic>> data) {
    setState(() {
      markers = data.map((data) {
        double latitude = double.tryParse(data['latitude']) ?? 0.0;
        double longitude = double.tryParse(data['longitude']) ?? 0.0;
        if (latitude != 0.0 && longitude != 0.0) {
          return Marker(
            markerId: MarkerId(data['id'].toString()),
            position: LatLng(latitude, longitude),
            onTap: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
                      width: MediaQuery.of(context).size.width *
                          0.8, // Largeur de la boîte de dialogue
                      child: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            Text(
                              data['libelle'],
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 200, // Largeur de l'image
                              height: 200, // Hauteur de l'image
                              child: Image.asset(
                                data['imagePath'],
                                fit: BoxFit
                                    .cover, // Ajuster l'image pour couvrir le conteneur
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Fermer'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Voir plus'),
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailHopital(
                              data: data,
                            ),
                          ));
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
          );
        } else {
          return Marker(
            markerId: MarkerId(data['id'].toString()),
            position: const LatLng(0.0, 0.0),
            infoWindow: InfoWindow(
              title: data['libelle'],
              snippet: 'Coordonnées non disponibles',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          );
        }
      }).toSet();
    });
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> _verifyInternet() async {
    if (!await hasNetwork()) {
      showDialogBox();
    }
  }

  @override
  void initState() {
    super.initState();
    _verifyInternet();
    getCurrentLocation();
    viewAllHopital(data);
  }

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });
      myLocation(position.latitude, position.longitude, "Vous êtes ici", null);
    }).catchError((e) {});
  }

  Future<void> gotoLocation(
      double latitude, double longitude, String name, data) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }

  void _showHospitalList(List<Map<String, dynamic>> data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                gotoLocation(
                  double.parse(data[index]['latitude']),
                  double.parse(data[index]['longitude']),
                  data[index]['libelle'].toString(),
                  data[index],
                );
              },
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 63, 160, 217),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.medical_services_sharp,
                    color: Colors.white),
              ),
              title: Text(
                data[index]['libelle'].toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailHopital(
                            data: data[index],
                          )));
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Map hopital",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            child: const Icon(
              Icons.gps_fixed,
              size: 28,
              color: Color.fromARGB(255, 63, 160, 217),
            ),
            onTap: () {
              getCurrentLocation();
            },
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: buildGoogleMap(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 63, 160, 217),
        onPressed: () {
          _showHospitalList(data);
        },
        child: const Icon(
          Icons.list,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Pas de connexion Internet'),
          content: const Text(
              'Veuillez vérifier votre connexion Internet et réessayez.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => exit(0),
              child: const Text('Quitter'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _verifyInternet();
                });
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );

  Widget buildGoogleMap(BuildContext context) {
    return SizedBox(
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        zoomControlsEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(12.9715987, 77.5945627),
          zoom: 15,
        ),
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mapController = controller;
        },
      ),
    );
  }

  Future<void> myLocation(double lat, double long, String prestatireName,
      BitmapDescriptor? icon) async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(prestatireName),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(title: prestatireName, snippet: prestatireName),
        icon: icon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    });
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
    )));
  }
}
