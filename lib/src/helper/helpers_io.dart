import 'dart:io';
import 'dart:typed_data';

extension U8intListExtension on Uint8List {
  Uint8List gzipEncode() => gzip.encode(this) as Uint8List;

  Uint8List gzipDecode() => gzip.decode(this) as Uint8List;
}
