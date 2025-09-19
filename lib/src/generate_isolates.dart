import 'dart:async';
import 'dart:isolate';
import 'dart:io';

import 'package:solana/solana.dart';

import 'models.dart';
import 'vanity_address.dart';

class _StartMessage {
  const _StartMessage(this.sendPort, this.config);
  final SendPort sendPort;
  final VanityConfig config;
}

class _ProgressMessage {
  const _ProgressMessage(this.attempts);
  final int attempts;
}

class _ResultMessage {
  const _ResultMessage(this.address, this.privateKeyBytes, this.attempts);
  final String address;
  final List<int> privateKeyBytes;
  final int attempts;
}

/// Generate vanity address using multiple isolates (CPU cores).
/// Defaults to half of available processors (similar to Node.js example).
Future<GenerationResult> generateWithIsolates({
  required VanityConfig config,
  int? workers,
  ProgressCallback? onProgress,
}) async {
  final cpuCount = _cpuCount();
  final workerCount = (workers ?? (cpuCount / 2).ceil()).clamp(1, cpuCount);

  final receivePort = ReceivePort();
  final subs = <StreamSubscription>[];
  final isolates = <Isolate>[];
  final completer = Completer<_ResultMessage>();
  int totalAttempts = 0;

  void handleMessage(dynamic message) {
    if (message is _ProgressMessage) {
      totalAttempts += message.attempts;
      onProgress?.call(totalAttempts);
    } else if (message is _ResultMessage) {
      if (!completer.isCompleted) {
        completer.complete(message);
      }
    }
  }

  subs.add(receivePort.listen(handleMessage));

  try {
    for (var i = 0; i < workerCount; i++) {
      final isolate = await Isolate.spawn<_StartMessage>(
        _workerEntry,
        _StartMessage(receivePort.sendPort, config),
        errorsAreFatal: true,
      );
      isolates.add(isolate);
    }

    final result = await completer.future;

    final keypair = await Ed25519HDKeyPair.fromPrivateKeyBytes(privateKey: result.privateKeyBytes);

    // For parity with web3.js Keypair.secretKey (64 bytes): private(32) + public(32)
    final combinedSecret = <int>[...result.privateKeyBytes, ...keypair.publicKey.bytes];

    return GenerationResult(
      keypair: keypair,
      address: result.address,
      privateKeyHex: _toHex(combinedSecret),
      attempts: totalAttempts + result.attempts,
    );
  } finally {
    for (final iso in isolates) {
      iso.kill(priority: Isolate.immediate);
    }
    for (final sub in subs) {
      await sub.cancel();
    }
    receivePort.close();
  }
}

void _workerEntry(_StartMessage start) async {
  final sendPort = start.sendPort;
  final cfg = start.config;

  int attempts = 0;

  // Generate until match; report progress in batches to reduce chatter
  const batch = 100;
  while (true) {
    attempts++; // Count every attempt
    var keypair = await Ed25519HDKeyPair.random();
    final address = keypair.address;

    if (isValidVanityAddress(address, cfg.prefix, cfg.suffix, cfg.caseSensitive)) {
      final data = await keypair.extract();
      sendPort.send(_ResultMessage(address, data.bytes, attempts));
      return;
    }

    if (attempts % batch == 0) {
      sendPort.send(const _ProgressMessage(batch));
    }
  }
}

String _toHex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

int _cpuCount() => Platform.numberOfProcessors;
