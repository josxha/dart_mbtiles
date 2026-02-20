@TestOn('browser')
library;

import 'package:mbtiles/mbtiles.dart';
import 'package:test/test.dart';

void main() {
  test('Test compilation for web', () {
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
