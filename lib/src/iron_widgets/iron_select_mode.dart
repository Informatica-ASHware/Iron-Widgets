/// Presentation mode for the Iron selector widgets ([IronSelect],
/// [IronEnum], [IronMultiSelector]).
///
/// Added in US-2.02 to provide a desktop-friendly alternative to the
/// original bottom-sheet picker.
enum IronSelectMode {
  /// Options open in a modal bottom sheet (legacy behaviour, default in
  /// the 1.x series for full backward compatibility).
  bottomSheet,

  /// Options open in an overlay menu anchored to the trigger field —
  /// Finandy-style — with full keyboard support (arrows, Enter, Escape,
  /// Home/End and prefix typeahead).
  dropdown,

  /// Resolves per platform: [dropdown] on desktop (macOS, Windows, Linux)
  /// and on the web; [bottomSheet] on touch-first platforms (Android,
  /// iOS, Fuchsia).
  ///
  /// The web always resolves to [dropdown] because the package targets
  /// desktop-first web usage (see `docs/specs/SPEC_WIDGETS_ROADMAP.md`).
  adaptive,
}
