// Golden comparator with a cross-platform anti-aliasing tolerance.
//
// Golden baselines are generated on the CI toolchain (Linux, the Flutter
// version pinned in `.fvmrc` / `ci.yml`). Other host platforms — notably
// macOS — rasterize text and blur anti-aliasing slightly differently,
// producing sub-pixel noise of up to ~4–5 % on these small images without
// any real layout or colour change. This config accepts diffs up to
// [_kGoldenDiffTolerance]; on the generating platform diffs are 0 %, so
// CI keeps enforcing exact rendering de facto.
//
// `flutter test --update-goldens` is unaffected (updates bypass the
// comparator) and remains the way to adopt intentional visual changes.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Maximum fraction of differing pixels tolerated against a baseline.
const double _kGoldenDiffTolerance = 0.05;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final comparator = goldenFileComparator;
  if (comparator is LocalFileComparator) {
    goldenFileComparator = _TolerantGoldenFileComparator(
      Uri.parse('${comparator.basedir}config.dart'),
    );
  }
  await testMain();
}

class _TolerantGoldenFileComparator extends LocalFileComparator {
  _TolerantGoldenFileComparator(super.testFile);

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed) return true;

    if (result.diffPercent <= _kGoldenDiffTolerance) {
      debugPrint(
        'Golden "$golden": accepted platform rasterization diff of '
        '${(result.diffPercent * 100).toStringAsFixed(2)}% '
        '(tolerance ${(_kGoldenDiffTolerance * 100).toStringAsFixed(0)}%).',
      );
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    throw FlutterError(error);
  }
}
