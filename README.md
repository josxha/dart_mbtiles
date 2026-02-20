# mbtiles

Mapbox MBTiles v1.3 files, support for vector and raster tiles.

- Supported raster tiles: `jpg`, `png`, `webp`
- Supported vector tiles: `pbf`
- Web is not supported because of its missing support for SQLite.

[![Pub Version](https://img.shields.io/pub/v/mbtiles)](https://pub.dev/packages/mbtiles)
[![likes](https://img.shields.io/pub/likes/mbtiles?logo=flutter)](https://pub.dev/packages/mbtiles)
[![Pub Points](https://img.shields.io/pub/points/mbtiles)](https://pub.dev/packages/mbtiles/score)
[![stars](https://badgen.net/github/stars/josxha/dart_mbtiles?label=stars&color=green&icon=github)](https://github.com/josxha/dart_mbtiles/stargazers)
[![codecov](https://codecov.io/gh/josxha/dart_mbtiles/graph/badge.svg?token=RGB99KA1GJ)](https://codecov.io/gh/josxha/dart_mbtiles)

## Getting started

#### Add the dependency

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  mbtiles: ^0.5.0
```

or run the following command in your terminal:

```bash
dart pub add mbtiles
```

## Usage

This package has by design no flutter dependency to be able to use it in
dart programs. Please refer to the [flutter instructions](#flutter) if you want
to use it in a flutter app and [dart-only instructions](#dart-only) to use it in
pure dart.

#### 1. Open your .mbtiles file.

First, you need to open your .mbtiles file. You can open it as read-only or as 
a writeable database.

- **[Flutter]** It is recommended to store the mbtiles file in one of the
  directories provided by the
  [path_provider](https://pub.dev/packages/path_provider) package.
- **[Flutter]** The mbtiles file cannot be opened if it is inside your
  flutter assets! Copy it to your file system first.
- **[Flutter]** If you want to open the file from the internal device storage
  or SD card, you need to ask for permission first! You can
  use [permission_handler](https://pub.dev/packages/permission_handler) to
  request the needed permission from the user.

```dart
final mbtiles = MBTiles(path: 'path/to/your/mbtiles-file.mbtiles');
```

#### 2. Work with the database

Afterward you can request tiles, read the metadata, etc.

```dart
// get metadata
final metadata = mbtiles.getMetadata();
// get tile data
final tile = mbtiles.getTile(z: 0, x: 0, y: 0);
```

#### 3. Close the database

After you don't need the MBTiles file anymore, close its sqlite database
connection.

```
mbtiles.close();
```

See the [example program](https://pub.dev/packages/mbtiles/example) for more
information.

## Additional information

- [MBTiles specification](https://github.com/mapbox/mbtiles-spec)
- [Read about MBTiles in the OpenStreetMap Wiki](https://wiki.openstreetmap.org/wiki/MBTiles)