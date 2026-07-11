import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_widgets/iron_widgets.dart';

/// Showcases the container widgets (US-2.17, US-2.18): an [IronPanel]
/// whose body is switched by [IronTabs].
class ContainersSection extends StatefulWidget {
  /// Creates the containers showcase section.
  const ContainersSection({super.key});

  @override
  State<ContainersSection> createState() => _ContainersSectionState();
}

class _ContainersSectionState extends State<ContainersSection> {
  static const _tabs = ['Order', 'SL', 'SLX', 'TP'];

  int _tab = 0;
  double _slPercent = 2;

  Widget get _tabBody => switch (_tab) {
    0 => const ShowGrid(
      columns: 1,
      items: [ShowItem('Type', 'Limit'), ShowItem('Amount', '25%')],
    ),
    1 => IronPercentSlider(
      value: _slPercent,
      max: 10,
      precision: 1,
      presets: const [1, 2, 5],
      onChanged: (v) => setState(() => _slPercent = v),
    ),
    _ => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '${_tabs[_tab]} settings…',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ),
  };

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _SectionHeader('Containers (v1.5)'),
      _WidgetCard(
        title: 'IronPanel + IronTabs · collapsible card with tabbed body',
        snippet:
            'IronPanel(\n'
            "  title: 'ORDER SETTINGS',\n"
            "  trailing: IronTag('PERP'),\n"
            '  collapsible: true,\n'
            '  child: Column(children: [\n'
            '    IronTabs(tabs: tabs, index: _tab, onChanged: …),\n'
            '    _bodyFor(_tab),\n'
            '  ]),\n'
            ')',
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: IronPanel(
            title: 'ORDER SETTINGS',
            trailing: const IronTag('PERP'),
            collapsible: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IronTabs(
                  tabs: _tabs,
                  index: _tab,
                  onChanged: (i) => setState(() => _tab = i),
                ),
                const SizedBox(height: 8),
                _tabBody,
              ],
            ),
          ),
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
