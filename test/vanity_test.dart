import 'package:test/test.dart';
import 'package:solana/solana.dart';
import 'package:vanity_solana/vanity_solana.dart';

void main() {
  group('VanityAddressValidator', () {
    test('validates prefix matching (case sensitive)', () {
      expect(
        isValidVanityAddress('ABC123xyz', 'ABC', '', true),
        isTrue,
      );
      expect(
        isValidVanityAddress('ABC123xyz', 'abc', '', true),
        isFalse,
      );
    });

    test('validates prefix matching (case insensitive)', () {
      expect(
        isValidVanityAddress('ABC123xyz', 'abc', '', false),
        isTrue,
      );
      expect(
        isValidVanityAddress('abc123xyz', 'ABC', '', false),
        isTrue,
      );
    });

    test('validates suffix matching (case sensitive)', () {
      expect(
        isValidVanityAddress('ABC123xyz', '', 'xyz', true),
        isTrue,
      );
      expect(
        isValidVanityAddress('ABC123xyz', '', 'XYZ', true),
        isFalse,
      );
    });

    test('validates suffix matching (case insensitive)', () {
      expect(
        isValidVanityAddress('ABC123xyz', '', 'XYZ', false),
        isTrue,
      );
      expect(
        isValidVanityAddress('ABC123XYZ', '', 'xyz', false),
        isTrue,
      );
    });

    test('validates combined prefix and suffix', () {
      expect(
        isValidVanityAddress('ABC123xyz', 'ABC', 'xyz', true),
        isTrue,
      );
      expect(
        isValidVanityAddress('ABC123xyz', 'abc', 'XYZ', false),
        isTrue,
      );
      expect(
        isValidVanityAddress('ABC123abc', 'ABC', 'xyz', true),
        isFalse,
      );
    });

    test('handles empty prefix and suffix', () {
      expect(
        isValidVanityAddress('AnyAddress123', '', '', true),
        isTrue,
      );
      expect(
        isValidVanityAddress('AnyAddress123', '', '', false),
        isTrue,
      );
    });

    test('handles edge cases', () {
      // Single character address
      expect(
        isValidVanityAddress('A', 'A', '', true),
        isTrue,
      );
      
      // Prefix longer than address should fail
      expect(
        isValidVanityAddress('AB', 'ABC', '', true),
        isFalse,
      );
      
      // Suffix longer than address should fail
      expect(
        isValidVanityAddress('AB', '', 'ABC', true),
        isFalse,
      );
    });
  });

  group('VanityConfig', () {
    test('creates config with default values', () {
      const config = VanityConfig();
      expect(config.prefix, equals(''));
      expect(config.suffix, equals(''));
      expect(config.caseSensitive, equals(false));
    });

    test('creates config with custom values', () {
      const config = VanityConfig(
        prefix: 'test',
        suffix: '123',
        caseSensitive: true,
      );
      expect(config.prefix, equals('test'));
      expect(config.suffix, equals('123'));
      expect(config.caseSensitive, equals(true));
    });
  });

  group('GenerationResult', () {
    test('stores generation result data', () async {
      final mockKeypair = await Ed25519HDKeyPair.random();
      const mockAddress = '1234567890abcdef';
      final mockPrivateKeyHex = 'deadbeef' * 16; // 64 chars
      const mockAttempts = 42;

      final result = GenerationResult(
        keypair: mockKeypair,
        address: mockAddress,
        privateKeyHex: mockPrivateKeyHex,
        attempts: mockAttempts,
      );

      expect(result.keypair, equals(mockKeypair));
      expect(result.address, equals(mockAddress));
      expect(result.privateKeyHex, equals(mockPrivateKeyHex));
      expect(result.attempts, equals(mockAttempts));
    });
  });
}
