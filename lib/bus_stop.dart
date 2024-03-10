class BusStop {
  final int id;
  final String name;
  final List<double> position;

  BusStop({
    required this.id,
    required this.name,
    required this.position,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      id: json['id'],
      name: json['name'],
      position: List<double>.from(json['position']),
    );
  }
}
