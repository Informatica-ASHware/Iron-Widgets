import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_widgets/iron_widgets.dart';

/// Showcases the anchored dropdown mode of the selector widgets
/// (US-2.02 / US-2.03 / US-2.04).
class DropdownSelectorsSection extends StatefulWidget {
  /// Creates the dropdown selectors showcase section.
  const DropdownSelectorsSection({super.key});

  @override
  State<DropdownSelectorsSection> createState() =>
      _DropdownSelectorsSectionState();
}

class _DropdownSelectorsSectionState extends State<DropdownSelectorsSection> {
  String? _pair;
  String _trigger = 'Last price';
  List<String> _protections = ['Take profit'];

  static const _pairs = [
    'BTCUSDT',
    'ETHUSDT',
    'SOLUSDT',
    'BNBUSDT',
    'ADAUSDT',
    'XRPUSDT',
  ];
  static const _triggerOptions = [
    'Last price',
    'Order book',
    '1m candle',
    '5m candle',
    '1h candle',
  ];
  static const _protectionOptions = [
    'Take profit',
    'Stop loss',
    'Trailing',
    'Breakeven',
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _SectionHeader('Selectors – Dropdown Mode (v1.1)'),
      _WidgetCard(
        title: 'IronSelect · dropdown + searchable',
        snippet:
            'IronSelect<String>(\n'
            '  mode: IronSelectMode.dropdown,\n'
            '  searchable: true,\n'
            '  title: "Pair", label: "Pair",\n'
            '  options: [...],\n'
            '  onChanged: (v) { … },\n'
            ')',
        child: IronSelect<String>(
          title: 'Pair',
          label: 'Pair',
          mode: IronSelectMode.dropdown,
          searchable: true,
          options: _pairs,
          value: _pair,
          onChanged: (v) => setState(() => _pair = v),
        ),
      ),
      _WidgetCard(
        title:
            'IronEnum · adaptive (dropdown on desktop/web, '
            'bottom sheet on mobile)',
        snippet:
            'IronEnum<String>(\n'
            '  mode: IronSelectMode.adaptive,\n'
            '  title: "Trigger", label: "Trigger",\n'
            '  value: _trigger,\n'
            '  options: triggerValues,\n'
            '  onChanged: (v) { … },\n'
            ')',
        child: IronEnum<String>(
          title: 'Trigger',
          label: 'Trigger',
          mode: IronSelectMode.adaptive,
          value: _trigger,
          options: _triggerOptions,
          onChanged: (v) => setState(() => _trigger = v),
        ),
      ),
      _WidgetCard(
        title: 'IronMultiSelector · dropdown, All row, immediate apply',
        snippet:
            'IronMultiSelector<String>(\n'
            '  mode: IronSelectMode.dropdown,\n'
            '  title: "Protections", label: "Protections",\n'
            '  value: _selected,\n'
            '  options: [...],\n'
            '  onChanged: (list) { … }, // fires on every toggle\n'
            ')',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IronMultiSelector<String>(
              title: 'Protections',
              label: 'Protections',
              mode: IronSelectMode.dropdown,
              value: _protections,
              options: _protectionOptions,
              onChanged: (list) => setState(() => _protections = list),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Applied: '
                '${_protections.isEmpty ? '—' : _protections.join(', ')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    ],
  );
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
