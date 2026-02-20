@TestOn('browser')
library;

import 'package:mbtiles/mbtiles.dart';
import 'package:test/test.dart';

const kIsWeb = bool.fromEnvironment('dart.library.js_util');

void main() {
  test('Test compilation for web', () {
    if (!kIsWeb) return;

    expect(
      () => MbTiles(path: 'noRealFile.mbtiles'),
      throwsA(const TypeMatcher<UnsupportedError>()),
    );

    expect(
      () => MbTiles.create(
        path: 'noRealFile.mbtiles',
        metadata: const MbTilesMetadata(name: 'Test', format: 'pbf'),
      ),
      throwsA(const TypeMatcher<UnsupportedError>()),
    );
  });
}
