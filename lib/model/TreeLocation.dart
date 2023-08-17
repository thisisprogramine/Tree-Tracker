
class PlantLocation {
  final List<Location>? locations;

  PlantLocation({
    this.locations,
  });

  factory PlantLocation.fromJson(Map<String, dynamic> json) => PlantLocation(
    locations: json["locations"] == null ? [] : List<Location>.from(json["locations"]!.map((x) => Location.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "locations": locations == null ? [] : List<dynamic>.from(locations!.map((x) => x.toJson())),
  };
}

class Location {
  final double? latitude;
  final double? longitude;

  Location({
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}
