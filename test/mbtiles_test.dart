import 'dart:io';
import 'dart:typed_data';

import 'package:mbtiles/mbtiles.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('Open read only raster Database', () {
    final _ = MbTiles(
      mbtilesPath: rasterMbtilesPath,
      sqlitePath: sqliteLibPath,
    );
  });
  test('Open read write raster Database', () {
    final _ = MbTiles(
      mbtilesPath: rasterMbtilesPath,
      sqlitePath: sqliteLibPath,
      editable: true,
    );
  });
  test('Create Database', () {
    final file = File('tmp.mbtiles');
    final mbTiles = MbTiles.create(
      mbtilesPath: file.path,
      sqlitePath: sqliteLibPath,
      metadata: const MBTilesMetadata(name: 'TestFiel', format: 'pbf'),
    );
    mbTiles.putTile(z: 0, x: 0, y: 0, bytes: Uint8List(0));
    mbTiles.dispose();
    file.deleteSync();
  });
}
