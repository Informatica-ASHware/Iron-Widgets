import 'dart:ui';

/// Uniformly downsamples [values] to at most [maxPoints], always keeping
/// the first and last samples so the visual trend endpoints are exact.
///
/// Pure helper for [IronSparkline] (US-2.08), extracted for unit testing.
List<double> downsampleSparkline(List<double> values, {int maxPoints = 200}) {
  assert(maxPoints >= 2, 'maxPoints must be >= 2.');
  if (values.length <= maxPoints) return values;
  final step = (values.length - 1) / (maxPoints - 1);
  return List<double>.generate(maxPoints, (i) => values[(i * step).round()]);
}

/// Maps [values] to paintable offsets inside a [width] × [height] box,
/// inset vertically by [verticalPadding] (typically half the stroke
/// width). Higher values map to smaller `dy` (up). A flat series renders
/// as a centred horizontal line.
///
/// Pure helper for [IronSparkline] (US-2.08), extracted for unit testing.
List<Offset> sparklinePoints(
  List<double> values, {
  required double width,
  required double height,
  double verticalPadding = 1,
}) {
  if (values.length < 2) return const [];
  var min = values.first;
  var max = values.first;
  for (final v in values) {
    if (v < min) min = v;
    if (v > max) max = v;
  }
  final range = max - min;
  final usable = height - verticalPadding * 2;
  final dx = width / (values.length - 1);
  return List<Offset>.generate(values.length, (i) {
    final normalized = range == 0 ? 0.5 : (values[i] - min) / range;
    return Offset(i * dx, verticalPadding + (1 - normalized) * usable);
  });
}
