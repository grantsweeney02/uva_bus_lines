import 'package:flutter/material.dart';
import 'bus_line.dart';
import 'bus_route_service.dart';
import 'package:location/location.dart';
import 'map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var location = Location();

  var hasPermission = await location.hasPermission();
  if (hasPermission == PermissionStatus.denied) {
    hasPermission = await location.requestPermission();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the background color of the app
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(229, 229, 229, 1.0),
      ),
      home: const BusLinesScreen(),
    );
  }
}

class BusLinesScreen extends StatefulWidget {
  const BusLinesScreen({super.key});

  @override
  State<BusLinesScreen> createState() => _BusLinesScreenState();
}

class _BusLinesScreenState extends State<BusLinesScreen> {
  List<BusLine> busLines = [];

  @override
  void initState() {
    super.initState();
    _fetchBusLines();
  }

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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: busLines.length,
              itemBuilder: (context, index) {
                final busLine = busLines[index];
                return ListTile(
                  title: Text(
                    busLine.longName,
                    style: TextStyle(
                      color: busLine.textColor.toUpperCase() == 'FFFFFF'
                          ? Colors.black
                          : Color(int.parse('0xff${busLine.textColor}')),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      busLine.isFavorite ? Icons.star : Icons.star_border,
                      color: busLine.isFavorite ? Colors.amber : null,
                    ),
                    onPressed: () {
                      setState(() {
                        _toggleFavorite(busLine);
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(selectedBusLine: busLine),
                      ),
                    );},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _fetchBusLines() async {
    final lines = await fetchBusLines();
    setState(() {
      busLines = lines;
      for (var line in busLines) {
        loadFavoriteStatus(line);
      }
      _sortBusLines(busLines);
    });
  }

  void _toggleFavorite(BusLine busLine) {
    busLine.toggleFavorite();
    saveFavoriteStatus(busLine);
    _sortBusLines(busLines);
  }

  void _sortBusLines(List<BusLine> lines) {
    lines.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) {
        return -1;
      } else if (!a.isFavorite && b.isFavorite) {
        return 1;
      } else {
        return a.longName.compareTo(b.longName);
      }
    });
  }
}
