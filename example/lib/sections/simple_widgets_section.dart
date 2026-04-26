import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_widgets/iron_widgets.dart';

class SimpleWidgetsSection extends StatefulWidget {
  const SimpleWidgetsSection({super.key});

  @override
  State<SimpleWidgetsSection> createState() => _SimpleWidgetsSectionState();
}

class _SimpleWidgetsSectionState extends State<SimpleWidgetsSection> {
  bool _checkValue = false;
  bool _switchValue = false;
  String _microEditorValue = '42';
  String _editorValue = 'Tony Stark';
  String? _selectValue;
  String _enumValue = 'idle';
  List<String> _multiSelected = [];

  static const _options = ['USA', 'UK', 'Canada', 'Germany', 'Japan'];
  static const _enumOptions = ['idle', 'active', 'turbo', 'overdrive'];
  static const _multiOptions = [
    'Flutter',
    'Dart',
    'Firebase',
    'Supabase',
    'GraphQL',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader('Simple Widgets'),
        const _WidgetCard(
          title: 'IronLabel',
          snippet: "IronLabel('Power Level')\nIronLabel('Power', colon: false)",
          child: Wrap(
            spacing: 16,
            children: [
              IronLabel('Power Level'),
              IronLabel('Status', colon: false),
            ],
          ),
        ),
        const _WidgetCard(
          title: 'IronMiniText',
          snippet:
              "IronMiniText('1234.56')  // right-aligned\nIronMiniText('Revenue') // left-aligned",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IronMiniText('1234.56', width: 120),
              SizedBox(height: 4),
              IronMiniText('Revenue', width: 120),
              SizedBox(height: 4),
              IronMiniText('', width: 120),
            ],
          ),
        ),
        _WidgetCard(
          title: 'IronCheck',
          snippet:
              'IronCheck(\n  label: "Enable HUD",\n  value: _checked,\n  onChanged: (v) => setState(() => _checked = v),\n)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IronCheck(
                label: 'Enable HUD',
                value: _checkValue,
                onChanged: (v) => setState(() => _checkValue = v),
              ),
              IronCheck(
                label: 'Disabled',
                value: true,
                onChanged: (_) {},
                enabled: false,
              ),
            ],
          ),
        ),
        _WidgetCard(
          title: 'IronMicroSwitch',
          snippet:
              'IronMicroSwitch(\n  text: "HUD",\n  value: _active,\n  onChanged: (v) => setState(() => _active = v),\n)',
          child: Wrap(
            spacing: 8,
            children: [
              IronMicroSwitch(
                text: 'HUD',
                value: _switchValue,
                onChanged: (v) => setState(() => _switchValue = v),
              ),
              IronMicroSwitch(
                text: 'JARVIS',
                value: !_switchValue,
                onChanged: (v) => setState(() => _switchValue = !v),
                message: 'Toggle JARVIS',
              ),
              IronMicroSwitch(
                text: 'OFF',
                value: false,
                onChanged: (_) {},
                enabled: false,
              ),
            ],
          ),
        ),
        _WidgetCard(
          title: 'IronMicroEditor',
          snippet:
              'IronMicroEditor(\n  label: "qty",\n  initialValue: "42",\n  onChanged: (v) { … },\n)',
          child: Row(
            children: [
              IronMicroEditor(
                label: 'qty',
                initialValue: _microEditorValue,
                onChanged: (v) => setState(() => _microEditorValue = v),
                width: 60,
                height: 24,
              ),
              const SizedBox(width: 16),
              Text(
                'value: $_microEditorValue',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        _WidgetCard(
          title: 'IronEditor',
          snippet:
              'IronEditor(\n  label: "Name",\n  initialValue: "Tony Stark",\n  onChanged: (v) { … },\n  debounce: Duration(milliseconds: 300),\n)',
          child: Column(
            children: [
              IronEditor(
                label: 'Name',
                initialValue: _editorValue,
                onChanged: (v) => setState(() => _editorValue = v),
                debounce: const Duration(milliseconds: 300),
              ),
              const SizedBox(height: 8),
              IronEditor(
                label: 'Bio',
                initialValue: 'Genius. Billionaire.',
                onChanged: (_) {},
                lines: 3,
                labelOnTop: true,
              ),
            ],
          ),
        ),
        _WidgetCard(
          title: 'IronSelect',
          snippet:
              'IronSelect<String>(\n  title: "Country",\n  label: "Country",\n  options: [...],\n  onChanged: (v) { … },\n)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IronSelect<String>(
                title: 'Country',
                label: 'Country',
                value: _selectValue,
                options: _options,
                onChanged: (v) => setState(() => _selectValue = v),
              ),
              if (_selectValue != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 10),
                  child: Text(
                    'Selected: $_selectValue',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
        _WidgetCard(
          title: 'IronEnum',
          snippet:
              'IronEnum<String>(\n  title: "Mode",\n  label: "Mode",\n  value: _mode,\n  options: modeValues,\n  onChanged: (v) { … },\n)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IronEnum<String>(
                title: 'Mode',
                label: 'Mode',
                value: _enumValue,
                options: _enumOptions,
                onChanged: (v) => setState(() => _enumValue = v),
                itemAsString: (s) => s.toUpperCase(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 10),
                child: Text(
                  'Current: $_enumValue',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        _WidgetCard(
          title: 'IronMultiSelector',
          snippet:
              'IronMultiSelector<String>(\n  title: "Tags",\n  label: "Select Tags",\n  value: _tags,\n  options: [...],\n  onChanged: (list) { … },\n)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IronMultiSelector<String>(
                title: 'Tags',
                label: 'Select Tags',
                value: _multiSelected,
                options: _multiOptions,
                onChanged: (list) => setState(() => _multiSelected = list),
                width: double.infinity,
              ),
              if (_multiSelected.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 10),
                  child: Text(
                    'Selected: ${_multiSelected.join(', ')}',
                    style: const TextStyle(fontSize: 12),
                  ),
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
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
