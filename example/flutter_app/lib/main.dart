import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vanity_solana/vanity_solana.dart';

void main() {
  runApp(const VanityExampleApp());
}

class VanityExampleApp extends StatelessWidget {
  const VanityExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vanity Solana Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _prefix = TextEditingController(text: 'm');
  final _suffix = TextEditingController(text: '2');
  bool _caseSensitive = false;

  int _attempts = 0;
  GenerationResult? _result;
  bool _generating = false;
  StreamSubscription? _progressSub;

  @override
  void dispose() {
    _prefix.dispose();
    _suffix.dispose();
    _progressSub?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() {
      _attempts = 0;
      _result = null;
      _generating = true;
    });

    final cfg = VanityConfig(
      prefix: _prefix.text,
      suffix: _suffix.text,
      caseSensitive: _caseSensitive,
    );

    try {
      final result = await generateWithIsolates(
        config: cfg,
        onProgress: (attempts) => setState(() => _attempts = attempts),
      );
      setState(() => _result = result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vanity Solana Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _prefix,
              decoration: const InputDecoration(
                labelText: 'Prefix',
                hintText: 'e.g. m',
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(12),
            TextField(
              controller: _suffix,
              decoration: const InputDecoration(
                labelText: 'Suffix',
                hintText: 'e.g. 2',
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(12),
            Row(
              children: [
                Switch(
                  value: _caseSensitive,
                  onChanged: (v) => setState(() => _caseSensitive = v),
                ),
                const Text('Case sensitive'),
              ],
            ),
            const Gap(16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generating ? null : _start,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Generate'),
              ),
            ),
            const Divider(height: 32),
            if (_generating) ...[
              const LinearProgressIndicator(),
              const Gap(8),
              Text('Attempts: ${_attempts.toString()}'),
            ],
            if (_result != null) ...[
              Text('Address:'),
              SelectableText(
                _result!.address,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              const Gap(12),
              Text('Private (hex 64bytes):'),
              SelectableText(
                _result!.privateKeyHex,
                maxLines: 1,
                // overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              const Gap(12),
              Text('Private Key QR:'),
              const Gap(8),
              Center(
                child: QrImageView(
                  data: _result!.privateKeyHex,
                  size: 220,
                  backgroundColor: Colors.white,
                ),
              ),
              const Gap(8),
              Text('Attempts: ${_result!.attempts}'),
            ],
          ],
        ),
      ),
    );
  }
}
