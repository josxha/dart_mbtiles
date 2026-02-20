import 'dart:typed_data';

import 'package:mbtiles/src/model/metadata.dart';
import 'package:mbtiles/src/repository/metadata.dart';
import 'package:mbtiles/src/repository/tiles.dart';
import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart'
    if (dart.library.js_util) 'package:sqlite3/wasm.dart';

/// A class to read and write MBTiles files.
///
/// MBTiles is a specification for storing tiled map data in SQLite databases.
/// This class provides methods to read and write MBTiles files, including
/// fetching tile data and metadata, and creating new MBTiles files. It uses the
/// `sqlite3` package to interact with the SQLite database, and supports both
/// raster and vector tiles.
class MbTiles {
  static const _notEditableMsg =
      'Database not editable, please set the parameter '
      '`MBTiles(editable: true)';
  late final CommonDatabase _database;
  late final MetadataRepository _metadataRepo;
  late final TilesRepository _tileRepo;

  /// Set to true if the mbtiles database can be modified, defaults to false.
  ///
  /// If the archive is not marked as editable the SQLite database gets opened
  /// as read-only.
  final bool editable;

  /// cached metadata values
  MbTilesMetadata? _metadata;

  /// Open a MBTiles file.
  /// Use the [sqlitePath] parameter if you don't use the
  /// `sqlite3_flutter_libs` package.
  ///
  /// Set [gzip] to true if the format of the mbtiles file is pbf / mvt and the
  /// tile data is gzip encoded.
  /// This flag is optional and defaults to true if the format is pbf and to
  /// false otherwise.
  MbTiles({required String path, bool? gzip, this.editable = false}) {
    if (_kIsWeb) throw UnsupportedError('Web is not supported');

    _database = sqlite3.open(
      path,
      mode: editable ? OpenMode.readWriteCreate : OpenMode.readOnly,
    );
    _metadataRepo = MetadataRepository(database: _database);
    _tileRepo = TilesRepository(
      database: _database,
      useGzip: gzip ?? getMetadata().format == 'pbf',
    );
  }

  /// Create a new MBTiles file.
  ///
  /// [metadata] is required to create the mbtiles file and will be written to
  /// the database.
  ///
  /// [path] is the file path to the mbtiles file, if `null` an in-memory
  /// database will be used.
  ///
  /// [gzip] is only supported for vector tiles (format pbf) and defaults to
  /// true for vector tiles and false for raster tiles.
  MbTiles.create({
    required String? path,
    required MbTilesMetadata metadata,
    bool? gzip,
  }) : editable = true {
    if (_kIsWeb) throw UnsupportedError('Web is not supported');

    if (path == null) {
      _database = sqlite3.openInMemory();
    } else {
      _database = sqlite3.open(path);
    }
    _metadataRepo = MetadataRepository(database: _database);
    _tileRepo = TilesRepository(
      database: _database,
      useGzip: gzip ?? metadata.format == 'pbf',
    );

    createTables();
    setMetadata(metadata);
  }

  /// Cached metadata that is stored inside the mbtiles file.
  MbTilesMetadata getMetadata({bool allowCache = true}) {
    if (allowCache) {
      if (_metadata case final metadata?) {
        return metadata;
      }
    }
    return _metadata = _metadataRepo.getAll();
  }

  /// Fetch the data for a tile, returns null if the tile is not found.
  Uint8List? getTile({required int z, required int x, required int y}) =>
      _tileRepo.getTile(z, x, y);

  /// Create all tables for the mbtiles file.
  ///
  /// Requires [editable] to be true.
  void createTables() {
    assert(editable, _notEditableMsg);
    _metadataRepo.createTable();
    _tileRepo.createTable();
  }

  /// Inserts or updates a tile.
  ///
  /// Requires [editable] to be true.
  void putTile({
    required int z,
    required int x,
    required int y,
    required Uint8List bytes,
  }) {
    assert(editable, _notEditableMsg);
    _tileRepo.putTile(z, x, y, bytes);
  }

  /// Set the metadata of the MBTiles file.
  ///
  /// Requires [editable] to be true.
  void setMetadata(MbTilesMetadata metadata) {
    assert(editable, _notEditableMsg);
    _metadataRepo.putAll(metadata);
    _metadata = metadata;
  }

  /// Closes the database and releases all resources.
  void close() {
    _tileRepo.dispose();
    _database.close();
  }
}

/// Weather the current platform is web or not.
/// Needed because `kIsWeb` is not available in pure dart packages.
const bool _kIsWeb = bool.fromEnvironment('dart.library.js_util');
