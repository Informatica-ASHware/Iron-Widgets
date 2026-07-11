import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_widgets/iron_widgets.dart';

/// Showcases the position & status widgets (US-2.13 … US-2.16) wired
/// together as a Finandy-style position card.
class PositionStatusSection extends StatefulWidget {
  /// Creates the position & status showcase section.
  const PositionStatusSection({super.key});

  @override
  State<PositionStatusSection> createState() => _PositionStatusSectionState();
}

class _PositionStatusSectionState extends State<PositionStatusSection> {
  static const double _sl = 41000;
  static const double _tp = 45000;
  static const double _entry = 43000;

  double _pricePercent = 71; // position of the price inside [SL, TP]

  double get _current => _sl + (_tp - _sl) * _pricePercent / 100;

  @override
  Widget build(BuildContext context) {
    final margin = (_pricePercent / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('Position & Status (v1.4)'),
        _WidgetCard(
          title: 'IronTag · IronRangeBar · IronGauge · ShowGrid',
          snippet:
              "IronTag('SHORT', variant: IronTagVariant.bear)\n"
              'IronRangeBar(min: sl, max: tp, entry: entry, current: price)\n'
              'IronGauge(value: margin, thresholds: [0.5, 0.9])\n'
              'ShowGrid(items: [ShowItem(\'Volume\', \'1.2M\'), …])',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    IronTag('SHORT', variant: IronTagVariant.bear),
                    SizedBox(width: 6),
                    IronTag('×20', variant: IronTagVariant.gold),
                    SizedBox(width: 6),
                    IronTag('Isol'),
                    SizedBox(width: 6),
                    IronTag('PERP'),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    SizedBox(
                      width: 240,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IronRangeBar(
                            min: _sl,
                            max: _tp,
                            entry: _entry,
                            current: _current,
                            width: 240,
                            showLabels: true,
                            precision: 0,
                          ),
                          const SizedBox(height: 4),
                          IronPercentSlider(
                            value: _pricePercent,
                            presets: const [],
                            editable: false,
                            onChanged: (v) => setState(() => _pricePercent = v),
                          ),
                        ],
                      ),
                    ),
                    IronGauge(
                      value: margin,
                      label: 'Margin',
                      thresholds: const [0.5, 0.9],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const ShowGrid(
                  items: [
                    ShowItem('Volume', '1.2M'),
                    ShowItem('High', '43910.0'),
                    ShowItem('Low', '42115.5'),
                    ShowItem('Funding', '0.0100%'),
                  ],
                ),
              ],
            ),
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
