import 'package:solana/solana.dart';

typedef ProgressCallback = void Function(int totalAttempts);

class VanityConfig {
  const VanityConfig({
    this.prefix = '',
    this.suffix = '',
    this.caseSensitive = false,
  });

  final String prefix;
  final String suffix;
  final bool caseSensitive;
}

class GenerationResult {
  const GenerationResult({
    required this.keypair,
    required this.address,
    required this.privateKeyHex,
    required this.attempts,
  });

  final Ed25519HDKeyPair keypair;
  final String address;
  final String privateKeyHex;
  final int attempts;
}
