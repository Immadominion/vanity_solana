import 'package:test/test.dart';
import 'package:vanity_solana/vanity_solana.dart';

void main() {
  group('Basic Integration Tests', () {
    test('generateVanityAddress finds address with easy prefix', () async {
      int attempts = 0;
      
      final result = await generateVanityAddress(
        '1', // prefix
        '', // suffix
        false, // case sensitive
        () => attempts++,
      );
      
      expect(result.address.toLowerCase().startsWith('1'), isTrue);
      expect(attempts, greaterThanOrEqualTo(0));
    });

    test('generateVanityAddress handles empty prefix and suffix', () async {
      int attempts = 0;
      
      final result = await generateVanityAddress(
        '', // prefix
        '', // suffix
        true, // case sensitive
        () => attempts++,
      );
      
      // Should find immediately since any address matches
      expect(result.address.isNotEmpty, isTrue);
      expect(attempts, equals(0)); // No failed attempts
    });

    test('generateWithIsolates basic functionality', () async {
      const config = VanityConfig(
        prefix: '',
        suffix: '',
        caseSensitive: false,
      );

      final result = await generateWithIsolates(
        config: config,
        workers: 1,
      );
      
      expect(result.address.isNotEmpty, isTrue);
      expect(result.attempts, greaterThanOrEqualTo(1));
    });
  }, timeout: const Timeout(Duration(seconds: 30)));
}
