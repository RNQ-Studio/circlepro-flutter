import 'package:core/core.dart';

/// Pure helpers for the Latihan Bersama link-first distribution (Sprint 09, K6).
///
/// The share artifact is an HTTPS link (`https://<host>/j/<CODE>`) so it is
/// tappable inside WhatsApp; the typed code stays as a fallback. This class also
/// parses an incoming deep link / QR payload / pasted text back into a join
/// code so every entry point funnels to the same preview.
///
/// Everything here is pure Dart and side-effect free so it is fully unit
/// testable; only [buildShareUrl]/[shareMessage] reach for [AppConfig] when no
/// explicit `webBase` is supplied.
abstract final class JoinLink {
  /// Anti-ambiguous join codes are 6 chars, but we accept 4–12 alphanumerics
  /// when parsing so older/wider links still resolve (the server validates
  /// existence on lookup).
  static final RegExp _codePattern = RegExp(r'^[A-Za-z0-9]{4,12}$');

  /// Clipboard stash format written by the web invite landing page so a freshly
  /// installed app can resume to the right session (deferred deep link, 9.4).
  static const String clipboardPrefix = 'manahpro:join:';

  /// Custom URL scheme fallback (mirrors the native config & backend).
  static const String scheme = 'manahpro';

  /// Derive the public web base (no `/api`, no trailing slash) from the API
  /// base URL, e.g. `https://circlepro.web.id/api/` → `https://circlepro.web.id`.
  static String webBaseFrom(String apiBaseUrl) {
    var base = apiBaseUrl.trim();
    while (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }
    if (base.endsWith('/api')) {
      base = base.substring(0, base.length - 4);
    }
    return base;
  }

  /// The HTTPS invite link for [code], e.g. `https://circlepro.web.id/j/ABC234`.
  static String buildShareUrl(String code, {String? webBase}) {
    final base = webBase ?? webBaseFrom(AppConfig.instance.baseUrl);
    return '$base/j/${code.toUpperCase()}';
  }

  /// The custom-scheme fallback link, e.g. `manahpro://join?code=ABC234`.
  static String buildSchemeUrl(String code) =>
      '$scheme://join?code=${code.toUpperCase()}';

  /// A WhatsApp-friendly share message: link first (the hero), typed code as a
  /// fallback below it (K6).
  static String shareMessage({
    required String code,
    String? title,
    String? webBase,
  }) {
    final name = (title == null || title.isEmpty) ? 'Latihan Bersama' : title;
    final url = buildShareUrl(code, webBase: webBase);
    return 'Yuk ikut "$name" di ManahPro! 🎯\n'
        'Ketuk tautan untuk bergabung:\n$url\n\n'
        'Atau masukkan kode gabung: ${code.toUpperCase()}';
  }

  /// Extract a normalized (uppercase) join code from any supported payload:
  /// an HTTPS invite link (`/j/<code>` or `?code=`), the custom scheme
  /// (`manahpro://join?code=`), the clipboard stash (`manahpro:join:<code>`),
  /// or a bare typed code. Returns null when nothing valid is found.
  static String? parseCode(String? raw) {
    if (raw == null) return null;
    var input = raw.trim();
    if (input.isEmpty) return null;

    // Clipboard deferred-link stash, e.g. "manahpro:join:ABC234".
    if (input.toLowerCase().startsWith(clipboardPrefix)) {
      input = input.substring(clipboardPrefix.length).trim();
    }

    final looksLikeUri = input.contains('://') || input.contains('/');
    if (looksLikeUri) {
      final uri = Uri.tryParse(input);
      if (uri != null) {
        // ?code= query (works for https & custom scheme).
        final query = uri.queryParameters['code'];
        if (query != null && _isValid(query)) return _normalize(query);

        // Path form: /j/<code> (only the segment right after `j`, so the
        // literal "join" segment never masquerades as a code).
        final segments =
            uri.pathSegments.where((s) => s.isNotEmpty).toList();
        final jIndex = segments.indexOf('j');
        if (jIndex != -1 &&
            jIndex + 1 < segments.length &&
            _isValid(segments[jIndex + 1])) {
          return _normalize(segments[jIndex + 1]);
        }
      }
      return null;
    }

    // Bare typed code.
    return _isValid(input) ? _normalize(input) : null;
  }

  static bool _isValid(String value) => _codePattern.hasMatch(value);

  static String _normalize(String value) => value.toUpperCase();
}
