## [0.5.0] 2026-02-20

This release uses native assets. Please follow the new 
[Getting started](https://pub.dev/packages/mbtiles#getting-started) guide.

- Update `sqlite3` dependency to v3
- Rename `dispose()` to `close()`
- Rename `mbtilesPath` to `path`
- Remove `sqlitePath` as it is no longer needed
- Add support for in memory database by passing `null` to the `path` parameter
- Bump minimum Dart SDK version to 3.9
- Remove deprecations

## [0.4.2] 2024-05-17

- Make compatible with WASM

## [0.4.1] 2024-03-20

- Update documentation
- Update example

## [0.4.0] 2024-02-18

- Renamed the parameter `isPBF` to `gzip`.
- Fix metadata `minzoom` and `maxzoom`.

## [0.3.1] 2024-02-12

- Add deprecations for `MBTiles` and `MBTilesMetadata`

## [0.3.0] 2024-02-12

- Rename `MBTiles` to `MbTiles`, rename `MBTilesMetadata` to `MbTilesMetadata`.
- add `MbTiles.create()` constructor to create new MBTiles files.
- Coordinates are now a LatLng using the package `latlong2`.
- `bounds` are now a instance of `MbTilesBounds`.
- `getTile()` now requires named parameters.
- Clean up dependencies.

## [0.2.0] 2024-02-09

- The package can now be compiled on Flutter Web. Note that MBTiles can still
  not be used on web and will throw an `UnimplementedError`.
- Change license to a BSD 3-Clause License.

## [0.1.1] 2023-11-25

- Fix package score on `pub.dev`

## [0.1.0] 2023-11-25

- Initial version
- Support to read raster and vector tiles
