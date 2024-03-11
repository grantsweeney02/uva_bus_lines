import 'package:flutter/material.dart';
import 'bus_line.dart';
import 'bus_route_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the background color of the app
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black12,
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
            style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black45,
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
                          ? Colors.white
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
                    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => MapScreen(busLine)));
                  },
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
