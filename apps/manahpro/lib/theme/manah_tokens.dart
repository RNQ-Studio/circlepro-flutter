/// ManahPro design tokens (primitive layer) — see
/// apps/manahpro/docs/ui-ux-design-guide.md §3. App-level (does not touch the
/// shared `core` design system used by other flavors).
library;

/// Spacing on an 8px grid.
abstract final class ManahSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

/// Corner radii.
abstract final class ManahRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 28;
  static const double full = 9999;
}

/// Border Radii mapping (card, button, badge, small)
abstract final class ManahBorderRadius {
  static const double small = 8;
  static const double badge = 9999;
  static const double card = 12;
  static const double button = 12;
}
