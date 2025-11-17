class LatLngPoint {
  final double lat;
  final double lng;
  final DateTime timestamp;
  LatLngPoint({required this.lat, required this.lng, required this.timestamp});
}

class Territory {
  final String id;
  final String userId;
  final DateTime createdAt;
  final double distanceMeters;
  final double? areaSqMeters;
  final List<LatLngPoint> points;
  final String? polylineEncoded;

  Territory({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.distanceMeters,
    this.areaSqMeters,
    required this.points,
    this.polylineEncoded,
  });
}