import 'package:solana/solana.dart';

/// Check if an address matches the given prefix and suffix.
/// Case sensitivity is controlled by [caseSensitive].
bool isValidVanityAddress(
  String address,
  String prefix,
  String suffix,
  bool caseSensitive,
) {
  final addressToCheck = caseSensitive ? address : address.toLowerCase();
  final prefixToCheck = caseSensitive ? prefix : prefix.toLowerCase();
  final suffixToCheck = caseSensitive ? suffix : suffix.toLowerCase();

  return addressToCheck.startsWith(prefixToCheck) && addressToCheck.endsWith(suffixToCheck);
}

/// Generate a vanity address matching the provided [prefix] and [suffix].
/// If a generated address does not match, the function will try again until a
/// valid address is generated. Calls [incrementCounter] for each failed attempt.
Future<Ed25519HDKeyPair> generateVanityAddress(
  String prefix,
  String suffix,
  bool caseSensitive,
  void Function() incrementCounter,
) async {
  var keypair = await Ed25519HDKeyPair.random();

  while (!isValidVanityAddress(keypair.address, prefix, suffix, caseSensitive)) {
    incrementCounter();
    keypair = await Ed25519HDKeyPair.random();
  }

  return keypair;
}
