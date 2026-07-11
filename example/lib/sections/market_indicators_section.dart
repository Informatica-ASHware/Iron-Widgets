import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_widgets/iron_widgets.dart';

/// Showcases the market indicator widgets (US-2.05 … US-2.08).
class MarketIndicatorsSection extends StatefulWidget {
  /// Creates the market indicators showcase section.
  const MarketIndicatorsSection({super.key});

  @override
  State<MarketIndicatorsSection> createState() =>
      _MarketIndicatorsSectionState();
}

class _MarketIndicatorsSectionState extends State<MarketIndicatorsSection> {
  static const double _open = 43000;
  final math.Random _rng = math.Random(7);
  final DateTime _candleClose = DateTime.now().add(const Duration(minutes: 5));

  double _price = 43250.5;
  bool _countdownPaused = false;

  static const _rising = [41.2, 41.8, 41.5, 42.9, 42.4, 43.1];
  static const _falling = [43.1, 42.4, 42.9, 41.5, 41.8, 41.2];

  void _bump(double direction) => setState(
    () => _price = double.parse(
      (_price + direction * (5 + _rng.nextInt(40))).toStringAsFixed(1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final deltaPct = (_price - _open) / _open * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('Market Indicators (v1.2)'),
        _WidgetCard(
          title: 'IronPriceTicker + IronDeltaBadge · flash on change',
          snippet:
              'IronPriceTicker(price: _price, precision: 1)\n'
              'IronDeltaBadge(deltaPct)',
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IronPriceTicker(price: _price, precision: 1, suffix: ' USDT'),
              IronDeltaBadge(deltaPct),
              IconButton(
                icon: const Icon(Icons.arrow_upward, size: 16),
                tooltip: 'Simulate rise',
                onPressed: () => _bump(1),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_downward, size: 16),
                tooltip: 'Simulate drop',
                onPressed: () => _bump(-1),
              ),
            ],
          ),
        ),
        _WidgetCard(
          title: 'IronCountdown · Ticker-driven, pausable',
          snippet:
              'IronCountdown(\n'
              '  until: candleClose,\n'
              '  paused: _paused,\n'
              '  onFinished: () { … },\n'
              ')',
          child: Row(
            children: [
              IronCountdown(until: _candleClose, paused: _countdownPaused),
              const SizedBox(width: 16),
              IronMicroSwitch(
                text: _countdownPaused ? 'Paused' : 'Running',
                value: _countdownPaused,
                onChanged: (v) => setState(() => _countdownPaused = v),
              ),
            ],
          ),
        ),
        const _WidgetCard(
          title: 'IronSparkline · trend-coloured, zero dependencies',
          snippet:
              'IronSparkline(values)\n'
              'IronSparkline(values, positiveIsBull: false)\n'
              'IronSparkline(flat, fill: false)',
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              IronSparkline(_rising),
              IronSparkline(_falling),
              IronSparkline([42, 42, 42, 42], fill: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}

class _WidgetCard extends StatelessWidget {
  const _WidgetCard({
    required this.title,
    required this.child,
    required this.snippet,
  });

  final String title;
  final Widget child;
  final String snippet;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(height: 20),
          // Widget preview
          child,
          const SizedBox(height: 16),
          // Code snippet
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    snippet,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  tooltip: 'Copy snippet',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: snippet));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
