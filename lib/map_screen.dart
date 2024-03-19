import 'dart:ffi';

import 'package:flutter/material.dart';
import 'bus_route_service.dart';
import 'package:location/location.dart';
import 'bus_line.dart';
import 'bus_stop.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final BusLine selectedBusLine;

  const MapScreen({super.key, required this.selectedBusLine});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final BusLine selectedBusLine;
  late LatLngBounds mapBounds;
  late LatLng center;
  late List<BusStop> stops = [];
  late List<Marker> markers = [];
  Location location = Location();

  @override
  void initState() {
    super.initState();
    selectedBusLine = widget.selectedBusLine;
    double south = widget.selectedBusLine.bounds[0];
    double west = widget.selectedBusLine.bounds[1];
    double north = widget.selectedBusLine.bounds[2];
    double east = widget.selectedBusLine.bounds[3];
    mapBounds = LatLngBounds(LatLng(south, west), LatLng(north, east));
    center = LatLng(
      (south + north) / 2,
      (west + east) / 2,
    );
    _createMarkers();
    _getUserLocation();
  }

  void _getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    print("Looking at permissions");

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    print("Getting location");
    locationData = await location.getLocation();
    print('User Location: ${locationData.latitude}, ${locationData.longitude}');
  }



  void _createMarkers() async {
    List<BusStop> fetchedStops = await fetchStopsForLine(selectedBusLine.id);
    setState(() {
      stops = fetchedStops;
    });
    setState(() {
      markers = stops.map((stop) =>
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(stop.position[0], stop.position[1]),
            child: IconButton(
              icon: const Icon(Icons.location_on),
              color: Colors.red,
              onPressed: () => _onMarkerPressed(stop.name),
            ),
          )).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedBusLine.longName,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: const Color.fromRGBO(20, 33, 61, 1.0),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }

  void _onMarkerPressed(String stopName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bus Stop'),
          content: Text(stopName),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
