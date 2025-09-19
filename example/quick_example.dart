import 'package:vanity_solana/vanity_solana.dart';

Future<void> main() async {
  print('🚀 Vanity Solana Address Generator - Quick Example\n');
  
  // Simple example with empty criteria (should find immediately)
  print('Generating any valid Solana address...');
  final result = await generateWithIsolates(
    config: const VanityConfig(),
    workers: 1,
  );
  
  print('✅ Generated address!');
  print('Address: ${result.address}');
  print('Attempts: ${result.attempts}');
  print('Private Key: ${result.privateKeyHex}');
  print('');
  
  // Validate the address
  final isValid = isValidVanityAddress(result.address, '', '', false);
  print('Address is valid: $isValid');
  
  print('\n📖 For more examples with custom prefixes/suffixes,');
  print('   see the full example in the main.dart file.');
}
