import 'package:latlong2/latlong.dart';
import 'package:mbtiles/src/model/metadata.dart';
import 'package:sqlite3/common.dart';

class MetadataRepository {
  final CommonDatabase database;

  const MetadataRepository({required this.database});

  MbTilesMetadata getAll() {
    final rows = database.select('SELECT * FROM metadata');
    final map = <String, String>{};
    for (final row in rows) {
      final name = row['name'] as String;
      final value = row['value'] as String;
      map[name] = value;
    }

    assert(
      map.containsKey('name'),
      'Invalid metadata table: The table must contain a name row.',
    );
    assert(
      map.containsKey('format'),
      'Invalid metadata table: The table must contain a format row.',
    );

    // tile layer bounds
    MbTilesBounds? bounds;
    if (map['bounds']?.split(',')
        case [
          final left,
          final bottom,
          final right,
          final top,
        ]) {
      bounds = MbTilesBounds(
        left: double.parse(left),
        bottom: double.parse(bottom),
        right: double.parse(right),
        top: double.parse(top),
      );
    }

    // default tile layer center and zoom level
    LatLng? center;
    double? zoom;
    if (map['center']?.split(',') case [final long, final lat, final z]) {
      center = LatLng(double.parse(lat), double.parse(long));
      zoom = double.parse(z);
    }

    return MbTilesMetadata(
      name: map['name']!,
      format: map['format']!,
      type: _parseTileLayerType(map['type']),
      bounds: bounds,
      attributionHtml: map['attribution'],
      defaultCenter: center,
      defaultZoom: zoom,
      description: map['description'],
      json: map['json'],
      maxZoom: map['maxzoom'] == null ? null : double.parse(map['maxzoom']!),
      minZoom: map['minzoom'] == null ? null : double.parse(map['minzoom']!),
      version: map['version'] == null ? null : double.parse(map['version']!),
    );
  }

  TileLayerType? _parseTileLayerType(String? raw) => switch (raw) {
        'baselayer' => TileLayerType.baseLayer,
        'overlay' => TileLayerType.overlay,
        null => null,
        _ => throw UnsupportedError(
            'The MBTiles file contains an unsupported tile layer type: $raw',
          ),
      };

  void createTable() => database.execute('''
      CREATE TABLE metadata (name text PRIMARY KEY, value text);
      ''');

  void putAll(MbTilesMetadata metadata) {
    assert(
      metadata.defaultCenter == null && metadata.defaultZoom == null ||
          metadata.defaultCenter != null && metadata.defaultZoom != null,
      'Default center and zoom need to be both set if one is set.',
    );

    final stmt = database.prepare('''
        INSERT OR REPLACE INTO metadata
        (name, value) 
        VALUES (?, ?);
        ''');
    stmt.execute(['name', metadata.name]);
    stmt.execute(['format', metadata.format]);
    if (metadata.bounds != null) {
      stmt.execute([
        'bounds',
        '${metadata.bounds!.left},${metadata.bounds!.bottom},' +
            '${metadata.bounds!.right},${metadata.bounds!.top}',
      ]);
    }
    if (metadata.type != null) {
      stmt.execute(['type', metadata.type!.name]);
    }
    if (metadata.defaultZoom != null && metadata.defaultCenter != null) {
      stmt.execute([
        'center',
        '${metadata.defaultCenter!.longitude},${metadata.defaultCenter!.latitude},${metadata.defaultZoom}',
      ]);
    }
    if (metadata.attributionHtml != null) {
      stmt.execute(['attribution', metadata.attributionHtml]);
    }
    if (metadata.description != null) {
      stmt.execute(['description', metadata.description]);
    }
    if (metadata.json != null) {
      stmt.execute(['json', metadata.json]);
    }
    if (metadata.maxZoom != null) {
      stmt.execute(['maxzoom', metadata.maxZoom]);
    }
    if (metadata.minZoom != null) {
      stmt.execute(['minzoom', metadata.minZoom]);
    }
    if (metadata.version != null) {
      stmt.execute(['version', metadata.version]);
    }
  }
}
