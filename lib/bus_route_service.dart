import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bus_line.dart';
import 'bus_stop.dart';

Future<List<BusLine>> fetchBusLines() async {
  const String url = 'https://www.cs.virginia.edu/~pm8fc/busses/busses.json';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<dynamic> linesJson = decodedData['lines'];
    return linesJson.map((json) => BusLine.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load bus lines');
  }
}

Future<List<BusStop>> fetchStopsForLine(int lineId) async {
  const String url = 'https://www.cs.virginia.edu/~pm8fc/busses/busses.json';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<dynamic> routesJson = decodedData['routes'];
    final List<dynamic> stopsJson = decodedData['stops'];

    final route = routesJson.firstWhere((route) => route['id'] == lineId, orElse: () => null);
    if (route == null) return [];

    final List<int> stopIds = List<int>.from(route['stops']);

    List<BusStop> stops = stopsJson.where((stop) => stopIds.contains(stop['id'])).map((json) => BusStop.fromJson(json)).toList();
    return stops;
  } else {
    throw Exception('Failed to load stops for line $lineId');
  }
}