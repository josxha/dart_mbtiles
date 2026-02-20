import 'dart:math';

import 'package:mbtiles/mbtiles.dart';

void main() {
  // ### RASTER MBTILES ###

  // open mbtiles
  final rasterMbtiles = MbTiles(
    path: 'assets/mbtiles/countries-raster.mbtiles',
  );

  // get metadata
  print('[RASTER MBTILES] metadata: ${rasterMbtiles.getMetadata()}');

  // get tile data
  final rasterTile = rasterMbtiles.getTile(z: 0, x: 0, y: 0);
  final rasterTileSize = rasterTile?.length ?? 0;
  print('[RASTER MBTILES] Tile size: ${formatSize(rasterTileSize)}');

  // close mbtiles
  rasterMbtiles.close();

  // ### VECTOR MBTILES ###

  // open mbtiles
  final vectorMbtiles = MbTiles(
    path: 'assets/mbtiles/countries-vector.mbtiles',
  );

  // get metadata
  print('[VECTOR MBTILES] metadata: ${vectorMbtiles.getMetadata()}');

  // get tile data
  final vectorTile = vectorMbtiles.getTile(z: 0, x: 0, y: 0);
  final vectorTileSize = vectorTile?.length ?? 0;
  print(
    '[VECTOR MBTILES] Uncompressed tile size: ${formatSize(vectorTileSize)}',
  );

  // close mbtiles
  vectorMbtiles.close();
}

/// Return a formatted String for an amount of bytes
/// (from https://stackoverflow.com/a/74568711/9439899)
String formatSize(int amountBytes, {int decimals = 0}) {
  const suffixes = ["b", "kb", "mb", "gb", "tb"];
  if (amountBytes == 0) return '0${suffixes[0]}';
  final i = (log(amountBytes) / log(1024)).floor();
  return ((amountBytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}
