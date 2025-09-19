# vanity_solana

A high-performance vanity Solana address generator implemented in Dart with multi-core parallelism support.

Generate Solana addresses that start or end with custom prefixes and suffixes. Uses the [solana](https://pub.dev/packages/solana) package for cryptographic operations and Dart isolates for parallel processing across multiple CPU cores.

## Features

- Generate vanity Solana addresses with custom prefixes and suffixes
- Case-sensitive and case-insensitive matching
- Multi-core parallel processing using Dart isolates
- Progress tracking with attempt counters
- Compatible with standard Solana keypair format
- No external dependencies beyond the Solana package

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  vanity_solana: ^0.1.0
```

Then run:

```bash
dart pub get
```

## Usage

### Basic Example

```dart
import 'package:vanity_solana/vanity_solana.dart';

Future<void> main() async {
  // Generate address starting with 'Sol'
  final result = await generateWithIsolates(
    config: const VanityConfig(
      prefix: 'Sol',
      caseSensitive: true,
    ),
    onProgress: (attempts) => print('Attempts: $attempts'),
  );

  print('Generated address: ${result.address}');
  print('Private key (hex): ${result.privateKeyHex}');
  print('Total attempts: ${result.attempts}');
}
```

### Advanced Configuration

```dart
import 'package:vanity_solana/vanity_solana.dart';

Future<void> main() async {
  final config = VanityConfig(
    prefix: 'ABC',           // Address must start with 'ABC'
    suffix: '123',           // Address must end with '123'
    caseSensitive: false,    // Case insensitive matching
  );

  final result = await generateWithIsolates(
    config: config,
    workers: 4,              // Use 4 CPU cores
    onProgress: (attempts) {
      if (attempts % 1000 == 0) {
        print('Progress: $attempts attempts');
      }
    },
  );

  print('Found vanity address: ${result.address}');
}
```

### Single-threaded Generation

For simpler use cases or testing, you can use single-threaded generation:

```dart
import 'package:vanity_solana/vanity_solana.dart';

Future<void> main() async {
  final keypair = await generateVanityAddress(
    'test',           // prefix
    '',               // suffix (empty)
    false,            // case sensitive
    () => print('Attempting...'), // progress callback
  );

  print('Address: ${keypair.address}');
}
```

## API Reference

### VanityConfig

Configuration class for vanity address generation.

```dart
class VanityConfig {
  const VanityConfig({
    this.prefix = '',
    this.suffix = '',
    this.caseSensitive = false,
  });

  final String prefix;        // Required prefix for the address
  final String suffix;        // Required suffix for the address
  final bool caseSensitive;   // Whether matching is case sensitive
}
```

### GenerationResult

Result of vanity address generation.

```dart
class GenerationResult {
  const GenerationResult({
    required this.keypair,
    required this.address,
    required this.privateKeyHex,
    required this.attempts,
  });

  final Ed25519HDKeyPair keypair;  // Generated keypair
  final String address;            // Base58 encoded address
  final String privateKeyHex;      // 64-byte hex (32 private + 32 public)
  final int attempts;              // Number of generation attempts
}
```

### Functions

#### generateWithIsolates

Multi-core vanity address generation using Dart isolates.

```dart
Future<GenerationResult> generateWithIsolates({
  required VanityConfig config,
  int? workers,                    // Number of isolates (defaults to CPU count / 2)
  ProgressCallback? onProgress,    // Progress callback function
})
```

#### generateVanityAddress

Single-threaded vanity address generation.

```dart
Future<Ed25519HDKeyPair> generateVanityAddress(
  String prefix,
  String suffix,
  bool caseSensitive,
  void Function() incrementCounter,
)
```

#### isValidVanityAddress

Check if an address matches the given criteria.

```dart
bool isValidVanityAddress(
  String address,
  String prefix,
  String suffix,
  bool caseSensitive,
)
```

## Performance

Generation time depends on the length and complexity of your prefix/suffix:

- 1 character: ~29 attempts average (sub-second)
- 2 characters: ~1,700 attempts average (1-2 seconds)
- 3 characters: ~100,000 attempts average (10-30 seconds)
- 4 characters: ~5.8 million attempts average (5-15 minutes)

The difficulty increases exponentially with each additional character. Use multiple CPU cores for faster generation of longer patterns.

## Examples

See the `example/` directory for a complete Flutter application demonstrating vanity address generation with a user interface.

## Compatibility

This package is compatible with standard Solana tools and wallets. The generated keypairs use the same format as the Solana CLI and other Solana libraries.

## License

MIT License - see [LICENSE](LICENSE) file for details.
