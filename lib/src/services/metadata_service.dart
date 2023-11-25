import 'package:mbtiles/mbtiles.dart';
import 'package:sqlite3/sqlite3.dart';

class MetadataService {
  final Database _database;

  const MetadataService(this._database);

  MBTilesMetadata getAll() {
    final rows = _database.select('SELECT * FROM metadata');
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
    ((double, double), (double, double))? bounds;
    if (map.containsKey('bounds')) {
      final values = map['bounds']!.split(',');
      bounds = (
        (double.parse(values[0]), double.parse(values[1])),
        (double.parse(values[2]), double.parse(values[3])),
      );
    }

    // default tile layer center and zoom level
    (double, double)? center;
    double? zoom;
    if (map.containsKey('center')) {
      final values = map['center']!.split(',');
      center = (double.parse(values[0]), double.parse(values[1]));
      zoom = double.parse(values[2]);
    }

    return MBTilesMetadata(
      name: map['name']!,
      format: map['format']!,
      type: _parseTileLayerType(map['type']),
      bounds: bounds,
      attributionHtml: map['attribution'],
      defaultCenter: center,
      defaultZoom: zoom,
      description: map['description'],
      json: map['json'],
      maxZoom: map['max_zoom'] == null ? null : int.parse(map['max_zoom']!),
      minZoom: map['min_zoom'] == null ? null : int.parse(map['min_zoom']!),
      version: map['version'] == null ? null : int.parse(map['version']!),
    );
  }

  TileLayerType? _parseTileLayerType(String? raw) => switch (raw) {
        'baselayer' => TileLayerType.baseLayer,
        'overlay' => TileLayerType.overlay,
        null => null,
        _ => throw Exception(
            'The MBTiles file contains an unsupported tile layer type: $raw',
          ),
      };
}
