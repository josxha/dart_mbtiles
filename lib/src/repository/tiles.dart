import 'dart:typed_data';

import 'package:mbtiles/src/helper/helpers_io.dart'
    if (dart.library.js_interop) 'package:mbtiles/src/helper/helpers_web.dart';
import 'package:sqlite3/common.dart';

class TilesRepository {
  final CommonDatabase database;
  final bool useGzip;

  CommonPreparedStatement? _putTileStmt;

  TilesRepository({required this.database, required this.useGzip});

  Uint8List? getTile(int zoom, int column, int row) {
    final rows = database.select(
      '''
    SELECT tile_data FROM tiles 
    WHERE zoom_level = ? AND tile_column = ? AND tile_row = ?
    LIMIT 1;
    ''',
      [zoom, column, row],
    );
    if (rows.isEmpty) return null;
    final bytes = rows.first['tile_data'] as Uint8List;
    if (!useGzip) return bytes;
    return bytes.gzipDecode();
  }

  void putTile(int zoom, int column, int row, Uint8List bytes) {
    _putTileStmt ??= database.prepare('''
        INSERT OR REPLACE INTO tiles
        (zoom_level, tile_column, tile_row, tile_data) 
        VALUES (?, ?, ?, ?);
        ''', persistent: true);
    _putTileStmt!.execute([
      zoom,
      column,
      row,
      if (useGzip) bytes.gzipEncode() else bytes,
    ]);
  }

  void createTable() {
    database.execute('''
      CREATE TABLE tiles 
      (
        zoom_level integer, 
        tile_column integer, 
        tile_row integer, 
        tile_data blob,
        PRIMARY KEY (zoom_level, tile_column, tile_row)
      );
    ''');
  }

  void dispose() {
    _putTileStmt?.close();
  }
}
