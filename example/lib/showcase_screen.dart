import 'package:flutter/material.dart';
import 'package:iron_widgets/iron_widgets.dart';

import '../sections/shows_section.dart';
import '../sections/simple_widgets_section.dart';
import '../theme_switcher.dart';

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({super.key, required this.notifier});

  final ThemeSwitcherNotifier notifier;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: notifier,
        builder: (context, _) {
          final (:theme, :useIronScope) = resolveTheme(notifier.mode);

          Widget body = Scaffold(
            appBar: AppBar(
              title: const Text('Iron Widgets Showcase'),
              centerTitle: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: ThemeSegmentedButton(notifier: notifier),
                ),
              ),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 768;
                final content = SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 48 : 16,
                    vertical: 16,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SimpleWidgetsSection(),
                          SizedBox(height: 16),
                          ShowsSection(),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                );
                return content;
              },
            ),
          );

          if (useIronScope) {
            body = IronWidgetsThemeScope(child: body);
          }

          return Theme(
            data: theme,
            child: body,
          );
        },
      );
}
