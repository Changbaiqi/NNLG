/* FileName WaterFavoriteDao
 *
 * @Description 饮水机收藏表DAO
 */
import 'package:floor/floor.dart';

import 'entity/WaterFavoriteEntity.dart';

@dao
abstract class WaterFavoriteDao {
  @Query(
      'SELECT * FROM WaterFavoriteEntity ORDER BY sortOrder ASC, id ASC')
  Future<List<WaterFavoriteEntity>> findAll();

  @Query(
      'SELECT * FROM WaterFavoriteEntity WHERE hotDeviceId= :hotDeviceId AND coldDeviceId= :coldDeviceId LIMIT 1')
  Future<WaterFavoriteEntity?> findByDevice(
      String hotDeviceId, String coldDeviceId);

  @insert
  Future<int> insertFavorite(WaterFavoriteEntity entity);

  @insert
  Future<List<int>> insertFavorites(List<WaterFavoriteEntity> entities);

  @update
  Future<int> updateFavorite(WaterFavoriteEntity entity);

  @update
  Future<void> updateFavorites(List<WaterFavoriteEntity> entities);

  @delete
  Future<int> deleteFavorite(WaterFavoriteEntity entity);

  @Query('DELETE FROM WaterFavoriteEntity')
  Future<void> clearAll();
}
