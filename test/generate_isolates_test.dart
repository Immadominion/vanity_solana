import 'package:test/test.dart';
import 'package:vanity_solana/vanity_solana.dart';

void main() {
  test('generateWithIsolates returns valid result quickly for empty criteria', () async {
    final result = await generateWithIsolates(
      config: const VanityConfig(prefix: '', suffix: '', caseSensitive: false),
      workers: 1,
    );

    expect(result.address, isNotEmpty);
    expect(result.privateKeyHex.length, 128); // 64 bytes hex
    expect(result.attempts, greaterThanOrEqualTo(0));
  });
}
