import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_widgets/iron_widgets.dart';

/// Showcases the order-entry widgets (US-2.09 … US-2.12) wired together
/// as a Finandy-style order form.
class OrderEntrySection extends StatefulWidget {
  /// Creates the order-entry showcase section.
  const OrderEntrySection({super.key});

  @override
  State<OrderEntrySection> createState() => _OrderEntrySectionState();
}

class _OrderEntrySectionState extends State<OrderEntrySection> {
  static const double _balance = 1250;

  String _side = 'LONG';
  double _percent = 25;
  double _leverage = 5;
  bool _sending = false;

  Future<void> _submit() async {
    setState(() => _sending = true);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveExampleTheme(context);
    final amount = _balance * _percent / 100 * _leverage;
    final long = _side == 'LONG';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('Order Entry (v1.3)'),
        _WidgetCard(
          title:
              'IronSegmented · IronPercentSlider · IronStepper · '
              'IronActionButton',
          snippet:
              'IronSegmented<String>(segments: [\'LONG\', \'SHORT\'], …)\n'
              'IronPercentSlider(value: _percent, …)\n'
              'IronStepper(value: _leverage, min: 1, max: 125, …)\n'
              'IronActionButton(\n'
              '  label: \'Add \$_side\',\n'
              '  variant: long ? success : danger,\n'
              '  loading: _sending,\n'
              ')',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    IronSegmented<String>(
                      segments: const ['LONG', 'SHORT'],
                      value: _side,
                      segmentWidth: 70,
                      selectedColor: (s) =>
                          s == 'LONG' ? theme.bullColor : theme.bearColor,
                      onChanged: (s) => setState(() => _side = s),
                    ),
                    const IronLabel('Lev'),
                    IronStepper(
                      value: _leverage,
                      min: 1,
                      max: 125,
                      editorWidth: 38,
                      onChanged: (v) => setState(() => _leverage = v),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                IronPercentSlider(
                  value: _percent,
                  onChanged: (v) => setState(() => _percent = v),
                ),
                const SizedBox(height: 12),
                IronActionButton(
                  label: 'Add $_side',
                  sublabel: '≈ ${amount.toStringAsFixed(1)} USDT',
                  variant: long
                      ? IronActionVariant.success
                      : IronActionVariant.danger,
                  loading: _sending,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Resolves the [IronWidgetsTheme] for the example (mirrors the internal
/// resolver, kept local to avoid importing package internals).
IronWidgetsTheme resolveExampleTheme(BuildContext context) =>
    Theme.of(context).extension<IronWidgetsTheme>() ??
    IronWidgetsTheme.defaults();

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
