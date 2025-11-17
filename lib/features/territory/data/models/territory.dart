import '../../domain/territory_entity.dart';

class TerritoryDTO {
  final String id;
  final String userId;
  final int createdAtMillis;
  final double distanceMeters;
  final double? areaSqMeters;
  final List<Map<String, dynamic>> points;

  TerritoryDTO({
    required this.id,
    required this.userId,
    required this.createdAtMillis,
    required this.distanceMeters,
    this.areaSqMeters,
    required this.points,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'createdAt': createdAtMillis,
    'distanceMeters': distanceMeters,
    'areaSqMeters': areaSqMeters,
    'points': points,
  };

  factory TerritoryDTO.fromDomain(Territory t) {
    return TerritoryDTO(
      id: t.id,
      userId: t.userId,
      createdAtMillis: t.createdAt.millisecondsSinceEpoch,
      distanceMeters: t.distanceMeters,
      areaSqMeters: t.areaSqMeters,
      points: t.points
          .map((p) => {
        'lat': p.lat,
        'lng': p.lng,
        'timestamp': p.timestamp.millisecondsSinceEpoch,
      })
          .toList(),
    );
  }

  Territory toDomain() {
    return Territory(
      id: id,
      userId: userId,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
      distanceMeters: distanceMeters,
      areaSqMeters: areaSqMeters,
      points: points
          .map((m) => LatLngPoint(
        lat: (m['lat'] as num).toDouble(),
        lng: (m['lng'] as num).toDouble(),
        timestamp: DateTime.fromMillisecondsSinceEpoch(m['timestamp'] as int),
      ))
          .toList(),
      polylineEncoded: null,
    );
  }
}