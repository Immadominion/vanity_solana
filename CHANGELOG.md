# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-12-19

### Added
- Initial release of vanity Solana address generator
- Core vanity address validation (`isValidVanityAddress`)
- Single-threaded vanity generation (`generateVanityAddress`) 
- Multi-core parallel generation using Dart isolates (`generateWithIsolates`)
- Support for custom prefixes and suffixes
- Case-sensitive and case-insensitive matching options
- Progress tracking with attempt counters
- Compatible 64-byte private key export (private + public key concatenation)
- Comprehensive API documentation and examples
- Flutter example application demonstrating usage

### Technical Details
- Uses `solana` package ^0.31.2 for cryptographic operations
- Leverages Dart isolates for multi-core CPU utilization
- Maintains compatibility with standard Solana keypair formats
- Zero external dependencies beyond Solana cryptographic library
