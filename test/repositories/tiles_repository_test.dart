@TestOn('vm')
library;

import 'dart:typed_data';

import 'package:mbtiles/src/repository/tiles.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

void main() {
  test('Get non existing tile', () {
    // given
    final database = sqlite3.openInMemory();
    final repo = TilesRepository(database: database, useGzip: false);

    // when
    repo.createTable();
    final tile = repo.getTile(1, 1, 1);

    // then
    expect(tile, null);
  });
  test('Put and get uncompressed tile', () {
    // given
    final database = sqlite3.openInMemory();
    final tile1 = Uint8List.fromList([0x12, 0xaa, 0x84, 0x23]);
    final repo = TilesRepository(database: database, useGzip: false);

    // when
    repo.createTable();
    repo.putTile(10, 23, 43, tile1);
    final tile2 = repo.getTile(10, 23, 43);

    // then
    expect(tile2, tile1);
  });
  test('Put and get compressed tile', () {
    // given
    final database = sqlite3.openInMemory();
    final tile1 = Uint8List.fromList([0x12, 0xaa, 0x84, 0x00]);
    final repo = TilesRepository(database: database, useGzip: true);

    // when
    repo.createTable();
    repo.putTile(10, 23, 43, tile1);
    final tile2 = repo.getTile(10, 23, 43);

    // then
    expect(tile2, tile1);
  });
  test('Put and get other tile', () {
    // given
    final database = sqlite3.openInMemory();
    final tile1 = Uint8List.fromList([0x12, 0xaa, 0x84, 0x23]);
    final repo = TilesRepository(database: database, useGzip: false);

    // when
    repo.createTable();
    repo.putTile(10, 23, 43, tile1);
    final tile2 = repo.getTile(9, 43, 4);

    // then
    expect(tile2, null);
  });
}
