import 'territory_entity.dart';

abstract class TerritoryRepository {
  Future<void> saveTerritory(Territory territory);
  Future<List<Territory>> getUserTerritories(String userId);
  Future<Territory?> getTerritoryById(String id);
}
