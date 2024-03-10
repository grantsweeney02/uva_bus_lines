import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bus_line.dart';
import 'bus_route_service.dart';
import 'bus_stop.dart';


void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final apiKey = await loadApiKey();
  // const platform = MethodChannel('com.example.uva_bus_lines/channel');
  // platform.invokeMethod('setMapsApiKey', apiKey);

  runApp(const MyApp());
}

Future<String> loadApiKey() async {
  final jsonString = await rootBundle.loadString('api/api_keys.json');
  final Map<String, dynamic> jsonMap = json.decode(jsonString);
  return jsonMap['MAPS_KEY'];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BusLinesScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
class BusLinesScreen extends StatefulWidget {
  const BusLinesScreen({super.key});

  @override
  State<BusLinesScreen> createState() => _BusLinesScreenState();
}

class _BusLinesScreenState extends State<BusLinesScreen> {
  List<BusLine> busLines = [];
  List<BusStop> busStops = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Lines and Stops")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _fetchBusLines,
            child: const Text('Fetch Bus Lines'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: busLines.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(busLines[index].longName),
                  onTap: () => _fetchStopsForLine(busLines[index].id),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: busStops.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(busStops[index].name),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _fetchBusLines() async {
    final lines = await fetchBusLines();
    print(lines);
    setState(() {
      busLines = lines;
    });
  }

  void _fetchStopsForLine(int lineId) async {
    final stops = await fetchStopsForLine(lineId);
    setState(() {
      busStops = stops;
    });
  }
}

