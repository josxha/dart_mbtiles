@TestOn('vm')
library;

import 'package:mbtiles/mbtiles.dart';
import 'package:mbtiles/src/repository/metadata.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

void main() {
  test('Put and get Metadata', () {
    // given
    const metadata1 = MbTilesMetadata(
      name: 'Example MBTiles',
      format: 'pbf',
      minZoom: 1,
      maxZoom: 12,
      version: 23,
      json: "{}",
      description: "A small description",
      defaultZoom: 6,
      defaultCenter: LatLng(47, 9),
      type: TileLayerType.baseLayer,
      attributionHtml: "Not a real attribution message",
      bounds: MbTilesBounds(bottom: -180, left: -90, top: 180, right: 90),
    );
    final db = sqlite3.openInMemory();
    final repo = MetadataRepository(database: db);

    // when
    repo.createTable();
    repo.putAll(metadata1);
    final metadata2 = repo.getAll();

    // then
    expect(metadata2, equals(metadata1));
  });
  test('Metadata toString', () {
    // given
    const metadata1 = MbTilesMetadata(
      name: 'Example MBTiles',
      format: 'pbf',
      minZoom: 1,
      maxZoom: 12,
      version: 23,
      json: "{}",
      description: "A small description",
      defaultZoom: 6,
      defaultCenter: LatLng(47, 9),
      attributionHtml: "Not a real attribution message",
      type: TileLayerType.baseLayer,
      bounds: MbTilesBounds(bottom: -180, left: -90, top: 180, right: 90),
    );
    expect(metadata1.toString(), contains('Example MBTiles'));
    expect(metadata1.toString(), contains('A small description'));
    expect(metadata1.toString(), contains('Not a real attribution message'));
    expect(metadata1.toString(), contains('baselayer'));
  });
  test('Metadata hashCode equals', () {
    // given
    const metadata1 = MbTilesMetadata(
      name: 'Example MBTiles',
      format: 'pbf',
      minZoom: 1,
      maxZoom: 12,
      version: 23,
      json: "{}",
      description: "A small description",
      defaultZoom: 6,
      defaultCenter: LatLng(47, 9),
      attributionHtml: "Not a real attribution message",
      bounds: MbTilesBounds(bottom: -180, left: -90, top: 180, right: 90),
    );
    const metadata2 = MbTilesMetadata(
      name: 'Example MBTiles',
      format: 'pbf',
      minZoom: 1,
      maxZoom: 12,
      version: 23,
      json: "{}",
      description: "A small description",
      defaultZoom: 6,
      defaultCenter: LatLng(47, 9),
      attributionHtml: "Not a real attribution message",
      bounds: MbTilesBounds(bottom: -180, left: -90, top: 180, right: 90),
    );
    expect(metadata1.hashCode, equals(metadata2.hashCode));
  });
  test('Metadata hashCode not equal', () {
    // given
    const metadata1 = MbTilesMetadata(
      name: 'Example MBTiles',
      format: 'pbf',
      minZoom: 1,
      maxZoom: 12,
      version: 23,
      json: "{}",
      description: "A small description",
      defaultZoom: 6,
      defaultCenter: LatLng(47, 9),
      attributionHtml: "Not a real attribution message",
      bounds: MbTilesBounds(bottom: -180, left: -90, top: 180, right: 90),
    );
    const metadata2 = MbTilesMetadata(
      name: 'Example MBTiles2',
      format: 'pbf',
      minZoom: 1,
      maxZoom: 12,
      version: 23,
      json: "{}",
      description: "A small description",
      defaultZoom: 6,
      defaultCenter: LatLng(47, 9),
      attributionHtml: "Not a real attribution message",
      bounds: MbTilesBounds(bottom: -180, left: -90, top: 180, right: 90),
    );
    expect(metadata1.hashCode != metadata2.hashCode, isTrue);
  });
  test('Unsupported tile layer', () {
    final db = sqlite3.openInMemory();
    final repo = MetadataRepository(database: db);
    repo.createTable();
    const metadata = MbTilesMetadata(name: 'TestFile', format: 'jpg');
    repo.putAll(metadata);
    db.execute('INSERT INTO metadata (name, value) VALUES (?, ?)', [
      'type',
      'unsupported',
    ]);
    expect(() => repo.getAll(), throwsA(const TypeMatcher<UnsupportedError>()));
  });
}
