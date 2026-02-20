@TestOn('vm')
library;

import 'dart:typed_data';

import 'package:mbtiles/mbtiles.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('Open read only raster db', () {
    final mbtiles = MbTiles(path: rasterMbtilesPath);
    mbtiles.close();
  });
  test('Open read write raster db', () {
    final mbtiles = MbTiles(path: rasterMbtilesPath);
    expect(mbtiles.getTile(z: 0, x: 0, y: 0), isA<Uint8List>());
    expect(mbtiles.getTile(z: 20, x: 123, y: 456), isNull);
    mbtiles.close();
  });
  test('Create db', () {
    final mbTiles = MbTiles.create(
      path: null,
      metadata: const MbTilesMetadata(name: 'TestFile', format: 'pbf'),
    );
    final bytes = Uint8List.fromList([0, 1, 2, 3]);

    mbTiles.putTile(z: 0, x: 0, y: 0, bytes: bytes);

    final actual = mbTiles.getTile(z: 0, x: 0, y: 0);
    expect(actual, equals(bytes));
    mbTiles.close();
  });
}
