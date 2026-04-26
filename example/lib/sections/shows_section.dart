import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_widgets/iron_widgets.dart';

class ShowsSection extends StatefulWidget {
  const ShowsSection({super.key});

  @override
  State<ShowsSection> createState() => _ShowsSectionState();
}

class _ShowsSectionState extends State<ShowsSection> {
  String _editableValue = '142.30';
  String _topPerc = '62';
  String _bottomPerc = '38';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('Show Panels'),
        const _ShowCard(
          title: 'Show (read-only)',
          snippet: "Show(label: 'Open', value: '142.30')",
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              // Text('See source code'),
              Show(label: 'O', value: '142.30'),
              Show(label: 'H', value: '148.00'),
              Show(label: 'L', value: '139.50'),
              Show(label: 'C', value: '145.20'),
            ],
          ),
        ),
        _ShowCard(
          title: 'Show (editable)',
          snippet:
              "Show(\n  label: 'Qty',\n  value: '142',\n  editable: true,\n  onChanged: (v) { … },\n)",
          child: Row(
            children: [
              Show(
                label: 'Qty',
                value: _editableValue,
                editable: true,
                onChanged: (v) => setState(() => _editableValue = v),
              ),
              const SizedBox(width: 12),
              Text('→ $_editableValue', style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
        _ShowCard(
          title: 'ShowValuesColumn',
          snippet:
              'ShowValuesColumn(\n  topLabel: "O", topValue: "142.30",\n  bottomLabel: "C", bottomValue: "139.80",\n)',
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              // Text('See source code'),
              const ShowValuesColumn(
                topLabel: 'O',
                topValue: '142.30',
                bottomLabel: 'C',
                bottomValue: '139.80',
              ),
              ShowValuesColumn(
                topLabel: 'H',
                topValue: '148.00',
                bottomLabel: 'L',
                bottomValue: '139.50',
                background: IronColors.darkGray.withAlpha(0x22),
              ),
            ],
          ),
        ),
        _ShowCard(
          title: 'ShowValuesColumn (editable)',
          snippet:
              'ShowValuesColumn(\n  topLabel: "O", topValue: _open,\n  bottomLabel: "C", bottomValue: _close,\n  editable: true,\n  onTopChanged: (v) { … },\n  onBottomChanged: (v) { … },\n)',
          child: ShowValuesColumn(
            topLabel: 'O',
            topValue: _editableValue,
            bottomLabel: 'C',
            bottomValue: '139.80',
            editable: true,
            onTopChanged: (v) => setState(() => _editableValue = v),
            onBottomChanged: (_) {},
          ),
        ),
        _ShowCard(
          title: 'ShowPercColumn',
          snippet:
              'ShowPercColumn(\n  topLabel: "W", topValue: "62",\n  bottomLabel: "L", bottomValue: "38",\n)',
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ShowPercColumn(
                topLabel: 'W',
                topValue: _topPerc,
                bottomLabel: 'L',
                bottomValue: _bottomPerc,
                editable: true,
                onTopChanged: (v) => setState(() => _topPerc = v),
                onBottomChanged: (v) => setState(() => _bottomPerc = v),
              ),
              const ShowPercColumn(
                topLabel: 'Buy',
                topValue: '55',
                bottomLabel: 'Sell',
                bottomValue: '45',
                background: Colors.transparent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Private helpers ──────────────────────────────────────────────────────────

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

class _ShowCard extends StatelessWidget {
  const _ShowCard({
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
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(height: 20),
          child,
          const SizedBox(height: 16),
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
