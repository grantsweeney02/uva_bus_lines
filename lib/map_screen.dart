import 'package:flutter/material.dart';
import 'bus_route_service.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bus Lines",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: const Color.fromRGBO(20, 33, 61, 1.0),
      ),
      body: const Column(
        children: [
          Expanded(
            child:
              Text("Map"),
                ),
          ],
      ),
    );
  }
}