class BusLine {
  final int id;
  final List<double> bounds;
  final String color;
  final String longName;
  final String shortName;
  final String textColor;

  BusLine({
    required this.id,
    required this.bounds,
    required this.color,
    required this.longName,
    required this.shortName,
    required this.textColor,
  });

  factory BusLine.fromJson(Map<String, dynamic> json) {
    List<double> defaultBounds = [38.031599, -78.508578, 38.130205, -78.436039];

    return BusLine(
      id: json['id'],
      bounds: json['bounds'] != null ? List<double>.from(json['bounds']) : defaultBounds,
      color: json['color'],
      longName: json['long_name'],
      shortName: json['short_name'],
      textColor: json['text_color'],
    );
  }
}
