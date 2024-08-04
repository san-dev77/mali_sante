import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapHopital extends StatefulWidget {
  final LatLng initialPosition;
  final List<Map<String, dynamic>> places;
  final LatLng currentLocation;

  const MapHopital({
    required this.initialPosition,
    required this.places,
    required this.currentLocation,
    Key? key,
  }) : super(key: key);

  @override
  State<MapHopital> createState() => _MapHopitalState();
}

class _MapHopitalState extends State<MapHopital> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  late Position currentPosition; // Define currentPosition

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _setInitialMarkers();
    _getCurrentLocation(); // Call to initialize currentPosition
  }

  _setInitialMarkers() {
    setState(() {
      markers = widget.places.map((place) {
        double lat = double.tryParse(place['lat']) ?? 0.0;
        double lon = double.tryParse(place['lon']) ?? 0.0;
        String placeId = place['place_id'].toString();
        String displayName = place['display_name'].toString();
        return Marker(
          markerId: MarkerId(placeId.isNotEmpty ? placeId : displayName),
          position: LatLng(lat, lon),
          infoWindow: InfoWindow(
            title: displayName,
            snippet: 'Distance: ${place['distance'].toString()}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
      }).toSet();
    });
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

  Future<void> _getCurrentLocation() async {
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
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map hopital", style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        zoomControlsEnabled: true,
        initialCameraPosition: CameraPosition(
          target: widget.currentLocation,
          zoom: 14,
        ),
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _getCurrentLocation();
        },
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }
}
