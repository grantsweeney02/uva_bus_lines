import 'package:flutter/material.dart';
import 'bus_route_service.dart';
import 'package:location/location.dart';
import 'bus_line.dart';
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
          minZoom: 10.0,
          maxZoom: 18.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          // const RichAttributionWidget(
          //   attributions: [
          //     TextSourceAttribution(
          //       'OpenStreetMap contributors',
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}