import 'package:flutter/cupertino.dart';
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
  late LatLng center;
  late List<BusStop> stops = [];
  late List<Marker> markers = [];
  Location location = Location();
  late LocationData locationData;
  String? selectedStopName;
  int? selectedStopId;



  @override
  void initState() {
    super.initState();
    selectedBusLine = widget.selectedBusLine;
    double south = widget.selectedBusLine.bounds[0];
    double west = widget.selectedBusLine.bounds[1];
    double north = widget.selectedBusLine.bounds[2];
    double east = widget.selectedBusLine.bounds[3];
    center = LatLng(
      (south + north) / 2,
      (west + east) / 2,
    );
    _createMarkers();
    _getUserLocation();
  }

  void _updateUserLocationMarker() {
    setState(() {
      double? userLatitude = locationData.latitude;
      double? userLongitude = locationData.longitude;
      Color color = Colors.blue;
      if (selectedStopId == -1) {
        color = Colors.purple;
      }

      final userLocationMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(userLatitude!, userLongitude!),
        child: IconButton(
          icon: const Icon(Icons.person_pin_circle),
          color: color,
          onPressed: () {
            setState(() {
              selectedStopId = -1;
              selectedStopName = "Your Location";
              _createMarkers();
            });
          },
        ),
      );
      markers.add(userLocationMarker);
    });
  }

  void _getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
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

    locationData = await location.getLocation();
    _updateUserLocationMarker();
  }

  void _createMarkers() async {
    List<BusStop> fetchedStops = await fetchStopsForLine(selectedBusLine.id);
    setState(() {
      stops = fetchedStops;
    });
    setState(() {
      markers = stops.map((stop) {
        Color color = Colors.red;
        if (selectedStopId == stop.id) {
          color = Colors.purple;
        }

        return Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(stop.position[0], stop.position[1]),
          child: IconButton(
            icon: const Icon(Icons.location_on),
            color: color,
            onPressed: () {
              setState(() {
                selectedStopId = selectedStopId == stop.id ? null : stop.id;
                selectedStopName = stop.name;
              });
              _createMarkers();
            },
          ),
        );
      }).toList();
    });
    _updateUserLocationMarker();
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
      body: Stack(
        children: [
          FlutterMap(
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
          if (selectedStopName != null) Positioned(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                selectedStopName!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
