import '../../domain/territory_entity.dart';
import '../../domain/territory_repository.dart';
import '../data_source/territory_data_source.dart';
import '../models/territory.dart';

class TerritoryRepositoryImpl implements TerritoryRepository {
  final FirebaseTerritoryDatasource datasource;
  TerritoryRepositoryImpl(this.datasource);

  @override
  Future<void> saveTerritory(Territory territory) async {
    final dto = TerritoryDTO.fromDomain(territory);
    await datasource.save(dto.id, dto.toMap());
  }

  @override
  Future<List<Territory>> getUserTerritories(String userId) async {

    final maps = await datasource.fetchUserTerritories(userId);

    return maps
        .map((m) => TerritoryDTO(
      id: m['id'],
      userId: m['userId'],
      createdAtMillis: m['createdAt'],
      distanceMeters: (m['distanceMeters'] as num).toDouble(),
      areaSqMeters: m['areaSqMeters'] != null
          ? (m['areaSqMeters'] as num).toDouble()
          : null,
      points: (m['points'] as List).cast<Map<String, dynamic>>(),
    ).toDomain())
        .toList();
  }

  @override
  Future<Territory?> getTerritoryById(String id) async {
    final m = await datasource.getById(id);
    if (m == null) return null;
    return TerritoryDTO(
      id: m['id'],
      userId: m['userId'],
      createdAtMillis: m['createdAt'],
      distanceMeters: (m['distanceMeters'] as num).toDouble(),
      areaSqMeters: m['areaSqMeters'] != null ? (m['areaSqMeters'] as num).toDouble() : null,
      points: (m['points'] as List).cast<Map<String, dynamic>>(),
    ).toDomain();
  }
}