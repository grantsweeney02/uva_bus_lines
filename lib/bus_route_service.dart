import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bus_line.dart';
import 'bus_stop.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String busDataUrl = 'https://www.cs.virginia.edu/~pm8fc/busses/busses.json';

Future<List<BusLine>> fetchBusLines() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http.get(Uri.parse(busDataUrl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<dynamic> linesJson = decodedData['lines'];
    List<BusLine> busLines = linesJson.map((json) => BusLine.fromJson(json)).toList();

   for (BusLine line in busLines) {
      line.isFavorite = prefs.getBool('bus_line_${line.id}') ?? false;
    }

    busLines.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return a.longName.compareTo(b.longName);
    });

    return busLines;
  } else {
    throw Exception('Failed to load bus lines');
  }
}

Future<List<BusStop>> fetchStopsForLine(int lineId) async {
  final response = await http.get(Uri.parse(busDataUrl));

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

Future<void> saveFavoriteStatus(BusLine busLine) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('bus_line_${busLine.id}', busLine.isFavorite);
}

Future<void> loadFavoriteStatus(BusLine busLine) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  busLine.isFavorite = prefs.getBool('bus_line_${busLine.id}') ?? false;
}