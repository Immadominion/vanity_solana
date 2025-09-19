import 'package:vanity_solana/vanity_solana.dart';

Future<void> main() async {
  print('Vanity Solana Address Generator Example\n');
  
  // Example 1: Generate address with prefix
  print('Generating address starting with "Sol"...');
  final result1 = await generateWithIsolates(
    config: const VanityConfig(
      prefix: 'Sol',
      caseSensitive: true,
    ),
    onProgress: (attempts) {
      if (attempts % 100 == 0) {
        print('Progress: $attempts attempts');
      }
    },
  );
  
  print('Found vanity address!');
  print('Address: ${result1.address}');
  print('Attempts: ${result1.attempts}');
  print('Private Key: ${result1.privateKeyHex}');
  print('');
  
  // Example 2: Generate address with case-insensitive matching
  print('Generating address starting with "test" (case insensitive)...');
  final result2 = await generateWithIsolates(
    config: const VanityConfig(
      prefix: 'test',
      caseSensitive: false,
    ),
    workers: 2,
  );
  
  print('Found vanity address!');
  print('Address: ${result2.address}');
  print('Attempts: ${result2.attempts}');
  print('');
  
  // Example 3: Validate an existing address
  print('Validating existing addresses...');
  final isValid1 = isValidVanityAddress(result1.address, 'Sol', '', true);
  final isValid2 = isValidVanityAddress(result2.address, 'test', '', false);
  
  print('${result1.address} starts with "Sol": $isValid1');
  print('${result2.address} starts with "test": $isValid2');
}
