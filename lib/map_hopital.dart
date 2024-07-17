import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  void ViewAllPrestataire(List<Map<String, dynamic>> data) {
    setState(() {
      markers = data.map((prestataire) {
        double latitude = double.tryParse(prestataire['latitude']) ?? 0.0;
        double longitude = double.tryParse(prestataire['longitude']) ?? 0.0;
        if (latitude != 0.0 && longitude != 0.0) {
          return Marker(
            markerId: MarkerId(prestataire['id'].toString()),
            position: LatLng(latitude, longitude),
            onTap: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text(prestataire['libelle']),
                          SizedBox(
                            width: 50,
                            child: Row(
                              children: [
                                AutoSizeText(
                                  prestataire['latitude'],
                                  maxLines: 1,
                                  minFontSize: 6,
                                  softWrap: true,
                                  style: TextStyle(fontSize: 10),
                                ),
                                AutoSizeText(
                                  prestataire['longitude'],
                                  maxLines: 1,
                                  minFontSize: 6,
                                  softWrap: true,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          )
                        ],
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
                                  )));
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
            markerId: MarkerId(prestataire['id'].toString()),
            position: const LatLng(0.0, 0.0),
            infoWindow: InfoWindow(
              title: prestataire['libelle'],
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
    ViewAllPrestataire(data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Réseau de data ",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            child: const Icon(
              Icons.gps_fixed,
              size: 28,
              color: Colors.orange,
            ),
            onTap: () {
              getCurrentLocation();
            },
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            buildGoogleMap(context),
          ],
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
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
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
