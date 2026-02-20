import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';

/// The model class for the mbtiles metadata table
@immutable
class MbTilesMetadata {
  /// The human-readable name of the tileset. (must contain)
  final String name;

  /// The file format of the tile data: pbf, jpg, png, webp,
  /// or an IETF media type for other formats. (must contain)
  final String format;

  /// The maximum extent of the rendered map area. Bounds must define an area
  /// covered by all zoom levels. The bounds are represented as WGS 84 latitude
  /// and longitude values, in the OpenLayers Bounds format (left, bottom,
  /// right, top). For example, the bounds of the full Earth, minus the poles,
  /// would be: -180.0,-85,180,85. (should contain)
  final MbTilesBounds? bounds;

  /// The longitude, latitude of the default view of the map. (should contain)
  final LatLng? defaultCenter;

  /// The zoom level of the default view of the map. (should contain)
  final double? defaultZoom;

  /// The lowest zoom level for which the tileset provides data.
  /// (should contain)
  final double? minZoom;

  /// The highest zoom level for which the tileset provides data.
  /// (should contain)
  final double? maxZoom;

  /// An attribution string, which explains the sources of data and/or style
  /// for the map. (may contain)
  final String? attributionHtml;

  /// A description of the fileset's content. (may contain)
  final String? description;

  /// Tile layer type, overlay or baselayer (may contain)
  final TileLayerType? type;

  /// The version of the tileset. This refers to a revision of the tileset
  /// itself, not of the MBTiles specification. (may contain)
  final double? version;

  /// Lists the layers that appear in the vector tiles and the names and types
  /// of the attributes of features that appear in those layers.
  /// (must contain if format is pbf)
  final String? json;

  const MbTilesMetadata({
    required this.name,
    required this.format,
    this.bounds,
    this.defaultCenter,
    this.defaultZoom,
    this.minZoom,
    this.maxZoom,
    this.attributionHtml,
    this.description,
    this.type,
    this.version,
    this.json,
  });

  @override
  String toString() {
    var result = 'MBTilesMetadata(name: "$name", format: "$format"';
    if (bounds != null) result += ', bounds: $bounds';
    if (defaultCenter != null) result += ', defaultCenter: $defaultCenter';
    if (defaultZoom != null) result += ', defaultZoom: $defaultZoom';
    if (minZoom != null) result += ', minZoom: $minZoom';
    if (maxZoom != null) result += ', maxZoom: $maxZoom';
    if (attributionHtml != null) {
      result += ', attributionHtml: $attributionHtml';
    }
    if (description != null) result += ', description: $description';
    if (type != null) result += ', type: $type';
    if (version != null) result += ', version: $version';
    if (json != null) result += ', json: $json';
    return '$result)';
  }

  @override
  bool operator ==(Object o) {
    if (o is! MbTilesMetadata) return false;
    return name == o.name &&
        format == o.format &&
        bounds == o.bounds &&
        defaultCenter == o.defaultCenter &&
        defaultZoom == o.defaultZoom &&
        minZoom == o.minZoom &&
        maxZoom == o.maxZoom &&
        attributionHtml == o.attributionHtml &&
        description == o.description &&
        version == o.version &&
        json == o.json;
  }

  @override
  int get hashCode => Object.hash(
    name,
    format,
    bounds,
    defaultCenter,
    defaultZoom,
    minZoom,
    maxZoom,
    attributionHtml,
    description,
    version,
    json,
  );
}

enum TileLayerType {
  overlay('overlay'),
  baseLayer('baselayer');

  final String name;

  const TileLayerType(this.name);

  @override
  String toString() => name;
}

@immutable
class MbTilesBounds {
  final double bottom;
  final double left;
  final double top;
  final double right;

  const MbTilesBounds({
    required this.bottom,
    required this.left,
    required this.top,
    required this.right,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MbTilesBounds &&
          runtimeType == other.runtimeType &&
          top == other.top;

  @override
  int get hashCode => top.hashCode;

  @override
  String toString() => 'MbTilesBounds($bottom, $left, $top, $right)';
}
