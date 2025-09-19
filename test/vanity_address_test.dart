import 'package:test/test.dart';
import 'package:vanity_solana/src/vanity_address.dart';

void main() {
  group('isValidVanityAddress', () {
    test('matches prefix and suffix (case-sensitive)', () {
      expect(isValidVanityAddress('AbC123xyZ', 'AbC', 'xyZ', true), isTrue);
      expect(isValidVanityAddress('AbC123xyz', 'AbC', 'xyZ', true), isFalse);
    });

    test('matches prefix and suffix (case-insensitive)', () {
      expect(isValidVanityAddress('AbC123xyZ', 'abc', 'xyz', false), isTrue);
      expect(isValidVanityAddress('AbC123xyZ', 'abc', 'xyzz', false), isFalse);
    });
  });
}
